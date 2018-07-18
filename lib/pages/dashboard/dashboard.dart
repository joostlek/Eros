import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/dashboard/location_card.dart';
import 'package:eros/pages/locations/locations.dart';
import 'package:eros/services/location_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final Future<User> user;

  Dashboard({this.user});

  @override
  State<StatefulWidget> createState() {
    return new DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  Future<LocationStorage> getLocationStorage() async {
    return LocationStorage.forUser(user: await widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body:
//      Column(
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Card(
//              child: Column(
//                children: <Widget>[
//                  ListTile(
//                    title: Text('Locations'),
//                    subtitle: Text('Manage your locations'),
//                    leading: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Icon(Icons.location_on),
//                    ),
//                    trailing: IconButton(
//                        iconSize: 36.0,
//                        icon: Icon(Icons.chevron_right),
//                        tooltip: 'Go to locations',
//                        onPressed: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) =>
//                                      Locations(user: widget.user)));
//                        }),
//                  ),
//                  Divider(),
//                  ListTile(
//                    title: Text('Coupons'),
//                    subtitle: Text('Amount of scanned coupons'),
//                    leading: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Icon(Icons.card_giftcard),
//                    ),
//                    trailing: IconButton(
//                      tooltip: 'Go to coupons',
//                      iconSize: 36.0,
//                      icon: Icon(Icons.chevron_right),
//                      onPressed: () => {},
//                    ),
//                  )
//                ],
//              ),
//            ),
//          )
//        ],
//      ),
            FutureBuilder<LocationStorage>(
                future: getLocationStorage(),
                builder: (BuildContext context,
                    AsyncSnapshot<LocationStorage> asyncLocationStorage) {
                  if (asyncLocationStorage.hasData &&
                      asyncLocationStorage.data != null) {
                    LocationStorage locationStorage = asyncLocationStorage.data;
                    return StreamBuilder<QuerySnapshot>(
                      stream: locationStorage.list(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> locations) {
                        if (locations.hasData && locations.data != null) {
                          return ListView.builder(
                              itemCount: locations.data.documents.length,
                              itemBuilder: (context, index) {
                                return LocationCard(
                                  location: LocationStorage.fromDocument(
                                      locations.data.documents[index]),
                                  user: locationStorage.user,
                                );
                              });
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }));
  }
}
