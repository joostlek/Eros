// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => new Location(
    json['location_id'] as String,
    json['name'] as String,
    json['street'] as String,
    json['house_number'] as String,
    json['city'] as String,
    json['country'] as String,
    json['owner'] as String,
    json['photo_url'] as String,
    json['managers'] == null
        ? null
        : new Map<String, bool>.from(json['managers'] as Map));

abstract class _$LocationSerializerMixin {
  String get locationId;
  String get name;
  String get street;
  String get houseNumber;
  String get city;
  String get country;
  String get owner;
  String get photoUrl;
  Map<String, bool> get managers;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'location_id': locationId,
        'name': name,
        'street': street,
        'house_number': houseNumber,
        'city': city,
        'country': country,
        'owner': owner,
        'photo_url': photoUrl,
        'managers': managers
      };
}
