import 'package:eros/models/message/activity.dart';
import 'package:eros/models/message/activities.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_location.g.dart';

@JsonSerializable()
class CreateLocation extends Activity with _$CreateLocationSerializerMixin {
  final Map<String, dynamic> location;

  CreateLocation(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.location)
      : super(messageId, originUser, Activities.CreateCoupon, date);

  factory CreateLocation.fromJson(Map<String, dynamic> json) =>
      _$CreateLocationFromJson(json);
}
