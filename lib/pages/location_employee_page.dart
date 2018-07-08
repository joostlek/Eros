import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/location_storage.dart';
import 'package:eros/services/user_storage.dart';
import 'package:flutter/material.dart';

class LocationEmployeePage extends StatefulWidget {
  final LocationStorage locationStorage;
  final Location location;

  LocationEmployeePage({this.locationStorage, this.location});

  @override
  State<StatefulWidget> createState() {
    return new LocationEmployeePageState();
  }
}

class LocationEmployeePageState extends State<LocationEmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.locationStorage.listEmployees(widget.location),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> querySnapshot) {
            if (querySnapshot.hasData && querySnapshot.data != null) {
              return ListView.builder(
                  itemCount: querySnapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    User user = UserStorage
                        .fromDocument(querySnapshot.data.documents[index]);
                    return Card(
                      child: ListTile(
                        title: Text(user.displayName),
                        subtitle: widget.location.owner == user.uid
                            ? Text('Owner')
                            : widget.location.managers[user.uid] == true
                                ? Text('Manager')
                                : Text('Employee'),
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            user.photoUrl,
                            width: 36.0,
                            height: 36.0,
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
