import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:ipisp/payment_details.dart';
import 'package:ipisp/payment_details_jwt_parser.dart';

class SendMoney extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SendMoneyState();

}

class _SendMoneyState extends State<SendMoney> {

  String barcode = null;

  @override
  void initState() {
    scan();
  }

  @override
  Widget build(BuildContext context) {
    if(barcode != null) {
      try {
        var barcodeJwt = Uri.parse(barcode).queryParameters['payment'];
        var data = PaymentDetailsJWTParser.parseJWT(barcodeJwt);
        return new PaymentDetails(data);
      } on FormatException {
//      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)'); //FIXME
        Navigator.pop(context);
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("Invalid payment barcode"))
        );
      }
    } else {
      return new Container();
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on FormatException {
//      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)'); //FIXME
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("Invalid payment barcode")));
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }

  }

}
