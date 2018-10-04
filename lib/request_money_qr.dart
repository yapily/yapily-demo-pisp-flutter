import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipisp/edit_profile.dart';
import 'package:ipisp/payment_details.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateRequestQR extends StatefulWidget {
  PaymentData _qrData;

  GenerateRequestQR(this._qrData);

  @override
  State<StatefulWidget> createState() => new _GenerateRequestQRState(_qrData);
}

class _GenerateRequestQRState extends State<GenerateRequestQR> {
  PaymentData _qrData;
  GlobalKey globalKey = new GlobalKey();

  String _name;
  String _recipientImage;

  _GenerateRequestQRState(this._qrData);

  @override
  void initState() {
    SharedPreferences.getInstance().then((result) {
      setState(() {
        _name = result.getString(EditProfileState.NAME_PREF);
        _recipientImage = result.getString(EditProfileState.IMAGE_URL_PREF);
      });
    });
  }

  _qrWidget(context, globalKey) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return RepaintBoundary(
        key: globalKey,
        child: new Stack(children: <Widget>[
          new Container(
              alignment: Alignment.center,
              child: new QrImage(
                data: qrDataFromPaymentData(),
                size: bodyHeight * 0.5,
                version: 20,
              )
          ),
          new Container(
            alignment: Alignment.center,
            child: _recipientImage!=null
                ? Image.network(_recipientImage, width: 65.0, height: 65.0,)
                : Container()
          )
        ]));
  }

  String qrDataFromPaymentData(){
    var paymentJson = _qrData.toJson();
    paymentJson['name'] = _name;
    paymentJson['recipientImageUrl'] = _recipientImage;
    var dataString = json.encode(paymentJson);
    //TODO nope :)
    var jwt = "yourJWTheader." + base64.encode(utf8.encode(dataString)) + ".yourJWTSignature";
    return "https://moneyme.yapily.com?payment=" + jwt;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(centerTitle: true, title: new Text("Payment QR")),
        body: Column(
          children: <Widget>[
            Expanded(child: Center(child: _qrWidget(context, globalKey))),
            Text(
              '£${_qrData.amount}',
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ));
  }
}
