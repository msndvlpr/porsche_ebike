import 'package:bluetooth_connection_api/bluetooth_connection_api.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  group('BluetoothConnectionApi', () {

    test('should emit distinct BleBikeData stream readings', () async {
      final fakeData = [
        BleBikeData(bikeId: 123456,
            motorRpm: 100,
            batteryCharge: 90,
            bikeType: BleBikeType.metroBee,
            odoMeter: 3500,
            lastError: 'last error sample'),
        BleBikeData(bikeId: 123456,
            motorRpm: 80,
            batteryCharge: 85,
            bikeType: BleBikeType.metroBee,
            odoMeter: 3501,
            lastError: 'last error sample'),
      ];

      final stream = Stream.fromIterable(fakeData);

      final api = BluetoothConnectionApi(
        bleDataStreamProvider: ({required int bikeId}) => stream,
      );

      final result = await api.getBikeReadingsDataStreamOverBle(
          bleDeviceAddress: 'abc')
          .toList();

      expect(result.length, 2);
      expect(result.first.motorRpm, 100);
      expect(result.last.motorRpm, 80);
    });
  });

}
