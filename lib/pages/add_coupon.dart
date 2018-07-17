import 'dart:async';

import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/coupon_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCoupon extends StatefulWidget {
  final Location location;
  final User user;
  AddCoupon(this.location, this.user);
  @override
  State<StatefulWidget> createState() {
    return AddCouponState();
  }
}

class AddCouponState extends State<AddCoupon> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final valueController = TextEditingController();
  DateTime expires;
  CouponStorage couponStorage = CouponStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add coupon'),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          tooltip: 'Save',
          onPressed: () {
            submit().then((bool) {
              if (bool == true) {
                Navigator.pop(context);
              }
            });
          }),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Value'),
                controller: valueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  subtitle: Text('Date of expire'),
                  title: expires != null
                      ? Text('${expires.day}-${expires.month}-${expires.year}')
                      : Text('Select date'),
                  leading: IconButton(
                      icon: Icon(Icons.date_range),
                      tooltip: 'Select date',
                      onPressed: () {
                        getDate(context).then((date) {
                          if (date != null) {
                            expires = date;
                            setState(() {});
                          }
                        });
                      }),
                  trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      tooltip: 'Clear current date',
                      onPressed: () {
                        expires = null;
                        setState(() {});
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime> getDate(BuildContext context) async {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 10000)));
  }

  Future<bool> submit() async {
    if (_formKey.currentState.validate()) {
      return couponStorage
          .createMoneyCoupon(
              nameController.text,
              widget.user,
              widget.location,
              double.parse(valueController.text),
              expires)
          .then((coupon) {
        if (coupon.couponId != null) {
          return true;
        }
      });
    }
    return false;
  }
}
