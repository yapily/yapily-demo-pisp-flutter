import 'dart:async';
import 'package:ipisp/api_client_factory.dart';
import 'package:ipisp/payment_processing.dart';
import 'package:flutter/material.dart';
import 'package:ipisp/payment_details.dart';
import 'package:ipisp/yapily_config.dart';
import 'package:yapily_sdk/api.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String basepath = "https://api.yapily.com:443";
String appplicationUuid = '32e45370-1fe8-44b1-be15-2e779ac1105a';
String applicationSecret = '0e3cd402-6c56-48d8-bcd7-894fa089694e';
HttpBasicAuth httpBasicAuth = HttpBasicAuth.setCredentials(username: appplicationUuid, password: applicationSecret);
String userUuid = 'a4bdd948-377d-49c2-ab3f-930a8f5c1a7f';
String callback = "moneyme://whatever/";
ApiClient apiClient = ApiClient.withAuth(httpBasicAuth);

class SelectInstitution {

  YapilyConfig yapilyConfig;
  String userUuid;

  BuildContext selectInstitutionContext;
  BuildContext paymentDetailsContext;
  FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();
  bool isOnWebView = false;
  bool isPaid = false;

  PaymentData paymentData;

  SortCodePaymentRequest sortCodePaymentRequest;

  final biggerFont = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

  SelectInstitution(PaymentData paymentData, BuildContext context) {
    this.paymentData = paymentData;
    paymentDetailsContext = context;
    var loadAsync = ConfigLoader.loadAsync();
    loadAsync.then((yapilyConfig) {
      this.yapilyConfig = yapilyConfig;
      _createYapilyUser();
    });
    _registerWebViewListener();
  }

