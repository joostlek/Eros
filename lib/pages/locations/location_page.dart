import 'dart:async';

import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/locations/location_coupon_page.dart';
import 'package:eros/pages/locations/location_employee_page.dart';
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
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Edit location',
        // TODO - Add edit function
        onPressed: () => {},
        child: Icon(Icons.edit),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
            child: Text(
              "${widget.location.street} ${widget.location.houseNumber}\n"
                  "${widget.location.city}\n"
                  "${widget.location.country}",
              style: TextStyle(color: Colors.grey[600]),
            ),
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
                      tooltip: 'Go to employee page',
                      onPressed: () {
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
          FutureBuilder<LocationStorage>(
            future: widget.getLocationStorage(),
            builder: (BuildContext context,
                AsyncSnapshot<LocationStorage> locationStorage) {
              if (locationStorage.hasData && locationStorage.data != null) {
                return Card(
                  child: ListTile(
                    title: Text('Coupons'),
                    leading: Icon(Icons.local_activity),
                    trailing: IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationCouponPage(
                                      widget.location,
                                      widget.user,
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
          FutureBuilder<LocationStorage>(
            future: widget.getLocationStorage(),
            builder: (BuildContext context,
                AsyncSnapshot<LocationStorage> locationStorage) {
              if (locationStorage.hasData && locationStorage.data != null) {
                return Card(
                  child: ListTile(
                    title: Text('Series'),
                    leading: Icon(Icons.view_agenda),
                    trailing: IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {
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
