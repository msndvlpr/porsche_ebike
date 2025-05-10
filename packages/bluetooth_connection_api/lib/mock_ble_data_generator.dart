import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'src/model/ble_bike_data.dart';


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


Stream<BleBikeData> getBleMockBikeDataReadings({required int bikeId}) async* {

  double odoMeter = 165000.0; // odo in meters
  double batteryCharge = 84.0; // battery in %
  double x = 0, y = 0, z = 0;  // gyro
  int rpm = 60;  // rpm

  bool rpmIncreasing = true;

  final rand = Random();

  // Generate total air time between 30 seconds to 300 seconds
  int? totalAirtime = (30 + rand.nextInt(300 - 30 + 1)) as int?;
  // Conditional error simulation
  String lastError = 'Motor Overheat';

  // Conditional fields based on bike type epoc time in seconds
  int? lastTheftAlert = 1652091600;

  // Random bike type
  final bikeType = bikeId % 2 == 0 ? BleBikeType.cliffHanger : BleBikeType.metroBee;

  while (true) {
    await Future.delayed(const Duration(seconds: 2));

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

    List<String>? gyroscope = [x.toStringAsFixed(2), y.toStringAsFixed(2), z.toStringAsFixed(2)];


    if (bikeType == BleBikeType.cliffHanger) {
      // CliffHanger: no lastTheftAlert
      lastTheftAlert = null;
    } else {
      // MetroBee: no gyro or airtime
      gyroscope = null;
      totalAirtime = null;
    }


    yield BleBikeData(
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
  }
}