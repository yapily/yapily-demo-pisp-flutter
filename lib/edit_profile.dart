import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {

  static const String NAME_PREF = "name";
  static const String IMAGE_URL_PREF = "imageUrl";
  static const String ACCOUNT_NO_PREF = "accountNo";
  static const String SORTCODE_PREF = "sortCode";

  SharedPreferences _prefs;

  final _formKey = new GlobalKey<FormState>();

  var formData = new _EditProfileFormData();

  @override
  void initState() {
    SharedPreferences.getInstance().then((result) {
      setState(() {
        _prefs = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Profile"),
      ),
      body: new Form(
        key: _formKey,
        child:Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: const Text("Name")
                  ),
                  Expanded(
                    child: new TextFormField(
                      controller: TextEditingController(text: _prefs!=null ? _prefs.getString(NAME_PREF) : ""),
                      decoration: new InputDecoration(
                          hintText: ""
                      ),
                      validator: (value) => validateTextField(value),
                      onSaved: (val) {
                        formData.name = val;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: const Text("Image")
                  ),
                  Expanded(
                    child: new TextFormField(
                      controller: TextEditingController(text: _prefs!=null ? _prefs.getString(IMAGE_URL_PREF) : ""),
                      decoration: new InputDecoration(
                          hintText: ""
                      ),
                      validator: (value) => validateTextField(value),
                      onSaved: (val) {
                        formData.imageUrl = val;
                      },
                    ),
                  ),
                ],
              ),
              new RaisedButton(
                color: Colors.red,
                textColor: Colors.white,
                splashColor: Colors.redAccent,
                child: const Text("Save changes"),
                onPressed: () {
                  _formKey.currentState.save();
                  SharedPreferences.getInstance().then((prefs){
                    prefs.setString(NAME_PREF, formData.name);
                    prefs.setString(IMAGE_URL_PREF, formData.imageUrl);
                  });
                  Navigator.pop(context);
                },
              )
            ],
          )
      ),
    ),
    );
  }

  validateTextField(String value) {
    if (value.isEmpty) {
      return 'Required';
    }
  }

}

class _EditProfileFormData {
  String name;
  String imageUrl;
}
