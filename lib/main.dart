import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/eros.dart';
import 'package:eros/login.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/user_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() {
  FirebaseAnalytics analytics = new FirebaseAnalytics();
  runApp(new MaterialApp(
    navigatorObservers: [
      new FirebaseAnalyticsObserver(analytics: analytics),
    ],
    home: new Example(),
  ));
}

class Example extends StatefulWidget {
  @override
  ExampleState createState() => new ExampleState();
}

class ExampleState extends State<Example> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;
  FirebaseUser _currentUser;
  User _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return new Login('Eros');
    } else {
      return new Eros(
          user: getUser(_currentUser),
          userStorage: UserStorage.forFirebaseUser(firebaseUser: _currentUser));
    }
  }

  void _checkCurrentUser() async {
    _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<User> getUser(FirebaseUser user) async {
    UserStorage userStorage = UserStorage.forFirebaseUser(firebaseUser: user);
    if (!(await userStorage.isUserStored())) {
      return userStorage.create(User.fromFirebaseUser(user));
    }
    return userStorage.getUser();
  }
}
