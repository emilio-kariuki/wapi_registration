// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wapi/screens/connect.dart';
import 'package:wapi/screens/entry.dart';

class Home extends StatefulWidget {
  final bool start;
  const Home({Key? key, this.start = true}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> isSelected = [true, false];
  bool status = false;

  late StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = [];
  late bool isDiscovering;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (FlutterBluetoothSerial.instance == BluetoothBondState.bonded) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }
  void _close() {
    setState(() {
        isDiscovering = false;
      });
  }

  void _restartDiscovery() async {
    await FlutterBluetoothSerial.instance.cancelDiscovery();
    setState(() {
      results.clear();
      isDiscovering = true;
    });
    _startDiscovery();
  }

  void _startDiscovery() async {
    await FlutterBluetoothSerial.instance.cancelDiscovery();
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        results.add(r);
      });
    });
    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
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
                  border: Border.all(width: 1, color: const Color.fromARGB(255, 8, 5, 14)),
                    color: const Color.fromARGB(255, 189, 189, 189),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const[
                        SizedBox(width: 10),
                         Action(action: "Fetch",color: Colors.black),
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
                              border: Border.all(width: 2, color: Colors.black)
                            ),
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
                              action: () {
                                Get.to(MainPage());
                              }),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          const Action(action: "Bluetooth",color: Colors.black),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Action(action: "The devices connected are: ",color: Colors.black),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 116, 13, 13)),
                    ),
                  ),
                )
              : Button(
                width: 0.4,
                  size: size,
                  actionString: "Connect",
                  action: _restartDiscovery),

              Button(
                width: 0.4,
                  size: size,
                  actionString: "Close",
                  action: _close),
            ],
          ),
          SizedBox(
            height: size.height * 0.008,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (BuildContext context, index) {
              BluetoothDiscoveryResult result = results[index];
              return BluetoothDeviceListEntry(
                device: result.device,
                rssi: result.rssi,
                onTap: () {
                  Navigator.of(context).pop(result.device);
                },
              );
            },
          ),
        ],
      ),
    )));
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
    required this.action, required this.color,
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
