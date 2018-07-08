class Location {
  final String locationId;
  final String name;
  final String street;
  final String houseNumber;
  final String city;
  final String country;
  final String owner;
  final String photoUrl;

  Location(this.locationId, this.name, this.street, this.houseNumber, this.city,
      this.country, this.owner, this.photoUrl);

  Location.fromMap(Map<String, dynamic> data)
      : this(
            data['locationId'],
            data['name'],
            data['street'],
            data['houseNumber'],
            data['city'],
            data['country'],
            data['owner'],
            data['photoUrl']);

  Map<String, dynamic> toMap() => {
        'locationId': this.locationId,
        'name': this.name,
        'street': this.street,
        'houseNumber': this.houseNumber,
        'city': this.city,
        'country': this.country,
        'owner': this.owner,
        'photoUrl': this.photoUrl,
      };
}
