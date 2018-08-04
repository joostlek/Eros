// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => new Message(
    json['message_id'] as String,
    json['origin_user'] as Map<String, dynamic>,
    json['type'] == null
        ? null
        : Activities.values
            .singleWhere((x) => x.toString() == 'Messages.${json['type']}'),
    json['date'] == null ? null : DateTime.parse(json['date'] as String));

abstract class _$MessageSerializerMixin {
  String get messageId;
  Map<String, dynamic> get originUser;
  Activities get type;
  DateTime get date;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message_id': messageId,
        'origin_user': originUser,
        'type': type == null ? null : type.toString().split('.')[1],
        'date': date?.toIso8601String()
      };
}
