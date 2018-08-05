// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUser _$RegisterUserFromJson(Map<String, dynamic> json) =>
    new RegisterUser(
        json['message_id'] as String,
        json['origin_user'] as Map<String, dynamic>,
        json['date'] == null ? null : DateTime.parse(json['date'] as String),
        json['type'] == null
            ? null
            : Activities.values.singleWhere(
                (x) => x.toString() == 'Activities.${json['type']}'));

abstract class _$RegisterUserSerializerMixin {
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
