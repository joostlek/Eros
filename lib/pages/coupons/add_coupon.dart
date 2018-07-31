import 'dart:async';

import 'package:eros/models/coupons.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/coupon_storage.dart';
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

class AddCouponState extends State<AddCoupon>
    with SingleTickerProviderStateMixin {
  DateTime expires;
  CouponStorage couponStorage = CouponStorage();

  final List<MyTab> myTabs = <MyTab>[
    MyTab(Icon(Icons.card_giftcard), 'Gift', MoneyTab()),
    MyTab(Icon(Icons.shopping_cart), 'Free item', ItemTab()),
    MyTab(Icon(Icons.trending_down), 'Discount', DiscountTab()),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add coupon'),
        bottom: TabBar(
            controller: _tabController,
            tabs: myTabs.map((MyTab tab) {
              return Tab(text: tab.text, icon: tab.icon);
            }).toList()),
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
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((MyTab tab) {
          return tab.widget;
        }).toList(),
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
    MyTab tab = myTabs[_tabController.index];
    if (tab.widget.validate()) {
      Coupons current = Coupons.values[_tabController.index];
      Map<String, dynamic> data = tab.widget.getValues();
      switch (current) {
        case Coupons.MoneyCoupon:
          return couponStorage
              .createMoneyCoupon(
                  data['name'], widget.user, widget.location, data['value'])
              .then((coupon) {
            return coupon.couponId != null;
          });
        case Coupons.DiscountCoupon:
          return couponStorage
              .createDiscountCoupon(
                  data['name'], widget.user, widget.location, data['discount'])
              .then((coupon) {
            return coupon.couponId != null;
          });
        case Coupons.ItemCoupon:
          return couponStorage
              .createItemCoupon(
                  data['name'], widget.user, widget.location, data['item'])
              .then((coupon) {
            return coupon.couponId != null;
          });
      }
    }
    return false;
  }
}

class DiscountTab extends TabWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _discountController = TextEditingController();
  final _DatePickerKey = GlobalKey<DatePickerState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Discount', suffixText: '%', prefixText: '-'),
                controller: _discountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
              DatePicker(
                key: _DatePickerKey,
              ),
            ],
          ),
        ));
  }

  bool validate() {
    return _formKey.currentState.validate();
  }

  @override
  Map<String, dynamic> getValues() {
    return {
      'name': _nameController.text,
      'discount': double.parse(_discountController.text)
    };
  }
}

class MoneyTab extends TabWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _DatePickerKey = GlobalKey<DatePickerState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Value'),
                controller: _valueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
              DatePicker(
                key: _DatePickerKey,
              ),
            ],
          ),
        ));
  }

  bool validate() {
    return _formKey.currentState.validate();
  }

  @override
  Map<String, dynamic> getValues() {
    return {
      'name': _nameController.text,
      'value': double.parse(_valueController.text)
    };
  }
}

class ItemTab extends TabWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _itemController = TextEditingController();
  final _DatePickerKey = GlobalKey<DatePickerState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Item'),
                controller: _itemController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
              DatePicker(
                key: _DatePickerKey,
              ),
            ],
          ),
        ));
  }

  bool validate() {
    return _formKey.currentState.validate();
  }

  @override
  Map<String, dynamic> getValues() {
    return {'name': _nameController.text, 'item': _itemController.text};
  }
}

class MyTab {
  final Icon icon;
  final String text;
  final TabWidget widget;

  MyTab(this.icon, this.text, this.widget);
}

class DatePicker extends StatefulWidget {
  DatePicker({Key key}) : super(key: key);
  static DatePickerState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<DatePickerState>());

  @override
  State<StatefulWidget> createState() {
    return DatePickerState();
  }

  DateTime getDate(BuildContext context) {
    return of(context).expires ?? null;
  }
}

class DatePickerState extends State<DatePicker> {
  DateTime expires = null;
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }

  Future<DateTime> getDate(BuildContext context) async {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 10000)));
  }
}

abstract class TabWidget extends StatelessWidget {
  bool validate();

  Map<String, dynamic> getValues();
}
