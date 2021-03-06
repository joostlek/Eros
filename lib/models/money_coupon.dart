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
      Map<String, dynamic> activatedBy,
      DateTime expires,
      DateTime issuedAt,
      Map<String, dynamic> issuedBy,
      Coupons type,
      this.value)
      : super(couponId, locationId, name, activated, activatedAt, activatedBy,
            expires, issuedAt, issuedBy, type);

  factory MoneyCoupon.fromJson(Map<String, dynamic> json) =>
      _$MoneyCouponFromJson(json);

  @override
  Map<String, dynamic> toShort() {
    return {
      'name': this.name,
      'coupon_id': this.couponId,
      'type': type == null ? null : type.toString().split('.')[1],
      'value': this.value,
    };
  }
}
