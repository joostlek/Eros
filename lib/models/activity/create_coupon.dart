import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_coupon.g.dart';

@JsonSerializable()
class CreateCoupon extends Activity with _$CreateCouponSerializerMixin {
  final Map<String, dynamic> coupon;
  @JsonKey(name: 'location_id')
  final String locationId;

  CreateCoupon(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.coupon, this.locationId,
      [Activities type])
      : super(messageId, originUser, Activities.CreateCoupon, date);

  factory CreateCoupon.fromJson(Map<String, dynamic> json) =>
      _$CreateCouponFromJson(json);

  Card toCard() {
    return Card(
      child: ListTile(
        leading: Image.network(
          originUser['photoUrl'],
          width: 36.0,
        ),
        subtitle:
            Text('${originUser['displayName']} created ${coupon['name']}'),
        title: Text('Created coupon'),
        trailing: Icon(Icons.local_activity),
      ),
    );
  }
}
