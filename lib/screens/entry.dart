import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import "package:flutter_blue/flutter_blue.dart";

class BluetoothDeviceListEntry extends ListTile {
  BluetoothDeviceListEntry({
    Key? key,
    required BluetoothDevice device,
    // required rssi,
    required GestureTapCallback onTap,
    bool enabled = true,
  }) : super(
          key: key,
          onTap: onTap,
          enabled: enabled,
          leading: const Icon(Icons.devices),
          // @TODO . !BluetoothClass! class aware icon
          title: Text(device.name ?? "Unknown device"),
          subtitle: Text(device.address.toString()),
        );

  static TextStyle _computeTextStyle(int rssi) {
    /**/ if (rssi >= -35) {
      return TextStyle(color: Colors.greenAccent[700]);
    } else if (rssi >= -45) {
      return TextStyle(
          color: Color.lerp(
              Colors.greenAccent[700], Colors.lightGreen, -(rssi + 35) / 10));
    } else if (rssi >= -55) {
      return TextStyle(
          color: Color.lerp(
              Colors.lightGreen, Colors.lime[600], -(rssi + 45) / 10));
    } else if (rssi >= -65) {
      return TextStyle(
          color: Color.lerp(Colors.lime[600], Colors.amber, -(rssi + 55) / 10));
    } else if (rssi >= -75) {
      return TextStyle(
          color: Color.lerp(
              Colors.amber, Colors.deepOrangeAccent, -(rssi + 65) / 10));
    } else if (rssi >= -85) {
      return TextStyle(
          color: Color.lerp(
              Colors.deepOrangeAccent, Colors.redAccent, -(rssi + 75) / 10));
    } else {
      return const TextStyle(color: Colors.redAccent);
    }
  }
}
