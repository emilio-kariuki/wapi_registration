// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import "package:flutter/material.dart";

// class Connect{
//   _getBTConnection() {
//     late BluetoothConnection connection;
//   bool isConnecting = true;

//   bool get isConnected = connection.isConnected;
//   bool isDisconnecting = false;

//   late String _selectedFrameSize;

//   List<List<int>> chunks = <List<int>>[];
//   int contentLength = 0;
//   late Uint8List _bytes;

//   late RestartableTimer _timer;
//     BluetoothConnection.toAddress(widget.server.address).then((_connection) {
//       connection = _connection;
//       isConnecting = false;
//       isDisconnecting = false;
//       setState(() {});
//       connection.input?.listen(_onDataReceived).onDone(() {
//         isConnecting
//             ? Text('Connecting to ${widget.server.name} ...')
//             : isConnected
//                 ? Text('Connected with ${widget.server.name}')
//                 : Text('Disconnected with ${widget.server.name}');
//         if (isDisconnecting) {
//           print('Disconnecting locally');
//         } else {
//           print('Disconnecting remotely');
//         }
//         if (mounted) {
//           setState(() {});
//         }
//         Navigator.of(context).pop();
//       });
//     }).catchError((error) {
//       Navigator.of(context).pop();
//     });
//   }

//   void _sendMessage(String text) async {
//     text = text.trim();
//     if (text.isNotEmpty) {
//       try {
//         // connection.output.add(utf8.encode(text));
//         // SVProgressHUD.show("Requesting...");
//         await connection.output.allSent;
//       } catch (e) {
//         setState(() {});
//       }
//     }
//   }

// }