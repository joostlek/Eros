import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/locations/add_location.dart';
import 'package:eros/pages/locations/location_page.dart';
import 'package:eros/services/location_storage.dart';
import 'package:flutter/material.dart';

class Locations extends StatefulWidget {
  final User user;
  final LocationStorage locationStorage;

  Locations({this.user, this.locationStorage});

  @override
  State<StatefulWidget> createState() {
    return LocationsState();
  }
}

class LocationsState extends State<Locations> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: 'Register location',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddLocation(widget.user, widget.locationStorage)));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Locations'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: widget.locationStorage.list(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> querySnapshot) {
              if (querySnapshot.hasData && querySnapshot.data != null) {
                if (querySnapshot.data.documents.length > 0) {
                  return ListView.builder(
                      itemCount: querySnapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds =
                            querySnapshot.data.documents[index];
                        return createCard(
                            user: widget.user,
                            location: LocationStorage.fromDocument(ds));
                      });
                } else {
                  return Center(
                    child: Text('No locations found!'),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Card createCard({User user, Location location}) {
    return Card(
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: location.photoUrl != null
              ? Image.network(
                  location.photoUrl,
                  width: 36.0,
                  height: 36.0,
                )
              : Icon(
                  Icons.store,
                  size: 36.0,
                ),
        ),
        title: Text(location.name),
        subtitle: location.owner == user.uid
            ? Text('Owner')
            : location.managers[user.uid] == true
                ? Text('Manager')
                : Text('Employee'),
        trailing: IconButton(
          icon: Icon(Icons.chevron_right),
          tooltip: 'Go to location',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LocationPage(user, location, widget.locationStorage)));
          },
        ),
      ),
    );
  }
}
