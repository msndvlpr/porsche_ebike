import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:rxdart/rxdart.dart';

/// Represents a CAN message. In a real implementation, we'd get this from the hardware interface.

//Simulates a CAN bus and the hardware interface.
class MockCanBusDataProvider {
  final _streamController = BehaviorSubject<CanMessage>();

  //Simulates sending CAN messages
  Stream<CanMessage> get canMessageStream => _streamController.stream;

  // Start simulating CAN data
  void startSimulation() {
    //Simulate different CAN IDs and data
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // Create some random variation for our simulated data
      final random = Random();

      //Simulate Motor RPM (CAN ID 0x100, for example)
      _streamController.add(CanMessage(
        id: 0x100,
        data: Uint8List.fromList([
          (1000 + random.nextInt(500)) >> 8, // High byte
          (1000 + random.nextInt(500)) & 0xFF, // Low byte
        ]),
      ));

      //Simulate Battery Charge (CAN ID 0x101, for example)
      _streamController.add(CanMessage(
        id: 0x101,
        data: Uint8List.fromList([(80 + random.nextInt(20)).round(), // Battery percentage
        ]),
      ));

      //Simulate ODO Meter (CAN ID 0x102)
      _streamController.add(CanMessage(
        id: 0x102,
        data: Uint8List.fromList([
          (1000 + random.nextInt(100)).toInt() >> 24,
          ((1000 + random.nextInt(100)).toInt() >> 16) & 0xFF,
          ((1000 + random.nextInt(100)).toInt() >> 8) & 0xFF,
          (1000 + random.nextInt(100)).toInt() & 0xFF,
        ]),
      ));

      //Simulate Gyroscope data (CAN ID 0x103)
      _streamController.add(CanMessage(
        id: 0x103,
        data: Uint8List.fromList([
          (random.nextDouble() * 10).toInt() >> 8,
          (random.nextDouble() * 10).toInt() & 0xFF,  // X
          (random.nextDouble() * 10).toInt() >> 8,
          (random.nextDouble() * 10).toInt() & 0xFF,  // Y
          (random.nextDouble() * 10).toInt() >> 8,
          (random.nextDouble() * 10).toInt() & 0xFF, // Z
        ]),
      ));
    });
  }

  void dispose() {
    _streamController.close();
  }
}

class CanMessage {
  final int id;
  final Uint8List data;

  CanMessage({required this.id, required this.data});
}