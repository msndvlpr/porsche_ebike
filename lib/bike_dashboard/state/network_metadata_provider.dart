import 'dart:async';
import 'package:bike_metadata_repository/bike_metadata_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_api/network_api_service.dart';


final networkMetadataProvider = Provider<BikeMetadataRepository>((ref) {
  return BikeMetadataRepository();
});

final bikeMetadataProvider = AsyncNotifierProvider<BikeMetadataNotifier, BikeAssetData?>(BikeMetadataNotifier.new);

class BikeMetadataNotifier extends AsyncNotifier<BikeAssetData?> {

  @override
  FutureOr<BikeAssetData?> build() => null;

  Future<void> fetchBikeAssets(String bikeId, String bikeType) async {
    final repository = ref.read(networkMetadataProvider);

    state = const AsyncLoading();
    try {
      final data = await repository.getBikeMetadataById(bikeId, bikeType);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> triggerBikeConnectedEvent(String timeStamp, String bikeId, bikeType) async {
    final repository = ref.read(networkMetadataProvider);

    state = const AsyncLoading();
    try {
      final data = await repository.triggerBikeConnectedEvent(timeStamp, bikeId, bikeType);
      debugPrint("BikeConnected event trigger success state: $data");

    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
