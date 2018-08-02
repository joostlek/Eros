import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MoneyCouponLineChart extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final Location location;
  MoneyCouponLineChart({this.location, this.stream});
  @override
  Widget build(BuildContext context) {
    CouponStorage couponStorage = CouponStorage();
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
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
                measureFn: (MoneyCoupon coupon, int _) {
                  double sum = 0.0;
                  coupons.getRange(0, _).forEach((MoneyCoupon moneyCoupon) {
                    sum += moneyCoupon.value;
                  });
                  return sum.floor();
                },
                data: coupons)
          ];

          return Card(
              child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Giftcards'),
                subtitle: Text('Total worth of all giftcards'),
              ),
              Container(
                  height: 150.0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                    child: charts.TimeSeriesChart(
                      series,
                      defaultRenderer: charts.LineRendererConfig(
                          includeArea: true, stacked: true),
                    ),
                  )),
            ],
          ));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
