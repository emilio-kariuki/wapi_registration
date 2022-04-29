// ignore_for_file: avoid_print

import "package:flutter/material.dart";

import "package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart";

class Discovery extends StatefulWidget {
  Discovery({Key? key}) : super(key: key);

  @override
  State<Discovery> createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  FlutterBluetoothSerial serial = FlutterBluetoothSerial.instance;
  BluetoothState state = BluetoothState.UNKNOWN;
  BluetoothConnection? connecction;
  BluetoothDevice? devices;

  @override
  @override
  void initState() {
    super.initState();
    serial.state.then((state) {
      setState(() {
        state = state;
        print("The state of the bluetooth connection is : $state");
      });
    });
    
      serial.startDiscovery().listen((r) {
        print("The devices are: ${r}");
      });

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
