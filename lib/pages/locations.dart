import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/location_storage.dart';
import 'package:flutter/material.dart';

class Locations extends StatefulWidget {
  final Future<User> user;

  Locations({this.user});

  @override
  State<StatefulWidget> createState() {
    return new LocationsState();
  }
}

class LocationsState extends State<Locations> {
  Future<LocationStorage> getStorage() async {
    return new LocationStorage.forUser(user: await widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationStorage>(
      future: getStorage(),
      builder: (BuildContext context,
          AsyncSnapshot<LocationStorage> locationStorage) {
        if (locationStorage.hasData && locationStorage.data != null) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => {},
                child: Icon(Icons.add),
              ),
              appBar: AppBar(
                title: Text('Locations'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: locationStorage.data.list(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> querySnapshot) {
                      if (querySnapshot.hasData && querySnapshot.data != null) {
                        return ListView.builder(
                            itemCount: querySnapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds =
                                  querySnapshot.data.documents[index];
                              return Card(
                                child: ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      ds['photoUrl'],
                                      width: 36.0,
                                      height: 36.0,
                                    ),
                                  ),
                                  title: Text(ds['name']),
                                  subtitle: Text(ds['country']),
                                  trailing: IconButton(
                                    icon: Icon(Icons.chevron_right),
                                    onPressed: () => {},
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Text('Loading...');
                      }
                    }),
              ));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
