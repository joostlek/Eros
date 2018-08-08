import 'dart:async';
import 'package:eros/models/user.dart';
import 'package:eros/pages/profile/profile_qr_page.dart';
import 'package:eros/services/user_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final User user;

  Profile({this.user});

  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  Future<UserStorage> getStorage() async {
    return UserStorage.forUser(user: await widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.displayName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.wallpaper),
            tooltip: 'Show unique QR-code',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileQrPage(widget.user)));
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: FirebaseAuth.instance.signOut,
            tooltip: 'Sign out',
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
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.user.photoUrl))),
              ),
            ),
          ),
          Center(
            child: ListTile(
              title: Center(child: Text(widget.user.displayName)),
              subtitle: Center(child: Text(widget.user.email)),
//              textScaleFactor: 1.5,
            ),
          )
        ],
      ),
    );
  }
}
