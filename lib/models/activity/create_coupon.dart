import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_coupon.g.dart';

@JsonSerializable()
class CreateCoupon extends Activity with _$CreateCouponSerializerMixin {
  final Map<String, dynamic> coupon;
  @JsonKey(name: 'location_id')
  final String locationId;

  CreateCoupon(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.coupon, this.locationId)
      : super(messageId, originUser, Activities.CreateCoupon, date);

  factory CreateCoupon.fromJson(Map<String, dynamic> json) =>
      _$CreateCouponFromJson(json);
}
