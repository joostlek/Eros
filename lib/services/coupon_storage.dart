import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupon.dart';

final CollectionReference couponCollection =
    Firestore.instance.collection('coupons');

class CouponStorage {
  CouponStorage();

  static Coupon fromDocument(DocumentSnapshot document) =>
      _fromMap(document.data);

  static Coupon _fromMap(Map<String, dynamic> data) =>
      new Coupon.fromJson(data);

  Map<String, dynamic> _toMap(Coupon coupon, [Map<String, dynamic> other]) {
    final Map<String, dynamic> result = {};
    if (other != null) {
      result.addAll(other);
    }
    result.addAll(json.decode(json.encode(coupon)));
    return result;
  }

  Future<Coupon> create(
      String name, String user_id, String location_id, double value,
      [DateTime expires]) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot doc = await tx.get(couponCollection.document());
      final Coupon coupon = new Coupon(
          doc.documentID,
          user_id,
          DateTime.now(),
          location_id,
          expires != null ? expires : null,
          value,
          null,
          null,
          false,
          name);
      final Map<String, dynamic> data = _toMap(coupon);
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
}
