import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = new GoogleSignIn();

class Login extends StatefulWidget {
  Login(this.title);

  final String title;
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _handleGoogleSignIn() async {
    GoogleSignIn _googleSignIn = new GoogleSignIn();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken != null) {
        try {
          FirebaseUser user = await _auth.signInWithGoogle(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          );
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Padding(
          padding: EdgeInsets.fromLTRB(64.0, 16.0, 64.0, 16.0),
          child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    color: Colors.white,
                    onPressed: _handleGoogleSignIn,
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                            padding:
                            EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                            child: new Image.asset('assets/go-logo.png')),
                        new Center(
                          child: new Text('Sign in with Google'),
                        ),
                      ],
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    color: Color(0xFF3B5998),
                    textColor: Colors.white,
                    onPressed: () => {},
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                            padding:
                            EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                            child: new Image.asset('assets/fb-logo.png')),
                        new Center(
                          child: new Text('Sign in with Facebook'),
                        ),
                      ],
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    color: Color(0xFF1DA1F2),
                    textColor: Colors.white,
                    onPressed: () => {},
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                            padding:
                            EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                            child: new Icon(Icons.home)),
                        new Center(
                          child: new Text('Sign in with Twitter'),
                        ),
                      ],
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    color: Colors.redAccent[700],
                    textColor: Colors.white,
                    onPressed: () => {},
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                            padding:
                            EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                            child: new Icon(Icons.email)),
                        new Center(
                          child: new Text('Sign in with email'),
                        ),
                      ],
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new RaisedButton(
                    color: Colors.tealAccent[700],
                    textColor: Colors.white,
                    onPressed: () => {},
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                            padding:
                            EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                            child: new Icon(Icons.phone)),
                        new Center(
                          child: new Text('Sign in with phone'),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
        ));
  }
}
