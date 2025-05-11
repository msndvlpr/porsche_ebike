import 'package:bluetooth_connection_api/bluetooth_connection_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hardware_connectivity_repository/hardware_connectivity_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:usb_connection_api/usb_connection_api.dart';


class MockUsbConnectionApi extends Mock implements UsbConnectionApi {
  @override
  void startScanning() => super.noSuchMethod(Invocation.method(#startScanning, []), returnValue: null);

  @override
  Stream<List<UsbPort>> getUsbDevicesListStream({Duration interval = const Duration(seconds: 2)}) =>
      super.noSuchMethod(
        Invocation.method(#getUsbDevicesListStream, [], {#interval: interval}),
        returnValue: Stream<List<UsbPort>>.value([]), // Provide a default stream
      );
}
class MockBluetoothConnectionApi extends Mock implements BluetoothConnectionApi {}

void main() {

  late MockUsbConnectionApi mockUsbApi;
  late MockBluetoothConnectionApi mockBleApi;
  late HardwareConnectivityRepository repository;

  final items =  [
    UsbPort(
      description: 'E-Bike Controller USB ',
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
      description: 'eBike Test',
      name: '/dev/cu.usbmodem-ebike002',
      transport: 'usb',
      busNumber: '001',
      deviceNumber: '006',
      vendorId: '0x1A86',
      productId: '0x7523',
      manufacturer: 'Porsche E-bike Pr',
      productName: 'Diagnostic USB Port',
      serialNumber: 'DIAG-98765432',
      macAddress: null,
    ),
  ];

  setUp(() {
    mockUsbApi = MockUsbConnectionApi();
    mockBleApi = MockBluetoothConnectionApi();
    repository = HardwareConnectivityRepository(mockUsbApi, mockBleApi);
    when(mockUsbApi.getUsbDevicesListStream()).thenAnswer((_) => Stream.value(items));
    mockUsbApi.startScanning();
  });

  test('returns mapped FoundDevice from USB ports', () async {

    final result = await repository.getDiscoveredDevicesStreamUsb().first;

    expect(result.length, 2);
    expect(result[0].deviceId, '/dev/cu.usbserial-ebike001');
    expect(result[0].deviceName, 'eBike USB Comm Module');
    expect(result[1].deviceName, 'Diagnostic USB Port');
  });

}