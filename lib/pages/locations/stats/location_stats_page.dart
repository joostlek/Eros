import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/locations/stats/coupon_activated_chart.dart';
import 'package:eros/pages/locations/stats/coupon_amount_chart.dart';
import 'package:eros/pages/locations/stats/coupon_percentage_chart.dart';
import 'package:eros/pages/locations/stats/money_coupon_line_chart.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';

class LocationStatsPage extends StatefulWidget {
  final Location location;
  final User user;

  LocationStatsPage({this.location, this.user});

  @override
  State<StatefulWidget> createState() => LocationStatsPageState();
}

class LocationStatsPageState extends State<LocationStatsPage> {
  Stream<QuerySnapshot> _couponStream;

  @override
  void initState() {
    super.initState();
    CouponStorage couponStorage = CouponStorage(widget.user);
    _couponStream = couponStorage.listCoupons(widget.location.locationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: SingleChildScrollView(
          child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Column(
            children: <Widget>[
              CouponActivatedChart(
                stream: _couponStream,
              ),
              MoneyCouponLineChart(
                location: widget.location,
                stream: _couponStream,
                user: widget.user,
              ),
              CouponAmountChart(
                location: widget.location,
                stream: _couponStream,
              ),
              CouponPercentageChart(
                stream: _couponStream,
              )
            ],
          ),
        ),
      )),
    );
  }
}
