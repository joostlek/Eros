import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupons.dart';
import 'package:eros/models/discount_coupon.dart';
import 'package:eros/models/item_coupon.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/models/coupon.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/coupons/add_coupon.dart';
import 'package:eros/pages/coupons/coupon_page.dart';
import 'package:eros/pages/dashboard/coupon_card.dart';
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
  ValueNotifier<Filter> _selectedItem =
      new ValueNotifier<Filter>(availableFilters[0]);
  CouponStorage couponStorage = CouponStorage();
  Stream<QuerySnapshot> stream;
  List<Filter> appliedFilters = <Filter>[];
  static List<Filter> availableFilters = <Filter>[
    Filter('', '', 'None'),
    Filter('type', 'MoneyCoupon', 'Giftcard'),
    Filter('type', 'DiscountCoupon', 'Discount'),
    Filter('type', 'ItemCoupon', 'Free item'),
  ];

  void addFilters(Filter filter) {
    _selectedItem.value = filter;
    if (filter.name != 'None') {
      if (!appliedFilters.contains(filter)) {
        setState(() {
          appliedFilters.clear();
          appliedFilters.add(filter);
        });
      }
    } else {
      setState(() {
        appliedFilters.clear();
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
//              return availableFilters.map((Filter filter) {
//                return PopupMenuItem<Filter>(
//                  value: filter,
//                  child: RadioListTile(
//                      value: filter, groupValue: null, onChanged: null),
//                );
//              }).toList();
              return List<PopupMenuEntry<Filter>>.generate(
                  availableFilters.length, (int index) {
                return PopupMenuItem(
                    child: AnimatedBuilder(
                        child: Text(availableFilters[index].name),
                        animation: _selectedItem,
                        builder: (BuildContext context, Widget child) {
                          return RadioListTile<Filter>(
                            value: availableFilters[index],
                            groupValue: _selectedItem.value,
                            title: child,
                            onChanged: (Filter filter) {
                              addFilters(filter);
                              Navigator.pop(context);
                            },
                          );
                        }));
              });
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
          stream: appliedFilters.length != 0
              ? couponStorage.filterCoupons(appliedFilters[0].attribute,
                  appliedFilters[0].value, widget.location.locationId)
              : couponStorage.listCoupons(widget.location.locationId),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
            if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
              return ListView.builder(
                  itemCount: asyncSnapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    Coupon coupon = CouponStorage
                        .fromDocument(asyncSnapshot.data.documents[index]);
                    return CouponCard(coupon: coupon);
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class Filter {
  final String attribute;
  final dynamic value;
  final String name;
  Filter(this.attribute, this.value, this.name);
}
