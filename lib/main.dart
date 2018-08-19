import 'dart:async';

import 'package:eros/eros.dart';
import 'package:eros/login.dart';
import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/activity_storage.dart';
import 'package:eros/services/location_storage.dart';
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
  LocationStorage locationStorage;
  UserStorage userStorage;

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

  Future<bool> getStorage(FirebaseUser user) async {
    userStorage = await getUserStorage(user);
    locationStorage =
        LocationStorage.forUser(user: await userStorage.getUser());
    if (userStorage != null && locationStorage != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return new Login('Couppo');
    } else {
      return FutureBuilder<bool>(
        future: getStorage(_currentUser),
        builder: (BuildContext context, AsyncSnapshot<bool> success) {
          if (success.hasData && success.data != null && success.data == true) {
            return Eros(
              userStorage: userStorage,
              locationStorage: locationStorage,
            );
          } else {
            return Scaffold(
              body: Container(
                color: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/eros-logo.png'),
                      ),
                      Text(
                        'Couppo',
                        textScaleFactor: 3.5,
                      ),
                      Text(
                        'Coupon verification tool',
                        textScaleFactor: 1.5,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );
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

  Future<UserStorage> getUserStorage(FirebaseUser firebaseUser) async {
    UserStorage userStorage =
        UserStorage.forFirebaseUser(firebaseUser: firebaseUser);
    if (!(await userStorage.isUserStored())) {
      User user = await userStorage.create(User.fromFirebaseUser(firebaseUser));
      _createUserActivity(user);
      return userStorage;
    }
    return userStorage;
  }

  _createUserActivity(User user) {
    ActivityStorage activityStorage = ActivityStorage(user);
    activityStorage.createActivity(Activities.RegisterUser);
  }
}
