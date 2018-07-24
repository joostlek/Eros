import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/user_storage.dart';
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
      Location.fromJson(data);

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
      final Location location = Location(
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

  Stream<QuerySnapshot> listEmployees(Location location,
      {int limit, int offset}) {
    Stream<QuerySnapshot> snapshots = Firestore.instance
        .collection('users')
        .where('locations.${location.locationId}', isEqualTo: true)
        .snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
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
        await locationCollection.document(locationId).get().catchError((e) {
      print('dart error $e');
      return null;
    }));
  }

  Future<bool> promoteUser(Location location, User givenUser) async {
    location.managers[givenUser.uid] = true;
    givenUser.manager[location.locationId] = true;
    return await update(location) ==
        await UserStorage.forUser(user: user).update(givenUser);
  }

  Future<bool> demoteUser(Location location, User givenUser) async {
    location.managers.remove(givenUser.uid);
    givenUser.manager.remove(location.locationId);
    return await update(location) ==
        await UserStorage.forUser(user: user).update(givenUser);
  }

  bool getBool(Map<String, dynamic> data) {
    return data['result'];
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
        .then((r) => getBool(r))
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

  Future<bool> removeUser(Location location, User user) async {
    location.managers.remove(user.uid);
    location.employees.remove(user.uid);
    user.locations.remove(location.locationId);
    user.manager.remove(location.locationId);
    return await update(location) ==
        await UserStorage.forUser(user: user).update(user);
  }

  Future<bool> undoRemoveUser(Location location, User user) async {
    if (user.manager[location.locationId] == true) {
      location.managers[user.uid] = true;
    }
    location.employees[user.uid] = true;
    return await update(location) ==
        await UserStorage.forUser(user: user).update(user);
  }

  Future<Map<String, dynamic>> addUser(Location location, String uid) async {
    DocumentSnapshot doc =
        await Firestore.instance.collection('users').document(uid).get();
    if (!doc.exists) {
      return {
        'success': false,
        'user': null,
        'error_message': 'User not found',
      };
    } else if (doc.data == null) {
      return {
        'success': false,
        'user': null,
        'error_message': 'User is empty',
      };
    }
    User user = UserStorage.fromDocument(doc);
    if (location.employees[user.uid] == true &&
        user.locations[location.locationId] == true) {
      return {
        'success': false,
        'user': user,
        'error_message': 'User already added',
      };
    }
    location.employees[user.uid] = true;
    user.locations[location.locationId] = true;
    return {
      'success': await update(location) ==
          await UserStorage.forUser(user: user).update(user),
      'user': user,
      'error_message': null,
    };
  }
}
