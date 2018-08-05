import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:flutter/material.dart';
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

  Card toCard() {
    return Card(
      child: ListTile(
        leading: Image.network(
          originUser['photoUrl'],
          width: 36.0,
        ),
        title: Text('Create location'),
        subtitle: Text(
            '${originUser['displayName']} created location ${location['name']}'),
        trailing: location['photoUrl'] != null
            ? Image.network(
                location['photoUrl'],
                width: 36.0,
              )
            : Icon(Icons.store),
      ),
    );
  }
}
