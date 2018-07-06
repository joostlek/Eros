import 'dart:async';

import 'package:eros/bottom_item.dart';
import 'package:eros/pages/dashboard.dart';
import 'package:eros/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:eros/pages/profile.dart';
import 'package:flutter/material.dart';

class Eros extends StatefulWidget {
  FirebaseUser user;
  Eros({this.user});

  final bottomItems = [
    new BottomItem("Camera", Icons.camera_alt, Colors.blue),
    new BottomItem("Dashboard", Icons.dashboard, Colors.blue),
    new BottomItem("My profile", Icons.person, Colors.blue)
  ];

  @override
  State<StatefulWidget> createState() {
    return new _ErosState();
  }
}

class _ErosState extends State<Eros> {
  int _selectedNavIndex = 0;
  String title = "Eros";

  @override
  Widget build(BuildContext context) {
    var navBarItems = <BottomNavigationBarItem>[];
    for (var i = 0; i < widget.bottomItems.length; i++) {
      navBarItems.add(widget.bottomItems[i].toBottomNavigationBarItem());
    }
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        items: navBarItems,
        onTap: (index) => _onSelectItem(index),
        currentIndex: _selectedNavIndex,
      ),
      body: getNavItemWidget(_selectedNavIndex),
    );
  }

  _onSelectItem(int index) {
    setState(() => _selectedNavIndex = index);
    getNavItemWidget(_selectedNavIndex);
  }

  getNavItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Center(child: new Text("Page 2"));
      case 1:
        return new Dashboard();
      case 2:
        return new Profile(user: widget.user);
    }
  }
}
