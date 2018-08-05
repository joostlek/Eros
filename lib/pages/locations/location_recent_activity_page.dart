import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/activity_storage.dart';
import 'package:flutter/material.dart';

class LocationRecentActivityPage extends StatefulWidget {
  final User user;
  final Location location;

  LocationRecentActivityPage(this.user, this.location);
  @override
  State createState() => LocationRecentActivityPageState();
}

class LocationRecentActivityPageState
    extends State<LocationRecentActivityPage> {
  @override
  Widget build(BuildContext context) {
    ActivityStorage activityStorage = ActivityStorage(widget.user);
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent activities'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: activityStorage.list(widget.location.locationId),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int i) {
                    Activity activity = ActivityStorage.fromDocument(
                        snapshot.data.documents.reversed.toList()[i]);
                    return activity.toCard();
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
