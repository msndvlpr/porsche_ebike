import 'package:flutter_test/flutter_test.dart';
import 'package:usb_connection_api/usb_connection_api.dart';
import 'package:your_package/api/usb_connection_api.dart';
import 'package:your_package/models/usb_port.dart';
import 'package:your_package/models/usb_bike_data.dart';


void main() {
  group('UsbConnectionApi', () {
    late UsbConnectionApi api;

    setUp(() {
      api = UsbConnectionApi();
    });

    test('stringToFixedDigitInt returns a consistent int value', () {
      final result1 = api.stringToFixedDigitInt("USB123");
      final result2 = api.stringToFixedDigitInt("USB123");
      expect(result1, equals(result2));
    });

    test('_listEquals returns true for same string lists', () {
      final result = api._listEquals(['a', 'b'], ['a', 'b']);
      expect(result, isTrue);
    });

    test('_listEquals returns false for different string lists', () {
      final result = api._listEquals(['a', 'b'], ['a', 'c']);
      expect(result, isFalse);
    });

    test('_bikeDataReadingEqual returns true for same data', () {
      final data1 = UsbBikeData(
        bikeId: 1,
        motorRpm: 100,
        batteryCharge: 90,
        odoMeter: 200,
        lastError: 'none',
        lastTheftAlert: 'none',
        gyroscope: ['x', 'y'],
        totalAirtime: 3600,
      );

      final data2 = UsbBikeData(
        bikeId: 1,
        motorRpm: 100,
        batteryCharge: 90,
        odoMeter: 200,
        lastError: 'none',
        lastTheftAlert: 'none',
        gyroscope: ['x', 'y'],
        totalAirtime: 3600,
      );

      final result = api._bikeDataReadingEqual(data1, data2);
      expect(result, isTrue);
    });
  });
}
