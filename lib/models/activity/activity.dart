import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/user.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class Activity {
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'origin_user')
  final Map<String, dynamic> originUser;
  final Activities type;
  final DateTime date;

  Activity(this.messageId, this.originUser, this.type, this.date);

  Activity.withUser(
    String messageId,
    User user,
    Activities type,
    DateTime date,
  ) : this(
          messageId,
          user.toShort(),
          type,
          date,
        );

  Card toCard();

  Map<String, dynamic> toJson();
}
