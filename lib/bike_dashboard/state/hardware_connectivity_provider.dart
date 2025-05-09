import 'dart:async';
import 'package:bluetooth_connection_api/bluetooth_connection_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hardware_connectivity_repository/hardware_connectivity_repository.dart';
import 'package:usb_connection_api/usb_connection_api.dart';


final hardwareConnectivityProvider = Provider<HardwareConnectivityRepository>((ref) {

  final usbConApi = UsbConnectionApi();
  final bleConApi = BluetoothConnectionApi();
  return HardwareConnectivityRepository(usbConApi, bleConApi);
});

final selectedDeviceProvider = StateProvider<String?>((ref) => null);

/*-------------------------------COMBINED------------------------------------*/

final devicesProvider = StateNotifierProvider<DevicesNotifier, AsyncValue<List<FoundDevice>>>((ref) {
  final repo = ref.watch(hardwareConnectivityProvider);
  return DevicesNotifier(repo);
});

class DevicesNotifier extends StateNotifier<AsyncValue<List<FoundDevice>>> {
  final HardwareConnectivityRepository _repo;
  StreamSubscription<List<FoundDevice>>? _subscription;

  bool get isScanning => _subscription != null;

  DevicesNotifier(this._repo) : super(const AsyncData([])) {
    _listenToStream();
  }

  void toggleScanning() {
    if (isScanning) {
      stopScanning();
    } else {
      startScanning();
    }
  }

  void startScanning() {
    if (_subscription != null) return;

    _repo.startScanning(); // unified start
    state = const AsyncLoading();

    _subscription = _repo.getCombinedDiscoveredDevicesStream().listen((devices) => state = AsyncData(devices),
      onError: (e, st) => state = AsyncError(e, st),
    );
  }

  void stopScanning() {
    _repo.stopScanning(); // unified stop
    _subscription?.cancel();
    _subscription = null;
    final currentList = state.value ?? [];
    state = AsyncData(currentList);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _listenToStream() {
    _repo.getCombinedDiscoveredDevicesStream().listen(
          (devices) => state = AsyncData(devices),
      onError: (e, st) => state = AsyncError(e, st),
    );
  }
}

/*-------------------------------DATA----------------------------------------*/

final bikeReadingProvider = StateNotifierProvider<BikeReadingNotifier, AsyncValue<BikeReading?>>((ref) {
  final repository = ref.read(hardwareConnectivityProvider);
  return BikeReadingNotifier(repository);
});

class BikeReadingNotifier extends StateNotifier<AsyncValue<BikeReading?>> {
  final HardwareConnectivityRepository repository;
  StreamSubscription<BikeReading>? _subscription;

  BikeReadingNotifier(this.repository) : super(const AsyncValue.data(null));

  void startBikeReadingListening(String id) {
    state = const AsyncValue.loading();
    _subscription?.cancel();
    _subscription = repository.getBikeReadingsStreamOverUsb(portAddress: id).listen((reading) {
        state = AsyncValue.data(reading);
      },
      onError: (err, stack) {
        state = AsyncValue.error(err, stack);
      },
    );
  }

  void stopBikeReadingListening() {
    _subscription?.cancel();
    _subscription = null;
    state = const AsyncValue.data(null);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
