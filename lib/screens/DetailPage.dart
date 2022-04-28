// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'dart:typed_data';

import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:photo_view/photo_view.dart';

class DetailPage extends StatefulWidget {
  final BluetoothDevice server;

  const DetailPage({required this.server});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late BluetoothConnection connection;
  bool isConnecting = true;

  bool get isConnected => connection.isConnected;
  bool isDisconnecting = false;

  List<List<int>> chunks = <List<int>>[];
  int contentLength = 0;
  late Uint8List _bytes;

  late RestartableTimer _timer;

  @override
  void initState() {
    super.initState();
    _getBTConnection();
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null as BluetoothConnection;
    }
    _timer.cancel();
    super.dispose();
  }

  void _onDataReceived(Uint8List data) {
    if (data != null && data.length > 0) {
      chunks.add(data);
      contentLength += data.length;
      _timer.reset();
    }

    print("Data Length: ${data.length}, chunks: ${chunks.length}");
  }

  _getBTConnection() {
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      connection = _connection;
      isConnecting = false;
      isDisconnecting = false;
      setState(() {});
      connection.input?.listen(_onDataReceived).onDone(() {
        isConnecting
            ? Text('Connecting to ${widget.server.name} ...')
            : isConnected
                ? Text('Connected with ${widget.server.name}')
                : Text('Disconnected with ${widget.server.name}');
        if (isDisconnecting) {
          print('Disconnecting locally');
        } else {
          print('Disconnecting remotely');
        }
        if (mounted) {
          setState(() {});
        }
        Navigator.of(context).pop();
      });
    }).catchError((error) {
      Navigator.of(context).pop();
    });
  }

  void _sendMessage(String text) async {
    text = text.trim();
    if (text.isNotEmpty) {
      try {
        // connection.output.add(utf8.encode(text));
        // SVProgressHUD.show("Requesting...");
        await connection.output.allSent;
      } catch (e) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}
