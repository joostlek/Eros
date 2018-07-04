import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final FirebaseUser user;
  Profile({this.user});
  @override
  State<StatefulWidget> createState() {
    return new ProfileState();
  }
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    print(widget.user);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.user.displayName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: FirebaseAuth.instance.signOut,
            tooltip: "Sign out",
          )
        ],
      ),
      body: Center(
        child: Container(
          width: 96.0,
          height: 96.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(widget.user.photoUrl))),
        ),
      ),
    );
  }
}
