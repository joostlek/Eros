// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLocation _$CreateLocationFromJson(Map<String, dynamic> json) =>
    new CreateLocation(
        json['message_id'] as String,
        json['origin_user'] as Map<String, dynamic>,
        json['date'] == null ? null : DateTime.parse(json['date'] as String),
        json['location'] as Map<String, dynamic>,
        json['type'] == null
            ? null
            : Activities.values.singleWhere(
                (x) => x.toString() == 'Activities.${json['type']}'));

abstract class _$CreateLocationSerializerMixin {
  String get messageId;
  Map<String, dynamic> get originUser;
  Activities get type;
  DateTime get date;
  Map<String, dynamic> get location;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'message_id': messageId,
        'origin_user': originUser,
        'type': type == null ? null : type.toString().split('.')[1],
        'date': date?.toIso8601String(),
        'location': location
      };
}
