
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FoundBleDevice {
  final String id;
  final String name;
  final int rssi;
  final BluetoothDevice device;

  FoundBleDevice({
    required this.id,
    required this.name,
    required this.rssi,
    required this.device,
  });

  factory FoundBleDevice.fromScanResult(ScanResult result) {
    final advertisedName = result.advertisementData.localName;
    final deviceName = result.device.name;
    return FoundBleDevice(
      id: result.device.id.id,
      name: advertisedName.isNotEmpty
          ? advertisedName
          : (deviceName.isNotEmpty ? deviceName : result.device.id.id),
      rssi: result.rssi,
      device: result.device,
    );
  }
}
