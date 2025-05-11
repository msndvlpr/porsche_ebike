import 'package:flutter_test/flutter_test.dart';
import 'package:usb_connection_api/usb_connection_api.dart';

void main() {
  group('UsbConnectionApi', () {

    test('getBikeReadingsDataStream emits only changed UsbBikeData values',
        () async {
      final fakeData = [
        UsbBikeData(
          bikeId: 1,
          motorRpm: 100,
          batteryCharge: 80,
          odoMeter: 100,
          lastError: "none",
          lastTheftAlert: 123456,
          gyroscope: ["x", "y"],
          totalAirtime: 1000,
          bikeType: UsbBikeType.metroBee,
        ),
        UsbBikeData(
            bikeId: 1,
            motorRpm: 100,
            // same as before
            batteryCharge: 80,
            odoMeter: 100,
            lastError: "none",
            lastTheftAlert: 123456,
            gyroscope: ["x", "y"],
            totalAirtime: 1000,
            bikeType: UsbBikeType.metroBee),
        UsbBikeData(
            bikeId: 1,
            motorRpm: 105,
            // changed
            batteryCharge: 85,
            odoMeter: 110,
            lastError: "none",
            lastTheftAlert: 123654,
            gyroscope: ["x", "y"],
            totalAirtime: 1020,
            bikeType: UsbBikeType.cliffHanger),
      ];

      final mockStream = Stream<UsbBikeData>.fromIterable(fakeData);

      final api = UsbConnectionApi(
        getBikeDataReadings: ({required int bikeId}) => mockStream,
      );

      final result = await api
          .getBikeReadingsDataStream(usbPortAddress: "test-port")
          .toList();

      expect(result.length, 2); // skips the duplicate
      expect(result[0].motorRpm, 100);
      expect(result[1].motorRpm, 105);
    });
  });
}
