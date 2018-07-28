import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Object with _$UserSerializerMixin {
  @JsonKey(name: 'display_name')
  final String displayName;
  final String email;
  final String uid;
  @JsonKey(name: 'photo_url')
  final String photoUrl;
  final Map<String, bool> locations;
  final Map<String, bool> owner;
  final Map<String, bool> manager;
  @JsonKey(name: 'scanned_coupons', includeIfNull: true, )
  final Map<String, Map<String, dynamic>> scannedCoupons;

  User(this.uid, this.displayName, this.email, this.photoUrl, this.locations,
      this.owner, this.manager, this.scannedCoupons);

  User.fromFirebaseUser(FirebaseUser user)
      : this(user.uid, user.displayName, user.email, user.photoUrl, {}, {}, {},
            {});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
