// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponLayout _$CouponLayoutFromJson(Map<String, dynamic> json) {
  return new CouponLayout(
      json['coupon_layout_id'] as String,
      json['name'] as String,
      json['html'] as String,
      json['location_id'] as String);
}

abstract class _$CouponLayoutSerializerMixin {
  String get couponLayoutId;
  String get name;
  String get html;
  String get locationId;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'coupon_layout_id': couponLayoutId,
        'name': name,
        'html': html,
        'location_id': locationId
      };
}
