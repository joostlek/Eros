import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'print_coupon.g.dart';

@JsonSerializable()
class PrintCoupon extends Activity with _$PrintCouponSerializerMixin {
  final Map<String, dynamic> coupon;
  @JsonKey(name: 'location_id')
  final String locationId;

  PrintCoupon(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.coupon, this.locationId,
      [Activities type])
      : super(messageId, originUser, Activities.PrintCoupon, date);

  factory PrintCoupon.fromJson(Map<String, dynamic> json) =>
      _$PrintCouponFromJson(json);

  Card toCard() {
    return Card(
      child: ListTile(
        leading: Image.network(
          originUser['photoUrl'],
          width: 36.0,
        ),
        title: Text('Printed coupon'),
        subtitle:
            Text('${originUser['displayName']} printed ${coupon['name']}'),
        trailing: Icon(Icons.local_activity),
      ),
    );
  }
}
