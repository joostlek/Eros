import 'package:eros/models/message/message.dart';
import 'package:eros/models/message/messages.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promote_user.g.dart';

@JsonSerializable()
class PromoteUser extends Message with _$PromoteUserSerializerMixin {
  @JsonKey(name: 'target_user')
  final Map<String, dynamic> targetUser;

  @JsonKey(name: 'location_id')
  final String locationId;

  PromoteUser(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.targetUser, this.locationId)
      : super(messageId, originUser, Messages.PromoteUser, date);

  PromoteUser.withUser(String messageId, User user, DateTime date,
      this.targetUser, this.locationId)
      : super.withUser(messageId, user, Messages.PromoteUser, date);

  factory PromoteUser.fromJson(Map<String, dynamic> json) =>
      _$PromoteUserFromJson(json);
}
