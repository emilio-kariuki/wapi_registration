// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wapi/screens/entry.dart';

import 'DetailPage.dart';

class Home extends StatefulWidget {
  final bool start;
  const Home({Key? key, this.start = true}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  List<BluetoothDevice> devices = <BluetoothDevice>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _getBTState();
    _stateChangeListener();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      //resume
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      }
    }
  }

  _getBTState() {
    FlutterBluetoothSerial.instance.state.then((state) {
      _bluetoothState = state;
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      }
      setState(() {});
    });
  }

  _stateChangeListener() {
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      _bluetoothState = state;
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      } else {
        devices.clear();
      }
      print("State isEnabled: ${state.isEnabled}");
      setState(() {});
    });
  }

  _listBondedDevices() {
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      devices = bondedDevices;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "wapi",
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                Text(
                  "Registration",
                  style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: size.height * 0.17,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: const Color.fromARGB(255, 8, 5, 14)),
                    color: const Color.fromARGB(255, 189, 189, 189),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(width: 10),
                        Action(action: "Fetch", color: Colors.black),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage("assets/globe.jpg"),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Button(
                              width: 0.55,
                              size: size,
                              actionString: "Fetch",
                              action: () {}),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          const Action(action: "Bluetooth", color: Colors.black),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(20)),
              child: SwitchListTile(
                activeColor: const Color.fromARGB(255, 22, 95, 3),
                title: Text('Enable Bluetooth',
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
                value: _bluetoothState.isEnabled,
                onChanged: (bool value) {
                  // Do the request and update with the true value then
                  future() async {
                    // async lambda seems to not working
                    if (value) {
                      await FlutterBluetoothSerial.instance.requestEnable();
                    } else {
                      await FlutterBluetoothSerial.instance.requestDisable();
                    }
                  }

                  future().then((_) {
                    setState(() {});
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: const Text('Bluetooth status'),
            subtitle: Text(_bluetoothState.toString()),
            trailing: RaisedButton(
              child: const Text('Settings'),
              onPressed: () {
                FlutterBluetoothSerial.instance.openSettings();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Action(
                  action: "The devices connected are: ", color: Colors.black),
            ],
          ),
          SizedBox(
            height: size.height * 0.008,
          ),
          ListView(
              shrinkWrap: true,
              children: devices
                  .map((_device) => BluetoothDeviceListEntry(
                        device: _device,
                        enabled: true,
                        // rssi: _device.RSSI,
                        onTap: () {
                          _startCameraConnect(context, _device);
                        },
                      ))
                  .toList()),
        ],
      ),
    )));
  }
  void _startCameraConnect(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return DetailPage(server: server);
    }));
  }
}

class Button extends StatelessWidget {
  final Function() action;
  final String actionString;
  final double width;
  const Button({
    Key? key,
    required this.size,
    required this.action,
    required this.actionString,
    required this.width,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: SizedBox(
        height: size.height * 0.06,
        width: size.width * width,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 14, 14, 20)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(
                  color: Color.fromARGB(255, 14, 14, 20),
                  width: 2.0,
                ),
              ),
            ),
          ),
          child: Text(actionString, style: GoogleFonts.roboto(fontSize: 20)),
          onPressed: action,
        ),
      ),
    );
  }
}

class Action extends StatelessWidget {
  final String action;
  final Color color;
  const Action({
    Key? key,
    required this.action,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(children: [
        Text(
          action,
          style: GoogleFonts.roboto(
              fontSize: 20, fontWeight: FontWeight.w500, color: color),
        ),
      ]),
    );
  }
  
}
