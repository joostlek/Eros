import 'package:eros/models/message/activity.dart';
import 'package:eros/models/message/activities.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'demote_user.g.dart';

@JsonSerializable()
class DemoteUser extends Message with _$DemoteUserSerializerMixin {
  @JsonKey(name: 'target_user')
  final Map<String, dynamic> targetUser;
  @JsonKey(name: 'location_id')
  final String locationId;

  DemoteUser(
    String messageId,
    Map<String, dynamic> originUser,
    DateTime date,
    this.targetUser,
    this.locationId,
  ) : super(messageId, originUser, Activities.DemoteUser, date);

  DemoteUser.withUser(String messageId, User user, DateTime date,
      this.targetUser, this.locationId)
      : super.withUser('', user, Activities.DemoteUser, date);

  factory DemoteUser.fromJson(Map<String, dynamic> json) =>
      _$DemoteUserFromJson(json);
}
