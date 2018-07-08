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

  Location(this.locationId, this.name, this.street, this.houseNumber, this.city,
      this.country, this.owner, this.photoUrl, this.managers);

//  Location.fromMap(Map<String, dynamic> data)
//      : this(
//          data['locationId'],
//          data['name'],
//          data['street'],
//          data['houseNumber'],
//          data['city'],
//          data['country'],
//          data['owner'],
//          data['photoUrl'],
//          data['managers'],
//        );
//
//  Map<String, dynamic> toMap() => {
//        'locationId': this.locationId,
//        'name': this.name,
//        'street': this.street,
//        'houseNumber': this.houseNumber,
//        'city': this.city,
//        'country': this.country,
//        'owner': this.owner,
//        'photoUrl': this.photoUrl,
//        'managers': this.managers,
//      };
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
