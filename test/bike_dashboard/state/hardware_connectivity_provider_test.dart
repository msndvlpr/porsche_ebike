import 'dart:async';
import 'package:bluetooth_connection_api/bluetooth_connection_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hardware_connectivity_repository/hardware_connectivity_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_api/network_api_service.dart';
import 'package:porsche_ebike_code_challenge/bike_dashboard/state/hardware_connectivity_provider.dart';
import 'package:usb_connection_api/usb_connection_api.dart';



class MockUsbConnectionApi extends Mock implements UsbConnectionApi {}

class MockBluetoothConnectionApi extends Mock implements BluetoothConnectionApi {}

class MockHardwareConnectivityRepository extends Mock implements HardwareConnectivityRepository {}

class MockBikeMetadataNotifier extends Mock implements AsyncNotifier<BikeAssetData?> {}


void main() {

  group('HardwareConnectionProvider', () {

    late MockHardwareConnectivityRepository mockRepo;
    late ProviderContainer container;
    const testPort = 'COM1';
    BikeReading? fakeReading;
    late List<FoundDevice> fakeDevices;

    setUp(() {
      fakeReading = BikeReading(
        bikeId: 1,
        bikeModel: BikeModel.cliffHanger, motorRpm: 95, batteryCharge: 65, odoMeterKm: '1200', lastError: 'err',
      );
      mockRepo = MockHardwareConnectivityRepository();
      container = ProviderContainer(overrides: [
        hardwareConnectivityProvider.overrideWithValue(mockRepo),
        connectedDeviceProvider.overrideWith((ref) => testPort),
      ]);
      fakeDevices = [
        FoundDevice(connectionType: DeviceType.usb,
          deviceName: "test device",
          deviceId: "21554")
      ];

      when(() => mockRepo.getCombinedDiscoveredDevicesStream())
          .thenAnswer((_) => Stream.value(fakeDevices));

      when(() => mockRepo.startScanning()).thenReturn(null);
      when(() => mockRepo.stopScanning()).thenReturn(null);

    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is AsyncData with null', () {
      expect(container.read(bikeReadingProvider), AsyncData<BikeReading?>(null));
      expect(container.read(bikeReadingProvider.notifier).isStreaming, isFalse);
    });

    test('stopBikeReadingListening cancels the subscription', () async {
      final streamController = StreamController<BikeReading>();
      when(() => mockRepo.getBikeReadingsStreamOverUsb(portAddress: testPort))
          .thenAnswer((_) => streamController.stream);

      final notifier = container.read(bikeReadingProvider.notifier);
      notifier.connectDeviceAndStartListening(testPort);
      expect(notifier.isStreaming, isTrue);

      notifier.stopBikeReadingListening();
      expect(notifier.isStreaming, isFalse);

      await streamController.close();
    });

    test('onError in bike readings stream updates state to AsyncError', () async {
      final streamController = StreamController<BikeReading>();
      final testError = Exception('Bike reading error');
      final testStackTrace = StackTrace.current;
      when(() => mockRepo.getBikeReadingsStreamOverUsb(portAddress: testPort))
          .thenAnswer((_) => streamController.stream);

      container.read(bikeReadingProvider.notifier).connectDeviceAndStartListening(testPort);
      streamController.addError(testError, testStackTrace);
      await Future.delayed(Duration.zero);

      expect(container.read(bikeReadingProvider).hasError, isTrue);
      expect(container.read(bikeReadingProvider).error, testError);
      expect(container.read(bikeReadingProvider).stackTrace, testStackTrace);

      await streamController.close();
    });

    test('connectDeviceAndStartListening updates state with reading', () async {
      when(() => mockRepo.getBikeReadingsStreamOverUsb(portAddress: 'USB1'))
          .thenAnswer((_) => Stream.value(fakeReading!));

      final notifier = container.read(bikeReadingProvider.notifier);
      notifier.connectDeviceAndStartListening('USB1');

      await Future.delayed(Duration.zero);

      expect(notifier.debugState, AsyncValue.data(fakeReading));
    });

  });
}