// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => new User(
    json['uid'] as String,
    json['display_name'] as String,
    json['email'] as String,
    json['photo_url'] as String);

abstract class _$UserSerializerMixin {
  String get displayName;
  String get email;
  String get uid;
  String get photoUrl;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'display_name': displayName,
        'email': email,
        'uid': uid,
        'photo_url': photoUrl
      };
}
