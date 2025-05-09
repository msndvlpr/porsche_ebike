import 'dart:async';
import 'package:bike_metadata_repository/bike_metadata_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_api/network_api_service.dart';


final bikeMetadataRepositoryProvider = Provider<BikeMetadataRepository>((ref) {
  return BikeMetadataRepository();
});

final bikeMetadataProvider = AsyncNotifierProvider<BikeMetadataNotifier, BikeAssetData?>(
  BikeMetadataNotifier.new,
);

class BikeMetadataNotifier extends AsyncNotifier<BikeAssetData?> {

  @override
  FutureOr<BikeAssetData?> build() => null;

  Future<void> fetch(String bikeId, String bikeType) async {
    final repository = ref.read(bikeMetadataRepositoryProvider);

    state = const AsyncLoading();
    try {
      final data = await repository.getBikeMetadataById(bikeId, bikeType);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
