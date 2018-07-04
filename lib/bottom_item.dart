import 'package:flutter/material.dart';

class BottomItem {
  String title;
  IconData icon;
  Color color;
  BottomItem(this.title, this.icon, this.color);
  BottomNavigationBarItem toBottomNavigationBarItem() {
    return new BottomNavigationBarItem(
        icon: new Icon(this.icon), title: new Text(this.title));
  }
}
