import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/dashboard/location_card.dart';
import 'package:eros/pages/dashboard/scan_qr_code_card.dart';
import 'package:eros/pages/locations/locations.dart';
import 'package:eros/services/location_storage.dart';
import 'package:eros/services/user_storage.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final UserStorage userStorage;
  final LocationStorage locationStorage;

  Dashboard({this.userStorage, this.locationStorage});

  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: widget.locationStorage.list(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> locations) {
            if (locations.hasData && locations.data != null) {
              List<Object> items = <Object>[
                getHeader(widget.locationStorage),
              ];
              if (locations.data.documents.length == 0) {
                items.add(ScanQrCodeCard(
                    widget.userStorage.user, widget.locationStorage));
              }
              items.addAll(locations.data.documents);
              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return items[index];
                    } else if (!(items[index] is ScanQrCodeCard)) {
                      return LocationCard(
                        location: LocationStorage.fromDocument(items[index]),
                        user: widget.userStorage.user,
                        locationStorage: widget.locationStorage,
                      );
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
        ));
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
        ],
      ),
    );
  }
}
