import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Locations'),
                    subtitle: Text('Manage your locations'),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.location_on),
                    ),
                    trailing: IconButton(
                        iconSize: 36.0,
                        icon: Icon(Icons.chevron_right),
                        onPressed: () => {}),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Coupons'),
                    subtitle: Text('Amount of scanned coupons'),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.card_giftcard),
                    ),
                    trailing: IconButton(
                      iconSize: 36.0,
                      icon: Icon(Icons.chevron_right),
                      onPressed: () => {},
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
