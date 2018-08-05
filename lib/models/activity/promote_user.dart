import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promote_user.g.dart';

@JsonSerializable()
class PromoteUser extends Activity with _$PromoteUserSerializerMixin {
  @JsonKey(name: 'target_user')
  final Map<String, dynamic> targetUser;

  @JsonKey(name: 'location_id')
  final String locationId;

  PromoteUser(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.targetUser, this.locationId,
      [Activities type])
      : super(messageId, originUser, Activities.PromoteUser, date);

  PromoteUser.withUser(String messageId, User user, DateTime date,
      this.targetUser, this.locationId)
      : super.withUser(messageId, user, Activities.PromoteUser, date);

  factory PromoteUser.fromJson(Map<String, dynamic> json) =>
      _$PromoteUserFromJson(json);
}
