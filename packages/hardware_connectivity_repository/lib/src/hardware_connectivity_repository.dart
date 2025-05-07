import 'package:bluetooth_con_api/bluetooth_con_api_service.dart';
import 'package:usb_con_api/usb_con_api_service.dart';

import 'model/found_device.dart';

class HardwareConnectivityRepository {
  final UsbConApi _usbConApi;
  //todo
  // final BluetoothConApi _bluetoothConApi;

  HardwareConnectivityRepository(this._usbConApi /*, this._bluetoothConApi*/);

  /// Get list of found USB devices via polling
  Future<List<UsbPort>> getDiscoveredUsbDevices() async {
    return _usbConApi.getUsbDevicesList();
  }

  /// Get list of found USB devices via stream
  Stream<List<FoundDevice>> getDiscoveredDevicesStream() {
    return _usbConApi.getUsbDevicesListStream().map((usbPorts) {
      return usbPorts.map((usbPort) {
        return FoundDevice(
          deviceType: DeviceType.usb,
          deviceName: usbPort.productName ?? usbPort.description ?? 'Unknown Device',
          deviceId: usbPort.serialNumber ?? usbPort.productId ?? usbPort.name,
          connected: false
        );
      }).toList();
    });
  }

  /// Start scanning USB devices (toggles internal scanning flag)
  void startUsbScanning() {
    _usbConApi.startScanning();
  }

  /// Stop scanning USB devices
  void stopUsbScanning() {
    _usbConApi.stopScanning();
  }

}
