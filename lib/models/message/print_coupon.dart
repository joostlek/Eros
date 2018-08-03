import 'package:eros/models/message/message.dart';
import 'package:eros/models/message/messages.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'print_coupon.g.dart';

@JsonSerializable()
class PrintCoupon extends Message with _$PrintCouponSerializerMixin {
  final Map<String, dynamic> coupon;
  @JsonKey(name: 'location_id')
  final String locationId;

  PrintCoupon(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.coupon, this.locationId)
      : super(messageId, originUser, Messages.PrintCoupon, date);

  factory PrintCoupon.fromJson(Map<String, dynamic> json) =>
      _$PrintCouponFromJson(json);
}
