import 'package:json_annotation/json_annotation.dart';

part 'coupon.g.dart';

@JsonSerializable()
class Coupon extends Object with _$CouponSerializerMixin {
  @JsonKey(name: 'coupon_id')
  final String couponId;
  @JsonKey(name: 'issued_by')
  final String issuedBy;
  @JsonKey(name: 'issued_at')
  final DateTime issuedAt;
  @JsonKey(name: 'location_id')
  final String locationId;
  @JsonKey(name: 'activated_by')
  final String activatedBy;
  @JsonKey(name: 'activated_at')
  final DateTime activatedAt;
  final DateTime expires;
  final double value;

  Coupon(this.couponId, this.issuedBy, this.issuedAt, this.locationId,
      this.expires, this.value, this.activatedBy, this.activatedAt);

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
}