  Scaffold build() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Select Bank"),
      ),
      body: new FutureBuilder<ApiListResponseOfInstitution>(
        future: _getInstitutions(),
        builder: (context, snapshot) {
          if(isPaid) {
            var alert = new AlertDialog(
              title: new Text("Payment Complete"),
              content: new Text("Thank you for using us for your payments!"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('OK'),
                  onPressed: () {
                    Navigator.pop(paymentDetailsContext);
                  },
                ),
              ],
            );
            showDialog(context: context, child: alert);
          }
          this.selectInstitutionContext = context;
          if(isOnWebView == true) {
            this.flutterWebviewPlugin.close();
            this.flutterWebviewPlugin.dispose();
            isOnWebView = false;
          }
          if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          else if (snapshot.hasData) {
            List<Widget> institutionWidgets = [];
            snapshot.data.data.forEach((institution) {
              Widget listItem;
              listItem = _buildRow(institution);
              institutionWidgets.add(listItem);
              institutionWidgets.add(new Divider(height: 0.0));
            });
            return _buildInstitutions(institutionWidgets);
          }

          // By default, show a loading spinner
          return new Center(
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildRow(Institution institution) {
    Widget listItem =
    new ListTile(
      title: new Text(
        institution.fullName,
        style: biggerFont,
      ),
      leading:  _getInstitutionLogo(institution),
      onTap: () {
        _launchURL(institution);
      },
    );
    return listItem;
  }

  Widget _buildInstitutions(List<Widget> institutionWidgets) {
    return new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: institutionWidgets
    );
  }

  Widget _getInstitutionLogo(Institution institution) {
    Image image;
    institution.media.forEach((media) {
      if(media.type == "icon") {
        image = new Image.network(media.source.replaceAll("size=0", "size=50"), width: 50.0);
      }
    });
    if(image == null) {
      return new Icon(
        Icons.account_balance,
        color: Colors.black38,
      );
    } else {
      return image;
    }
  }

  _launchURL(Institution institution) {
    openAsyncUrl(institution);
  }

  void openAsyncUrl(Institution institution) {

      sortCodePaymentRequest = new SortCodePaymentRequest();
      sortCodePaymentRequest.paymentReferenceId = new Uuid().v4().toString().replaceAll("-", "");
      sortCodePaymentRequest.senderAccountId = "9bd5ae68-2266-4dad-865b-4980550a72b7";
      sortCodePaymentRequest.accountNumber = paymentData.accountNumber;
      sortCodePaymentRequest.sortCode = paymentData.sortCode;
      sortCodePaymentRequest.country = "GB";
      sortCodePaymentRequest.currency = paymentData.currency;
      sortCodePaymentRequest.name = paymentData.name;
      if(paymentData.description == null) {
        sortCodePaymentRequest.reference = "moneyme payment";
      } else {
        if(paymentData.description.length > 35) {
          sortCodePaymentRequest.reference =
              paymentData.description.substring(0, 35);
        } else {
          sortCodePaymentRequest.reference =
              paymentData.description;
        }
      }
      sortCodePaymentRequest.amount = num.parse(paymentData.amount);

    _createPaymentInitiation(institution.id, sortCodePaymentRequest, userUuid, yapilyConfig.callback).then((apiResponse) {

          Navigator.of(selectInstitutionContext).push(
              new MaterialPageRoute(
                  builder: (credentialsContext) {
                    return new Scaffold(appBar:
                      new AppBar(
                        leading: new IconButton(icon: new Icon(Icons.arrow_back), onPressed:(){
                          flutterWebviewPlugin.close();
                          flutterWebviewPlugin.dispose();
                          isOnWebView = false;
                          Navigator.pop(selectInstitutionContext);
                        }),
                        centerTitle: true,
                        title: new Text('Provide Consent'),

                      ),
                    );
                  }
              )
          );
          isOnWebView = true;
          flutterWebviewPlugin.launch(apiResponse.data.authUrl,
              rect: new Rect.fromLTWH(
                  0.0,
                  80.0,
                  MediaQuery.of(selectInstitutionContext).size.width - 0.0,
                  MediaQuery.of(selectInstitutionContext).size.height),
              withZoom: true,
              withJavascript: true,
              withLocalStorage: true,
              scrollBar: true);

        }
    );
  }

  void _registerWebViewListener() {
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if(url.contains(yapilyConfig.callback) && isOnWebView) {
        String consentLookupString = 'consent=';
        if (url.contains(consentLookupString)) {
          int indexOfConsent = url.indexOf(consentLookupString);
          String consent = url.substring(
              indexOfConsent + consentLookupString.length, url.length);
          flutterWebviewPlugin.close();
          flutterWebviewPlugin.dispose();
          this.isOnWebView = false;
          _makePayment(consent);
        }
      }
    });
  }

  void _createYapilyUser() {
    var apiClientFactory = ApiClientFactory.create();
    apiClientFactory.then((apiClient) {
      ApplicationUsersApi yapilyUsersApi = new ApplicationUsersApi(apiClient);
      yapilyUsersApi.getUsersUsingGET().then((userList) {
        userList.asMap().forEach((key, user) {
          if (user.referenceId == yapilyConfig.userName) {
            userUuid = user.uuid;
          }
        });
        if (userUuid == null) {
          //No user exists with this username
          NewApplicationUser applicationUser = new NewApplicationUser();
          applicationUser.referenceId = yapilyConfig.userName;
          yapilyUsersApi.addUserUsingPOST(applicationUser).then((yapilyUser) {
            userUuid = yapilyUser.uuid;
          });
        }
      });
    });
  }

  void _makePayment(String consent) {
    _createPayment(consent, sortCodePaymentRequest).then((paymentResponse) {
        Navigator.push(selectInstitutionContext, new MaterialPageRoute(
            builder: (context) => new PaymentProcessing(paymentData: paymentData, paymentResponse: paymentResponse.data, consent: consent).build()));
    });
  }

  Future<ApiListResponseOfInstitution> _getInstitutions() {
    var apiClientFactory = ApiClientFactory.create();
    return apiClientFactory.then((apiClient) {
      return new InstitutionsApi(apiClient).getInstitutionsUsingGET();
    });
  }

  Future<ApiResponseOfPaymentResponse> _createPaymentInitiation(String id, SortCodePaymentRequest paymentRequest, String userUuid, String callback) {
    var apiClientFactory = ApiClientFactory.create();
    return apiClientFactory.then( (apiClient) {
      return new PaymentsApi(apiClient).createPaymentInitiationUsingPOST(id,paymentRequest: sortCodePaymentRequest, userUuid: userUuid, callback: callback);
    });
  }

  Future<ApiResponseOfPaymentResponse> _createPayment(String consent, SortCodePaymentRequest paymentRequest) {
    var apiClientFactory = ApiClientFactory.create();
    return apiClientFactory.then( (apiClient) {
      return new PaymentsApi(apiClient).createPaymentUsingPOST(consent, paymentRequest: paymentRequest);
    });
  }

}

