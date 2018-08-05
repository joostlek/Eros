// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintCoupon _$PrintCouponFromJson(Map<String, dynamic> json) {
  return new PrintCoupon(
      json['message_id'] as String,
      json['origin_user'] == null
          ? null
          : new Map<String, dynamic>.from(json['origin_user'] as Map),
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['coupon'] == null
          ? null
          : new Map<String, dynamic>.from(json['coupon'] as Map),
      json['location_id'] as String,
      $enumDecodeNullable(
          'Activities', Activities.values, json['type'] as String));
}

abstract class _$PrintCouponSerializerMixin {
  String get messageId;
  Map<String, dynamic> get originUser;
  Activities get type;
  DateTime get date;
  Map<String, dynamic> get coupon;
  String get locationId;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message_id': messageId,
        'origin_user': originUser,
        'type': type?.toString()?.split('.')?.last,
        'date': date?.toIso8601String(),
        'coupon': coupon,
        'location_id': locationId
      };
}
