// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveUser _$RemoveUserFromJson(Map<String, dynamic> json) {
  return new RemoveUser(
      json['message_id'] as String,
      json['origin_user'] == null
          ? null
          : new Map<String, dynamic>.from(json['origin_user'] as Map),
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['target_user'] == null
          ? null
          : new Map<String, dynamic>.from(json['target_user'] as Map),
      json['location_id'] as String,
      $enumDecodeNullable(
          'Activities', Activities.values, json['type'] as String));
}

abstract class _$RemoveUserSerializerMixin {
  String get messageId;
  Map<String, dynamic> get originUser;
  Activities get type;
  DateTime get date;
  Map<String, dynamic> get targetUser;
  String get locationId;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message_id': messageId,
        'origin_user': originUser,
        'type': type?.toString()?.split('.')?.last,
        'date': date?.toIso8601String(),
        'target_user': targetUser,
        'location_id': locationId
      };
}
