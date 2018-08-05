// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLocation _$CreateLocationFromJson(Map<String, dynamic> json) {
  return new CreateLocation(
      json['message_id'] as String,
      json['origin_user'] as Map<String, dynamic>,
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['location'] as Map<String, dynamic>,
      $enumDecodeNullable(
          'Activities', Activities.values, json['type'] as String));
}

abstract class _$CreateLocationSerializerMixin {
  String get messageId;
  Map<String, dynamic> get originUser;
  Activities get type;
  DateTime get date;
  Map<String, dynamic> get location;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message_id': messageId,
        'origin_user': originUser,
        'type': type?.toString()?.split('.')?.last,
        'date': date?.toIso8601String(),
        'location': location
      };
}
