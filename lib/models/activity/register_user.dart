import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:eros/models/user.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_user.g.dart';

@JsonSerializable()
class RegisterUser extends Activity with _$RegisterUserSerializerMixin {
  RegisterUser(String messageId, Map<String, dynamic> originUser, DateTime date,
      [Activities type])
      : super(messageId, originUser, Activities.RegisterUser, date);

  RegisterUser.withUser(String messageId, User user, DateTime date)
      : super.withUser(messageId, user, Activities.RegisterUser, date);

  factory RegisterUser.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserFromJson(json);

  Card toCard() {
    return Card(
      child: ListTile(
        leading: Image.network(originUser['photoUrl'], width: 36.0,),
        title: Text('User registered'),
        subtitle: Text('${originUser['displayName']} registered'),
      ),
    );
  }
}
