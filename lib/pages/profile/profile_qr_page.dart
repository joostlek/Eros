import 'package:eros/models/user.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileQrPage extends StatefulWidget {
  final User user;

  ProfileQrPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return new ProfileQrPageState();
  }
}

class ProfileQrPageState extends State<ProfileQrPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR-code'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: QrImage(
                data: widget.user.uid,
                size: 200.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.user.uid,
                  style: TextStyle(color: Colors.grey[600])),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'This is your unique code, use this to get added as employee!',
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
