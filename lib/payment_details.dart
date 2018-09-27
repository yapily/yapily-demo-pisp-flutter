import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipisp/select_institution.dart';

class PaymentDetails extends StatefulWidget {
  final PaymentData data;

  PaymentDetails(this.data);

  @override
  State<StatefulWidget> createState() => new _PaymentDetailsState(data);
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final PaymentData data;

  final labelTextStyle = const TextStyle(color: Colors.blue, fontSize: 20.0);

  _PaymentDetailsState(this.data);

  @override
  Widget build(BuildContext sendMoneyContext) {
    return new Scaffold(
        appBar: new AppBar(title: const Text("Send Money")),
        body: SingleChildScrollView(
            child: new Padding(
                padding: const EdgeInsets.all(20.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: new Text(
                          "To:",
                          style: const TextStyle(fontSize: 16.0),
                        )),
                    new Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: data.recipientImageUrl!=null ? Wrap(spacing: 10.0, children: <Widget>[Image.network(data.recipientImageUrl, width: 75.0, height: 75.0,)]) : Container(),
                    ),
                    new Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: new Text(
                          data.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                        )),
                    new Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: new Text(
                          "Amount:",
                          style: const TextStyle(fontSize: 16.0),
                        )),
                    new Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: new Text(
                          "£" + data.amount,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                        )),
                    new Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: new Text(
                          "Description:",
                          style: const TextStyle(fontSize: 16.0),
                        )),
                    new Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: new Text(
                          data.description!=null ? data.description : '',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                        )),
                    new Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: data.paymentImageUrl!=null ? Wrap(spacing: 10.0, children: <Widget>[Image.network(data.paymentImageUrl)]) : Container(),
                    ),
                    new Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: new RaisedButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          splashColor: Colors.redAccent,
                          child: const Text("PAY"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                              builder: (context) => new SelectInstitution(data, sendMoneyContext).build()),
                            );
                          },
                        ))
                  ],
                ),
              )
      )
    );
  }
}

/**
 * {
    "id":"bojack",
    "name":"Bojack",
    "description":"Forging equipment and rock candy",
    "accountNumber":"12345678",
    "sortCode":"123456",
    "amount":"40.42",
    "currency":"GBP",
    "recipientImageUrl":"https://image.shutterstock.com/image-photo/horses-260nw-591425546.jpg",
    "paymentImageUrl":"https://vignette.wikia.nocookie.net/yandere-simulator-fanon/images/4/4e/Johnson.jpg/revision/latest?cb=20160625153352",
    }
 */
class PaymentData {
  final String id;
  final String name;
  final String description;
  final String accountNumber;
  final String sortCode;
  final String amount;
  final String currency;
  final String recipientImageUrl;
  final String paymentImageUrl;

  PaymentData({
      this.id,
      this.name,
      this.accountNumber,
      this.sortCode,
      this.amount,
      this.currency,
      this.recipientImageUrl,
      this.paymentImageUrl,
      this.description});

  PaymentData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        recipientImageUrl = json['recipientImageUrl'],
        paymentImageUrl = json['paymentImageUrl'],
        accountNumber = json['accountNumber'],
        sortCode = json['sortCode'],
        amount = json['amount'],
        currency = json['currency'];

  Map<String, dynamic> toJson() => {
    'id':this.id,
    'name':this.name,
    'description':this.description,
    'recipientImageUrl':this.recipientImageUrl,
    'paymentImageUrl':this.paymentImageUrl,
    'accountNumber':this.accountNumber,
    'sortCode':this.sortCode,
    'amount':this.amount,
    'currency':this.currency,
  };

}
