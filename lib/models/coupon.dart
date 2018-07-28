import 'package:eros/models/coupons.dart';
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
  String activatedBy;
  @JsonKey(name: 'activated_at')
  DateTime activatedAt;
  final String name;
  bool activated;
  final DateTime expires;
  final Coupons type;

  Coupon(
      this.couponId,
      this.locationId,
      this.name,
      this.activated,
      this.activatedAt,
      this.activatedBy,
      this.expires,
      this.issuedAt,
      this.issuedBy,
      this.type);

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);

  Map<String, dynamic> toChild() {
    return {
      'name': this.name,
      'coupon_id': this.couponId,
      'location_id': this.locationId,
      'activated': this.activated,
      'type': this.type
    };
  }
}
