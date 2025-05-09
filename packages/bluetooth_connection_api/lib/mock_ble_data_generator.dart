import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'model/bike_data.dart';


List<ScanResult> getMockScanResults() {
  return [ScanResult(

    device: BluetoothDevice(
      remoteId: const DeviceIdentifier('AA:BB:CC:DD:EE:FF'),
    ),
    advertisementData: AdvertisementData(
      serviceUuids: <Guid>[
        Guid('12345678-1234-1234-1234-1234567890ab'),
      ],
      manufacturerData: {},
      serviceData: {},
      txPowerLevel: null,
      connectable: false,
      advName: 'Mock Device B',
      appearance: null,
    ),
    rssi: -72,
    timeStamp: DateTime.now(),
  ),
    ScanResult(
      device: BluetoothDevice(
        remoteId: const DeviceIdentifier('11:22:33:44:55:66'),
      ),
      advertisementData: AdvertisementData(
        serviceUuids: <Guid>[
          Guid('abcdefab-cdef-abcd-efab-cdefabcdef12')
        ],
        manufacturerData: {},
        serviceData: {},
        txPowerLevel: -5,
        connectable: true,
        advName: 'Mock Device A',
        appearance: null,
      ),
      rssi: -60,
      timeStamp: DateTime.now(),
    ),
  ];
}


Stream<BikeData> getMockBikeDataReadings({
  int bikeId = 1402,
  BikeType bikeType = BikeType.metroBee,
  Duration interval = const Duration(seconds: 3)
}) async* {
  double odoMeter = 165000.0; // in meters
  double batteryCharge = 84.0; // in %
  double x = 0, y = 0, z = 0;
  int rpm = 60;
  bool rpmIncreasing = true;

  final rand = Random();
  int tick = 0;

  while (true) {
    await Future.delayed(interval);

    // RPM control logic
    if (rpmIncreasing) {
      rpm += 10;
      if (rpm >= 100) rpmIncreasing = false;
    } else {
      rpm -= 10;
      if (rpm <= 40) rpmIncreasing = true;
    }

    // Distance travelled
    final distance = rand.nextInt(11) + 5; // 5–15 meters
    odoMeter += distance;

    // Battery drain
    batteryCharge -= (rand.nextDouble() * 0.2 + 0.1);
    if (batteryCharge < 0) batteryCharge = 0;

    // Gyroscope update
    x += rand.nextDouble() * 0.5 - 0.25;
    y += rand.nextDouble() * 0.5 - 0.25;
    z += rand.nextDouble() * 0.5 - 0.25;

    // Conditional error simulation
    String lastError = 'Motor Overheat';

    // Conditional fields based on bike type
    int? lastTheftAlert;
    List<double>? gyroscope;
    int? totalAirtime;

    if (bikeType == BikeType.cliffHanger) {
      // Allow gyro and airtime, but no theft alerts
      gyroscope = [x, y, z];
      totalAirtime = tick * interval.inSeconds;
      lastTheftAlert = null;
    } else {
      // MetroBee: no gyro or airtime, allow theft alerts
      if (tick % 45 == 0 && rand.nextInt(100) < 5) {
        lastTheftAlert = 1652091600;
      }
      gyroscope = null;
      totalAirtime = null;
    }

    yield BikeData(
      bikeId: bikeId,
      bikeType: bikeType,
      motorRpm: rpm,
      batteryCharge: double.parse(batteryCharge.toStringAsFixed(1)),
      odoMeter: double.parse(odoMeter.toStringAsFixed(1)),
      lastError: lastError,
      lastTheftAlert: lastTheftAlert,
      gyroscope: gyroscope,
      totalAirtime: totalAirtime,
    );

    tick++;
  }
}