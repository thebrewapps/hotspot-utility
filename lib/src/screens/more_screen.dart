import 'package:flutter/material.dart';
import 'package:hotspotutility/src/screens/software_license_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[],
        ),
        body: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(title: Text('Version'), trailing: Text("0.1.0")),
            ListTile(
              title: Text('Software License'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SoftwareLicenseScreen()));
              },
            ),
          ]).toList(),
        ));
  }
}
