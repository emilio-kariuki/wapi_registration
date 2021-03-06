// import 'dart:io';
// import 'dart:typed_data';

// import "package:flutter/material.dart";
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:wapi/screens/chat.dart';
// import 'package:wapi/screens/discovery.dart';
// import 'package:wapi/screens/entry.dart';
// import 'controller.dart';

// class Home extends StatelessWidget with WidgetsBindingObserver {
//   Home({Key? key}) : super(key: key);

//   FlutterBluetoothSerial serial = FlutterBluetoothSerial.instance;
//   BluetoothDevice? server;
//   BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
//   late BluetoothConnection connection;
//   List<BluetoothDevice> devices = <BluetoothDevice>[];
//   static List<int> list = 'Emilio'.codeUnits;
//   Uint8List bytes = Uint8List.fromList(list);
//   bool isConnecting = true;
//   bool isConnected = true;
//   bool isDisconnecting = false;
//   String _messageBuffer = '';
//   // final BluetoothController controller =
//   //     Get.put(BluetoothController(connection, devices));

//   get Fluttertoast => null;

//   @override
//   void initState() {
//     WidgetsBinding.instance?.addObserver(this);
//     _getBTState();
//     _stateChangeListener();
//   }

//   _getBTConnection(BluetoothDevice serverr) async {
//     print("The status of the connection: $isConnected");
//     print("The name of the server: ${serverr.name}");
//     await BluetoothConnection.toAddress(serverr.address).then((_connection) {
//       connection = _connection;
//       isConnecting = false;
//       isDisconnecting = false;

//       if (isConnecting) {
//         Fluttertoast.showToast(msg: "Connecting to ${server?.name}");
//         if (connection.isConnected) {
//           Fluttertoast.showToast(msg: "Connected to ${server?.name}");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Connection Lost");
//       }
//       if (isDisconnecting) {
//         print('Disconnecting locally');
//       } else {
//         print('Disconnecting remotely');
//       }
//     }).catchError((error) {
//       print("The error caught is : $error");
//     });
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance?.removeObserver(this);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state.index == 0) {
//       //resume
//       if (_bluetoothState.isEnabled) {
//         _listBondedDevices();
//       }
//     }
//   }

//   _getBTState() {
//     serial.state.then((state) {
//       _bluetoothState = state;
//       if (_bluetoothState.isEnabled) {
//         _listBondedDevices();
//       } else {
//         print("The connection is disabled");
//       }
//     });
//   }

//   _stateChangeListener() {
//     serial.onStateChanged().listen((BluetoothState state) {
//       _bluetoothState = state;
//       if (_bluetoothState.isEnabled) {
//         _listBondedDevices();
//       } else {
//         devices.clear();
//       }
//       print("State isEnabled: ${state.isEnabled}");
//     });
//   }

//   _listBondedDevices() {
//     serial.getBondedDevices().then((List<BluetoothDevice> bondedDevices) {
//       devices = bondedDevices;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         body: SingleChildScrollView(
//             child: SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 10, bottom: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "wapi",
//                       style: GoogleFonts.roboto(
//                           fontSize: 20,
//                           fontWeight: FontWeight.normal,
//                           color: const Color.fromARGB(255, 0, 0, 0)),
//                     ),
//                     Text(
//                       "Registration",
//                       style: GoogleFonts.roboto(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: const Color.fromARGB(255, 0, 0, 0)),
//                     ),
//                   ],
//                 ),
//               ),
//               const Action(
//                   fontSize: 25,
//                   action: "Fetch",
//                   color: Color.fromARGB(255, 0, 0, 0)),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                     height: size.height * 0.12,
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                             width: 1,
//                             color: const Color.fromARGB(255, 8, 5, 14)),
//                         color: const Color.fromARGB(255, 146, 146, 146),
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               const SizedBox(width: 15),
//                               Container(
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                         width: 2, color: Colors.black)),
//                                 child: const CircleAvatar(
//                                   radius: 30,
//                                   backgroundImage:
//                                       AssetImage("assets/globe.jpg"),
//                                 ),
//                               ),
//                               const SizedBox(width: 15),
//                               Button(
//                                   width: 0.55,
//                                   size: size,
//                                   actionString: "Fetch",
//                                   action: () {}),
//                             ],
//                           ),
//                         ),
//                       ],
//                     )),
//               ),
//               const Divider(
//                 thickness: 2,
//                 color: Color.fromARGB(255, 206, 206, 206),
//                 height: 5,
//               ),
//               const Action(
//                 action: "Bluetooth",
//                 color: Colors.black,
//                 fontSize: 20,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   padding: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 146, 146, 146),
//                       borderRadius: BorderRadius.circular(20)),
//                   child: SwitchListTile(
//                     activeColor: const Color.fromARGB(255, 7, 65, 52),
//                     title: Text('Enable Bluetooth',
//                         style: GoogleFonts.roboto(
//                             fontSize: 20,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500)),
//                     value: _bluetoothState.isEnabled,
//                     onChanged: (bool value) {
//                       // Do the request and update with the true value then
//                       future() async {
//                         // async lambda seems to not working
//                         if (value) {
//                           await FlutterBluetoothSerial.instance.requestEnable();
//                         } else {
//                           await FlutterBluetoothSerial.instance
//                               .requestDisable();
//                         }
//                       }

