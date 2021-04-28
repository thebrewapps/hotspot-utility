import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hotspotutility/src/screens/wifi_available_ssid_screen.dart';
import 'package:http/http.dart' as http;

class HotspotScreen extends StatefulWidget {
  const HotspotScreen({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  _HotspotScreenState createState() => _HotspotScreenState();
}

class _HotspotScreenState extends State<HotspotScreen> {
  BluetoothCharacteristic wifiServicesChar;
  BluetoothCharacteristic wifiConfiguredServicesChar;
  BluetoothCharacteristic wifiSsidChar;
  BluetoothCharacteristic wifiConnectChar;
  BluetoothCharacteristic wifiRemoveChar;
  BluetoothCharacteristic ethernetOnlineChar;
  BluetoothCharacteristic hotspotFirmwareChar;
  BluetoothCharacteristic hotspotSerialChar;
  BluetoothCharacteristic publicKeyChar;

  bool wifiSsidBuilt = false;
  bool foundChars = true;
  String wifiSsidResult = 'None';
  String publicKeyResult = 'None';

  StreamController<String> hotspotNameStreamController =
      StreamController<String>();
  StreamController<String> wifiSsidStreamController =
      StreamController<String>();
  StreamController<bool> charReadStatusStreamController =
      StreamController<bool>.broadcast();
  StreamController<String> ethernetStatusStreamController =
      StreamController<String>();
  StreamController<String> hotspotFirmwareStreamController =
      StreamController<String>();
  StreamController<String> hotspotSerialStreamController =
      StreamController<String>();

  @override
  void dispose() {
    super.dispose();
    hotspotNameStreamController.close();
    wifiSsidStreamController.close();
    charReadStatusStreamController.close();
    ethernetStatusStreamController.close();
    hotspotFirmwareStreamController.close();
    hotspotSerialStreamController.close();
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    hotspotNameStreamController.add('');
    wifiSsidStreamController.add('');
    charReadStatusStreamController.add(false);
    ethernetStatusStreamController.add('');
    hotspotFirmwareStreamController.add('');
    hotspotSerialStreamController.add('');
    widget.device.state.listen((connectionState) {
      if (connectionState == BluetoothDeviceState.connected) {
        widget.device.discoverServices().then((services) {
          _findChars(services);
          // public key
          publicKeyChar.read().then((value) {
            publicKeyResult = new String.fromCharCodes(value);
            // hotspot info http
            http
                .get(Uri.parse("https://api.helium.io/v1/hotspots/" + publicKeyResult))
                .then((value) {
              var parsed = json.decode(value.body);
              hotspotNameStreamController.add(parsed['data']['name']);
            }).catchError((e) {
              print("Helium API Error");
            });
            // current wifi ssid
            wifiSsidChar.read().then((value) {
              wifiSsidResult = new String.fromCharCodes(value);
              // add result to stream
              wifiSsidStreamController.add(wifiSsidResult);
              // ethernet status
              ethernetOnlineChar.read().then((value) {
                var ethernetStatusResult = new String.fromCharCodes(value);
                // add result to stream
                if (ethernetStatusResult == 'true') {
                  ethernetStatusStreamController.add('Connected');
                } else {
                  ethernetStatusStreamController.add('Disconnected');
                }
                // hotspot firmware version
                hotspotFirmwareChar.read().then((value) {
                  // add result to stream
                  hotspotFirmwareStreamController
                      .add(new String.fromCharCodes(value));
                  // hotspot serial number
                  hotspotSerialChar.read().then((value) {
                    // indicate last char read is done
                    charReadStatusStreamController.add(true);
                    // add result to stream
                    hotspotSerialStreamController
                        .add(new String.fromCharCodes(value));
                  });
                });
              });
            });
          });
        });
      }
    });
  }

  void _findChars(List<BluetoothService> services) {
    if (services != null) {
      var hotspotService = services.singleWhere(
          (s) => s.uuid.toString() == "0fda92b2-44a2-4af2-84f5-fa682baa2b8d",
          orElse: () => null);
      var deviceInformationService = services.singleWhere(
          (s) => s.uuid.toString() == "0000180a-0000-1000-8000-00805f9b34fb",
          orElse: () => null);
      if (hotspotService != null) {
        wifiSsidChar = hotspotService.characteristics.singleWhere(
            (c) => c.uuid.toString() == "7731de63-bc6a-4100-8ab1-89b2356b038b",
            orElse: () => null);
        wifiServicesChar = hotspotService.characteristics.singleWhere(
            (c) => c.uuid.toString() == "d7515033-7e7b-45be-803f-c8737b171a29",
            orElse: () => null);
        wifiConfiguredServicesChar = hotspotService.characteristics.singleWhere(
            (c) => c.uuid.toString() == "e125bda4-6fb8-11ea-bc55-0242ac130003",
            orElse: () => null);
        wifiConnectChar = hotspotService.characteristics.singleWhere(
            (c) => c.uuid.toString() == "398168aa-0111-4ec0-b1fa-171671270608",
            orElse: () => null);
        wifiRemoveChar = hotspotService.characteristics.singleWhere(
            (c) => c.uuid.toString() == "8cc6e0b3-98c5-40cc-b1d8-692940e6994b",
            orElse: () => null);
        ethernetOnlineChar = hotspotService.characteristics.singleWhere(
            (c) => c.uuid.toString() == "e5866bd6-0288-4476-98ca-ef7da6b4d289",
            orElse: () => null);
        hotspotFirmwareChar = deviceInformationService.characteristics
            .singleWhere(
                (c) =>
                    c.uuid.toString() == "00002a26-0000-1000-8000-00805f9b34fb",
                orElse: () => null);
        hotspotSerialChar = deviceInformationService.characteristics
            .singleWhere(
                (c) =>
                    c.uuid.toString() == "00002a25-0000-1000-8000-00805f9b34fb",
                orElse: () => null);
        publicKeyChar = hotspotService.characteristics.singleWhere(
            (c) => c.uuid.toString() == "0a852c59-50d3-4492-bfd3-22fe58a24f01",
            orElse: () => null);
      }
    } else {
      print("Erro: Services is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotspot Settings',
            style: TextStyle(
                fontFamily: 'Nexa',
                fontWeight: FontWeight.bold,
                fontSize: 24.0)),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: (widget.device != null) ? widget.device.state : null,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) => ListTile(
                title: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/information-button.png'),
                      width: 20.0,
                      height: 20.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: (snapshot.data == BluetoothDeviceState.connected)
                          ? Text(
                              "Ready for WiFi Setup. Click ‘WiFi Setup’ when it loads in the app below",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.black87),
                            )
                          : Text(
                              'Disconnected from Hotspot Bluetooth',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.black87),
                            ),
                    ),
                  ],
                ),
                trailing: StreamBuilder<bool>(
                    stream: charReadStatusStreamController.stream,
                    initialData: false,
                    builder: (c, snapshot) {
                      if (snapshot.data == false) {
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.grey),
                        );
                      } else {
                        return Icon(null);
                      }
                    })),
          ),
          StreamBuilder<String>(
              stream: wifiSsidStreamController.stream,
              initialData: 'None',
              builder: (c, snapshot) {
                return Column(children: <Widget>[
                  ListTile(
                    title: Text('WiFi Network'),
                    subtitle: Text(snapshot.data),
                    trailing: StreamBuilder<bool>(
                        stream: charReadStatusStreamController.stream,
                        initialData: false,
                        builder: (c, snapshot) {
                          if (snapshot.data == true) {
                            return FlatButton(
                              child: Text(
                                'Wifi Setup',
                                style: TextStyle(
                                    fontFamily: 'Nexa',
                                    fontWeight: FontWeight.bold),
                              ),
                              highlightColor: Color(int.parse('0xff23abf7')),
                              color: Color(int.parse('0xff0F265A')),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return WifiAvailableScreen(
                                      currentWifiSsid: wifiSsidResult,
                                      device: widget.device ?? null,
                                      wifiServicesChar: wifiServicesChar,
                                      wifiConfiguredServicesChar:
                                          wifiConfiguredServicesChar,
                                      wifiSsidChar: wifiSsidChar,
                                      wifiConnectChar: wifiConnectChar,
                                      wifiRemoveChar: wifiRemoveChar);
                                }));
                              },
                            );
                          } else {
                            return Icon(null);
                          }
                        }),
                  )
                ]);
              }),
          StreamBuilder<String>(
              stream: ethernetStatusStreamController.stream,
              initialData: '',
              builder: (c, snapshot) {
                return Column(children: <Widget>[
                  ListTile(
                    title: Text('Ethernet'),
                    subtitle: Text(snapshot.data),
                  )
                ]);
              }),
          StreamBuilder<String>(
              stream: hotspotFirmwareStreamController.stream,
              initialData: '',
              builder: (c, snapshot) {
                return Column(children: <Widget>[
                  ListTile(
                    title: Text('Firmware Version'),
                    subtitle: Text(snapshot.data),
                  )
                ]);
              }),
          StreamBuilder<String>(
              stream: hotspotSerialStreamController.stream,
              initialData: '',
              builder: (c, snapshot) {
                return Column(children: <Widget>[
                  ListTile(
                    title: Text('Serial Number'),
                    subtitle: Text(snapshot.data),
                  )
                ]);
              }),
        ]),
      ),
    );
  }
}
