part 'device_type.dart';

class FoundDevice{

  final DeviceType? deviceType;
  final String? deviceName;
  final String? deviceId;
  final bool? connected;


  FoundDevice({
    this.deviceType,
    this.deviceName,
    this.deviceId,
    this.connected
  });
}
