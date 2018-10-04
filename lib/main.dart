import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ipisp/edit_profile.dart';
import 'package:ipisp/payment_details.dart';
import 'package:ipisp/request_money.dart';
import 'package:ipisp/send_money.dart';
import 'package:ipisp/payment_request_listener.dart';
import 'package:ipisp/application_link_listener.dart';
import 'package:flutter/services.dart';
import 'package:ipisp/payment_details_jwt_parser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future main() async {

  final FirebaseApp app = FirebaseApp.instance;
  final FirebaseStorage storage = new FirebaseStorage(
    app: app,
    storageBucket: 'gs://yapily-staging.appspot.com'
  );

  runApp(new MannekenPisp(storage));
}

class HomePage extends StatefulWidget {
  var storage;

  HomePage(this.storage);

  @override
  createState() => new _HomePageState(storage);
}

class _HomePageState extends State<HomePage> implements PaymentRequestListener {

  var storage;

  static const platform = const MethodChannel('app.channel.yapily.data');

  _HomePageState(this.storage);

  @override
  void paymentRequestReceived(String paymentRequest) {
    handlePaymentData(paymentRequest);
  }

  void handlePaymentData(data){
    if (data != null) {
      PaymentData paymentData = PaymentDetailsJWTParser.parseJWT(data);

      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new PaymentDetails(paymentData)));
    }
  }

  void getPaymentJWT() async {
    String sharedData = await platform.invokeMethod("getPaymentJWT");
    handlePaymentData(sharedData);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(new ApplicationLinkListener(platform, this));
  }

  @override
  Widget build(BuildContext context) {
//    getPaymentJWT();
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("Money Me"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.person),
              onPressed: (){
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new EditProfile()),
                );
              },
            ),
          ],
        ),
        body: new Center(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Image.asset('graphics/money_me.png', width: 150.0, height: 150.0),
                  ),
                  new Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 66.0),
                      child: new RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                          color: Colors.red,
                          textColor: Colors.white,
                          splashColor: Colors.redAccent,
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SendMoney()),
                            );
                          },
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Padding(padding: EdgeInsets.only(right: 8.0), child: const Text("SEND MONEY")), Icon(FontAwesomeIcons.camera),])
                      )
                  ),
                  new Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 66.0),
                      child: new RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                          color: Colors.red,
                          textColor: Colors.white,
                          splashColor: Colors.redAccent,
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new RequestMoney(storage)),
    //                      new MaterialPageRoute(builder: () => GenerateScreen())
                            );
                          },
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Padding(padding: EdgeInsets.only(right: 8.0), child: const Text("REQUEST PAY")), Icon(FontAwesomeIcons.qrcode),]),
                      ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Image.asset('graphics/sponsored_by_yapily.png', width: 50.0, height: 50.0),
                  ),
                  new Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                      child: Image.asset('graphics/forgerock_hackathon.png', width: 50.0, height: 50.0),
                  ),
            ])));
  }

}

class MannekenPisp extends StatelessWidget {
  var storage;

  MannekenPisp(this.storage);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Money Me',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new HomePage(storage),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
