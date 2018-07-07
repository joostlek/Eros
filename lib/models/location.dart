class Location {
  final String name;
  final String street;
  final String houseNumber;
  final String city;
  final String country;
  final String owner;

  Location(this.name, this.street, this.houseNumber, this.city, this.country,
      this.owner);

  Location.fromMap(Map<String, dynamic> data)
      : this(data['name'], data['street'], data['houseNumber'], data['city'],
            data['country'], data['owner']);

  Map<String, dynamic> toMap() => {
        'name': this.name,
        'street': this.street,
        'houseNumber': this.houseNumber,
        'city': this.city,
        'country': this.country,
        'owner': this.owner,
      };
}
