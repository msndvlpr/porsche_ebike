import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import '../usb_con_api_service.dart';
import 'mock_can_bus_data_provider.dart';

class UsbConApi {

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

  bool _listsAreEqual(List<UsbPort> a, List<UsbPort> b) {
    return a.length == b.length &&
        a.every((port) => b.any((other) => port.name == other.name));
  }

  Stream<List<UsbPort>> getUsbDevicesListStream({Duration interval = const Duration(seconds: 3)}) async* {
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
          print(e);
        }
      }

      // Add mock USB devices
      current.addAll(getMockUsbPorts());

      // Only emit if the list has changed
      if (current.length != previous.length || !_listsAreEqual(current, previous)) {
        yield current;
        previous = current;
      }

    }
  }

  List<UsbPort> getMockUsbPorts() {
    return [
      UsbPort(
        description: 'E-Bike Controller USB Interface',
        name: '/dev/cu.usbserial-ebike001',
        transport: 'usb',
        busNumber: '001',
        deviceNumber: '005',
        vendorId: '0x2341',
        productId: '0x8036',
        manufacturer: 'Porsche E-bike',
        productName: 'eBike USB Comm Module',
        serialNumber: 'EBIKE-12345678',
        macAddress: null,
      ),
      UsbPort(
        description: 'eBike Diagnostic Interface',
        name: '/dev/cu.usbmodem-ebike002',
        transport: 'usb',
        busNumber: '001',
        deviceNumber: '006',
        vendorId: '0x1A86',
        productId: '0x7523',
        manufacturer: 'Porsche E-bike',
        productName: 'Diagnostic USB Port',
        serialNumber: 'DIAG-98765432',
        macAddress: null,
      ),
    ];
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

/////////////////////////

// Provider for the MockCanBus (or your real CAN bus interface)
final canBusProvider = Provider<MockCanBusDataProvider>((ref) { // Change to your actual implementation
  final bus = MockCanBus();
  ref.onDispose(bus.dispose);
  return bus;
});

// StateProvider to hold the current BikeData
final bikeDataProvider = StateProvider<BikeData>((ref) {
  return BikeData(); // Initialize with default values
});

// StreamProvider to get the transformed BikeData stream
final bikeDataStreamProvider = StreamProvider.autoDispose<BikeData>((ref) {
  final canBus = ref.watch(canBusProvider);
  // Combine the CAN message stream and the current BikeData.
  return canBus.canMessageStream.transform(
    StreamTransformer<CanMessage, BikeData>.fromBind((stream) {
      final controller = StreamController<BikeData>();
      BikeData currentData = ref.read(bikeDataProvider); //get initial value;

      stream.listen((message) {
        final newData = parseCanMessage(message, currentData);
        if (newData != null) {
          currentData = newData; // IMPORTANT: Update currentData!
          controller.add(newData);
          ref.read(bikeDataProvider.notifier).state = newData; //update the state
        }
      },
          onError: (error, stackTrace) {
            controller.addError(error, stackTrace);
          },
          onDone: () {
            controller.close();
          });
      return controller.stream;
    }),
  );
});