//                       future().then((_) {});
//                     },
//                   ),
//                 ),
//               ),
//               const Divider(
//                 thickness: 2,
//                 color: Color.fromARGB(255, 206, 206, 206),
//                 height: 5,
//               ),
//               ListTile(
//                 title: const Action(
//                   action: "Bluetooth Status ",
//                   color: Colors.black,
//                   fontSize: 20,
//                 ),
//                 subtitle: Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: Text(_bluetoothState.toString()),
//                 ),
//                 trailing: Button(
//                     width: 0.35,
//                     size: size,
//                     actionString: "Settings",
//                     action: () {
//                       FlutterBluetoothSerial.instance.openSettings();
//                     }),
//                 //
//               ),
//               const Divider(
//                 thickness: 2,
//                 color: Color.fromARGB(255, 206, 206, 206),
//                 height: 5,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Action(
//                     action: "The devices connected are: ",
//                     color: Colors.black,
//                     fontSize: 20,
//                   ),
//                 ],
//               ),
//               ListTile(
//                   title: TextButton(
//                       child: const Text(
//                           'Connected to paired device to chat with ESP32'),
//                       onPressed: () async {
//                         final BluetoothDevice selectedDevice =
//                             await Get.to(Discovery());

//                         if (selectedDevice != null) {
//                           print('Discovery -> selected ' +
//                               selectedDevice.address);
//                           server = selectedDevice;
//                           _startChat(context, selectedDevice);
//                         } else {
//                           print('Discovery -> no device selected');
//                         }
//                       })),
//               SizedBox(
//                 height: size.height * 0.008,
//               ),
//               ListView(
//                   shrinkWrap: true,
//                   children: devices
//                       .map((_device) => BluetoothDeviceListEntry(
//                             device: _device,
//                             enabled: true,
//                             // rssi: _device.RSSI,
//                             onTap: () {
//                               // _getBTConnection(_device);
//                               // _startCameraConnect(context, _device);
//                             },
//                           ))
//                       .toList()),
//               const Divider(
//                 thickness: 2,
//                 color: Color.fromARGB(255, 206, 206, 206),
//                 height: 5,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Button(
//                       width: 0.35,
//                       size: size,
//                       actionString: "Close",
//                       action: () {
//                         exit(0);
//                       }),
//                   Button(
//                       width: 0.35,
//                       size: size,
//                       actionString: "Sending",
//                       action: () {
//                         // send(bytes);
//                         Get.to(Discovery());
//                       }),
//                 ],
//               ),
//             ],
//           ),
//         )));
//   }

//   // void _startCameraConnect(BuildContext context, BluetoothDevice server) {
//   //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//   //     return DetailPage(server: server);
//   //   }));
//   // }
//   void _startChat(BuildContext context, BluetoothDevice server) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) {
//           return ChatPage(server: server);
//         },
//       ),
//     );
//   }
// }

// class Button extends StatelessWidget {
//   final Function() action;
//   final String actionString;
//   final double width;
//   const Button({
//     Key? key,
//     required this.size,
//     required this.action,
//     required this.actionString,
//     required this.width,
//   }) : super(key: key);

//   final Size size;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 15, bottom: 10),
//       child: SizedBox(
//         height: size.height * 0.06,
//         width: size.width * width,
//         child: ElevatedButton(
//           style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all(
//                 const Color.fromARGB(255, 14, 14, 20)),
//             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30.0),
//                 side: const BorderSide(
//                   color: Color.fromARGB(255, 14, 14, 20),
//                   width: 2.0,
//                 ),
//               ),
//             ),
//           ),
//           child: Text(actionString, style: GoogleFonts.roboto(fontSize: 20)),
//           onPressed: action,
//         ),
//       ),
//     );
//   }
// }

// class Action extends StatelessWidget {
//   final String action;
//   final Color color;
//   final double fontSize;
//   const Action({
//     Key? key,
//     required this.action,
//     required this.color,
//     required this.fontSize,
//   }) : super(key: key);

//   get GoogleFonts => null;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10, top: 10),
//       child: Row(children: [
//         Text(
//           action
//           // style: GoogleFonts.roboto(
//           //     fontSize: fontSize, fontWeight: FontWeight.w500, color: color),
//         ),
//       ]),
//     );
//   }
// }
