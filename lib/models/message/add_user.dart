import 'package:eros/models/message/activity.dart';
import 'package:eros/models/message/activities.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_user.g.dart';

@JsonSerializable()
class AddUser extends Message with _$AddUserSerializerMixin {
  @JsonKey(name: 'target_user')
  final Map<String, dynamic> targetUser;
  @JsonKey(name: 'location_id')
  final String locationId;

  AddUser(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.targetUser, this.locationId)
      : super(messageId, originUser, Activities.AddUser, date);

  AddUser.withUser(String messageId, User user, DateTime date, this.targetUser,
      this.locationId)
      : super.withUser('', user, Activities.AddUser, date);

  factory AddUser.fromJson(Map<String, dynamic> json) =>
      _$AddUserFromJson(json);
}