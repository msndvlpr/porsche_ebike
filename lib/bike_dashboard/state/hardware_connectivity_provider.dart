import 'dart:async';
import 'package:bluetooth_connection_api/bluetooth_connection_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hardware_connectivity_repository/hardware_connectivity_repository.dart';
import 'package:usb_connection_api/usb_connection_api.dart';
import 'network_metadata_provider.dart';


final hardwareConnectivityProvider = Provider<HardwareConnectivityRepository>((ref) {

  final usbConApi = UsbConnectionApi();
  final bleConApi = BluetoothConnectionApi();
  return HardwareConnectivityRepository(usbConApi, bleConApi);
});

final selectedDeviceProvider  = StateProvider<String?>((ref) => null);
final connectedDeviceProvider = StateProvider<String?>((ref) => null);



final devicesProvider = StateNotifierProvider<DevicesNotifier, AsyncValue<List<FoundDevice>>>((ref) {
  final repo = ref.watch(hardwareConnectivityProvider);
  return DevicesNotifier(repo);
});

class DevicesNotifier extends StateNotifier<AsyncValue<List<FoundDevice>>> {
  final HardwareConnectivityRepository _repo;
  StreamSubscription<List<FoundDevice>>? _foundDevicesSubscription;

  bool get isScanning => _foundDevicesSubscription != null;

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
    if (_foundDevicesSubscription != null) return;

    _repo.startScanning(); // unified start
    state = const AsyncLoading();

    _foundDevicesSubscription = _repo.getCombinedDiscoveredDevicesStream().listen((devices) => state = AsyncData(devices),
      onError: (e, st) => state = AsyncError(e, st),
    );
  }

  void stopScanning() {
    _repo.stopScanning(); // unified stop
    _foundDevicesSubscription?.cancel();
    _foundDevicesSubscription = null;
    final currentList = state.value ?? [];
    state = AsyncData(currentList);
  }

  @override
  void dispose() {
    _foundDevicesSubscription?.cancel();
    super.dispose();
  }

  void _listenToStream() {
    _repo.getCombinedDiscoveredDevicesStream().listen(
          (devices) => state = AsyncData(devices),
      onError: (e, st) => state = AsyncError(e, st),
    );
  }
}


final bikeReadingProvider = StateNotifierProvider<BikeReadingNotifier, AsyncValue<BikeReading?>>((ref) {
    final repo = ref.watch(hardwareConnectivityProvider);
    return BikeReadingNotifier(ref, repo);
  }
);

class BikeReadingNotifier extends StateNotifier<AsyncValue<BikeReading?>> {

  final Ref ref;
  final HardwareConnectivityRepository repository;
  StreamSubscription<BikeReading>? _bikeReadingSubscription;
  String? _lastConnectedDevice;

  bool get isStreaming => _bikeReadingSubscription != null;

  BikeReadingNotifier(this.ref, this.repository) : super(const AsyncValue.data(null));

  void connectDeviceAndStartListening(String id) {
    state = const AsyncValue.loading();
    _bikeReadingSubscription?.cancel();
    _bikeReadingSubscription = repository.getBikeReadingsStreamOverUsb(portAddress: id).listen((reading) {
      state = AsyncValue.data(reading);

      final connectedDevice = ref.read(connectedDeviceProvider);
      final bikeTypeName = reading.bikeModel.name;

      if (connectedDevice != null && connectedDevice != _lastConnectedDevice) {
        /// Fetch the bikes additional assets and information from backend
        ref.read(bikeMetadataProvider.notifier).fetchBikeAssets(connectedDevice, bikeTypeName);

        /// Trigger the analytics endpoint for bike connected event
        final timeStamp = DateTime.now().millisecondsSinceEpoch;
        ref.read(bikeMetadataProvider.notifier).triggerBikeConnectedEvent(timeStamp.toString(), reading.bikeId.toString(), bikeTypeName);

        _lastConnectedDevice = connectedDevice;
      }
    }, onError: (err, stack) {
          state = AsyncValue.error(err, stack);
        });
  }

  void stopBikeReadingListening() {
    _bikeReadingSubscription?.cancel();
    _bikeReadingSubscription = null;
  }

  @override
  void dispose() {
    _bikeReadingSubscription?.cancel();
    super.dispose();
  }
}
