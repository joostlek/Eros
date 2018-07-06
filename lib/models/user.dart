import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String displayName;
  final String email;
  final String uid;
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
}
