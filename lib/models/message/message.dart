import 'package:eros/models/message/messages.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package:eros/models/message/message.g.dart';

@JsonSerializable()
class Message extends Object with _$MessageSerializerMixin {
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'origin_user')
  final Map<String, dynamic> originUser;
  final Messages type;
  final DateTime date;

  Message(this.messageId, this.originUser, this.type, this.date);

  Message.withUser(
    String messageId,
    User user,
    Messages type,
    DateTime date,
  ) : this(
          messageId,
          user.toShort(),
          type,
          date,
        );

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
