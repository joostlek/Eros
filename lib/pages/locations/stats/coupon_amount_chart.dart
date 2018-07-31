import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupon.dart';
import 'package:eros/models/coupons.dart';
import 'package:eros/models/discount_coupon.dart';
import 'package:eros/models/item_coupon.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CouponAmountChart extends StatefulWidget {
  final Location location;

  CouponAmountChart({this.location});

  @override
  State<StatefulWidget> createState() => CouponAmountChartState();
}

class CouponAmountChartState extends State<CouponAmountChart> {
  ValueNotifier<String> _selectedItem =
      new ValueNotifier<String>(availableFilters[0]);
  CouponStorage couponStorage = CouponStorage();
  static List<String> availableFilters = <String>[
    'All',
    'Giftcard',
    'Discount',
    'Item',
  ];

  _update(String string) {
    setState(() {
      _selectedItem.value = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: couponStorage.listCoupons(widget.location.locationId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          List<Coupon> coupons = snapshot.data.documents
              .map((DocumentSnapshot document) =>
                  CouponStorage.fromDocument(document))
              .toList();
          coupons.sort((Coupon a, Coupon b) => a.issuedAt.millisecondsSinceEpoch
              .compareTo(b.issuedAt.millisecondsSinceEpoch));
          List<charts.Series<Coupon, DateTime>> series = [
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
          List<charts.Series<Coupon, DateTime>> money_series = [
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
                    .where(
                        (Coupon coupon) => coupon.type == Coupons.MoneyCoupon)
                    .map((Coupon coupon) {
                  MoneyCoupon moneyCoupon = coupon;
                  return moneyCoupon;
                }).toList()),
          ];
          List<charts.Series<Coupon, DateTime>> discount_series = [
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
                    .where((Coupon coupon) =>
                        coupon.type == Coupons.DiscountCoupon)
                    .map((Coupon coupon) {
                  DiscountCoupon discountCoupon = coupon;
                  return discountCoupon;
                }).toList()),
          ];
          List<charts.Series<Coupon, DateTime>> item_series = [
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Column(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.local_activity),
                    title: _selectedItem.value == 'Giftcard'
                        ? Text('Amount of giftcards')
                        : _selectedItem.value == 'Discount'
                            ? Text('Amount of discount coupons')
                            : _selectedItem.value == 'Item'
                                ? Text('Amount of item coupons')
                                : Text('Total amount of coupons'),
                    subtitle: _selectedItem.value == 'Giftcard'
                        ? Text('Total amount of giftcards added')
                        : _selectedItem.value == 'Discount'
                            ? Text('Total amount of discount coupons added')
                            : _selectedItem.value == 'Item'
                                ? Text('Total amount of item coupons added')
                                : Text('Total amount of coupons'),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert),
                      onSelected: _update,
                      itemBuilder: (BuildContext context) {
                        return List<PopupMenuEntry<String>>.generate(
                            availableFilters.length, (int index) {
                          return PopupMenuItem(
                              child: AnimatedBuilder(
                                  child: Text(availableFilters[index]),
                                  animation: _selectedItem,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return RadioListTile<String>(
                                      value: availableFilters[index],
                                      groupValue: _selectedItem.value,
                                      title: child,
                                      onChanged: (String filter) {
                                        _update(filter);
                                        Navigator.pop(context);
                                      },
                                    );
                                  }));
                        });
                      },
                    )),
                Container(
                    height: 150.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                      child: _selectedItem.value == 'Giftcard' &&
                              money_series[0].data.length > 1
                          ? charts.TimeSeriesChart(
                              money_series,
                              defaultRenderer: charts.LineRendererConfig(
                                  includeArea: true, stacked: true),
                            )
                          : _selectedItem.value == 'Discount' &&
                                  discount_series[0].data.length > 1
                              ? charts.TimeSeriesChart(
                                  discount_series,
                                  defaultRenderer: charts.LineRendererConfig(
                                      includeArea: true, stacked: true),
                                )
                              : _selectedItem.value == 'Item' &&
                                      item_series[0].data.length > 1
                                  ? charts.TimeSeriesChart(
                                      item_series,
                                      defaultRenderer:
                                          charts.LineRendererConfig(
                                              includeArea: true, stacked: true),
                                    )
                                  : _selectedItem.value == 'All' &&
                                          series[0].data.length > 1
                                      ? charts.TimeSeriesChart(
                                          series,
                                          defaultRenderer:
                                              charts.LineRendererConfig(
                                                  includeArea: true,
                                                  stacked: true),
                                        )
                                      : Center(
                                          child: Text('Not enough data'),
                                        ),
                    )),
              ],
            )),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
