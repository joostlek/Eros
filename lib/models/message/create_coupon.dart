import 'package:eros/models/message/message.dart';
import 'package:eros/models/message/messages.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_coupon.g.dart';

@JsonSerializable()
class CreateCoupon extends Message with _$CreateCouponSerializerMixin {
  final Map<String, dynamic> coupon;
  @JsonKey(name: 'location_id')
  final String locationId;

  CreateCoupon(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.coupon, this.locationId)
      : super(messageId, originUser, Messages.CreateCoupon, date);

  factory CreateCoupon.fromJson(Map<String, dynamic> json) =>
      _$CreateCouponFromJson(json);
}
