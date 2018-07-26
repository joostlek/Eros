import 'package:eros/models/coupon.dart';
import 'package:eros/models/discount_coupon.dart';
import 'package:eros/models/item_coupon.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/pages/coupons/coupon_page.dart';
import 'package:eros/util.dart';
import 'package:flutter/material.dart';

class CouponCard extends StatelessWidget {
  final Coupon coupon;

  CouponCard({this.coupon});

  @override
  Widget build(BuildContext context) {
    Coupon coupon = this.coupon;
    return Card(
      child: ListTile(
        title: Text(coupon.name),
        subtitle: coupon.activated
            ? Text('Activated')
            : coupon.expires != null && coupon.expires.isBefore(DateTime.now())
                ? Text('Expired')
                : Text('Not activated'),
        trailing: coupon is MoneyCoupon
            ? Text('€' + Util.format(coupon.value))
            : coupon is DiscountCoupon
                ? Text('-${coupon.discount}%')
                : coupon is ItemCoupon ? Text(coupon.item) : null,
        leading: coupon is MoneyCoupon
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.card_giftcard),
              )
            : coupon is DiscountCoupon
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.trending_down),
                  )
                : coupon is ItemCoupon
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.shopping_cart),
                      )
                    : null,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CouponPage(
                        coupon,
                      )));
        },
      ),
    );
  }
}
