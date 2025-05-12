import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hardware_connectivity_repository/hardware_connectivity_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_api/network_api_service.dart';
import 'package:porsche_ebike_code_challenge/bike_dashboard/state/hardware_connectivity_provider.dart';
import 'package:porsche_ebike_code_challenge/bike_dashboard/state/network_metadata_provider.dart';
import 'package:porsche_ebike_code_challenge/bike_dashboard/view/bike_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:porsche_ebike_code_challenge/bike_dashboard/view/bike_dashboard_screen.dart';

/*
class MockDevicesNotifier extends AutoDisposeAsyncNotifier<List<FoundDevice>> {
  @override
  Future<List<FoundDevice>> build() async {
    return [];
  }
}

class FakeDevicesNotifier extends StateNotifier<AsyncValue<List<FoundDevice>>> {
  FakeDevicesNotifier() : super(const AsyncData([]));
}


void main() {

  group('BikeDashboardScreen UI Tests', () {

    testWidgets('renders app bar title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => const AsyncData([])),
            selectedDeviceProvider.overrideWith((ref) => null),
            connectedDeviceProvider.overrideWith((ref) => null),
            bikeReadingProvider.overrideWith((ref) => const AsyncData(null)),
            bikeMetadataProvider.overrideWith((ref) => const AsyncData(null)),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        )
      );

      expect(find.text('Porsche eBike Performance Diagnostics Tool'), findsOneWidget);
    });

    testWidgets('shows loading indicators for all async data', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => const AsyncLoading()),
            selectedDeviceProvider.overrideWith((ref) => null),
            connectedDeviceProvider.overrideWith((ref) => null),
            bikeReadingProvider.overrideWith((ref) => const AsyncLoading()),
            bikeMetadataProvider.overrideWith((ref) => const AsyncLoading()),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('shows message when no USB devices found', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => const AsyncData([])),
            selectedDeviceProvider.overrideWith((ref) => null),
            connectedDeviceProvider.overrideWith((ref) => null),
            bikeReadingProvider.overrideWith((ref) => const AsyncData(null)),
            bikeMetadataProvider.overrideWith((ref) => const AsyncData(null)),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      expect(find.text('No devices available, please press Scan to start searching.'), findsOneWidget);
    });

    testWidgets('shows reading fallback when no data is received yet', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => const AsyncData([])),
            selectedDeviceProvider.overrideWith((ref) => null),
            connectedDeviceProvider.overrideWith((ref) => null),
            bikeReadingProvider.overrideWith((ref) => const AsyncData(null)),
            bikeMetadataProvider.overrideWith((ref) => const AsyncData(null)),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      expect(find.text('No data received yet'), findsOneWidget);
    });

    testWidgets('renders scan button and triggers snackbar', (WidgetTester tester) async {
      final container = ProviderContainer(overrides: [
        devicesProvider.overrideWith((ref) => const AsyncData([])),
        selectedDeviceProvider.overrideWith((ref) => null),
        connectedDeviceProvider.overrideWith((ref) => null),
        bikeReadingProvider.overrideWith((ref) => const AsyncData(null)),
        bikeMetadataProvider.overrideWith((ref) => const AsyncData(null)),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      expect(find.text('Scan'), findsOneWidget);
      await tester.tap(find.text('Scan'));
      await tester.pump(); // Allow snackbar to show
    });
  });
}*/


class MockDevicesNotifier extends Mock implements DevicesNotifier {}

class MockBikeReadingNotifier extends Mock implements BikeReadingNotifier {}

class MockBikeMetadataNotifier extends Mock implements AsyncNotifier<BikeAssetData?> {}

