import 'package:eros/models/message/message.dart';
import 'package:eros/models/message/messages.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_user.g.dart';

@JsonSerializable()
class RemoveUser extends Message with _$RemoveUserSerializerMixin {
  @JsonKey(name: 'target_user')
  final Map<String, dynamic> targetUser;
  @JsonKey(name: 'location_id')
  final String locationId;

  RemoveUser(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.targetUser, this.locationId)
      : super(messageId, originUser, Messages.RemoveUser, date);

  RemoveUser.withUser(String messageId, User user, DateTime date,
      this.targetUser, this.locationId)
      : super.withUser('', user, Messages.RemoveUser, date);

  factory RemoveUser.fromJson(Map<String, dynamic> json) =>
      _$RemoveUserFromJson(json);
}
