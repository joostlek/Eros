import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_layout.g.dart';

@JsonSerializable()
class CreateLayout extends Activity with _$CreateLayoutSerializerMixin {
  final Map<String, dynamic> layout;
  @JsonKey(name: 'location_id')
  final String locationId;

  CreateLayout(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.layout, this.locationId,
      [Activities type])
      : super(messageId, originUser, Activities.CreateLayout, date);

  factory CreateLayout.fromJson(Map<String, dynamic> json) =>
      _$CreateLayoutFromJson(json);
}
