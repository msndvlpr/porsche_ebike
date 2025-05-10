part 'usb_bike_type.dart';

class UsbBikeData {
  final int bikeId;
  final UsbBikeType bikeType;
  final int motorRpm;
  final double batteryCharge;
  final double odoMeter; // in meters
  final String lastError;
  final int? lastTheftAlert; // in epoc time second
  final List<String>? gyroscope;
  final int? totalAirtime;

  UsbBikeData({
    required this.bikeId,
    required this.bikeType,
    required this.motorRpm,
    required this.batteryCharge,
    required this.odoMeter,
    required this.lastError,
    this.lastTheftAlert,
    this.gyroscope,
    this.totalAirtime,
  });
}