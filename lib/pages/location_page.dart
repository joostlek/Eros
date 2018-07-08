import 'dart:async';

import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/location_employee_page.dart';
import 'package:eros/services/location_storage.dart';
import 'package:eros/services/user_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  final Location location;
  final User user;

  LocationPage(this.user, this.location);

  Future<LocationStorage> getLocationStorage() async {
    return LocationStorage.forUser(user: user);
  }

  @override
  State<StatefulWidget> createState() {
    return new LocationPageState();
  }
}

class LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location.name),
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
                        image: new NetworkImage(widget.location.photoUrl))),
              ),
            ),
          ),
          Center(
            child: Text(
              widget.location.name,
              textScaleFactor: 1.5,
            ),
          ),
          Text(
            "${widget.location.street} ${widget.location.houseNumber}\n"
                "${widget.location.country}\n"
                "${widget.location.city}",
            style: TextStyle(color: Colors.grey[600]),
          ),
          FutureBuilder<LocationStorage>(
            future: widget.getLocationStorage(),
            builder: (BuildContext context,
                AsyncSnapshot<LocationStorage> locationStorage) {
              if (locationStorage.hasData && locationStorage.data != null) {
                return Card(
                  child: ListTile(
                    title: Text('Employees'),
                    leading: Icon(Icons.person),
                    trailing: IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {
                        print(widget.location);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationEmployeePage(
                                      locationStorage: locationStorage.data,
                                      location: widget.location,
                                    )));
                      },
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
