part of 'found_device.dart';

enum DeviceType {
  ble('BLE'),
  usb('USB');

  final String? value;
  const DeviceType(this.value);

}