import 'package:eros/models/message/message.dart';
import 'package:eros/models/message/messages.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_user.g.dart';

@JsonSerializable()
class RegisterUser extends Message with _$RegisterUserSerializerMixin {
  RegisterUser(String messageId, Map<String, dynamic> originUser, DateTime date)
      : super(messageId, originUser, Messages.RegisterUser, date);

  RegisterUser.withUser(String messageId, User user, DateTime date)
      : super.withUser(messageId, user, Messages.RegisterUser, date);

  factory RegisterUser.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserFromJson(json);
}
