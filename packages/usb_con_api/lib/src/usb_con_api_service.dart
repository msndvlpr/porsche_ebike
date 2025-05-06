import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import '../usb_con_api_service.dart';

class UsbConApi {

  final Duration _interval = Duration(seconds: 2);


  Future<List<UsbPort>> getUsbDevicesList() async{
    List<UsbPort> output = [];
    final availablePortAddresses = SerialPort.availablePorts;

    for (final address in availablePortAddresses){
      final port = SerialPort(address);
      output.add(UsbPort(
          description: port.description,
          transport: port.transport.toTransport(),
          busNumber: port.busNumber?.toPadded(),
          deviceNumber: port.deviceNumber?.toPadded(),
          vendorId: port.vendorId?.toHex(),
          productId: port.productId?.toHex(),
          manufacturer: port.manufacturer,
          productName: port.productName,
          serialNumber: port.serialNumber,
          macAddress: port.macAddress ));
    }

    return output;

  }

  Stream<List<UsbPort>> watchUsbDevices() {
    return Stream.periodic(_interval).asyncMap((_) => getUsbDevicesList());
  }

}

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}
