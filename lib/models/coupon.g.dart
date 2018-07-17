// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coupon _$CouponFromJson(Map<String, dynamic> json) => new Coupon(
    json['coupon_id'] as String,
    json['location_id'] as String,
    json['name'] as String,
    json['activated'] as bool,
    json['activated_at'] == null
        ? null
        : DateTime.parse(json['activated_at'] as String),
    json['activated_by'] as String,
    json['expires'] == null ? null : DateTime.parse(json['expires'] as String),
    json['issued_at'] == null
        ? null
        : DateTime.parse(json['issued_at'] as String),
    json['issued_by'] as String,
    json['type'] == null
        ? null
        : Coupons.values
            .singleWhere((x) => x.toString() == 'Coupons.${json['type']}'));

abstract class _$CouponSerializerMixin {
  String get couponId;
  String get issuedBy;
  DateTime get issuedAt;
  String get locationId;
  String get activatedBy;
  DateTime get activatedAt;
  String get name;
  bool get activated;
  DateTime get expires;
  Coupons get type;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'coupon_id': couponId,
        'issued_by': issuedBy,
        'issued_at': issuedAt?.toIso8601String(),
        'location_id': locationId,
        'activated_by': activatedBy,
        'activated_at': activatedAt?.toIso8601String(),
        'name': name,
        'activated': activated,
        'expires': expires?.toIso8601String(),
        'type': type == null ? null : type.toString().split('.')[1]
      };
}
