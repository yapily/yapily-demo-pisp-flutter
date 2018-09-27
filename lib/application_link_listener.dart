import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'payment_request_listener.dart';

class ApplicationLinkListener extends WidgetsBindingObserver{

  MethodChannel platform;
  PaymentRequestListener paymentRequestListener;

  ApplicationLinkListener(this.platform, this.paymentRequestListener);

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    getPaymentJWT();
  }

  void getPaymentJWT() async {
    var sharedData = await platform.invokeMethod("getPaymentJWT");
    if (sharedData != null) {
      paymentRequestListener.paymentRequestReceived(sharedData);
    }
  }

}