import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';


final discoveredBikesProvider = StateNotifierProvider<BikeScannerNotifier, AsyncValue<List<Bike>>>(
      (ref) => BikeScannerNotifier(),
);

final selectedBikeProvider = StateProvider<Bike?>((ref) => null);

final bikeReadingsProvider = Provider<BikeReadings?>((ref) {
  final bike = ref.watch(selectedBikeProvider);
  return bike != null ? mockBikeReadings[bike.name] : null;
});

final modelOverviewProvider = Provider<ModelOverview?>((ref) {
  final bike = ref.watch(selectedBikeProvider);
  return bike != null ? modelOverviewData[bike.model] : null;
});

class Bike {
  final String name;
  final String connectionType;
  final String model;

  Bike({required this.name, required this.connectionType, required this.model});
}

class BikeScannerNotifier extends StateNotifier<AsyncValue<List<Bike>>> {
  BikeScannerNotifier() : super(const AsyncValue.data([]));

  Future<void> scan() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncValue.data([
      Bike(name: "John's Bike", connectionType: 'USB', model: 'MetroBee'),
      Bike(name: "Doe's Bike", connectionType: 'BLE', model: 'CliffHanger'),
      Bike(name: "My Bike", connectionType: 'USB', model: 'MetroBee'),
    ]);
  }

}

class BikeReadings {
  final String bikeId;
  final String stateOfCharge;
  final String odoMeter;
  final String lastError;
  final String lastAntiTheftAlert;

  BikeReadings({
    required this.bikeId,
    required this.stateOfCharge,
    required this.odoMeter,
    required this.lastError,
    required this.lastAntiTheftAlert,
  });
}

class ModelOverview {
  final String modelName;
  final String description;

  ModelOverview({required this.modelName, required this.description});
}

final mockBikeReadings = {
  "John's Bike": BikeReadings(
    bikeId: '5236942',
    stateOfCharge: '90%',
    odoMeter: '1.268 km',
    lastError: '5001',
    lastAntiTheftAlert: '2025.05.11 21:11',
  ),
};

final modelOverviewData = {
  'MetroBee': ModelOverview(
    modelName: 'MetroBee',
    description:
    'Conquer the concrete jungle with effortless speed and style. Glide through traffic, beat rush-hour, and make every ride a breeze.',
  ),
  'CliffHanger': ModelOverview(
    modelName: 'CliffHanger',
    description: 'Built for the climb. CliffHanger delivers stability and ruggedness for the adventurous rider.',
  ),
};

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final discoveredBikes = ref.watch(discoveredBikesProvider);
    final selectedBike = ref.watch(selectedBikeProvider);
    final readings = ref.watch(bikeReadingsProvider);
    final overview = ref.watch(modelOverviewProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Discovered Bikes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: discoveredBikes.when(
                        data: (bikes) => bikes.isEmpty
                            ? const Center(child: Text('No devices yet. Click Scan.'))
                            : ListView.builder(
                          itemCount: bikes.length,
                          itemBuilder: (context, index) {
                            final bike = bikes[index];
                            return ListTile(
                              title: Text(bike.name),
                              trailing: Text(bike.connectionType),
                              selected: selectedBike == bike,
                              onTap: () => ref.read(selectedBikeProvider.notifier).state = bike,
                            );
                          },
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const Center(child: Text('Scan failed.')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => ref.read(selectedBikeProvider.notifier).state = null,
                        child: const Text('Connect \\ Disconnect'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          print('msn scan started');
                           //ref.read(discoveredBikesProvider.notifier).scan();
                          //BluetoothConApi

                        },
                        child: const Text('Scan'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bike Readings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: readings == null
                        ? const Text('No bike connected')
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bike Id: ${readings.bikeId}'),
                        Text('Bike Model: ${selectedBike?.model ?? ''}'),
                        Text('State of Charge: ${readings.stateOfCharge}'),
                        Text('ODO Meter: ${readings.odoMeter}'),
                        Text('Last Known Error: ${readings.lastError}'),
                        Text('Last anti-theft alert: ${readings.lastAntiTheftAlert}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Model Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: overview == null
                        ? const Text('No model selected')
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(overview.modelName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        const SizedBox(height: 4),
                        Text(overview.description),
                        const SizedBox(height: 12),
                        Container(
                          height: 180,
                          color: Colors.black12,
                          child: const Center(child: Text('Model Image Placeholder')),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
