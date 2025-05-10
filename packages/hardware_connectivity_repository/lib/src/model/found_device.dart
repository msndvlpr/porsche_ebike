part 'device_type.dart';

class FoundDevice{

  final DeviceType? connectionType;
  final String? deviceName;
  /// ID for USB device is Port Address and for BLE device is MAC Address/UUID
  final String? deviceId;


  FoundDevice({
    this.connectionType,
    this.deviceName,
    this.deviceId
  });
}
