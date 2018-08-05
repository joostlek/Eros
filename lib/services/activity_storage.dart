import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/activity/activate_coupon.dart';
import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:eros/models/activity/add_user.dart';
import 'package:eros/models/activity/create_coupon.dart';
import 'package:eros/models/activity/create_layout.dart';
import 'package:eros/models/activity/create_location.dart';
import 'package:eros/models/activity/demote_user.dart';
import 'package:eros/models/activity/print_coupon.dart';
import 'package:eros/models/activity/promote_user.dart';
import 'package:eros/models/activity/register_user.dart';
import 'package:eros/models/activity/remove_layout.dart';
import 'package:eros/models/activity/remove_user.dart';
import 'package:eros/models/user.dart';

final activityCollection = Firestore.instance.collection('recent_activities');

class ActivityStorage {
  final User originUser;

  ActivityStorage(this.originUser);

  static Activity _fromDocument(DocumentSnapshot doc) => _fromMap(doc.data);

  static Activity _fromMap(Map<String, dynamic> data) {
    switch (data['type'] == null
        ? null
        : Activities.values
            .singleWhere((x) => x.toString() == 'Activities.${data['type']}')) {
      case Activities.ActivateCoupon:
        return ActivateCoupon.fromJson(data);
      case Activities.AddUser:
        return AddUser.fromJson(data);
      case Activities.CreateCoupon:
        return CreateCoupon.fromJson(data);
      case Activities.CreateLayout:
        return CreateLayout.fromJson(data);
      case Activities.DemoteUser:
        return DemoteUser.fromJson(data);
      case Activities.PrintCoupon:
        return PrintCoupon.fromJson(data);
      case Activities.PromoteUser:
        return PromoteUser.fromJson(data);
      case Activities.RegisterUser:
        return RegisterUser.fromJson(data);
      case Activities.RemoveUser:
        return RemoveUser.fromJson(data);
      case Activities.RemoveLayout:
        return RemoveLayout.fromJson(data);
      case Activities.CreateLocation:
        return CreateLocation.fromJson(data);
    }
    return Activity.fromJson(data);
  }

  Future<Activity> createActivity(
    Activities type, {
    String locationId,
    Map<String, dynamic> coupon,
    Map<String, dynamic> targetUser,
    Map<String, dynamic> layout,
    Map<String, dynamic> location,
  }) async {
    if (type == Activities.CreateCoupon ||
        type == Activities.ActivateCoupon ||
        type == Activities.PrintCoupon) {
      assert(coupon != null);
      assert(locationId != null);
    } else if (type == Activities.CreateLocation) {
      assert(location != null);
    } else if (type == Activities.RemoveLayout ||
        type == Activities.CreateLayout) {
      assert(layout != null);
      assert(locationId != null);
    } else if (type == Activities.RemoveUser ||
        type == Activities.PromoteUser ||
        type == Activities.DemoteUser ||
        type == Activities.AddUser) {
      assert(targetUser != null);
      assert(locationId != null);
    }
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot doc = await tx.get(activityCollection.document());
      Activity activity;
      switch (type) {
        case Activities.ActivateCoupon:
          activity = ActivateCoupon(doc.documentID, originUser.toShort(),
              DateTime.now(), coupon, locationId);
          break;
        case Activities.AddUser:
          activity = AddUser(doc.documentID, originUser.toShort(),
              DateTime.now(), targetUser, locationId);
          break;
        case Activities.CreateCoupon:
          activity = CreateCoupon(doc.documentID, originUser.toShort(),
              DateTime.now(), coupon, locationId);
          break;
        case Activities.CreateLayout:
          activity = CreateLayout(doc.documentID, originUser.toShort(),
              DateTime.now(), layout, locationId);
          break;
        case Activities.DemoteUser:
          activity = DemoteUser(doc.documentID, originUser.toShort(),
              DateTime.now(), targetUser, locationId);
          break;
        case Activities.PrintCoupon:
          activity = PrintCoupon(doc.documentID, originUser.toShort(),
              DateTime.now(), coupon, locationId);
          break;
        case Activities.PromoteUser:
          activity = PromoteUser(doc.documentID, originUser.toShort(),
              DateTime.now(), targetUser, locationId);
          break;
        case Activities.RegisterUser:
          activity = RegisterUser(
              doc.documentID, originUser.toShort(), DateTime.now());
          break;
        case Activities.RemoveUser:
          activity = RemoveUser(doc.documentID, originUser.toShort(),
              DateTime.now(), targetUser, locationId);
          break;
        case Activities.RemoveLayout:
          activity = RemoveLayout(doc.documentID, originUser.toShort(),
              DateTime.now(), layout, locationId);
          break;
        case Activities.CreateLocation:
          activity = CreateLocation(
              doc.documentID, originUser.toShort(), DateTime.now(), location);
          break;
      }
      final Map<String, dynamic> data = activity.toJson();
      await tx.set(doc.reference, data);
      return data;
    };
    return Firestore.instance
        .runTransaction(createTransaction)
        .then(_fromMap)
        .catchError((e) {
      print('dart error $e');
      return null;
    });
  }
}
