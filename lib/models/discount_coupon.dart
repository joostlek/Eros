import 'package:eros/models/coupons.dart';
import 'package:eros/models/coupon.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discount_coupon.g.dart';

@JsonSerializable()
class DiscountCoupon extends Coupon with _$DiscountCouponSerializerMixin {
  final double discount;

  DiscountCoupon(
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
      this.discount)
      : super(couponId, locationId, name, activated, activatedAt, activatedBy,
            expires, issuedAt, issuedBy, type);

  factory DiscountCoupon.fromJson(Map<String, dynamic> json) =>
      _$DiscountCouponFromJson(json);
}
