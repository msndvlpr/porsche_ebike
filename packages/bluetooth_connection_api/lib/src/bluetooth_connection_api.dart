import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../mock_ble_data_generator.dart';
import 'model/ble_bike_data.dart';


class BluetoothConnectionApi {


  bool _scanning = false;

  void startScanning() => _scanning = true;
  void stopScanning() => _scanning = false;

  Stream<List<ScanResult>> getBluetoothDevicesStream() async* {

    List<Guid> withServices = const [];
    final mockScanResults = getMockScanResults();
    // Emit mock data immediately
    if (mockScanResults.isNotEmpty) {
      yield mockScanResults;
    }

    // Wait for Bluetooth to be ON
    await FlutterBluePlus.adapterState.where((state) => state == BluetoothAdapterState.on).first;

    // Start scanning
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 2), withServices: withServices);

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


  Stream<BleBikeData> getBikeReadingsDataStreamOverBle({required String bleDeviceAddress}) async* {

    /// Simulate connection to the USB port
    /// todo: connectToBleDeviceByAddress(bleDeviceAddress)

    final id = stringToFixedDigitInt(bleDeviceAddress);
    final stream = getBleMockBikeDataReadings(bikeId: id);

    BleBikeData? previous;

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

  bool _bikeDataReadingEqual(BleBikeData a, BleBikeData b) {
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

}

