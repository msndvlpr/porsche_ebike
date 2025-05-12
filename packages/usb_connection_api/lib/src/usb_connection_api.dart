import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import '../usb_connection_api.dart';
import 'mock_usb_data_generator.dart';


class UsbConnectionApi {
  final Stream<UsbBikeData> Function({required int bikeId}) getBikeDataReadings;

  UsbConnectionApi({Stream<UsbBikeData> Function({required int bikeId})? getBikeDataReadings})
      : getBikeDataReadings = getBikeDataReadings ?? getMockBikeDataReadings;

  bool _scanning = false;
  void startScanning() => _scanning = true;
  void stopScanning() => _scanning = false;

  Future<List<UsbPort>> getUsbDevicesList() async {
    List<UsbPort> output = [];
    final availablePortAddresses = SerialPort.availablePorts;

    for (final address in availablePortAddresses) {
      final port = SerialPort(address);
      output.add(UsbPort(
          description: port.description,
          name: port.name,
          transport: port.transport.toTransport(),
          busNumber: port.busNumber?.toPadded(),
          deviceNumber: port.deviceNumber?.toPadded(),
          vendorId: port.vendorId?.toHex(),
          productId: port.productId?.toHex(),
          manufacturer: port.manufacturer,
          productName: port.productName,
          serialNumber: port.serialNumber,
          macAddress: port.macAddress));
    }

    return output;
  }

  bool _usbPortsEqual(List<UsbPort> a, List<UsbPort> b) {
    return a.length == b.length &&
        a.every((port) => b.any((other) => port.name == other.name));
  }

  bool _bikeDataReadingEqual(UsbBikeData a, UsbBikeData b) {
    return a.bikeId == b.bikeId &&
        a.motorRpm == b.motorRpm &&
        a.batteryCharge == b.batteryCharge &&
        a.odoMeter == b.odoMeter &&
        a.lastError == b.lastError &&
        a.lastTheftAlert == b.lastTheftAlert &&
        _listEquals(a.gyroscope, b.gyroscope) &&
        a.totalAirtime == b.totalAirtime;
  }

  bool _listEquals(List<String>? a, List<String>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }


  Stream<List<UsbPort>> getUsbDevicesListStream({Duration interval = const Duration(seconds: 2)}) async* {
    List<UsbPort> previous = [];

    while (_scanning) {
      final availablePortAddresses = SerialPort.availablePorts;
      List<UsbPort> current = [];

      await Future.delayed(interval);

      for (final address in availablePortAddresses) {
        final port = SerialPort(address);
        try {
          current.add(UsbPort(
            description: port.description,
            name: port.name,
            transport: port.transport.toTransport(),
            busNumber: port.busNumber?.toPadded(),
            deviceNumber: port.deviceNumber?.toPadded(),
            vendorId: port.vendorId?.toHex(),
            productId: port.productId?.toHex(),
            manufacturer: port.manufacturer,
            productName: port.productName,
            serialNumber: port.serialNumber,
            macAddress: port.macAddress,
          ));
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      /// Add mock USB devices
      current.addAll(getMockUsbPorts());

      /// Only emit if the list has changed
      if (current.length != previous.length || !_usbPortsEqual(current, previous)) {
        yield current;
        previous = current;
      }

    }
  }

  Stream<UsbBikeData> getBikeReadingsDataStream({required String usbPortAddress}) async* {

    /// Simulate connection to the USB port
    /// todo: connectToUsbDeviceByAddress(usbPortAddress);

    final id = stringToFixedDigitInt(usbPortAddress);
    final stream = getBikeDataReadings(bikeId: id);

    UsbBikeData? previous;

    await for (final current in stream) {
      if (previous == null || !_bikeDataReadingEqual(previous, current)) {
        yield current;
        previous = current;
      }
    }
  }

  int stringToFixedDigitInt(String input, {int digits = 6}) {
    final int hash = input.hashCode & 0x7FFFFFFF;
    final int max = pow(6, digits).toInt();
    return hash % max;
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