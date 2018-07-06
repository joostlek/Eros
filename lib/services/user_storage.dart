import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final CollectionReference userCollection =
    Firestore.instance.collection('users');

class UserStorage {
  final FirebaseUser user;

  UserStorage.forUser({
    @required this.user,
  }) : assert(user != null);

  static User fromDocument(DocumentSnapshot document) =>
      _fromMap(document.data);

  static User _fromMap(Map<String, dynamic> data) => new User.fromMap(data);

  Map<String, dynamic> _toMap(User user, [Map<String, dynamic> other]) {
    final Map<String, dynamic> result = {};
    if (other != null) {
      result.addAll(other);
    }
    result.addAll(user.toMap());
    return result;
  }

  Future<User> create(User user) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot newDoc =
          await tx.get(userCollection.document(user.uid));
      await tx.set(newDoc.reference, user.toMap());
      return user;
    };
    return Firestore.instance
        .runTransaction(createTransaction)
        .then(_fromMap)
        .catchError((e) {
      print('dart error $e');
      return null;
    });
  }

  Stream<QuerySnapshot> list({int limit, int offset}) {
    Stream<QuerySnapshot> snapshots =
        userCollection.where('uid', isEqualTo: this.user.uid).snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  Future<User> getUser() async {
    return fromDocument(await userCollection.document(user.uid).get());
  }

  Future<bool> update(User user) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot doc =
          await tx.get(userCollection.document(user.uid));
      await tx.update(doc.reference, _toMap(user));
      return {'result': true};
    };
    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((r) => r['result'])
        .catchError((e) {
      print('dart error $e');
      return false;
    });
  }

  Future<bool> delete(User user) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot doc =
          await tx.get(userCollection.document(user.uid));
      await tx.delete(doc.reference);
      return {'result': true};
    };
    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((r) => r['result'])
        .catchError((e) {
      print('dart error $e');
      return false;
    });
  }
}
