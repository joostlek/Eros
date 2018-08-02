import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupon.dart';
import 'package:eros/models/coupons.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CouponPercentageChart extends StatelessWidget {
  final Stream<QuerySnapshot> stream;

  CouponPercentageChart({this.stream});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Percentage of coupons'),
            subtitle: Text('Percentage of coupons'),
            leading: Icon(Icons.donut_large),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: this.stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                List<Coupon> coupons = snapshot.data.documents
                    .map((DocumentSnapshot document) =>
                        CouponStorage.fromDocument(document))
                    .toList();

                List<charts.Series<Coupons, int>> data = [
                  new charts.Series<Coupons, int>(
                      id: 'amount',
                      colorFn: (_, __) =>
                          charts.MaterialPalette.blue.shadeDefault,
                      displayName: 'amount',
                      domainFn: (Coupons coupon, int _) => coupon.index,
                      measureFn: (Coupons coupon, int _) => coupons
                          .where((Coupon cou) => cou.type == coupon)
                          .length,
                      labelAccessorFn: (Coupons coupon, _) => coupon.toString(),
                      data: Coupons.values),
                ];
                return Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Giftcard: ${getPercentage(coupons, 0)}%',
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'Discount: ${getPercentage(coupons, 1)}%',
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'Item: ${getPercentage(coupons, 2)}%',
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          height: 150.0,
                          child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                              child: charts.PieChart(data,
                                  animate: true,
                                  defaultRenderer: new charts.ArcRendererConfig(
                                      arcWidth: 20)))),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }

  double getPercentage(List<Coupon> coupons, int id) {
    return coupons.where((Coupon cou) => cou.type.index == id).length /
        coupons.length *
        100;
  }
}
