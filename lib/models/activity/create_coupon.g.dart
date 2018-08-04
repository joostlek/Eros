// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCoupon _$CreateCouponFromJson(Map<String, dynamic> json) =>
    new CreateCoupon(
        json['message_id'] as String,
        json['origin_user'] as Map<String, dynamic>,
        json['date'] == null ? null : DateTime.parse(json['date'] as String),
        json['coupon'] as Map<String, dynamic>,
        json['location_id'] as String);

abstract class _$CreateCouponSerializerMixin {
  String get messageId;
  Map<String, dynamic> get originUser;
  DateTime get date;
  Map<String, dynamic> get coupon;
  String get locationId;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message_id': messageId,
        'origin_user': originUser,
        'date': date?.toIso8601String(),
        'coupon': coupon,
        'location_id': locationId
      };
}
