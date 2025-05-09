part 'bike_type.dart';

class BikeData {
  final int bikeId;
  final BikeType bikeType;
  final int motorRpm;
  final double batteryCharge;
  final double odoMeter; // in meters
  final String lastError;
  final int? lastTheftAlert; // in epoc time second
  final List<double>? gyroscope;
  final int? totalAirtime;

  BikeData({
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