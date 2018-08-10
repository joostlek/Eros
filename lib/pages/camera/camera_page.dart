import 'dart:async';

import 'package:eros/models/coupon.dart';
import 'package:eros/models/user.dart';
import 'package:eros/pages/coupons/coupon_page.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/QRCodeReader.dart';

class CameraPage extends StatefulWidget {
  final User user;

  CameraPage({this.user});

  @override
  State<StatefulWidget> createState() {
    return CameraPageState();
  }
}

class CameraPageState extends State<CameraPage> {

  Future<String> scan() async {
    return QRCodeReader()
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
        .setAutoFocusIntervalInMs(200)
        .scan();
  }

  Future<Map<String, dynamic>> getCoupon() async {
    CouponStorage couponStorage = CouponStorage(widget.user);
    String couponString = await scan();
    if (couponString == null || couponString == '') {
      return {
        'item': null,
        'error': true,
        'message': 'No QR-code found!',
      };
    }
    Coupon coupon = await couponStorage.get(couponString);
    if (coupon == null) {
      return {
        'item': null,
        'error': true,
        'message': 'Coupon not found',
      };
    } else {
      return {
        'item': await couponStorage.get(couponString),
        'error': false,
        'message': null,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eros'),
      ),
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
            return FlatButton.icon(
                onPressed: () {
                  getCoupon().then((data) {
                    if (data['error'] == false) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CouponPage(data['item'], widget.user);
                      }));
                    } else {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text(data['message'])));
                    }
                  });
                },
                icon: Icon(Icons.camera_alt),
                label: Text('Scan coupon'));
          },
        ),
      ),
    );
  }
}
