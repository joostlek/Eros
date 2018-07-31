import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eros/models/location.dart';
import 'package:eros/models/user.dart';
import 'package:eros/services/location_storage.dart';
import 'package:eros/services/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/QRCodeReader.dart';

class LocationEmployeePage extends StatefulWidget {
  final LocationStorage locationStorage;
  final Location location;

  LocationEmployeePage({this.locationStorage, this.location});

  @override
  State<StatefulWidget> createState() {
    return new LocationEmployeePageState();
  }
}

class LocationEmployeePageState extends State<LocationEmployeePage> {
  User tempUser;
  bool edit = false;

  Future<bool> promoteUser(User user) async {
    return widget.locationStorage.promoteUser(widget.location, user);
  }

  Future<bool> demoteUser(User user) async {
    return widget.locationStorage.demoteUser(widget.location, user);
  }

  Future<bool> removeUser(User user) async {
    tempUser = new User.fromJson(user.toJson());
    return widget.locationStorage.removeUser(widget.location, user);
  }

  Future<bool> undoRemoveUser() async {
    return widget.locationStorage.undoRemoveUser(widget.location, tempUser);
  }

  Future<Map<String, dynamic>> addEmployee() async {
    String uid = await scan();
    return widget.locationStorage.addUser(widget.location, uid);
  }

  Future<String> scan() async {
    return QRCodeReader()
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
        .setAutoFocusIntervalInMs(200)
        .scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          widget.location.owner == widget.locationStorage.user.uid
              ? FloatingActionButton(
                  tooltip: 'Edit employees',
                  child: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      edit = !edit;
                    });
                  })
              : null,
      appBar: AppBar(
          title: Text('Employees'),
          actions: widget.location.owner == widget.locationStorage.user.uid
              ? <Widget>[
                  Builder(
                    builder: (context) {
                      return IconButton(
                          icon: Icon(Icons.person_add),
                          tooltip: 'Add employee',
                          onPressed: () {
                            addEmployee().then((data) {
                              if (data['success'] == true) {
                                final snackBar = SnackBar(
                                  content: Text(
                                      '${data['user'].displayName} is now an employee'),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                              } else {
                                final snackBar = SnackBar(
                                  content: Text(data['error_message']),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                            });
                          });
                    },
                  ),
                ]
              : null),
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.locationStorage.listEmployees(widget.location),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> querySnapshot) {
            if (querySnapshot.hasData && querySnapshot.data != null) {
              return ListView.builder(
                  itemCount: querySnapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    User user = UserStorage
                        .fromDocument(querySnapshot.data.documents[index]);
                    if (widget.location.employees[user.uid] != true) {
                      return null;
                    }
                    return getEmployeeCard(user: user, context: context);
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Card getEmployeeCard({User user, BuildContext context}) {
    return Card(
      child: ListTile(
          title: Text(user.displayName),
          subtitle: widget.location.owner == user.uid
              ? Text('Owner')
              : widget.location.managers[user.uid] == true
                  ? Text('Manager')
                  : Text('Employee'),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              user.photoUrl,
              width: 36.0,
              height: 36.0,
            ),
          ),
          trailing: user.uid != widget.locationStorage.user.uid &&
                  widget.location.owner == widget.locationStorage.user.uid &&
                  edit
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    widget.location.managers[user.uid] == true
                        ? IconButton(
                            icon: Icon(Icons.keyboard_arrow_down),
                            tooltip: 'Demote to employee',
                            onPressed: () {
                              demoteUser(user).then((success) {
                                if (success) {
                                  final snackBar = SnackBar(
                                      action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {
                                            promoteUser(user).then((success) {
                                              if (success) {
                                                final snackBar = SnackBar(
                                                    content: Text('Undone'));
                                                Scaffold
                                                    .of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            });
                                          }),
                                      content: Text(
                                          '${user.displayName} is now employee'));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                }
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.keyboard_arrow_up),
                            tooltip: 'Promote to manager',
                            onPressed: () {
                              promoteUser(user).then((success) {
                                if (success) {
                                  final snackBar = SnackBar(
                                      action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {
                                            demoteUser(user).then((success) {
                                              if (success) {
                                                final snackBar = SnackBar(
                                                    content: Text('Undone'));
                                                Scaffold
                                                    .of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            });
                                          }),
                                      content: Text(
                                          '${user.displayName} is now manager'));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                }
                              });
                            },
                          ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      tooltip: 'Remove employee',
                      onPressed: () {
                        removeUser(user).then((success) {
                          if (success) {
                            final snackBar = SnackBar(
                              action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    undoRemoveUser().then((success) {
                                      if (success) {
                                        final snackBar =
                                            SnackBar(content: Text('Undone'));
                                        Scaffold
                                            .of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    });
                                  }),
                              content: Text('Removed ${user.displayName}'),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        });
                      },
                    )
                  ],
                )
              : null),
    );
  }
}
