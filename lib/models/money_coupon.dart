import 'package:eros/models/coupons.dart';
import 'package:eros/models/coupon.dart';
import 'package:json_annotation/json_annotation.dart';

part 'money_coupon.g.dart';

@JsonSerializable()
class MoneyCoupon extends Coupon with _$MoneyCouponSerializerMixin {
  final double value;

  MoneyCoupon(
      String couponId,
      String locationId,
      String name,
      bool activated,
      DateTime activatedAt,
      String activatedBy,
      DateTime expires,
      DateTime issuedAt,
      String issuedBy,
      Coupons type,
      this.value)
      : super(couponId, locationId, name, activated, activatedAt, activatedBy,
            expires, issuedAt, issuedBy, type);

  factory MoneyCoupon.fromJson(Map<String, dynamic> json) =>
      _$MoneyCouponFromJson(json);
}