void main() {

  group('BikeDashboardScreen', () {

    testWidgets('renders title correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => MockDevicesNotifier()),
            selectedDeviceProvider.overrideWith((ref) => "selected-device-id"),
            connectedDeviceProvider.overrideWith((ref) => "connected-device-id"),
            bikeReadingProvider.overrideWith((ref) => MockBikeReadingNotifier()),
            //bikeMetadataProvider.overrideWith((ref) => MockBikeMetadataNotifier()),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      expect(find.text('Porsche eBike Performance Diagnostics Tool'), findsOneWidget);
    });
/*
    testWidgets('shows loading indicator when devicesProvider is loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => MockDevicesNotifier()..state = const AsyncLoading()),
            selectedDeviceProvider.overrideWithValue(null),
            connectedDeviceProvider.overrideWithValue(null),
            bikeReadingProvider.overrideWith((ref) => MockBikeReadingNotifier()),
            bikeMetadataProvider.overrideWith((ref) => MockBikeMetadataNotifier()),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows "No devices available" text when devicesProvider data is empty', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => MockDevicesNotifier()..state = const AsyncData([])),
            selectedDeviceProvider.overrideWithValue(null),
            connectedDeviceProvider.overrideWithValue(null),
            bikeReadingProvider.overrideWith((ref) => MockBikeReadingNotifier()),
            bikeMetadataProvider.overrideWith((ref) => MockBikeMetadataNotifier()),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      expect(find.text('No devices available, please press Scan to start searching.'), findsOneWidget);
    });

    testWidgets('renders discovered devices when data is available', (tester) async {
      final devices = [
        FoundDevice(deviceId: 'usb1', deviceName: 'USB Device 1', connectionType: null),
        FoundDevice(deviceId: 'ble1', deviceName: 'BLE Device 1', connectionType: null),
      ];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => MockDevicesNotifier()..state = AsyncData(devices)),
            selectedDeviceProvider.overrideWithValue(null),
            connectedDeviceProvider.overrideWithValue(null),
            bikeReadingProvider.overrideWith((ref) => MockBikeReadingNotifier()),
            bikeMetadataProvider.overrideWith((ref) => MockBikeMetadataNotifier()),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      expect(find.text('USB Device 1'), findsOneWidget);
      expect(find.text('BLE Device 1'), findsOneWidget);
    });

    testWidgets('taps on a device updates selectedDeviceProvider', (tester) async {
      final devices = [FoundDevice(deviceId: 'usb1', deviceName: 'USB Device 1', connectionType: null)];
      String? selectedDeviceId;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => MockDevicesNotifier()..state = AsyncData(devices)),
            selectedDeviceProvider.overrideWith((ref) {
              final provider = StateController<String?>(null);
              ref.onDispose(() => provider.dispose());
              return provider;
            }),
            connectedDeviceProvider.overrideWithValue(null),
            bikeReadingProvider.overrideWith((ref) => MockBikeReadingNotifier()),
            bikeMetadataProvider.overrideWith((ref) => MockBikeMetadataNotifier()),
          ],
          child: Consumer(builder: (context, ref, _) {
            selectedDeviceId = ref.watch(selectedDeviceProvider);
            return const MaterialApp(home: BikeDashboardScreen());
          }),
        ),
      );

      await tester.tap(find.byWidgetPredicate((widget) =>
      widget is ListTile && (widget.leading as Text).data == 'USB Device 1'));
      expect(selectedDeviceId, 'usb1');
    });

    testWidgets('calls toggleScanning on Scan button tap', (tester) async {
      final mockNotifier = MockDevicesNotifier();
      when(() => mockNotifier.toggleScanning()).thenReturn(null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => mockNotifier..state = const AsyncData([])),
            selectedDeviceProvider.overrideWithValue(null),
            connectedDeviceProvider.overrideWithValue(null),
            bikeReadingProvider.overrideWith((ref) => MockBikeReadingNotifier()),
            bikeMetadataProvider.overrideWith((ref) => MockBikeMetadataNotifier()),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Scan'));
      verify(() => mockNotifier.toggleScanning()).called(1);
    });

    testWidgets('shows loading indicator when bikeReadingProvider is loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => MockDevicesNotifier()..state = const AsyncData([])),
            selectedDeviceProvider.overrideWithValue('someId'),
            connectedDeviceProvider.overrideWithValue(null),
            bikeReadingProvider.overrideWith((ref) => MockBikeReadingNotifier()..state = const AsyncLoading()),
            bikeMetadataProvider.overrideWith((ref) => MockBikeMetadataNotifier()),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      expect(find.descendant(of: find.ancestor(of: find.text('Bike Readings'), matching: find.byType(Card)), matching: find.byType(CircularProgressIndicator)), findsOneWidget);
    });

    testWidgets('shows "No data received yet" when bikeReadingProvider data is null', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            devicesProvider.overrideWith((ref) => MockDevicesNotifier()..state = const AsyncData([])),
            selectedDeviceProvider.overrideWithValue('someId'),
            connectedDeviceProvider.overrideWithValue(null),
            bikeReadingProvider.overrideWith((ref) => MockBikeReadingNotifier()..state = const AsyncData(null)),
            bikeMetadataProvider.overrideWith((ref) => MockBikeMetadataNotifier()),
          ],
          child: const MaterialApp(home: BikeDashboardScreen()),
        ),
      );

      expect(find.text('No data received yet'), findsOneWidget);
    });*/

  });
}
