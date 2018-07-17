import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/discount_coupon.dart';
import 'package:eros/models/item_coupon.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/models/new_coupon.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/add_coupon.dart';
import 'package:eros/pages/coupon_page.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:eros/util.dart';
import 'package:flutter/material.dart';

class LocationCouponPage extends StatefulWidget {
  final Location location;
  final User user;

  LocationCouponPage(this.location, this.user);

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
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddCoupon(widget.location, widget.user);
          }));
        },
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
        subtitle: coupon.activated
            ? Text('Activated')
            : coupon.expires != null && coupon.expires.isBefore(DateTime.now())
                ? Text('Expired')
                : Text('Not activated'),
        trailing: coupon is MoneyCoupon
            ? Text('€' + Util.format(coupon.value))
            : coupon is DiscountCoupon
                ? Text('-${coupon.discount}%')
                : coupon is ItemCoupon ? Text(coupon.item) : null,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CouponPage(
                        coupon,
                      )));
        },
      ),
    );
  }
}
