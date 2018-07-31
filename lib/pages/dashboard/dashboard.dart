import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/dashboard/location_card.dart';
import 'package:eros/pages/dashboard/recent_scanned_coupons.dart';
import 'package:eros/pages/locations/locations.dart';
import 'package:eros/services/location_storage.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final User user;

  Dashboard({this.user});

  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  Future<LocationStorage> getLocationStorage() async {
    return LocationStorage.forUser(user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: FutureBuilder<LocationStorage>(
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
                      List<Object> items = <Object>[
                        getHeader(locationStorage),
                      ];
                      if (locations.data.documents.length == 0) {
                        items.add(Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Let your boss scan your QR code to add you to his location'),
                          ),
                        ));
                      }
                      items.addAll(locations.data.documents);
                      return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            if (!(items[index] is Card)) {
                              return LocationCard(
                                location:
                                    LocationStorage.fromDocument(items[index]),
                                user: locationStorage.user,
                              );
                            } else if (index == 0) {
                              return items[index];
                            } else {
                              return Dismissible(
                                child: items[index],
                                onDismissed: (direction) {
                                  items.removeAt(index);
                                },
                                key: Key(items[index].toString()),
                              );
                            }
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Card getHeader(LocationStorage locationStorage) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Locations'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Locations(
                            user: locationStorage.user,
                          )));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_activity),
            title: Text('Scanned coupons'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecentScannedCoupons(
                            user: locationStorage.user,
                          )));
            },
          )
        ],
      ),
    );
  }
}
