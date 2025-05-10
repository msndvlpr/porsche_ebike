import 'dart:math';

import '../usb_connection_api.dart';

List<UsbPort> getMockUsbPorts() {
  return [
    UsbPort(
      description: 'E-Bike Controller USB ',
      name: '/dev/cu.usbserial-ebike001',
      transport: 'usb',
      busNumber: '001',
      deviceNumber: '005',
      vendorId: '0x2341',
      productId: '0x8036',
      manufacturer: 'Porsche E-bike',
      productName: 'eBike USB Comm Module',
      serialNumber: 'EBIKE-12345678',
      macAddress: null,
    ),
    UsbPort(
      description: 'eBike Test',
      name: '/dev/cu.usbmodem-ebike002',
      transport: 'usb',
      busNumber: '001',
      deviceNumber: '006',
      vendorId: '0x1A86',
      productId: '0x7523',
      manufacturer: 'Porsche E-bike Pr',
      productName: 'Diagnostic USB Port',
      serialNumber: 'DIAG-98765432',
      macAddress: null,
    ),
  ];
}


Stream<UsbBikeData> getMockBikeDataReadings({required int bikeId}) async* {
  double odoMeter = 165000.0; // odo in meters
  double batteryCharge = 84.0; // battery in %
  double x = 0,
      y = 0,
      z = 0; // gyro
  int rpm = 60; // rpm

  bool rpmIncreasing = true;

  final rand = Random();

  // Generate total air time between 30 seconds to 300 seconds
  int? totalAirtime = (30 + rand.nextInt(300 - 30 + 1)) as int?;
  // Conditional error simulation
  String lastError = 'Motor Overheat';

  // Conditional fields based on bike type epoc time in seconds
  int? lastTheftAlert = 1652091600;

  // Random bike type
  final bikeType = bikeId % 2 == 0 ? UsbBikeType.cliffHanger : UsbBikeType
      .metroBee;

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


    if (bikeType == UsbBikeType.cliffHanger) {
      // CliffHanger: no lastTheftAlert
      lastTheftAlert = null;
    } else {
      // MetroBee: no gyro or airtime
      gyroscope = null;
      totalAirtime = null;
    }

    yield UsbBikeData(
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