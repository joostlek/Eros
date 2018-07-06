import 'package:flutter/material.dart';

class Locations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LocationsState();
  }
}

class LocationsState extends State<Locations> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Locations'),
      ),
    );
  }
}
