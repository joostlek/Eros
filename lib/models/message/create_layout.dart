import 'package:eros/models/message/message.dart';
import 'package:eros/models/message/messages.dart';
import 'package:eros/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_layout.g.dart';

@JsonSerializable()
class CreateLayout extends Message with _$CreateLayoutSerializerMixin {
  final Map<String, dynamic> layout;
  @JsonKey(name: 'location_id')
  final String locationId;

  CreateLayout(String messageId, Map<String, dynamic> originUser, DateTime date,
      this.layout, this.locationId)
      : super(messageId, originUser, Messages.CreateLayout, date);

  factory CreateLayout.fromJson(Map<String, dynamic> json) =>
      _$CreateLayoutFromJson(json);
}
