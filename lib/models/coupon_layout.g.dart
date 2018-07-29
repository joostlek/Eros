// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponLayout _$CouponLayoutFromJson(Map<String, dynamic> json) =>
    new CouponLayout(json['name'] as String, json['html'] as String,
        json['location_id'] as String);

abstract class _$CouponLayoutSerializerMixin {
  String get name;
  String get html;
  String get locationId;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'name': name, 'html': html, 'location_id': locationId};
}
