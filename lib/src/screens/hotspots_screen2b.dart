import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hotspotutility/src/screens/hotspot_screen.dart';
import 'package:hotspotutility/src/screens/wifi_available_ssid_screen.dart';
import 'package:hotspotutility/src/screens/wifi_connect_screen.dart';
import 'package:hotspotutility/src/widgets/bluetooth_device_widgets.dart';

import 'package:flutter_blue/gen/flutterblue.pb.dart' as proto;

final List<Guid> scanFilterServiceUuids = [
  Guid('0fda92b2-44a2-4af2-84f5-fa682baa2b8d')
];

enum DeviceBtType { LE, CLASSIC, DUAL, UNKNOWN }
BluetoothDevice createBluetoothDevice(
    String deviceName, String deviceIdentifier, DeviceBtType deviceType) {
  proto.BluetoothDevice p = proto.BluetoothDevice.create();
  p.name = deviceName;
  p.remoteId = deviceIdentifier;

  if (deviceType == DeviceBtType.LE) {
    p.type = proto.BluetoothDevice_Type.LE;
  } else if (deviceType == DeviceBtType.CLASSIC) {
    p.type = proto.BluetoothDevice_Type.CLASSIC;
  } else if (deviceType == DeviceBtType.DUAL) {
    p.type = proto.BluetoothDevice_Type.DUAL;
  } else {
    p.type = proto.BluetoothDevice_Type.UNKNOWN;
  }
  return BluetoothDevice.fromProto(p);
}

