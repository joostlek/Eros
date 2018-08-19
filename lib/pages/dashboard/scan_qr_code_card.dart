import 'package:eros/models/user.dart';
import 'package:eros/pages/locations/add_location.dart';
import 'package:eros/pages/profile/profile_qr_page.dart';
import 'package:eros/services/location_storage.dart';
import 'package:flutter/material.dart';

class ScanQrCodeCard extends StatelessWidget {
  final User user;
  final LocationStorage locationStorage;

  ScanQrCodeCard(this.user, this.locationStorage);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Join a company or start one'),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileQrPage(user)));
                },
                child: Text('SHOW QR-CODE'),
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddLocation(user, locationStorage)));
                },
                child: Text('START COMPANY'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
