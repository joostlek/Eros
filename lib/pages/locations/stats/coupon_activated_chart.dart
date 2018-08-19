import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupon.dart';
import 'package:eros/models/coupons.dart';
import 'package:eros/models/status.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CouponActivatedChart extends StatefulWidget {
  final Stream<QuerySnapshot> stream;

  CouponActivatedChart({this.stream});
  @override
  State<StatefulWidget> createState() => CouponActivatedChartState();
}

class CouponActivatedChartState extends State<CouponActivatedChart> {
  List<Coupon> coupons = [];
  List<charts.Series<DateTime, DateTime>> series = [];
  List<DateTime> dates;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.change_history),
            title: Text('Active Coupons'),
            subtitle: Text('Shows coupons active on that date'),
          ),
          Container(
            height: 150.0,
            child: series == null
                ? Text('')
                : charts.TimeSeriesChart(
                    series,
                    defaultRenderer: charts.LineRendererConfig(
                        includeArea: true, stacked: true),
                  ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCoupons();
  }

  _getCoupons() {
    widget.stream.listen((QuerySnapshot snapshot) {
      coupons = snapshot.documents
          .map((DocumentSnapshot document) =>
              CouponStorage.fromDocument(document))
          .toList();
      coupons.sort((Coupon a, Coupon b) => a.issuedAt.millisecondsSinceEpoch
          .compareTo(b.issuedAt.millisecondsSinceEpoch));
      dates = List.generate(
          DateTime.now().difference(coupons[0].issuedAt).inDays, (int i) {
        return coupons[0].issuedAt.add(Duration(days: i));
      });
      series = [
        new charts.Series<DateTime, DateTime>(
          id: 'Discount',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          displayName: 'amount',
          domainFn: (DateTime dateTime, int _) => dateTime,
          measureFn: (DateTime dateTime, int _) {
            int sum = 0;
            coupons.forEach((Coupon coupon) {
              if (coupon.type == Coupons.DiscountCoupon &&
                  coupon.getStatusAt(dateTime) == Status.Active) {
                sum++;
              }
            });
            return sum;
          },
          data: dates,
        ),
        new charts.Series<DateTime, DateTime>(
          id: 'Item',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          displayName: 'amount',
          domainFn: (DateTime dateTime, int _) => dateTime,
          measureFn: (DateTime dateTime, int _) {
            int sum = 0;
            coupons
                .where((Coupon coupon) => coupon.type == Coupons.ItemCoupon)
                .forEach((Coupon coupon) {
              if (coupon.getStatusAt(dateTime) == Status.Active) {
                sum++;
              }
            });
            return sum;
          },
          data: dates,
        ),
        new charts.Series<DateTime, DateTime>(
          id: 'Giftcard',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          displayName: 'amount',
          domainFn: (DateTime dateTime, int _) => dateTime,
          measureFn: (DateTime dateTime, int _) {
            int sum = 0;
            coupons.forEach((Coupon coupon) {
              if (coupon.type == Coupons.MoneyCoupon &&
                  coupon.getStatusAt(dateTime) == Status.Active) {
                sum++;
              }
            });
            return sum;
          },
          data: dates,
        ),
      ];
      setState(() {});
    });
  }
}
