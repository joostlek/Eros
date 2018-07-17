import 'package:eros/models/coupons.dart';
import 'package:eros/models/coupon.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_coupon.g.dart';

@JsonSerializable()
class ItemCoupon extends Coupon with _$ItemCouponSerializerMixin {
  final String item;

  ItemCoupon(
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
      this.item)
      : super(couponId, locationId, name, activated, activatedAt, activatedBy,
            expires, issuedAt, issuedBy, type);

  factory ItemCoupon.fromJson(Map<String, dynamic> json) =>
      _$ItemCouponFromJson(json);
}
