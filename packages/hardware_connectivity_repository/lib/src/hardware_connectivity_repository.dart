import 'package:bluetooth_connection_api/bluetooth_connection_api.dart';
import 'package:hardware_connectivity_repository/src/model/bike_reading.dart';
import 'package:usb_connection_api/usb_connection_api.dart';
import 'model/found_device.dart';
import 'package:rxdart/rxdart.dart';


class HardwareConnectivityRepository {

  final UsbConnectionApi _usbConnectionApi;
  final BluetoothConnectionApi _bluetoothConnectionApi;

  HardwareConnectivityRepository(this._usbConnectionApi, this._bluetoothConnectionApi);

  /*-------------------------------USB----------------------------------------*/

  /// Get list of found USB devices via stream
  Stream<List<FoundDevice>> getDiscoveredDevicesStreamUsb() {
    return _usbConnectionApi.getUsbDevicesListStream().map((usbPorts) {
      return usbPorts.map((usbPort) {
        return FoundDevice(
          connectionType: DeviceType.usb,
          deviceName: usbPort.productName ?? usbPort.description ?? 'Unknown Device',
          deviceId: usbPort.name, // device unique port address
          connected: false
        );
      }).toList();
    });
  }

  /// Start scanning USB devices (toggles internal scanning flag)
  void startUsbScanning() {
    _usbConnectionApi.startScanning();
  }

  /// Stop scanning USB devices
  void stopUsbScanning() {
    _usbConnectionApi.stopScanning();
  }

  /// Get data readings from a USB device via stream
  Stream<BikeReading> getBikeReadingsStreamOverUsb({required String portAddress}) {
    return _usbConnectionApi.getBikeReadingsDataStream(usbPortAddress: portAddress).map((bikeData) {
      return BikeReading(
        bikeId: bikeData.bikeId,
        bikeType: _mapBikeTypeToModel(bikeData.bikeType),
        motorRpm: bikeData.motorRpm,
        batteryCharge: bikeData.batteryCharge,
        odoMeterKm: (bikeData.odoMeter / 1000).toStringAsFixed(3),
        lastError: bikeData.lastError,
        lastTheftAlert: bikeData.lastTheftAlert != null ?
        DateTime.fromMillisecondsSinceEpoch(bikeData.lastTheftAlert! * 1000,
          isUtc: true,
        )
            : null,
        gyroscope: bikeData.gyroscope,
        totalAirtime: bikeData.totalAirtime,
      );
    });
  }

  BikeModel _mapBikeTypeToModel(BikeType type) {
    switch (type) {
      case BikeType.cliffHanger:
        return BikeModel.cliffHanger;
      case BikeType.metroBee:
        return BikeModel.metroBee;
      }
  }

  /*-------------------------------BLE----------------------------------------*/

  /// Get a stream of discovered BLE devices
  Stream<List<FoundDevice>> getDiscoveredDevicesStreamBle() {
    final stream = _bluetoothConnectionApi.getBluetoothDeviceStream();

    return stream.map((scanResults) {
      return scanResults
          .where((scanResult) => scanResult.device.platformName.isNotEmpty)
          .map((scanResult) {
        return FoundDevice(
          connectionType: DeviceType.ble,
          deviceName: scanResult.device.platformName,
          deviceId: scanResult.device.remoteId.str,
          connected: false,
        );
      }).toList();
    });
  }

  /// Start scanning for BLE devices.
  void startBleScanning() {
    _bluetoothConnectionApi.startScanning();
  }

  /// Stop scanning for BLE devices.
  void stopBleScanning() {
    _bluetoothConnectionApi.stopScanning();
  }

  /*-------------------------------COMBINED-----------------------------------*/

  /// Combined stream of USB + BLE discovered devices
  Stream<List<FoundDevice>> getCombinedDiscoveredDevicesStream() {
    return Rx.combineLatest2<List<FoundDevice>, List<FoundDevice>, List<FoundDevice>>(
      getDiscoveredDevicesStreamUsb(),
      getDiscoveredDevicesStreamBle(),
          (usbList, bleList) {
        final all = [...usbList];
        for (final ble in bleList) {
          if (!all.any((d) => d.deviceId == ble.deviceId)) {
            all.add(ble);
          }
        }
        return all;
      },
    );
  }

  void startScanning() {
    startUsbScanning();
    startBleScanning();
  }

  void stopScanning() {
    stopUsbScanning();
    stopBleScanning();
  }

}
