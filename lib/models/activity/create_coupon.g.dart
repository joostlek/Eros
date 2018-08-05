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
        json['location_id'] as String,
        json['type'] == null
            ? null
            : Activities.values.singleWhere(
                (x) => x.toString() == 'Activities.${json['type']}'));

abstract class _$CreateCouponSerializerMixin {
  String get messageId;
  Map<String, dynamic> get originUser;
  Activities get type;
  DateTime get date;
  Map<String, dynamic> get coupon;
  String get locationId;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message_id': messageId,
        'origin_user': originUser,
        'type': type == null ? null : type.toString().split('.')[1],
        'date': date?.toIso8601String(),
        'coupon': coupon,
        'location_id': locationId
      };
}
