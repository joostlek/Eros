import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/activity/activities.dart';
import 'package:eros/models/activity/activity.dart';
import 'package:eros/models/coupons.dart';
import 'package:eros/models/discount_coupon.dart';
import 'package:eros/models/item_coupon.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/money_coupon.dart';
import 'package:eros/models/coupon.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/activity_storage.dart';

final CollectionReference couponCollection =
    Firestore.instance.collection('coupons');

class CouponStorage {
  final User user;
  CouponStorage(this.user);

  static Coupon fromDocument(DocumentSnapshot document) =>
      _fromMap(document.data);

  static Coupon _fromMap(Map<String, dynamic> data) {
    switch (data['type'] == null
        ? null
        : Coupons.values
            .singleWhere((x) => x.toString() == 'Coupons.${data['type']}')) {
      case Coupons.MoneyCoupon:
        return MoneyCoupon.fromJson(data);
      case Coupons.DiscountCoupon:
        return DiscountCoupon.fromJson(data);
      case Coupons.ItemCoupon:
        return ItemCoupon.fromJson(data);
    }
    return Coupon.fromJson(data);
  }

  static MoneyCoupon _fromMoneyCouponMap(Map<String, dynamic> json) =>
      MoneyCoupon.fromJson(json);

  static DiscountCoupon _fromDiscountCouponMap(Map<String, dynamic> json) =>
      DiscountCoupon.fromJson(json);

  static ItemCoupon _fromItemCouponMap(Map<String, dynamic> json) =>
      ItemCoupon.fromJson(json);

  Map<String, dynamic> _toMap(Coupon coupon, [Map<String, dynamic> other]) {
    final Map<String, dynamic> result = {};
    if (other != null) {
      result.addAll(other);
    }
    result.addAll(json.decode(json.encode(coupon)));
    return result;
  }

  _createCouponActivity(Coupon coupon, String locationId) {
    ActivityStorage activityStorage = ActivityStorage(user);
    activityStorage.createActivity(Activities.CreateCoupon,
        coupon: coupon.toShort(), locationId: locationId);
  }

  _activateCouponActivity(Coupon coupon) {
    ActivityStorage activityStorage = ActivityStorage(user);
    activityStorage.createActivity(Activities.ActivateCoupon,
        coupon: coupon.toShort(), locationId: coupon.locationId);
  }

  Future<ItemCoupon> createItemCoupon(
      String name, User user, Location location, String item,
      [DateTime expires]) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot doc = await tx.get(couponCollection.document());
      final ItemCoupon itemCoupon = ItemCoupon(
          doc.documentID,
          location.locationId,
          name,
          false,
          null,
          null,
          expires,
          DateTime.now(),
          user.toShort(),
          Coupons.ItemCoupon,
          item);
      final Map<String, dynamic> data = _toMap(itemCoupon);
      await tx.set(doc.reference, data);
      return data;
    };
    return Firestore.instance.runTransaction(createTransaction).then((data) {
      ItemCoupon itemCoupon = _fromItemCouponMap(data);
      _createCouponActivity(itemCoupon, location.locationId);
      return itemCoupon;
    }).catchError((e) {
      print('dart error $e');
      return null;
    });
  }

  Future<MoneyCoupon> createMoneyCoupon(
      String name, User user, Location location, double value,
      [DateTime expires]) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot doc = await tx.get(couponCollection.document());
      final MoneyCoupon moneyCoupon = MoneyCoupon(
          doc.documentID,
          location.locationId,
          name,
          false,
          null,
          null,
          expires,
          DateTime.now(),
          user.toShort(),
          Coupons.MoneyCoupon,
          value);
      final Map<String, dynamic> data = _toMap(moneyCoupon);
      await tx.set(doc.reference, data);
      return data;
    };
    return Firestore.instance.runTransaction(createTransaction).then((data) {
      MoneyCoupon moneyCoupon = _fromMoneyCouponMap(data);
      _createCouponActivity(moneyCoupon, location.locationId);
      return moneyCoupon;
    }).catchError((e) {
      print('dart error $e');
      return null;
    });
  }

  Future<DiscountCoupon> createDiscountCoupon(
      String name, User user, Location location, double discount,
      [DateTime expires]) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot doc = await tx.get(couponCollection.document());
      final DiscountCoupon discountCoupon = DiscountCoupon(
          doc.documentID,
          location.locationId,
          name,
          false,
          null,
          null,
          expires,
          DateTime.now(),
          user.toShort(),
          Coupons.DiscountCoupon,
          discount);
      final Map<String, dynamic> data = _toMap(discountCoupon);
      await tx.set(doc.reference, data);
      return data;
    };
    return Firestore.instance.runTransaction(createTransaction).then((data) {
      DiscountCoupon discountCoupon = _fromDiscountCouponMap(data);
      _createCouponActivity(discountCoupon, location.locationId);
      return discountCoupon;
    }).catchError((e) {
      print('dart error $e');
      return null;
    });
  }

  Stream<QuerySnapshot> listCoupons(String location_id,
      {int limit, int offset}) {
    Stream<QuerySnapshot> snapshots = couponCollection
        .where('location_id', isEqualTo: location_id)
        .snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  Stream<QuerySnapshot> filterCoupons(
      String attribute, String value, String location_id) {
    Stream<QuerySnapshot> snapshots = couponCollection
        .where('location_id', isEqualTo: location_id)
        .where(attribute, isEqualTo: value)
        .snapshots();
    return snapshots;
  }

  Future<Coupon> get(String couponId) async {
    return fromDocument(
        await couponCollection.document(couponId).get().catchError((e) {
      print('dart error $e');
      return null;
    }));
  }

  Future<bool> update(Coupon coupon) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot doc =
          await tx.get(couponCollection.document(coupon.couponId));
      await tx.update(doc.reference, _toMap(coupon));
      return {'result': true};
    };
    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((r) => getBool(r))
        .catchError((e) {
      print('dart error $e');
      return false;
    });
  }

  Future<bool> delete(Coupon coupon) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot doc =
          await tx.get(couponCollection.document(coupon.couponId));
      await tx.delete(doc.reference);
      return {'result': true};
    };
    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((r) => r['result'])
        .catchError((e) {
      print('dart error $e');
      return false;
    });
  }

  bool getBool(Map<String, dynamic> data) {
    return data['result'];
  }

  Future<bool> activate(Coupon coupon, User user) {
    coupon.activatedAt = DateTime.now();
    coupon.activated = true;
    coupon.activatedBy = user.toShort();
    _activateCouponActivity(coupon);
    return update(coupon);
  }

  Future<bool> undoActivate(Coupon coupon) {
    coupon.activated = false;
    coupon.activatedBy = null;
    coupon.activatedBy = null;
    return update(coupon);
  }

  Future<int> countCoupons(Location location) async {
    return (await couponCollection
            .where('location_id', isEqualTo: location.locationId)
            .getDocuments())
        .documents
        .length;
  }
}
