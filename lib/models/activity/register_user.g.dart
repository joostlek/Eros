// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUser _$RegisterUserFromJson(Map<String, dynamic> json) {
  return new RegisterUser(
      json['message_id'] as String,
      json['origin_user'] as Map<String, dynamic>,
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      $enumDecodeNullable(
          'Activities', Activities.values, json['type'] as String));
}

abstract class _$RegisterUserSerializerMixin {
  String get messageId;
  Map<String, dynamic> get originUser;
  Activities get type;
  DateTime get date;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message_id': messageId,
        'origin_user': originUser,
        'type': type?.toString()?.split('.')?.last,
        'date': date?.toIso8601String()
      };
}
