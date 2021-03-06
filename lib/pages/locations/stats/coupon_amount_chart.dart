import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupon.dart';
import 'package:eros/models/coupons.dart';
import 'package:eros/models/discount_coupon.dart';
import 'package:eros/models/item_coupon.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CouponAmountChart extends StatefulWidget {
  final Location location;
  final Stream<QuerySnapshot> stream;
  final User user;

  CouponAmountChart({this.location, this.stream, this.user});

  @override
  State<StatefulWidget> createState() => CouponAmountChartState();
}

class CouponAmountChartState extends State<CouponAmountChart>
    with SingleTickerProviderStateMixin {
  List<Coupon> coupons = <Coupon>[];

  static List<CouponGraph> graphs = <CouponGraph>[
    CouponGraph('All', []),
    CouponGraph('Giftcard', []),
    CouponGraph('Discount', []),
    CouponGraph('Item', []),
  ];

  TabController _tabController;

  _getCoupons() {
    widget.stream.listen((QuerySnapshot snapshot) {
      coupons = snapshot.documents
          .map((DocumentSnapshot document) =>
              CouponStorage.fromDocument(document))
          .toList();
      coupons.sort((Coupon a, Coupon b) => a.issuedAt.millisecondsSinceEpoch
          .compareTo(b.issuedAt.millisecondsSinceEpoch));
      graphs[0].series = [
        new charts.Series<Coupon, DateTime>(
            id: 'amount',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            displayName: 'amount',
            domainFn: (Coupon coupon, int _) => coupon.issuedAt,
            measureFn: (Coupon coupon, int _) {
              int sum = 0;
              coupons.getRange(0, _).forEach((Coupon) {
                sum++;
              });
              return sum.floor();
            },
            data: coupons),
      ];
      graphs[1].series = [
        new charts.Series<MoneyCoupon, DateTime>(
            id: 'amount',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            displayName: 'amount',
            domainFn: (MoneyCoupon coupon, int _) => coupon.issuedAt,
            measureFn: (MoneyCoupon coupon, int _) {
              int sum = 0;
              coupons.getRange(0, _).forEach((Coupon) {
                sum++;
              });
              return sum.floor();
            },
            data: coupons
                .where((Coupon coupon) => coupon.type == Coupons.MoneyCoupon)
                .map((Coupon coupon) {
              MoneyCoupon moneyCoupon = coupon;
              return moneyCoupon;
            }).toList()),
      ];
      graphs[2].series = [
        new charts.Series<DiscountCoupon, DateTime>(
            id: 'amount',
            colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
            displayName: 'amount',
            domainFn: (DiscountCoupon coupon, int _) => coupon.issuedAt,
            measureFn: (DiscountCoupon coupon, int _) {
              int sum = 0;
              coupons.getRange(0, _).forEach((Coupon) {
                sum++;
              });
              return sum.floor();
            },
            data: coupons
                .where((Coupon coupon) => coupon.type == Coupons.DiscountCoupon)
                .map((Coupon coupon) {
              DiscountCoupon discountCoupon = coupon;
              return discountCoupon;
            }).toList()),
      ];
      graphs[3].series = [
        new charts.Series<ItemCoupon, DateTime>(
            id: 'amount',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            displayName: 'amount',
            domainFn: (ItemCoupon coupon, int _) => coupon.issuedAt,
            measureFn: (ItemCoupon coupon, int _) {
              int sum = 0;
              coupons.getRange(0, _).forEach((Coupon) {
                sum++;
              });
              return sum.floor();
            },
            data: coupons
                .where((Coupon coupon) => coupon.type == Coupons.ItemCoupon)
                .map((Coupon coupon) {
              ItemCoupon itemCoupon = coupon;
              return itemCoupon;
            }).toList()),
      ];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _getCoupons();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.local_activity),
          title: Text('Amount of coupons'),
          subtitle: Text('Total amount of coupons created using the app'),
        ),
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          tabs: <Widget>[
            Tab(
              text: 'All',
            ),
            Tab(
              text: 'Giftcard',
            ),
            Tab(
              text: 'Discount',
            ),
            Tab(
              text: 'Item',
            )
          ],
        ),
        Container(
          height: 150.0,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: graphs[0].series.length > 0
                  ? graphs[_tabController.index].series[0].data.length > 1
                      ? charts.TimeSeriesChart(
                          graphs[_tabController.index].series,
                        )
                      : Center(child: Text('Not enough data'))
                  : Center(child: CircularProgressIndicator())),
        )
      ],
    ));
  }
}

class CouponGraph {
  final String name;
  List<charts.Series<Coupon, DateTime>> series;

  CouponGraph(this.name, this.series);
}
