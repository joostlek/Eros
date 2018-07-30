import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/pages/locations/line_chart.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
        stream: couponStorage.listCoupons(widget.location.locationId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
          if (data.hasData && data.data != null) {
            List<MoneyCoupon> coupons = data.data.documents
                .where((coupon) => coupon.data['type'] == 'MoneyCoupon')
                .map((DocumentSnapshot document) =>
                    MoneyCoupon.fromJson(document.data))
                .toList();
            coupons.sort((MoneyCoupon a, MoneyCoupon b) => a
                .issuedAt.millisecondsSinceEpoch
                .compareTo(b.issuedAt.millisecondsSinceEpoch));
            List<charts.Series<MoneyCoupon, DateTime>> series = [
              new charts.Series<MoneyCoupon, DateTime>(
                  id: 'amount',
                  colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                  displayName: 'amount',
                  domainFn: (MoneyCoupon coupon, int _) => coupon.issuedAt,
                  measureFn: (MoneyCoupon coupon, int _) =>
                      coupon.value.floor(),
                  data: coupons)
            ];

            return charts.TimeSeriesChart(series);
          } else {
            return CircularProgressIndicator();
          }
        },
      )),
    );
  }
}
