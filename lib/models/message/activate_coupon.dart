import 'package:eros/models/message/activity.dart';
import 'package:eros/models/message/activities.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activate_coupon.g.dart';

@JsonSerializable()
class ActivateCoupon extends Message with _$ActivateCouponSerializerMixin {
  final Map<String, dynamic> coupon;
  @JsonKey(name: 'location_id')
  final String locationId;

  ActivateCoupon(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.coupon, this.locationId)
      : super(messageId, originUser, Activities.ActivateCoupon, date);

  factory ActivateCoupon.fromJson(Map<String, dynamic> json) =>
      _$ActivateCouponFromJson(json);
}
