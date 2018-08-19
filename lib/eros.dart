import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/bottom_item.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/camera/camera_page.dart';
import 'package:eros/pages/dashboard/dashboard.dart';
import 'package:eros/pages/profile/profile.dart';
import 'package:eros/services/location_storage.dart';
import 'package:eros/services/user_storage.dart';

import 'package:flutter/material.dart';

class Eros extends StatefulWidget {
  final UserStorage userStorage;
  final LocationStorage locationStorage;

  Eros({this.userStorage, this.locationStorage});

  final bottomItems = [
    new BottomItem('Camera', Icons.camera_alt, Colors.blue),
    new BottomItem('Dashboard', Icons.dashboard, Colors.blue),
    new BottomItem('My profile', Icons.person, Colors.blue)
  ];

  @override
  State<StatefulWidget> createState() {
    return new _ErosState();
  }
}

class _ErosState extends State<Eros> {
  Stream<QuerySnapshot> locationStream;
  int _selectedNavIndex = 1;
  String title = 'Couppo';


  @override
  void initState() {
    super.initState();
    locationStream = widget.locationStorage.list();
  }

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
        return new CameraPage();
      case 1:
        return new Dashboard(
          locationStorage: widget.locationStorage,
          userStorage: widget.userStorage,
        );
      case 2:
        return new Profile(
          user: widget.userStorage.user,
        );
    }
  }
}
