import 'package:eros/models/new_coupon.dart';
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
      this.value)
      : super(couponId, locationId, name, activated, activatedAt, activatedBy,
      expires, issuedAt, issuedBy);

  factory MoneyCoupon.fromJson(Map<String, dynamic> json) =>
      _$MoneyCouponFromJson(json);
}
