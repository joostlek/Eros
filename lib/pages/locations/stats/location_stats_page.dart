import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/pages/locations/stats/coupon_amount_chart.dart';
import 'package:eros/pages/locations/stats/money_coupon_line_chart.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';

class LocationStatsPage extends StatefulWidget {
  final Location location;

  LocationStatsPage({this.location});

  @override
  State<StatefulWidget> createState() => LocationStatsPageState();
}

class LocationStatsPageState extends State<LocationStatsPage> {
  CouponStorage couponStorage = CouponStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: Column(
        children: <Widget>[
          MoneyCouponLineChart(
            location: widget.location,
          ),
          CouponAmountChart(
            location: widget.location,
          )
        ],
      ),
    );
  }
}