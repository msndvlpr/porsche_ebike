import 'package:bluetooth_connection_api/bluetooth_connection_api.dart';
import 'package:hardware_connectivity_repository/src/model/bike_reading.dart';
import 'package:intl/intl.dart';
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
          deviceId: usbPort.name // device unique port address
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

  /// Get real time data readings from a USB device via stream
  Stream<BikeReading> getBikeReadingsStreamOverUsb({required String portAddress}) {
    return _usbConnectionApi.getBikeReadingsDataStream(usbPortAddress: portAddress).map((bikeData) {
      return BikeReading(
        bikeId: bikeData.bikeId,
        bikeModel: bikeData.bikeType.value == 'CliffHanger' ? BikeModel.cliffHanger : BikeModel.metroBee,
        motorRpm: bikeData.motorRpm,
        batteryCharge: bikeData.batteryCharge,
        odoMeterKm: (bikeData.odoMeter / 1000).toStringAsFixed(3),
        lastError: bikeData.lastError,
        lastTheftAlert: bikeData.lastTheftAlert != null ?
        DateFormat('yyyy.MM.dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(bikeData.lastTheftAlert! * 1000, isUtc: true)) : null,
        gyroscope: bikeData.gyroscope,
        totalAirtime: bikeData.totalAirtime,
      );
    });
  }

  /*-------------------------------BLE---------------------------------------*/

  /// Get real time data readings from a BLE device via stream
  Stream<BikeReading> getBikeReadingsStreamOverBle({required String address}) {
    return _bluetoothConnectionApi.getBikeReadingsDataStreamOverBle(bleDeviceAddress: address).map((bikeData) {
      return BikeReading(
        bikeId: bikeData.bikeId,
        bikeModel: bikeData.bikeType.value == 'CliffHanger' ? BikeModel.cliffHanger : BikeModel.metroBee,
        motorRpm: bikeData.motorRpm,
        batteryCharge: bikeData.batteryCharge,
        odoMeterKm: (bikeData.odoMeter / 1000).toStringAsFixed(3),
        lastError: bikeData.lastError,
        lastTheftAlert: bikeData.lastTheftAlert != null ?
        DateFormat('yyyy.MM.dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(bikeData.lastTheftAlert! * 1000, isUtc: true)) : null,
        gyroscope: bikeData.gyroscope,
        totalAirtime: bikeData.totalAirtime,
      );
    });
  }

  /// Get a stream of discovered BLE devices
  Stream<List<FoundDevice>> getDiscoveredDevicesStreamBle() {
    final stream = _bluetoothConnectionApi.getBluetoothDevicesStream();

    return stream.map((scanResults) {
      return scanResults
          .where((scanResult) => scanResult.device.platformName.isNotEmpty)
          .map((scanResult) {
        return FoundDevice(
          connectionType: DeviceType.ble,
          deviceName: scanResult.device.platformName,
          deviceId: scanResult.device.remoteId.str
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

  /// Combined stream of USB + BLE data readings
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
