import 'package:eros/models/coupons.dart';
import 'package:eros/models/status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coupon.g.dart';

@JsonSerializable()
class Coupon extends Object with _$CouponSerializerMixin {
  @JsonKey(name: 'coupon_id')
  final String couponId;
  @JsonKey(name: 'issued_by')
  final Map<String, dynamic> issuedBy;
  @JsonKey(name: 'issued_at')
  final DateTime issuedAt;
  @JsonKey(name: 'location_id')
  final String locationId;
  @JsonKey(name: 'activated_by')
  Map<String, dynamic> activatedBy;
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

  Map<String, dynamic> toShort() {
    return {
      'name': this.name,
      'coupon_id': this.couponId,
      'type': type,
      'value': '',
    };
  }

  Status getStatus() => getStatusAt(DateTime.now());

  Status getStatusAt(DateTime dateTime) {
    if (dateTime == null) {
      return null;
    }
    if (this.expires != null && dateTime.isAfter(this.expires)) {
      return Status.Expired;
    } else if (this.activatedAt != null &&
        this.activatedAt.isAfter(dateTime) &&
        this.issuedAt.isBefore(dateTime)) {
      return Status.Active;
    } else if (this.activated == true && this.activatedAt.isBefore(dateTime)) {
      return Status.Redeemed;
    } else if (this.issuedAt.isBefore(dateTime)) {
      return Status.Active;
    } else if (this.issuedAt.isAfter(dateTime)) {
      return null;
    } else {
      return null;
    }
  }
}
