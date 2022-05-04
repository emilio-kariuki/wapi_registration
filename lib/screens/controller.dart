import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  final BluetoothConnection connection;
  final BluetoothDevice device;
  BluetoothController(this.connection,this.device);

  final _obj = ''.obs;
  set obj(value) => this._obj.value = value;
  get obj => this._obj.value;
}
