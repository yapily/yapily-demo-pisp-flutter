// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Path Provider',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Path Provider'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Directory> _tempDirectory;
  Future<Directory> _appDocumentsDirectory;
  Future<Directory> _externalDocumentsDirectory;

  void _requestTempDirectory() {
    setState(() {
      _tempDirectory = getTemporaryDirectory();
    });
  }

  Widget _buildDirectory(
      BuildContext context, AsyncSnapshot<Directory> snapshot) {
    Text text = const Text('');
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = new Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        text = new Text('path: ${snapshot.data.path}');
      } else {
        text = const Text('path unavailable');
      }
    }
    return new Padding(padding: const EdgeInsets.all(16.0), child: text);
  }

  void _requestAppDocumentsDirectory() {
    setState(() {
      _appDocumentsDirectory = getApplicationDocumentsDirectory();
    });
  }

  void _requestExternalStorageDirectory() {
    setState(() {
      _externalDocumentsDirectory = getExternalStorageDirectory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    child: const Text('Get Temporary Directory'),
                    onPressed: _requestTempDirectory,
                  ),
                ),
              ],
            ),
            new Expanded(
              child: new FutureBuilder<Directory>(
                  future: _tempDirectory, builder: _buildDirectory),
            ),
            new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    child: const Text('Get Application Documents Directory'),
                    onPressed: _requestAppDocumentsDirectory,
                  ),
                ),
              ],
            ),
            new Expanded(
              child: new FutureBuilder<Directory>(
                  future: _appDocumentsDirectory, builder: _buildDirectory),
            ),
            new Column(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: new Text('${Platform.isIOS ?
                                    "External directories are unavailable " 
                                    "on iOS":
                                    "Get External Storage Directory" }'),
                  onPressed:
                      Platform.isIOS ? null : _requestExternalStorageDirectory,
                ),
              ),
            ]),
            new Expanded(
              child: new FutureBuilder<Directory>(
                  future: _externalDocumentsDirectory,
                  builder: _buildDirectory),
            ),
          ],
        ),
      ),
    );
  }
}
