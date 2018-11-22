import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ipisp/edit_profile.dart';
import 'package:ipisp/payment_details.dart';
import 'package:ipisp/request_money_qr.dart';
import 'package:path/path.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RequestMoney extends StatelessWidget {
  var storage;

  RequestMoney(this.storage);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: const Text("Request Money"),
      ),
      body: SingleChildScrollView(child: RequestMoneyForm(storage)),
    );
  }
}

class RequestMoneyForm extends StatefulWidget {
  var storage;

  RequestMoneyForm(this.storage);

  @override
  State<StatefulWidget> createState() => new _RequestMoneyFormState(storage);
}

class _RequestMoneyFormData {
  var reference;
  var amount;
  var imageUrl;

  PaymentData asPaymentData() {
    return PaymentData(
        id: "", // TODO
        name: "",
        accountNumber: "12345678",
        sortCode: "123456",
        amount: this.amount,
        currency: "GBP",
        recipientImageUrl:"",
        paymentImageUrl: this.imageUrl,
        description: this.reference);
  }
}

class _RequestMoneyFormState extends State<RequestMoneyForm> {
  final FirebaseStorage storage;

  final _formKey = new GlobalKey<FormState>();

  File _image;

  String _account = 'Current account';

  var formData = new _RequestMoneyFormData();

  _RequestMoneyFormState(this.storage);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Description"),
                new TextFormField(
                  decoration: new InputDecoration(hintText: "Pay reference"),
                  validator: (value) => validateTextField(value),
                  onSaved: (val) {
                    this.formData.reference = val;
                  },
                ),
                Text("Account"),
                new DropdownButton<String>(
                  value: _account,
                  items: <String>["Current account", "Savings account"]
                      .map((value) {
                    return new DropdownMenuItem(
                        value: value,
                        child: new Text(value)
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _account = val;
                    });
                  },
                ),
                Text("Amount"),
                new Row(children: <Widget>[
                  const Text("£"),
                  Flexible(
                      child: new TextFormField(
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    validator: (value) => validateTextField(value),
                    onSaved: (val) {
                      this.formData.amount = val;
                    },
                  )),
                ]),
                new FlatButton.icon(
                  icon: new Icon(Icons.camera_alt),
                  label: new Text("Include photo (optional)"),
                  onPressed: getImage,
                ),
                _image != null
                    ? Wrap(
                        spacing: 10.0,
                        children: <Widget>[Image.file(_image)],
                      )
                    : Container(),
                new RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  splashColor: Colors.redAccent,
                  child: const Text("REQUEST"),
                  onPressed: () {
                    _formKey.currentState.save();
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              new GenerateRequestQR(formData.asPaymentData())),
                    );
                  },
                )
              ],
            )));
  }

  validateTextField(String value) {
    if (value.isEmpty) {
      return 'Required';
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });

    this.formData.imageUrl = await uploadImage(_image);
  }

  Future uploadImage(File image) async {
    StorageUploadTask uploadTask = storage
        .ref()
        .child('payment_images')
        .child(basename(_image.path))
        .putFile(
          image,
          new StorageMetadata(
            contentLanguage: 'en',
            customMetadata: <String, String>{'activity': 'test'},
          ),
        );
    //return (await uploadTask.onComplete).downloadUrl.toString();
  }
}
