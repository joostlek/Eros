import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/coupon_layout.dart';
import 'package:eros/models/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponLayoutPage extends StatefulWidget {
  final CouponLayout couponLayout;
  final Location location;
  final bool newLayout;

  CouponLayoutPage(this.couponLayout, this.location, this.newLayout);

  @override
  State<StatefulWidget> createState() => CouponLayoutPageState();
}

class CouponLayoutPageState extends State<CouponLayoutPage> {
  static const PRINT_CHANNEL = const MethodChannel('eros.jtosti.nl/print');
  CouponLayout couponLayout;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _htmlController;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    if (widget.newLayout == true) {
      couponLayout = CouponLayout('', '', '', '');
    } else if (couponLayout == null) {
      couponLayout = widget.couponLayout;
    }
  }

  @override
  Widget build(BuildContext context) {
    _nameController = TextEditingController(text: couponLayout.name);
    _htmlController = TextEditingController(text: couponLayout.html);
    return Scaffold(
      appBar: AppBar(
        title: widget.newLayout ? Text('Add layout') : Text(couponLayout.name),
        actions: <Widget>[
          IconButton(
            tooltip: 'Test current layout',
            icon: Icon(Icons.print),
            onPressed: () {
              _print(couponLayout);
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleChange(),
        child: widget.newLayout == true
            ? Icon(Icons.save)
            : edit ? Icon(Icons.save) : Icon(Icons.edit),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                enabled: widget.newLayout == true ? true : edit,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
                decoration: InputDecoration(
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.rate_review),
                  ),
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                controller: _htmlController,
                enabled: widget.newLayout == true ? true : edit,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
                maxLines: 5,
                decoration: InputDecoration(
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.code),
                    ),
                    labelText: 'HTML'),
              )
            ],
          ),
        ),
      ),
    );
  }

  _handleChange() async {
    if (widget.newLayout == true) {
      _save().then(Navigator.pop(context));
    }
    if (edit == true) {
      await _save();
      setState(() {
        edit = false;
      });
    } else {
      setState(() {
        edit = true;
      });
    }
  }

  _save() {
    if (widget.newLayout == true) {
      final TransactionHandler createTransaction = (Transaction tx) async {
        final DocumentSnapshot doc = await tx
            .get(Firestore.instance.collection('coupon_layouts').document());
        final CouponLayout couponLayout = CouponLayout(
            doc.documentID,
            _nameController.text,
            _htmlController.text,
            widget.location.locationId);
        final Map<String, dynamic> data = couponLayout.toJson();
        await tx.set(doc.reference, data);
        return data;
      };
      return Firestore.instance
          .runTransaction(createTransaction)
          .then((json) => CouponLayout.fromJson(json))
          .catchError((e) {
        print('dart error $e');
        return null;
      });
    } else {
      final TransactionHandler updateTransaction = (Transaction tx) async {
        final DocumentSnapshot doc = await tx.get(Firestore.instance
            .collection('coupon_layouts')
            .document(couponLayout.couponLayoutId));
        await tx.update(
            doc.reference,
            CouponLayout(couponLayout.couponLayoutId, _nameController.text,
                    _htmlController.text, widget.location.locationId)
                .toJson());
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
  }

  bool getBool(Map<String, dynamic> data) {
    return data['result'];
  }

  Future<bool> _print(CouponLayout couponLayout) async {
    try {
      final bool result = await PRINT_CHANNEL.invokeMethod('print', {
        'html': _htmlController.text
            .replaceAll('<!--QRCODE-->',
                '<img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=test">')
            .replaceAll('<!--VALUE-->', '€10,00')
      });
      return result;
    } catch (e) {
      print('dart error $e');
    }
    return false;
  }
}
