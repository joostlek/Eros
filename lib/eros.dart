import 'dart:async';

import 'package:eros/bottom_item.dart';
//import 'package:eros/pages/profile.dart';
import 'package:flutter/material.dart';

class Eros extends StatefulWidget {
  Eros();
  final bottomItems = [
    new BottomItem("Camera", Icons.camera_alt, Colors.red),
    new BottomItem("My profile", Icons.person_outline, Colors.cyan),
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
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: getNavItemWidget(_selectedNavIndex),
    );
  }

  _onSelectItem(int index) {
    setState(() => _selectedNavIndex = index);
    getNavItemWidget(_selectedNavIndex);
//    title = widget.bottomItems[index].title;
  }

  getNavItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Center(child: new Text("Page 2"));
      case 1:
        return new Text("");
    }
  }
}
