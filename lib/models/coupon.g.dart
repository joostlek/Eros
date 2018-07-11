// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coupon _$CouponFromJson(Map<String, dynamic> json) => new Coupon(
    json['coupon_id'] as String,
    json['issued_by'] as String,
    json['issued_at'] == null
        ? null
        : DateTime.parse(json['issued_at'] as String),
    json['location_id'] as String,
    json['expires'] == null ? null : DateTime.parse(json['expires'] as String),
    (json['value'] as num)?.toDouble(),
    json['activated_by'] as String,
    json['activated_at'] == null
        ? null
        : DateTime.parse(json['activated_at'] as String),
    json['activated'] as bool);

abstract class _$CouponSerializerMixin {
  String get couponId;
  String get issuedBy;
  DateTime get issuedAt;
  String get locationId;
  String get activatedBy;
  DateTime get activatedAt;
  bool get activated;
  DateTime get expires;
  double get value;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'coupon_id': couponId,
        'issued_by': issuedBy,
        'issued_at': issuedAt?.toIso8601String(),
        'location_id': locationId,
        'activated_by': activatedBy,
        'activated_at': activatedAt?.toIso8601String(),
        'activated': activated,
        'expires': expires?.toIso8601String(),
        'value': value
      };
}
