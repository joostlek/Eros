import 'dart:async';

import 'package:eros/models/coupon.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:eros/services/user_storage.dart';
import 'package:eros/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CouponPage extends StatefulWidget {
  final Coupon coupon;

  CouponPage(this.coupon);

  @override
  State<StatefulWidget> createState() {
    return CouponPageState();
  }
}

class CouponPageState extends State<CouponPage> {
  UserStorage userStorage = UserStorage();
  CouponStorage couponStorage = CouponStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coupon.name),
      ),
      floatingActionButton: (widget.coupon.activated ||
              (widget.coupon.expires != null
                  ? widget.coupon.expires.isBefore(DateTime.now().toLocal())
                  : true))
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
            title: Text('Worth'),
            trailing: Text('€' + Util.format(widget.coupon.value)),
          ),
          ListTile(
            title: Text('Expires at'),
            trailing: Text(Util.getWeekday(widget.coupon.expires.weekday) +
                ' ${widget.coupon.expires.day}-${widget.coupon.expires.month}-${widget.coupon.expires.year} ${widget.coupon.expires.hour}:${widget.coupon.expires.minute}'),
          ),
          ListTile(
            title: Text('Issued at'),
            trailing: Text(Util.getWeekday(widget.coupon.issuedAt.weekday) +
                ' ${widget.coupon.issuedAt.day}-${widget.coupon.issuedAt.month}-${widget.coupon.issuedAt.year} ${widget.coupon.issuedAt.hour}:${widget.coupon.issuedAt.minute}'),
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
                return CircularProgressIndicator();
              }
            },
          ),
          !widget.coupon.activated
              ? ListTile(
                  title: Text('Not activated'),
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
                                ' ${widget.coupon.activatedAt.day}-${widget.coupon.activatedAt.month}-${widget.coupon.activatedAt.year} ${widget.coupon.activatedAt.hour}:${widget.coupon.activatedAt.minute}'),
                          ),
                          ListTile(
                            title: Text('Activated by'),
                            trailing: Text(user.data.displayName),
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
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
}
