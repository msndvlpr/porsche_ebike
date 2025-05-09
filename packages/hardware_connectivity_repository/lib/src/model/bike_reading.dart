part 'bike_model.dart';

class BikeReading {
  final int bikeId;
  final BikeModel bikeType;
  final int motorRpm;
  final double batteryCharge;
  final String odoMeterKm; // in Km
  final String lastError;
  final DateTime? lastTheftAlert; // in human readable date-time
  final List<double>? gyroscope;
  final int? totalAirtime;

  BikeReading({
    required this.bikeId,
    required this.bikeType,
    required this.motorRpm,
    required this.batteryCharge,
    required this.odoMeterKm,
    required this.lastError,
    this.lastTheftAlert,
    this.gyroscope,
    this.totalAirtime,
  });

  BikeReading copyWith({
    int? bikeId,
    BikeModel? bikeType,
    int? motorRpm,
    double? batteryCharge,
    String? odoMeterKm,
    String? lastError,
    DateTime? lastTheftAlert,
    List<double>? gyroscope,
    int? totalAirtime

  }) {
    return BikeReading(
      bikeId: bikeId ?? this.bikeId,
      bikeType: bikeType ?? this.bikeType,
      motorRpm: motorRpm ?? this.motorRpm,
      batteryCharge: batteryCharge ?? this.batteryCharge,
      odoMeterKm: odoMeterKm ?? this.odoMeterKm,
      lastError: lastError ?? this.lastError,
      lastTheftAlert: lastTheftAlert ?? this.lastTheftAlert,
      gyroscope: gyroscope ?? this.gyroscope,
      totalAirtime: totalAirtime ?? this.totalAirtime,
    );
  }
}
