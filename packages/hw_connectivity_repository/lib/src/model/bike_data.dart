
part 'bike_type.dart';

class BikeData {
  final int? bikeId;
  final BikeType? bikeType;
  final int? motorRpm;
  final double? batteryCharge;
  final double? odoMeter;
  final String? lastError;
  final DateTime? lastTheftAlert;
  final List<double>? gyroscope;
  final int? totalAirtime;

  BikeData({
    this.bikeId,
    this.bikeType,
    this.motorRpm,
    this.batteryCharge,
    this.odoMeter,
    this.lastError,
    this.lastTheftAlert,
    this.gyroscope,
    this.totalAirtime,
  });

  BikeData copyWith({
    int? bikeId,
    BikeType? bikeType,
    int? motorRpm,
    double? batteryCharge,
    double? odoMeter,
    String? lastError,
    DateTime? lastTheftAlert,
    List<double>? gyroscope,
    int? totalAirtime,
  }) {
    return BikeData(
      bikeId: bikeId ?? this.bikeId,
      bikeType: bikeType ?? this.bikeType,
      motorRpm: motorRpm ?? this.motorRpm,
      batteryCharge: batteryCharge ?? this.batteryCharge,
      odoMeter: odoMeter ?? this.odoMeter,
      lastError: lastError ?? this.lastError,
      lastTheftAlert: lastTheftAlert ?? this.lastTheftAlert,
      gyroscope: gyroscope ?? this.gyroscope,
      totalAirtime: totalAirtime ?? this.totalAirtime,
    );
  }
}