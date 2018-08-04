import 'package:eros/models/message/activities.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package:eros/models/message/activity.g.dart';

@JsonSerializable()
class Activity extends Object with _$ActivitySerializerMixin {
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'origin_user')
  final Map<String, dynamic> originUser;
  final Activities type;
  final DateTime date;

  Activity(this.messageId, this.originUser, this.type, this.date);

  Activity.withUser(
    String messageId,
    User user,
    Activities type,
    DateTime date,
  ) : this(
          messageId,
          user.toShort(),
          type,
          date,
        );

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
