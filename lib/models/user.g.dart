// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => new User(
    json['uid'] as String,
    json['display_name'] as String,
    json['email'] as String,
    json['photo_url'] as String,
    json['locations'] == null
        ? null
        : new Map<String, bool>.from(json['locations'] as Map),
    json['owner'] == null
        ? null
        : new Map<String, bool>.from(json['owner'] as Map),
    json['manager'] == null
        ? null
        : new Map<String, bool>.from(json['manager'] as Map),
    json['scanned_coupons'] == null
        ? null
        : new Map<String, Map<String, dynamic>>.fromIterables(
            (json['scanned_coupons'] as Map<String, dynamic>).keys,
            (json['scanned_coupons'] as Map)
                .values
                .map((e) => e as Map<String, dynamic>)));

abstract class _$UserSerializerMixin {
  String get displayName;
  String get email;
  String get uid;
  String get photoUrl;
  Map<String, bool> get locations;
  Map<String, bool> get owner;
  Map<String, bool> get manager;
  Map<String, Map<String, dynamic>> get scannedCoupons;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'display_name': displayName,
        'email': email,
        'uid': uid,
        'photo_url': photoUrl,
        'locations': locations,
        'owner': owner,
        'manager': manager,
        'scanned_coupons': scannedCoupons
      };
}
