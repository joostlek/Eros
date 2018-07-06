import 'dart:async';
import 'dart:io';
import 'package:eros/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final User user;

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
      body: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
          ),
          Center(
            child: Text(
              widget.user.displayName,
              textScaleFactor: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Column(
              children: <Widget>[
                const ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.camera_alt),
                  ),
                  title: const Text("Amount of coupons scanned"),
                  subtitle: const Text("123"),
                ),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text("VIEW"),
                        onPressed: () => {},
                      )
                    ],
                  ),
                )
              ],
            )),
          )
        ],
      ),
    );
  }
}
