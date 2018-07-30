import 'dart:async';

import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/locations/location_coupon_layout_page.dart';
import 'package:eros/pages/locations/location_coupon_page.dart';
import 'package:eros/pages/locations/location_employee_page.dart';
import 'package:eros/pages/locations/location_stats_page.dart';
import 'package:eros/services/location_storage.dart';
import 'package:eros/services/user_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  final Location location;
  final User user;

  LocationPage(this.user, this.location);

  LocationStorage getLocationStorage() {
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
      floatingActionButton: FloatingActionButton(
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
              child: widget.location.photoUrl != null
                  ? Container(
                      width: 96.0,
                      height: 96.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(widget.location.photoUrl))),
                    )
                  : Icon(
                      Icons.store,
                      size: 96.0,
                      color: Theme.of(context).disabledColor,
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
          getCards(),
        ],
      ),
    );
  }

  Column getCards() {
    if (widget.location.owner == widget.user.uid) {
      return Column(
        children: <Widget>[
          getEmployeeCard(),
          getCouponsCard(),
          getLayoutCard(),
          getStatsCard(),
        ],
      );
    } else if (widget.location.managers[widget.user.uid] == true) {
      return Column(
        children: <Widget>[getCouponsCard()],
      );
    } else {
      return Column();
    }
  }

  Card getEmployeeCard() {
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
                          locationStorage: widget.getLocationStorage(),
                          location: widget.location,
                        )));
          },
        ),
      ),
    );
  }

  Card getCouponsCard() {
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
  }

  Card getLayoutCard() {
    return Card(
      child: ListTile(
        title: Text('Coupon layouts'),
        leading: Icon(Icons.straighten),
        trailing: IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LocationCouponLayoutPage(
                          location: widget.location,
                        )));
          },
        ),
      ),
    );
  }

  Card getStatsCard() {
    return Card(
      child: ListTile(
        title: Text('Statistics'),
        leading: Icon(Icons.trending_up),
        trailing: IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LocationStatsPage(
                          location: widget.location,
                        )));
          },
        ),
      ),
    );
  }
}
