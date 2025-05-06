import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_connectivity_repository/hw_connectivity_repository.dart';
import 'package:usb_con_api/usb_con_api_service.dart';

final usbDevicesProvider = StateNotifierProvider<UsbDevicesNotifier, AsyncValue<List<UsbPort>>>(
      (ref) {
    final repo = ref.watch(hardwareConnectivityRepoProvider);
    return UsbDevicesNotifier(repo);
  },
);

final hardwareConnectivityRepoProvider = Provider<HwConnectivityRepository>((ref) {
  final api = UsbConApi();
  return HwConnectivityRepository(api);
});

class UsbDevicesNotifier extends StateNotifier<AsyncValue<List<UsbPort>>> {
  final HwConnectivityRepository _repo;

  UsbDevicesNotifier(this._repo) : super(const AsyncLoading()) {
    _listenToStream();
  }

  void _listenToStream() {
    _repo.watchUsbDevices().listen(
          (devices) {
        state = AsyncData(devices);
      },
      onError: (e, st) {
        state = AsyncError(e, st);
      },
    );
  }
}
