// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'test',
    options: const FirebaseOptions(
      googleAppID: '1:79601577497:ios:5f2bcc6ba8cecddd',
      gcmSenderID: '79601577497',
      apiKey: 'AIzaSyArgmRGfB5kiQT6CunAOmKRVKEsxKmy6YI-G72PVU',
      projectID: 'flutter-firestore',
    ),
  );
  final Firestore firestore = new Firestore(app: app);

  runApp(new MaterialApp(
      title: 'Firestore Example', home: new MyHomePage(firestore: firestore)));
}

class MessageList extends StatelessWidget {
  MessageList({this.firestore});

  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        final int messageCount = snapshot.data.documents.length;
        return new ListView.builder(
          itemCount: messageCount,
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            return new ListTile(
              title: new Text(document['message'] ?? '<No message retrieved>'),
              subtitle: new Text('Message ${index + 1} of $messageCount'),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({this.firestore});
  final Firestore firestore;
  CollectionReference get messages => firestore.collection('messages');

  Future<Null> _addMessage() async {
    final DocumentReference document = messages.document();
    document.setData(<String, dynamic>{
      'message': 'Hello world!',
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Firestore Example'),
      ),
      body: new MessageList(firestore: firestore),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
