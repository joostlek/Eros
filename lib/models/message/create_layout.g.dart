// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLayout _$CreateLayoutFromJson(Map<String, dynamic> json) =>
    new CreateLayout(
        json['message_id'] as String,
        json['origin_user'] as Map<String, dynamic>,
        json['date'] == null ? null : DateTime.parse(json['date'] as String),
        json['layout'] as Map<String, dynamic>,
        json['location_id'] as String);

abstract class _$CreateLayoutSerializerMixin {
  String get messageId;
  Map<String, dynamic> get originUser;
  DateTime get date;
  Map<String, dynamic> get layout;
  String get locationId;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message_id': messageId,
        'origin_user': originUser,
        'date': date?.toIso8601String(),
        'layout': layout,
        'location_id': locationId
      };
}
