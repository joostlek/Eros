import 'dart:async';

import 'package:eros/pages/coupon_page.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/QRCodeReader.dart';

class CameraPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CameraPageState();
  }
}

class CameraPageState extends State<CameraPage> {
  CouponStorage couponStorage = CouponStorage();

  Future<String> scan() async {
    return new QRCodeReader()
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
        .setAutoFocusIntervalInMs(200)
        .scan();
  }

  Future<Map<String, dynamic>> getCoupon() async {
    String couponString = await scan();
    return {'item': await couponStorage.get(couponString)};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              getCoupon().then((data) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CouponPage(data['item']);
                }));
              });
            }),
      ),
    );
  }
}
