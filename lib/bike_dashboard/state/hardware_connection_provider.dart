import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hardware_connectivity_repository/hardware_connectivity_repository.dart';
import 'package:usb_con_api/usb_con_api_service.dart';


final usbDevicesProvider = StateNotifierProvider<UsbDevicesNotifier, AsyncValue<List<FoundDevice>>>((ref) {

    final repo = ref.watch(hardwareConnectivityRepoProvider);
    return UsbDevicesNotifier(repo);
  });

final hardwareConnectivityRepoProvider = Provider<HardwareConnectivityRepository>((ref) {

  final api = UsbConApi();
  return HardwareConnectivityRepository(api);
});

final selectedDeviceProvider = StateProvider<String?>((ref) => null);

class UsbDevicesNotifier extends StateNotifier<AsyncValue<List<FoundDevice>>> {

  final HardwareConnectivityRepository _repo;

  StreamSubscription<List<FoundDevice>>? _subscription;

  bool get isScanning => _subscription != null;

  UsbDevicesNotifier(this._repo) : super(const AsyncData([])) {
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
    _repo.startUsbScanning();
    _subscription?.cancel(); // Cancel previous subscription if any
    state = const AsyncLoading();

    _subscription = _repo.getDiscoveredDevicesStream().listen((devices) {
        state = AsyncData(devices);
      },
      onError: (e, st) {
        state = AsyncError(e, st);
      },
    );
  }

  void stopScanning() {
    _repo.stopUsbScanning();
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
    _repo.getDiscoveredDevicesStream().listen(
          (devices) {
        state = AsyncData(devices);
      },
      onError: (e, st) {
        state = AsyncError(e, st);
      }
    );
  }
}
