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

  User(this.uid, this.displayName, this.email, this.photoUrl);

  User.fromMap(Map<String, dynamic> data)
      : this(data['uid'], data['displayName'], data['email'], data['photoUrl']);

  User.fromFirebaseUser(FirebaseUser user)
      : this(user.uid, user.displayName, user.email, user.photoUrl);

  Map<String, dynamic> toMap() => {
        'uid': this.uid,
        'displayName': this.displayName,
        'email': this.email,
        'photoUrl': this.photoUrl,
      };

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
