import 'package:json_annotation/json_annotation.dart';

part 'coupon_layout.g.dart';

@JsonSerializable()
class CouponLayout extends Object with _$CouponLayoutSerializerMixin {
  @JsonKey(name: 'coupon_layout_id')
  final String couponLayoutId;
  final String name;
  final String html;
  @JsonKey(name: 'location_id')
  final String locationId;

  CouponLayout(
    this.couponLayoutId,
    this.name,
    this.html,
    this.locationId,
  );

  factory CouponLayout.fromJson(Map<String, dynamic> json) =>
      _$CouponLayoutFromJson(json);
}
