// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveLayout _$RemoveLayoutFromJson(Map<String, dynamic> json) =>
    new RemoveLayout(
        json['message_id'] as String,
        json['origin_user'] as Map<String, dynamic>,
        json['date'] == null ? null : DateTime.parse(json['date'] as String),
        json['layout'] as Map<String, dynamic>,
        json['location_id'] as String);

abstract class _$RemoveLayoutSerializerMixin {
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