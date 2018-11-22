// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of cloud_firestore;

/// A QuerySnapshot contains zero or more DocumentSnapshot objects.
class QuerySnapshot {
  /// Gets a list of all the documents included in this snapshot
  final List<DocumentSnapshot> documents;

  /// An array of the documents that changed since the last snapshot. If this
  /// is the first snapshot, all documents will be in the list as Added changes.
  final List<DocumentChange> documentChanges;

  final Firestore _firestore;

  QuerySnapshot._(Map<dynamic, dynamic> data, this._firestore)
      : documents = new List<DocumentSnapshot>.generate(
            data['documents'].length, (int index) {
          return new DocumentSnapshot._(
            data['paths'][index],
            _asStringKeyedMap(data['documents'][index]),
            _firestore,
          );
        }),
        documentChanges = new List<DocumentChange>.generate(
            data['documentChanges'].length, (int index) {
          return new DocumentChange._(
            data['documentChanges'][index],
            _firestore,
          );
        });
}
