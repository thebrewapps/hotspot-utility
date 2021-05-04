import 'package:flutter/material.dart';
import 'package:hotspotutility/src/screens/software_license_screen.dart';
// import 'package:package_info/package_info.dart';
// import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key key}) : super(key: key);
  
  // Future<String> getVersionNumber() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   return packageInfo.version;
    
  //   // Other data you can get:
  //   //
  //   // 	String appName = packageInfo.appName;
  //   // 	String packageName = packageInfo.packageName;
  //   //	String buildNumber = packageInfo.buildNumber;
  // }
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
            // ListTile(title: Text('Version'), trailing: FutureBuilder(
            //   future: getVersionNumber(),
            //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>	Text(snapshot.hasData ? snapshot.data : "Loading ...",)
            //   // child: Text(version)
            // )),
            ListTile(title: Text('Version'), trailing: Text("2.0.7")), // TODO : ios is 0.0.1 v behind
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
