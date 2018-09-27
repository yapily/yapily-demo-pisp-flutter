import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ipisp/payment_details.dart';
import 'package:yapily_sdk/api.dart';
import 'api_client_factory.dart';

class PaymentProcessing {
  
  PaymentResponse paymentResponse;
  String consent;
  BuildContext context;
  PaymentData paymentData;
  int retries = 34;
  Duration timeToCall = new Duration(seconds: 2);
  
  PaymentProcessing({this.paymentData, this.paymentResponse, this.consent});

  Scaffold build() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Processing Payment"),
      ),
      body: new FutureBuilder<PaymentResponse>(
        future: verifyPayment(this.paymentResponse.id),
        builder: (context, snapshot) {
          this.context = context;
          if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          else if (snapshot.hasData) {
          }
          // By default, show a loading spinner
          return new Center(
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<PaymentResponse> verifyPayment(String paymentId) async {
    return _getPaymentStatus(paymentId).then((paymentResponse) {
      if (paymentResponse.data.status != 'COMPLETED' && retries >= 1) {
        sleep(timeToCall);
        return verifyPayment(paymentId);
      } else if (retries < 1) {
        throw("Payment Failed");
      } else {
        confirmPayment(context, paymentResponse.data.id);
        return paymentResponse.data;
      }
    });
  }

  void confirmPayment(BuildContext context, String paymentId) {
    var dialog = new AlertDialog(
      title: new Text("Payment of " + paymentData.amount.toString() + " " +
          paymentData.currency + " completed succesfully"),
      content: new Text("Payment Id: " + paymentId + "\n\nThank you for using us for your payments!"),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Go Home'),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ],
    );
    showDialog(context: context, child: dialog);
  }

  Future<ApiResponseOfPaymentResponse> _getPaymentStatus(String paymentId) {
    var apiClientFactory = ApiClientFactory.create();
    return apiClientFactory.then( (apiClient) {
      return new PaymentsApi(apiClient).getPaymentStatusUsingGET(paymentId, consent);
    });
  }

}