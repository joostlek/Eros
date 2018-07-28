import 'package:eros/models/user.dart';
import 'package:flutter/material.dart';

class RecentScannedCoupons extends StatefulWidget {
  final User user;

  RecentScannedCoupons({this.user});

  @override
  State<StatefulWidget> createState() => RecentScannedCouponsState();
}

class RecentScannedCouponsState extends State<RecentScannedCoupons> {
  List<String> coupons;

  @override
  void initState() {
    if (widget.user.scannedCoupons != null &&
        widget.user.scannedCoupons.length > 0) {
      coupons = widget.user.scannedCoupons.keys.toList();
    } else {
      coupons = List<String>();
    }
  }

  Map<String, dynamic> getCoupon(int index) {
    return widget.user.scannedCoupons[coupons[index]];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent coupons'),
      ),
      body: ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> coupon = getCoupon(index);
          return Card(
            child: ListTile(
              title: Text(coupon['name']),
            ),
          );
        },
      ),
    );
  }
}