class HotspotsScreen2b extends StatelessWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          return FindDevicesScreen();
        });
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);
  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString().substring(15)}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({Key key}) : super(key: key);

  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  StreamController<bool> showTipCardStreamController = StreamController<bool>();
  bool scanned = false;

  @override
  void dispose() {
    super.dispose();
    showTipCardStreamController.close();
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    showTipCardStreamController.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find CoastFi Hotspot',
          style: TextStyle(
              fontFamily: 'Nexa', fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBlue.instance.startScan(
            timeout: Duration(seconds: 3),
            withServices: scanFilterServiceUuids),
        child: Stack(
          alignment: const Alignment(0.0, 1.0),
          children: [mainWidget(), findButtonWidget()],
        ),
      ),
    );
  }

  Widget mainWidget() {
    return Container(
      color: Colors.white,
      height: double.maxFinite,
      child: showTipCardWidget(),
    );
  }

  Widget showTipCardWidget() {
    return StreamBuilder<bool>(
        stream: showTipCardStreamController.stream,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data == true) {
            return ListView(
              children: [
                SizedBox(
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.all(20),
                    elevation: 5.0,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
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
                                    'Instructions',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 16.0),
                            

                            Text(
                              "1. Turn Bluetooth on in your phone/device settings and then return to the CoastFi App\n\n2. Press and hold the black button on the left side of the CoastFi Hotspot (near the power adapter port) for 2 seconds\n\n3. Wait 10 seconds\n\n4. Press the ‘Find Hotspot’ button in the app below to find the CoastFi Hotspot\n\n5. Once CoastFi Hotspot is found, press ‘Connect’",
                              // "1. Turn Bluetooth on in your phone/device settings and then return to the CoastFi App\n\n2. Press and hold the black button on the left side of the CoastFi Hotspot (near the power adapter port) for 2 seconds\n\n3. Wait 10 seconds\n\n4. Press the ‘Find Hotspot’ button in the app below to find the CoastFi Hotspot\n\n5. Once CoastFi Hotspot is found, press ‘Connect’1. Turn Bluetooth on in your phone/device settings and then return to the CoastFi App\n\n2. Press and hold the black button on the left side of the CoastFi Hotspot (near the power adapter port) for 2 seconds\n\n3. Wait 10 seconds\n\n4. Press the ‘Find Hotspot’ button in the app below to find the CoastFi Hotspot\n\n5. Once CoastFi Hotspot is found, press ‘Connect’",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20.0),
                              textAlign: TextAlign.left,
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded(child: Container()),
                SizedBox(
                              height: 60.0,
                            )
              ],
            );
          } else {
            return scanResultWidget();
          }
        });
  }

  Widget scanResultWidget() {
    return StreamBuilder<List<ScanResult>>(
      stream: FlutterBlue.instance.scanResults,
      initialData: [],
      builder: (c, snapshot) {
        // for (var i = 0; i < 20; i++)
          // snapshot.data.add(ScanResult(
          //     device: createBluetoothDevice(
          //         'deviceName', 'deviceIdentifier', DeviceBtType.LE),
          //     rssi: 123,
          //     advertisementData: AdvertisementData(
          //         localName: 'CoastFi Hotspot 6476',
          //         connectable: true,
          //         txPowerLevel: 123,
          //         serviceUuids: [
          //           "123",
          //           "345",
          //           "123",
          //           "345",
          //           "123",
          //           "345",
          //           "123",
          //           "345",
          //           "123",
          //           "345",
          //           "123",
          //           "345",
          //           "123",
          //           "345"
          //         ]))
          //     );

        if (snapshot.data.isEmpty == true && scanned) {
          return Container(
            child: noResult(),
          );
        } else {
          return Container(
            margin: EdgeInsets.only(top: 8.0),
            child: Stack(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 25.0),
                    child: resultsWidget(snapshot.data)),
                Container(
                  height: 25.0,
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image:
                            AssetImage('assets/images/information-button.png'),
                        width: 20.0,
                        height: 20.0,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Container(
                        child: Text(
                          "Press 'Connect' button",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget noResult() {
    return ListView(
      children: [
        Card(
          color: Colors.white,
          margin: EdgeInsets.all(20),
          elevation: 5.0,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
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
                          'No Hotspot Found',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0
                  ),
                  // Text(
                  //             "Just plugged in Hotspot? Wait 60 seconds for it to turn on. Press ‘Find Hotspot’",
                  //             // "",
                              
                  //             style: TextStyle(
                  //                 color: Colors.black87,
                  //                 fontWeight: FontWeight.normal,
                  //                 fontSize: 20.0),
                  //             textAlign: TextAlign.left,
                  //           ),
                  // SizedBox(
                  //   height: 16.0
                  // ),
                            
                  Text(
                    // "1. Turn Bluetooth on in your phone/device settings and then return to the CoastFi App\n\n2. Press and hold the black button on the left side of the CoastFi Hotspot (near the power adapter port) for 2 seconds\n\n3. Wait 10 seconds\n\n4. Press the ‘Find Hotspot’ button in the app below to find the CoastFi Hotspot\n\n5. Once CoastFi Hotspot is found, press ‘Connect’\n\nIf you have re-attempted the steps above and are still unable to ‘Find Hotspot’ in the CoastFi App you must reset the phone/device that you are using the CoastFi App on.\n\nReset your phone/device. Turn Bluetooth on in your phone/device settings once it powers on. Re-open the CoastFi App.\n\nNow reset the CoastFi Hotspot by removing the power supply, waiting 15 seconds, and then re-inserting the power supply. Then try again.\n\nStill unable to pair with the CoastFi Hotspot? Send an email to help@coastfi.com, call or text 888-262-7881",
                    // "1. Turn Bluetooth on in your phone/device settings and then return to the CoastFi App\n\n2. Press and hold the black button on the side of the CoastFi Hotspot (near the power adapter port) for 2 seconds\n\n3. Wait 10 seconds\n\n4. Press the ‘Find Hotspot’ button in the app below to find the CoastFi Hotspot\n\n5. Once CoastFi Hotspot is found, press ‘Connect’",
                    "1. Turn Bluetooth on in your phone/device settings and then return to the CoastFi App\n\n2. Press and hold the black button on the side of the CoastFi Hotspot (near the power adapter port) for 2 seconds\n\n3. Wait 10 seconds\n\n4. Press the ‘Find Hotspot’ button in the app below to find the CoastFi Hotspot\n\n5. Once CoastFi Hotspot is found, press ‘Connect’\n\nIf you have re-attempted the steps above and are still unable to ‘Find Hotspot’ in the CoastFi App you must reset the phone/device that you are using the CoastFi App on.\n\nReset your phone/device. Turn Bluetooth on in your phone/device settings once it powers on. Re-open the CoastFi App.\n\nNow reset the CoastFi Hotspot by removing the adapter, waiting 15 seconds, and then re-inserting the adapter. Then try again.\n\nStill unable to pair with the CoastFi Hotspot? Send an email to help@coastfi.com, call or text 888-262-7881",


                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                        color: Colors.black87),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60.0,
        )
      ],
    );
  }

  Widget resultsWidget(List<ScanResult> data) {
    return ListView(
      children: data
          .map(
            (r) => ScanResultTile(
              result: r,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                r.device.state.listen((connectionState) {
                  print("connectionState Hotspots Screen: " +
                      connectionState.toString());
                  if (connectionState == BluetoothDeviceState.disconnected) {
                    r.device.connect();
                  }
                }, onDone: () {
                  print("Connection State Check Complete");
                }, onError: (error) {
                  print("Connection Error: " + error);
                });
                print('object');
                return HotspotScreen(device: r.device);
              })),
            ),
          )
          .toList(),
    );
  }

//  var scanResult = ScanResult(
//      device: createBluetoothDevice('deviceName', 'deviceIdentifier', DeviceBtType.LE),
//      rssi: 123,
//      advertisementData: AdvertisementData(
//          localName: 'CoastFi Hotspot 6476',
//          connectable: true,
//          txPowerLevel: 123,
//          serviceUuids: [
//            "123",
//            "345",
//            "123",
//            "345",
//            "123",
//            "345",
//            "123",
//            "345",
//            "123",
//            "345",
//            "123",
//            "345",
//            "123",
//            "345"
//          ]));

//  Widget sampleWidget() {
//    return ScanResultTile(
//      result: ScanResult(
//         //  device: BluetoothDevice(
//         //      id: DeviceIdentifier("test"),
//         //      name: "Coast",
//         //      type: BluetoothDeviceType.classic),
//         device: createBluetoothDevice('deviceName', 'deviceIdentifier', DeviceBtType.LE),
//          rssi: 123,
//          advertisementData: AdvertisementData(
//              localName: 'CoastFi Hotspot 6476',
//              connectable: true,
//              txPowerLevel: 123,
//              serviceUuids: [
//                "123",
//                "345",
//                "123",
//                "345",
//                "123",
//                "345",
//                "123",
//                "345",
//                "123",
//                "345",
//                "123",
//                "345",
//                "123",
//                "345"
//              ])),
//      onTap: () {
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => WifiAvailableScreen()));
//      },
//    );
//  }

  Widget connectWifiSample() {
    return Container(
      child: Center(
        child: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WifiConnectScreen(
                          wifiNetworkSelected: "Wifi A0909",
                        )));
          },
          child: Text('Go to Connect Wifi'),
        ),
      ),
    );
  }

  Widget findButtonWidget() {
    return Container(
      height: 100.0,
      color: Colors.transparent,
      child: Center(
        child: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => FlutterBlue.instance.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FlatButton(
                highlightColor: Color(int.parse('0xff23abf7')),
                color: Color(int.parse('0xff0F265A')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Find Hotspot",
                    style: TextStyle(
                        fontFamily: 'Nexa',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                ),
                onPressed: () {
                  showTipCardStreamController.add(false);
                  scanned = true;
                  FlutterBlue.instance.startScan(
                      timeout: Duration(seconds: 3),
                      withServices: scanFilterServiceUuids);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
