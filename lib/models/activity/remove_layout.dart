import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_layout.g.dart';

@JsonSerializable()
class RemoveLayout extends Activity with _$RemoveLayoutSerializerMixin {
  final Map<String, dynamic> layout;
  @JsonKey(name: 'location_id')
  final String locationId;

  RemoveLayout(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.layout, this.locationId,
      [Activities type])
      : super(messageId, originUser, Activities.CreateCoupon, date);

  factory RemoveLayout.fromJson(Map<String, dynamic> json) =>
      _$RemoveLayoutFromJson(json);
}
