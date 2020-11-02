import 'package:flutter/material.dart';
import 'package:hotspotutility/src/screens/software_license_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('More', style: TextStyle(
              fontFamily: 'Nexa',
              fontWeight: FontWeight.bold,
              fontSize: 24.0
          ),),
        ),
        body: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(title: Text('Version'), trailing: Text("1.0.1")),
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
