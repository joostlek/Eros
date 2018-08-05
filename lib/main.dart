import 'dart:async';

import 'package:eros/eros.dart';
import 'package:eros/login.dart';
import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/activity_storage.dart';
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

  @override
  void initState() {
    _checkCurrentUser();
    super.initState();
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
      return FutureBuilder<User>(
          future: getUser(_currentUser),
          builder: (BuildContext context, AsyncSnapshot<User> user) {
            if (user.hasData && user.data != null) {
              return Eros(
                user: user.data,
                userStorage: UserStorage.forUser(user: user.data),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
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

  Future<User> getUser(FirebaseUser firebaseUser) async {
    UserStorage userStorage =
        UserStorage.forFirebaseUser(firebaseUser: firebaseUser);
    if (!(await userStorage.isUserStored())) {
      User user = await userStorage.create(User.fromFirebaseUser(firebaseUser));
      _createUserActivity(user);
      return user;
    }
    return userStorage.getUser();
  }

  _createUserActivity(User user) {
    ActivityStorage activityStorage = ActivityStorage(user);
    activityStorage.createActivity(Activities.RegisterUser);
  }
}
