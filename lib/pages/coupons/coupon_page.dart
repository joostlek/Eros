import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupon.dart';
import 'package:eros/models/coupon_layout.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:eros/services/user_storage.dart';
import 'package:eros/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponPage extends StatefulWidget {
  final Coupon coupon;
  final bool newCoupon;

  CouponPage(this.coupon, this.newCoupon);

  @override
  State<StatefulWidget> createState() {
    return CouponPageState();
  }
}

class CouponPageState extends State<CouponPage> {
  static const PRINT_CHANNEL = const MethodChannel('eros.jtosti.nl/print');
  UserStorage userStorage = UserStorage();

  CouponStorage couponStorage = CouponStorage();
  QuerySnapshot couponLayouts;

  getStorage() async {
    this.userStorage = UserStorage.forFirebaseUser(
        firebaseUser: await FirebaseAuth.instance.currentUser());
    User user = await this.userStorage.getUser();
    if (user.manager[widget.coupon.locationId] == true ||
        user.owner[widget.coupon.locationId] == true) {
      this.couponLayouts = await Firestore.instance
          .collection('coupon_layouts')
          .where('location_id', isEqualTo: widget.coupon.locationId)
          .getDocuments();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            this.couponLayouts.documents.length + 1,
                            (int index) {
                          if (index == 0) {
                            return PopupMenuItem(
                              value: CouponLayout('asd', '<!--QRCODE-->', ''),
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
//                    return IconButton(
//                      icon: Icon(Icons.print),
//                      onPressed: () {
//                        _print().then((bool) {
//                          if (bool == true) {
//                            final snackbar = SnackBar(
//                              content: Text('Printing...'),
//                            );
//                            Scaffold.of(context).showSnackBar(snackbar);
//                          } else {
//                            final snackbar = SnackBar(
//                              content: Text('An error occured!'),
//                            );
//                            Scaffold.of(context).showSnackBar(snackbar);
//                          }
//                        });
//                      },
//                    );
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
          ListTile(
            title: Text('Worth'),
//            trailing: Text('€' + Util.format(widget.coupon.value)),
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
          FutureBuilder<User>(
            future: userStorage.getUserByUid(widget.coupon.issuedBy),
            builder: (context, user) {
              if (user.data != null && user.hasData) {
                return ListTile(
                  title: Text('Issued by'),
                  trailing: Text(user.data.displayName),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          !widget.coupon.activated
              ? ListTile(
                  title: Text(''),
                )
              : FutureBuilder<User>(
                  future: userStorage.getUserByUid(widget.coupon.activatedBy),
                  builder: (context, user) {
                    if (user.data != null && user.hasData) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('Activated at'),
                            trailing: Text(Util.getWeekday(
                                    widget.coupon.activatedAt.weekday) +
                                ' ${widget.coupon.activatedAt.day}-${widget.coupon
                              .activatedAt.month}-${widget.coupon.activatedAt
                              .year} ${widget.coupon.activatedAt.hour}:${widget
                              .coupon.activatedAt.minute}'),
                          ),
                          ListTile(
                            title: Text('Activated by'),
                            trailing: Text(user.data.displayName),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
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
    try {
      final bool result = await PRINT_CHANNEL.invokeMethod('print', {
        'html': couponLayout.html.replaceAll(
            '<!--QRCODE-->',
            '<img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${widget
            .coupon.couponId}">')
      });
      return result;
    } catch (e) {
      print('dart error $e');
    }
    return false;
  }

  addRecentCoupon() async {
    UserStorage userStorage = UserStorage.forFirebaseUser(
        firebaseUser: await FirebaseAuth.instance.currentUser());
    User user = await userStorage.getUser();
    user.scannedCoupons[widget.coupon.couponId] == widget.coupon.toChild();
    userStorage.update(user);
  }

  @override
  void initState() {
    super.initState();
    getStorage();
//    if (widget.newCoupon == true) {
//      addRecentCoupon();
//    }
  }
}
