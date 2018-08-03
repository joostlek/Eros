import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final CollectionReference userCollection =
    Firestore.instance.collection('users');

class UserStorage {
  FirebaseUser firebaseUser;
  User user;

  UserStorage();

  UserStorage.forFirebaseUser({
    @required this.firebaseUser,
  }) : assert(firebaseUser != null);

  UserStorage.forUser({
    @required this.user,
  }) : assert(user != null);

  static User fromDocument(DocumentSnapshot document) =>
      _fromMap(document.data);

  static User _fromMap(Map<String, dynamic> data) => User.fromJson(data);

  Map<String, dynamic> _toMap(User user, [Map<String, dynamic> other]) {
    final Map<String, dynamic> result = {};
    if (other != null) {
      result.addAll(other);
    }
    result.addAll(json.decode(json.encode(user)));
    return result;
  }

  Future<User> create(User user) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot newDoc =
          await tx.get(userCollection.document(user.uid));
      await tx.set(newDoc.reference,
          _toMap(user, {'created': DateTime.now().toUtc().toIso8601String()}));
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
    Stream<QuerySnapshot> snapshots = userCollection
        .where('uid', isEqualTo: this.firebaseUser.uid)
        .snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  Future<bool> isUserStored() {
    final DocumentReference userRef = userCollection.document(firebaseUser.uid);
    return userRef.get().then((DocumentSnapshot docSnapshot) {
      return docSnapshot.exists;
    });
  }

  Future<User> getUser() async {
    if (user == null) {
      user =
          fromDocument(await userCollection.document(firebaseUser.uid).get());
    }
    return user;
  }

  Future<User> getUserByUid(String uid) async {
    return fromDocument(await userCollection.document(uid).get());
  }

  bool getBool(Map<String, dynamic> data) {
    return data['result'];
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
        .then((r) => getBool(r))
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
