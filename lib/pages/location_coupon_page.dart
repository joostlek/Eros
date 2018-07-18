import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupons.dart';
import 'package:eros/models/discount_coupon.dart';
import 'package:eros/models/item_coupon.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/models/coupon.dart';
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
  Stream<QuerySnapshot> stream;
  List<Filter> appliedFilters = <Filter>[];
  List<Filter> availableFilters = <Filter>[
    Filter('type', 'MoneyCoupon', 'Giftcard'),
    Filter('type', 'DiscountCoupon', 'Discount'),
    Filter('type', 'ItemCoupon', 'Free item'),
  ];

  void addFilters(Filter filter) {
    if (!appliedFilters.contains(filter)) {
      setState(() {
        appliedFilters.clear();
        appliedFilters.add(filter);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupons'),
        actions: <Widget>[
          PopupMenuButton<Filter>(
            icon: Icon(Icons.filter_list),
            onSelected: addFilters,
            itemBuilder: (BuildContext context) {
              return availableFilters.map((Filter filter) {
                return PopupMenuItem<Filter>(
                  value: filter,
                  child: Text(filter.name),
                );
              }).toList();
            },
          )
        ],
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
          stream: stream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
            if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
              return ListView.builder(
                  itemCount: asyncSnapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    if (applyFilters(
                        asyncSnapshot.data.documents[index].data)) {
                      Coupon coupon = CouponStorage
                          .fromDocument(asyncSnapshot.data.documents[index]);
                      return generateCouponCard(coupon);
                    } else {
                      return null;
                    }
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  bool applyFilters(Map<String, dynamic> data) {
    if (appliedFilters.length == 0) {
      return true;
    }
    for (var i = 0; i < appliedFilters.length; i++) {
      if (data[appliedFilters[i].attribute] != appliedFilters[i].value) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    stream = couponStorage.listCoupons(widget.location.locationId);
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
        leading: coupon is MoneyCoupon
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.card_giftcard),
              )
            : coupon is DiscountCoupon
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.trending_down),
                  )
                : coupon is ItemCoupon
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.shopping_cart),
                      )
                    : null,
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

class Filter {
  final String attribute;
  final dynamic value;
  final String name;
  Filter(this.attribute, this.value, this.name);
}
