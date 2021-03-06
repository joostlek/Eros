import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/coupon.dart';
import 'package:eros/models/coupon_layout.dart';
import 'package:eros/models/discount_coupon.dart';
import 'package:eros/models/item_coupon.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/activity_storage.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:eros/services/user_storage.dart';
import 'package:eros/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponPage extends StatefulWidget {
  final Coupon coupon;
  final User user;

  CouponPage(this.coupon, this.user);

  @override
  State<StatefulWidget> createState() {
    return CouponPageState();
  }
}

class CouponPageState extends State<CouponPage> {
  static const PRINT_CHANNEL = const MethodChannel('eros.jtosti.nl/print');
  CouponStorage couponStorage;

  QuerySnapshot couponLayouts;

  _printCouponActivity() {
    ActivityStorage activityStorage = ActivityStorage(widget.user);
    activityStorage.createActivity(Activities.PrintCoupon,
        coupon: widget.coupon.toShort(), locationId: widget.coupon.locationId);
  }

  getStorage() async {
    if (widget.user.manager[widget.coupon.locationId] == true ||
        widget.user.owner[widget.coupon.locationId] == true) {
      this.couponLayouts = await Firestore.instance
          .collection('coupon_layouts')
          .where('location_id', isEqualTo: widget.coupon.locationId)
          .getDocuments();
    }
  }

  @override
  Widget build(BuildContext context) {
    Coupon coupon = widget.coupon;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coupon.name),
        actions: (widget.coupon.activated ||
                (widget.coupon.expires != null
                    ? widget.coupon.expires.isBefore(DateTime.now().toLocal())
                    : false))
            ? null
            : <Widget>[
                Builder(
                  builder: (context) {
                    return PopupMenuButton<CouponLayout>(
                      onSelected: (CouponLayout couponLayout) =>
                          _print(couponLayout),
                      icon: Icon(Icons.print),
                      itemBuilder: (BuildContext context) {
                        return List<PopupMenuItem<CouponLayout>>.generate(
                            this.couponLayouts == null
                                ? 1
                                : this.couponLayouts.documents.length + 1,
                            (int index) {
                          if (index == 0) {
                            return PopupMenuItem(
                              value: CouponLayout(
                                  'Default', 'Default', '<!--QRCODE-->', ''),
                              child: Text('Default'),
                            );
                          }
                          return PopupMenuItem(
                              value: CouponLayout.fromJson(
                                  this.couponLayouts.documents[index - 1].data),
                              child: Text(this
                                  .couponLayouts
                                  .documents[index - 1]
                                  .data['name']));
                        });
                      },
                    );
                  },
                )
              ],
      ),
      floatingActionButton: (widget.coupon.activated ||
              (widget.coupon.expires != null
                  ? widget.coupon.expires.isBefore(DateTime.now().toLocal())
                  : false))
          ? null
          : Builder(
              builder: (context) {
                return FloatingActionButton(
                  onPressed: () {
                    handleActivation(context);
                  },
                  tooltip: 'Activate coupon',
                  child: Icon(Icons.done),
                );
              },
            ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: widget.coupon.activated == true
                ? Text('Activated')
                : (widget.coupon.expires != null &&
                        widget.coupon.expires
                            .isBefore(DateTime.now().toLocal()))
                    ? Text('Expired')
                    : Text('Not activated'),
            trailing: widget.coupon.activated == true
                ? Icon(
                    Icons.done_all,
                    color: Colors.green,
                  )
                : (widget.coupon.expires != null &&
                        widget.coupon.expires
                            .isBefore(DateTime.now().toLocal()))
                    ? Icon(
                        Icons.update,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.done,
                        color: Colors.blue,
                      ),
          ),
          Divider(),
          coupon is MoneyCoupon
              ? ListTile(
                  title: Text('Worth'),
                  trailing: Text('€' + Util.format(coupon.value)),
                )
              : coupon is DiscountCoupon
                  ? ListTile(
                      title: Text('Discount'),
                      trailing: Text('-' + Util.format(coupon.discount) + '%'),
                    )
                  : coupon is ItemCoupon
                      ? ListTile(
                          title: Text('Item'),
                          trailing: Text(coupon.item),
                        )
                      : ListTile(
                          title: Text('-'),
                        ),
          ListTile(
            title: Text('Expires at'),
            trailing: widget.coupon.expires != null
                ? Text(Util.getWeekday(widget.coupon.expires.weekday) +
                    ' ${widget.coupon.expires.day}-${widget.coupon.expires
                    .month}-${widget.coupon.expires.year}')
                : Text('Doesn\'t expire'),
          ),
          ListTile(
            title: Text('Issued at'),
            trailing: Text(Util.getWeekday(widget.coupon.issuedAt.weekday) +
                ' ${widget.coupon.issuedAt.day}-${widget.coupon.issuedAt
                    .month}-${widget.coupon.issuedAt.year} ${widget.coupon
                    .issuedAt.hour}:${widget.coupon.issuedAt.minute}'),
          ),
          ListTile(
            title: Text('Issued by'),
            trailing: Text(widget.coupon.issuedBy['displayName']),
          ),
          widget.coupon.activated == true
              ? Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('Activated at'),
                      trailing: Text(
                          Util.getWeekday(widget.coupon.activatedAt.weekday) +
                              ' ${widget.coupon.activatedAt.day}-${widget.coupon
                      .activatedAt.month}-${widget.coupon.activatedAt
                      .year} ${widget.coupon.activatedAt.hour}:${widget
                      .coupon.activatedAt.minute}'),
                    ),
                    ListTile(
                      title: Text('Activated by'),
                      trailing: Text(widget.coupon.activatedBy['displayName']),
                    ),
                  ],
                )
              : ListTile()
        ],
      ),
    );
  }

  Future<bool> activateCoupon() async {
    return couponStorage.activate(
        widget.coupon,
        await UserStorage
            .forFirebaseUser(
                firebaseUser: await FirebaseAuth.instance.currentUser())
            .getUser());
  }

  Future<bool> undoActivate() async {
    return couponStorage.undoActivate(widget.coupon);
  }

  handleActivation(context) {
    activateCoupon().then((bool) {
      setState(() {});
      final snackBar = SnackBar(
        content: Text('${widget.coupon.name} is activated'),
        action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              undoActivate().then((bool) {
                setState(() {});
                final snackbar = SnackBar(
                  content: Text('${widget.coupon.name} is deactivated'),
                );
                Scaffold.of(context).showSnackBar(snackbar);
              });
            }),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  Future<bool> _print(CouponLayout couponLayout) async {
    _printCouponActivity();
    try {
      final bool result = await PRINT_CHANNEL.invokeMethod('print', {
        'html': couponLayout.html
            .replaceAll(
                '<!--QRCODE-->',
                '<img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${widget
            .coupon.couponId}">')
            .replaceAll('<!--VALUE-->', getValue())
      });
      return result;
    } catch (e) {
      print('dart error $e');
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    couponStorage = CouponStorage(widget.user);
    getStorage();
  }

  String getValue() {
    Coupon coupon = widget.coupon;
    return coupon is MoneyCoupon
        ? '€' + Util.format(coupon.value)
        : coupon is DiscountCoupon
            ? '-' + Util.format(coupon.discount) + '%'
            : coupon is ItemCoupon ? coupon.item : '-';
  }
}
