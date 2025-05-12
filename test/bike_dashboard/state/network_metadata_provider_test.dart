import 'dart:async';
import 'package:bike_metadata_repository/bike_metadata_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/foundation.dart';
import 'package:network_api/network_api_service.dart';
import 'package:porsche_ebike_code_challenge/bike_dashboard/state/network_metadata_provider.dart';


class MockBikeMetadataRepository extends Mock implements BikeMetadataRepository {}

void main() {

  group('BikeMetadataNotifier', () {
    late MockBikeMetadataRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockBikeMetadataRepository();
      container = ProviderContainer(overrides: [
        networkMetadataProvider.overrideWithValue(mockRepository),
      ]);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is null', () {
      final notifier = container.read(bikeMetadataProvider.notifier);
      expect(container.read(bikeMetadataProvider).value, isNull);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.hasError, isFalse);
    });

    group('fetchBikeAssets', () {
      const bikeId = 'bike123';
      const bikeType = 'eBike';
      final mockData = BikeAssetData(
         resourceId: 123456, bikeDescription: 'some description', bikeImageUrl: 'some urls', bikeModel: 'some type'
      );
      final mockError = Exception('Failed to fetch');

      test('fetches bike assets successfully', () async {
        when(() => mockRepository.getBikeMetadataById(bikeId, bikeType))
            .thenAnswer((_) async => mockData);

        await container.read(bikeMetadataProvider.notifier).fetchBikeAssets(bikeId, bikeType);

        expect(container.read(bikeMetadataProvider).value, mockData);
        expect(container.read(bikeMetadataProvider).isLoading, isFalse);
        expect(container.read(bikeMetadataProvider).hasError, isFalse);
        verify(() => mockRepository.getBikeMetadataById(bikeId, bikeType)).called(1);
      });

      test('fails to fetch bike assets and sets error state', () async {
        when(() => mockRepository.getBikeMetadataById(bikeId, bikeType))
            .thenThrow(mockError);

        await container.read(bikeMetadataProvider.notifier).fetchBikeAssets(bikeId, bikeType);

        expect(container.read(bikeMetadataProvider).error, mockError);
        expect(container.read(bikeMetadataProvider).isLoading, isFalse);
        expect(container.read(bikeMetadataProvider).hasError, isTrue);
        verify(() => mockRepository.getBikeMetadataById(bikeId, bikeType)).called(1);
      });

      test('sets loading state while fetching', () async {
        final completer = Completer<BikeAssetData>();
        when(() => mockRepository.getBikeMetadataById(bikeId, bikeType))
            .thenAnswer((_) => completer.future);

        final future = container.read(bikeMetadataProvider.notifier).fetchBikeAssets(bikeId, bikeType);

        expect(container.read(bikeMetadataProvider).isLoading, isTrue);
        expect(container.read(bikeMetadataProvider).hasError, isFalse);

        completer.complete(mockData);
        await future;

        expect(container.read(bikeMetadataProvider).isLoading, isFalse);
      });
    });

    group('triggerBikeConnectedEvent', () {
      const timeStamp = '2025-05-11T22:38:00Z';
      const bikeId = 'bike456';
      const bikeType = 'roadBike';
      final mockError = Exception('Failed to trigger event');

      test('triggers bike connected event successfully', () async {

        when(() => mockRepository.triggerBikeConnectedEvent(timeStamp, bikeId, bikeType)).thenAnswer((_) async => true);

        await container.read(bikeMetadataProvider.notifier).triggerBikeConnectedEvent(timeStamp, bikeId, bikeType);

        expect(container.read(bikeMetadataProvider).hasError, isFalse);
        verify(() => mockRepository.triggerBikeConnectedEvent(timeStamp, bikeId, bikeType)).called(1);
      });

      test('fails to trigger bike connected event and sets error state', () async {
        when(() => mockRepository.triggerBikeConnectedEvent(timeStamp, bikeId, bikeType))
            .thenThrow(mockError);

        await container.read(bikeMetadataProvider.notifier).triggerBikeConnectedEvent(timeStamp, bikeId, bikeType);

        expect(container.read(bikeMetadataProvider).isLoading, isFalse);
        expect(container.read(bikeMetadataProvider).hasError, isTrue);
        expect(container.read(bikeMetadataProvider).error, mockError);
        verify(() => mockRepository.triggerBikeConnectedEvent(timeStamp, bikeId, bikeType)).called(1);
      });

    });
  });
}