
import '../mock_can_bus_data_provider.dart';

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


// Converts a CAN message to the corresponding data in your BikeData model.
  BikeData? parseCanMessage(CanMessage message, BikeData currentBikeData) {
    switch (message.id) {
      case 0x100: // Motor RPM
        if (message.data.length == 2) {
          final rpm = (message.data[0] << 8) | message.data[1];
          return currentBikeData.copyWith(motorRpm: rpm);
        }
        break;
      case 0x101: // Battery Charge
        if (message.data.length == 1) {
          final charge = message.data[0].toDouble();
          return currentBikeData.copyWith(batteryCharge: charge);
        }
        break;
      case 0x102: // ODO Meter
        if (message.data.length == 4) {
          final odoMeter = (message.data[0] << 24) +
              (message.data[1] << 16) +
              (message.data[2] << 8) +
              message.data[3];
          return currentBikeData.copyWith(odoMeter: odoMeter.toDouble());
        }
        break;
      case 0x103: // Gyroscope
        if (message.data.length == 6) {
          List<double> gyroscopeData = [
            ((message.data[0] << 8) | message.data[1]).toDouble(), // X
            ((message.data[2] << 8) | message.data[3]).toDouble(), // Y
            ((message.data[4] << 8) | message.data[5]).toDouble(), // Z
          ];
          return currentBikeData.copyWith(gyroscope: gyroscopeData);
        }
        break;
    // todo: Add cases for other CAN IDs as needed (e.g., for Bike ID, Last Error, etc.)
    }
    return null; // Return null if the message isn't recognized or has an invalid format.
  }

}
