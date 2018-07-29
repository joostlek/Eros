import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupon_layout.dart';
import 'package:eros/models/location.dart';
import 'package:eros/pages/locations/coupon_layout_page.dart';
import 'package:flutter/material.dart';

class LocationCouponLayoutPage extends StatefulWidget {
  final Location location;

  LocationCouponLayoutPage({this.location});

  @override
  State<StatefulWidget> createState() => LocationCouponLayoutPageState();
}

class LocationCouponLayoutPageState extends State<LocationCouponLayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupon layouts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CouponLayoutPage(null, widget.location, true)));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('coupon_layouts')
              .where('location_id', isEqualTo: widget.location.locationId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return getCouponLayoutCard(CouponLayout(
                          'Default', 'Default', '<!--QRCODE-->', ''));
                    } else {
                      return getCouponLayoutCard(CouponLayout
                          .fromJson(snapshot.data.documents[index - 1].data));
                    }
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Card getCouponLayoutCard(CouponLayout couponLayout) {
    return Card(
      child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CouponLayoutPage(
                        couponLayout, widget.location, false)));
          },
          title: Text(couponLayout.name),
          trailing: Icon(Icons.chevron_right)),
    );
  }
}
