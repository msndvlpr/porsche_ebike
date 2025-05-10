part 'bike_model.dart';

class BikeReading {
  final int bikeId;
  final BikeModel bikeModel;
  final int motorRpm;
  final double batteryCharge;
  final String odoMeterKm; // in Km
  final String lastError;
  final String? lastTheftAlert; // in human readable date-time
  final List<String>? gyroscope;
  final int? totalAirtime;

  BikeReading({
    required this.bikeId,
    required this.bikeModel,
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
    String? lastTheftAlert,
    List<String>? gyroscope,
    int? totalAirtime

  }) {
    return BikeReading(
      bikeId: bikeId ?? this.bikeId,
      bikeModel: bikeType ?? this.bikeModel,
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
