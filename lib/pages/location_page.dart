import 'package:eros/models/location.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  final Location location;

  LocationPage(this.location);
  @override
  State<StatefulWidget> createState() {
    return new LocationPageState();
  }
}

class LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location.name),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 96.0,
                height: 96.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(widget.location.photoUrl))),
              ),
            ),
          ),
          Center(
            child: Text(
              widget.location.name,
              textScaleFactor: 1.5,
            ),
          ),
          Text(
            "${widget.location.street} ${widget.location.houseNumber}\n"
                "${widget.location.country}\n"
                "${widget.location.city}",
            style: TextStyle(color: Colors.grey[600]),
          ),

        ],
      ),
    );
  }
}
