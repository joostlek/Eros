// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoneyCoupon _$MoneyCouponFromJson(Map<String, dynamic> json) {
  return new MoneyCoupon(
      json['coupon_id'] as String,
      json['location_id'] as String,
      json['name'] as String,
      json['activated'] as bool,
      json['activated_at'] == null
          ? null
          : DateTime.parse(json['activated_at'] as String),
      json['activated_by'] == null
          ? null
          : new Map<String, dynamic>.from(json['activated_by'] as Map),
      json['expires'] == null
          ? null
          : DateTime.parse(json['expires'] as String),
      json['issued_at'] == null
          ? null
          : DateTime.parse(json['issued_at'] as String),
      json['issued_by'] == null
          ? null
          : new Map<String, dynamic>.from(json['issued_by'] as Map),
      $enumDecodeNullable('Coupons', Coupons.values, json['type'] as String),
      (json['value'] as num)?.toDouble());
}

abstract class _$MoneyCouponSerializerMixin {
  String get couponId;
  Map<String, dynamic> get issuedBy;
  DateTime get issuedAt;
  String get locationId;
  Map<String, dynamic> get activatedBy;
  DateTime get activatedAt;
  String get name;
  bool get activated;
  DateTime get expires;
  Coupons get type;
  double get value;
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
        'type': type?.toString()?.split('.')?.last,
        'value': value
      };
}
