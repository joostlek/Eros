import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_location.g.dart';

@JsonSerializable()
class CreateLocation extends Activity with _$CreateLocationSerializerMixin {
  final Map<String, dynamic> location;

  CreateLocation(String messageId, Map<String, dynamic> originUser,
      DateTime date, this.location,
      [Activities type])
      : super(messageId, originUser, Activities.CreateLocation, date);

  factory CreateLocation.fromJson(Map<String, dynamic> json) =>
      _$CreateLocationFromJson(json);
}
