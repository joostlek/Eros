import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:flutter/material.dart';

final CollectionReference locationCollection =
    Firestore.instance.collection('locations');

class LocationStorage {
  final User user;

  LocationStorage.forUser({
    @required this.user,
  }) : assert(user != null);

  static Location fromDocument(DocumentSnapshot document) =>
      _fromMap(document.data);

  static Location _fromMap(Map<String, dynamic> data) =>
      new Location.fromJson(data);

  Map<String, dynamic> _toMap(Location location, [Map<String, dynamic> other]) {
    final Map<String, dynamic> result = {};
    if (other != null) {
      result.addAll(other);
    }
    result.addAll(json.decode(json.encode(location)));
    return result;
  }

  Future<Location> create(String name, String street, String houseNumber,
      String city, String country, String photoUrl) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot doc = await tx.get(locationCollection.document());
      final Location location = new Location(
          doc.documentID,
          name,
          street,
          houseNumber,
          city,
          country,
          this.user.uid,
          photoUrl,
          {},
          {this.user.uid: true});
      final Map<String, dynamic> data = _toMap(location, {
        'created': new DateTime.now().toUtc().toIso8601String(),
      });
      await tx.set(doc.reference, data);
      return data;
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
    Stream<QuerySnapshot> snapshots = locationCollection
        .where('employees.${this.user.uid}', isEqualTo: true)
        .snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  Future<Location> get({String locationId}) async {
    return fromDocument(
        await Firestore.instance.document(locationId).get().catchError((e) {
      print('dart error $e');
      return null;
    }));
  }

  Future<bool> update(Location location) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot doc =
          await tx.get(locationCollection.document(location.locationId));
      if (doc['owner'] != this.user.uid) {
        throw new Exception('Permission Denied');
      }
      await tx.update(doc.reference, _toMap(location));
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

  Future<bool> delete(Location location) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot doc =
          await tx.get(locationCollection.document(location.locationId));
      if (doc['owner'] != this.user.uid) {
        throw new Exception('Permission denied');
      }
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
