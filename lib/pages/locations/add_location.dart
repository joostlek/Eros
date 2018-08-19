import 'package:eros/models/user.dart';
import 'package:eros/services/location_storage.dart';
import 'package:flutter/material.dart';

class AddLocation extends StatefulWidget {
  final User user;
  final LocationStorage locationStorage;

  AddLocation(this.user, this.locationStorage);

  @override
  State createState() => AddLocationState();
}

class AddLocationState extends State<AddLocation> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _houseNumberController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _photoUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add location'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _save(),
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                TextFormField(
                  controller: _streetController,
                  decoration: InputDecoration(labelText: 'Street'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                TextFormField(
                  controller: _houseNumberController,
                  decoration: InputDecoration(labelText: 'House number'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    } else if (!validateRegex(
                        r"\d+[a-zA-Z]{0,1}\s{0,1}[-]{1}\s{0,1}\d*[a-zA-Z]{0,1}|\d+[a-zA-Z-]{0,1}\d*[a-zA-Z]{0,1}",
                        value)) {
                      return 'Please enter a valid house number';
                    }
                  },
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(labelText: 'Country'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                TextFormField(
                  controller: _photoUrlController,
                  decoration: InputDecoration(labelText: 'Photo url'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    } else if (!validateRegex(
                        r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)",
                        value)) {
                      return 'Please enter a valid url';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateRegex(String regex, String test) {
    RegExp regExp = RegExp(regex);
    return regExp.hasMatch(test);
  }

  bool validate() {
    return _formKey.currentState.validate();
  }

  _save() {
    if (validate() == true) {
      widget.locationStorage
          .create(
              _nameController.text,
              _streetController.text,
              _houseNumberController.text,
              _cityController.text,
              _countryController.text,
              _photoUrlController.text)
          .then((location) {
        if (location.locationId != null) {
          Navigator.pop(context);
        }
      });
    }
  }
}
