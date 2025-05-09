import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../mock_ble_data_generator.dart';


class BluetoothConnectionApi {


  bool _scanning = false;

  void startScanning() => _scanning = true;
  void stopScanning() => _scanning = false;

  Stream<List<ScanResult>> getBluetoothDeviceStream() async* {

    List<Guid> withServices = const [];
    final mockScanResults = getMockScanResults();
    // Emit mock data immediately
    if (mockScanResults.isNotEmpty) {
      yield mockScanResults;
    }

    // Wait for Bluetooth to be ON
    await FlutterBluePlus.adapterState.where((state) => state == BluetoothAdapterState.on).first;

    // Start scanning
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 4), withServices: withServices);

    final controller = StreamController<List<ScanResult>>();
    final discoveredDevices = [...mockScanResults]; // Start with mock results

    final subscription = FlutterBluePlus.onScanResults.listen((results) {
        for (final result in results) {
          final alreadyAdded = discoveredDevices.any((d) => d.device.remoteId == result.device.remoteId);
          if (!alreadyAdded) {
            discoveredDevices.add(result);
          }
        }
        controller.add(List.of(discoveredDevices));
      },
      onError: controller.addError,
      onDone: controller.close,
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);
    yield* controller.stream;
  }




}

