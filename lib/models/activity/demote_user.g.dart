// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demote_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemoteUser _$DemoteUserFromJson(Map<String, dynamic> json) {
  return new DemoteUser(
      json['message_id'] as String,
      json['origin_user'] as Map<String, dynamic>,
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['target_user'] as Map<String, dynamic>,
      json['location_id'] as String,
      $enumDecodeNullable(
          'Activities', Activities.values, json['type'] as String));
}

abstract class _$DemoteUserSerializerMixin {
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
