import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location extends Object with _$LocationSerializerMixin {
  @JsonKey(name: 'location_id')
  final String locationId;
  final String name;
  final String street;
  @JsonKey(name: 'house_number')
  final String houseNumber;
  final String city;
  final String country;
  final String owner;
  @JsonKey(name: 'photo_url')
  final String photoUrl;
  final Map<String, bool> managers;
  final Map<String, bool> employees;

  Location(this.locationId, this.name, this.street, this.houseNumber, this.city,
      this.country, this.owner, this.photoUrl, this.managers, this.employees);

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
