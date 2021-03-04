import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hotspotutility/gen/hotspotutility.pb.dart' as protos;
import 'package:hotspotutility/src/screens/wifi_connect_screen.dart';

class WifiAvailableScreen extends StatefulWidget {
  const WifiAvailableScreen(
      {Key key,
      this.currentWifiSsid,
      this.device,
      this.wifiServicesChar,
      this.wifiConfiguredServicesChar,
      this.wifiSsidChar,
      this.wifiConnectChar,
      this.wifiRemoveChar})
      : super(key: key);
  final String currentWifiSsid;
  final BluetoothDevice device;
  final BluetoothCharacteristic wifiServicesChar;
  final BluetoothCharacteristic wifiConfiguredServicesChar;
  final BluetoothCharacteristic wifiSsidChar;
  final BluetoothCharacteristic wifiConnectChar;
  final BluetoothCharacteristic wifiRemoveChar;

  _WifiAvailableScreenState createState() => _WifiAvailableScreenState();
}

class _WifiAvailableScreenState extends State<WifiAvailableScreen> {
  StreamController<List<String>> wifiSsidListStreamController =
      StreamController<List<String>>();

  List<String> configuredSsidResults;

  @override
  void dispose() {
    super.dispose();
    wifiSsidListStreamController.close();
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
  //  wifiSsidListStreamController
  //      .add(['Wifi NetWork', 'Wifi NetWork', 'Wifi NetWork', 'Wifi NetWork']);
    wifiSsidListStreamController
        .add([]);

    widget.wifiConfiguredServicesChar.read().then((value) {
      configuredSsidResults =
          protos.wifi_services_v1.fromBuffer(value).services.toList();

      widget.wifiServicesChar.read().then((value) {
        if (new String.fromCharCodes(value) != "failed") {
          var availableSsidResults =
              protos.wifi_services_v1.fromBuffer(value).services;
          wifiSsidListStreamController.add(availableSsidResults);
        }
      });
    }).catchError((e) {
      print("Error: wifiConfiguredServices Failure: ${e.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Available WiFi Networks",
              style: TextStyle(
                  fontFamily: 'Nexa',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0)),
          actions: <Widget>[],
        ),
        body: ListView(
          children: [
            SizedBox(height: 16.0,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                        'assets/images/information-button.png'),
                    width: 20.0,
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'Select your WiFi Network',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  )
                ],
              ),
            ),
            SizedBox(height: 16.0,),
            mainWidget()
          ],
        ));
  }

  Widget mainWidget() {
    return SingleChildScrollView(
        child: StreamBuilder<List<String>>(
            stream: wifiSsidListStreamController.stream,
            initialData: [],
            builder: (c, snapshot) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Stack(
                      children: [
                        ListTile(
                            title: Text(snapshot.data[index].toString()),
                      leading: snapshot.data[index].toString() ==
                              widget.currentWifiSsid
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24.0,
                                    semanticLabel: 'Connected to Network',
                                  )
                                : Icon(
                                    Icons.wifi_lock,
                                    color: Colors.grey,
                                    size: 24.0,
                                    semanticLabel: 'Available Network',
                                  ),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return WifiConnectScreen(
                                    currentWifiSsid: widget.currentWifiSsid,
                                    device: widget.device,
                                    wifiNetworkSelected:
                                        snapshot.data[index].toString(),
                                    wifiSsidChar: widget.wifiSsidChar,
                                    wifiConfiguredServices:
                                        configuredSsidResults,
                                    wifiConnectChar: widget.wifiConnectChar,
                                    wifiRemoveChar: widget.wifiRemoveChar);
                              }));
                            }),
                        snapshot.data[index].toString() ==
                              widget.currentWifiSsid
                            ? Container(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Connected to',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  );
                },
              );
            }));
  }
}
