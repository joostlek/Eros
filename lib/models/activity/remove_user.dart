import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:eros/models/user.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_user.g.dart';

@JsonSerializable()
class RemoveUser extends Activity with _$RemoveUserSerializerMixin {
  @JsonKey(name: 'target_user')
  final Map<String, dynamic> targetUser;
  @JsonKey(name: 'location_id')
  final String locationId;

  RemoveUser(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.targetUser, this.locationId,
      [Activities type])
      : super(messageId, originUser, Activities.RemoveUser, date);

  RemoveUser.withUser(String messageId, User user, DateTime date,
      this.targetUser, this.locationId)
      : super.withUser('', user, Activities.RemoveUser, date);

  factory RemoveUser.fromJson(Map<String, dynamic> json) =>
      _$RemoveUserFromJson(json);

  Card toCard() {
    return Card(
      child: ListTile(
        leading: Image.network(
          originUser['photoUrl'],
          width: 36.0,
        ),
        isThreeLine: true,
        title: Text('Removed user'),
        subtitle: Text(
            '${originUser['displayName']} removed ${targetUser['displayName']}'),
        trailing: Image.network(
          targetUser['photoUrl'],
          width: 36.0,
        ),
      ),
    );
  }
}
