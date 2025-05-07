import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothConApi {

  /// Start scanning for nearby Bluetooth devices.
  Future<void> startScan({Duration timeout = const Duration(seconds: 4)}) async {
    await FlutterBluePlus.startScan(timeout: timeout);
  }

  /// Stop ongoing Bluetooth scan.
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  /// Stream of scan results (listens to found devices).
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  /// Connect to a Bluetooth device.
  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect(autoConnect: false);
  }

  /// Disconnect from a Bluetooth device.
  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    await device.disconnect();
  }

  /// Discover services of a connected Bluetooth device.
  Future<List<BluetoothService>> discoverServices(BluetoothDevice device) async {
    return await device.discoverServices();
  }

  /// Get a list of previously connected (bonded) devices.
  Future<List<BluetoothDevice>> getBondedDevices() async {
    final devices = await FlutterBluePlus.connectedDevices;
    for (var d in devices) {
      print(d);
    }
    return devices;
  }

  /// Check whether Bluetooth is turned on.
  Future<bool> get isBluetoothOn => FlutterBluePlus.isOn;

  /// Connect to a device for real time data stream
  Future<void> connectAndListen(BluetoothDevice device) async {
    // 1. Connect to the device
    await device.connect(autoConnect: false);
    print('Connected to ${device.name}');

    // 2. Discover services
    List<BluetoothService> services = await device.discoverServices();

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        // 3. Check for notify property
        if (characteristic.properties.notify) {
          // 4. Subscribe to notifications
          await characteristic.setNotifyValue(true);
          characteristic.onValueReceived.listen((value) {
            // Handle incoming data here
            print('Received: $value'); // value is List<int>
            final decoded = String.fromCharCodes(value);
            print('Decoded: $decoded');
          });
        }
      }
    }
  }

  /// Get list of discovered devices
  getDevices() {
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        final displayName = r.advertisementData.localName.isNotEmpty
            ? r.advertisementData.localName
            : (r.device.name.isNotEmpty ? r.device.name : r.device.id.id); // fallback to MAC
        print('Found device: $displayName');
      }
    });

  }


}
