import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/locations/location_coupon_page.dart';
import 'package:eros/pages/locations/location_employee_page.dart';
import 'package:eros/pages/locations/location_page.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:eros/services/location_storage.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final User user;
  final Location location;

  LocationCard({this.user, this.location});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      child: Card(
        child: Column(children: <Widget>[
          ListTile(
            title: Text(location.name),
            subtitle: location.owner == user.uid
                ? Text('Owner')
                : location.managers.containsKey(user.uid)
                    ? Text('Manager')
                    : Text('Employee'),
            leading: location.photoUrl != null
                ? Image.network(
                    location.photoUrl,
                    width: 36.0,
                    height: 36.0,
                  )
                : Icon(
                    Icons.store,
                    size: 36.0,
                  ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationPage(user, location)));
            },
          ),
          location.owner == user.uid
              ? getOwnerVersion(context)
              : location.managers.containsKey(user.uid)
                  ? getManagerVersion(context)
                  : getEmployeeVersion(context),
        ]),
      ),
    );
  }

  Column getEmployeeVersion(BuildContext context) {
    return Column();
  }

  Column getManagerVersion(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        FutureBuilder<int>(
          future: CouponStorage().countCoupons(location),
          builder: (BuildContext context, AsyncSnapshot<int> result) {
            if (result.hasData && result.data != null) {
              return ListTile(
                title: Text('Coupons'),
                subtitle: Text(result.data.toString()),
                leading: Icon(Icons.local_activity),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LocationCouponPage(location, user)));
                },
                trailing: Icon(Icons.chevron_right),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Column getOwnerVersion(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        ListTile(
          title: Text('Employees'),
          subtitle: Text(location.employees.length.toString()),
          leading: Icon(Icons.people),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LocationEmployeePage(
                          locationStorage: LocationStorage.forUser(user: user),
                          location: location,
                        )));
          },
          trailing: Icon(Icons.chevron_right),
        ),
        getManagerVersion(context),
      ],
    );
  }
}
