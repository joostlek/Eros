import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupon.dart';
import 'package:eros/models/location.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';

class LocationCouponPage extends StatefulWidget {
  final Location location;

  LocationCouponPage(this.location);

  @override
  State<StatefulWidget> createState() {
    return LocationCouponPageState();
  }
}

class LocationCouponPageState extends State<LocationCouponPage> {
  CouponStorage couponStorage = CouponStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupons'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {},
      ),
      body: StreamBuilder(
          stream: couponStorage.listCoupons(widget.location.locationId),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
            if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
              return ListView.builder(
                  itemCount: asyncSnapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    Coupon coupon = CouponStorage
                        .fromDocument(asyncSnapshot.data.documents[index]);
                    return generateCouponCard(coupon);
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Card generateCouponCard(Coupon coupon) {
    return Card(
      child: ListTile(
        title: Text(coupon.name),
        subtitle: Text(getWeekday(coupon.issuedAt.weekday) +
            ' ${coupon.issuedAt.day}-${coupon.issuedAt.month}-${coupon.issuedAt.year} ${coupon.issuedAt.hour}:${coupon.issuedAt.minute}'),
        trailing: Text('€' + format(coupon.value)),
        onTap: () => {},
      ),
    );
  }

  String getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Day';
    }
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }
}
