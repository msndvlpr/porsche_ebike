import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:hardware_connectivity_repository/hardware_connectivity_repository.dart';
import 'package:intl/intl.dart';
import '../state/hardware_connectivity_provider.dart';
import '../state/network_resource_provider.dart';

/*class BikeDashboardScreen extends StatelessWidget {
  const BikeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        hintColor: Colors.grey.shade600,
        textTheme: TextTheme(
          headlineSmall: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
          titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          bodyMedium: const TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const BikeInfoFrame(),
    );
  }
}*/

class BikeDashboardScreen extends ConsumerWidget {
  const BikeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final usbDevicesAsync = ref.watch(devicesProvider);
    final usbNotifier = ref.watch(devicesProvider.notifier);
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final isScanning = ref.watch(devicesProvider.select((stateNotifier) =>
       stateNotifier is AsyncData && (ref.read(devicesProvider.notifier)).isScanning));

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PORSCHE eBike Performance Diagnostic'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor.withOpacity(0.8),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: Container(margin: EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Discovered Bikes Pane
              Expanded(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Discovered Bikes', style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 12),
                        Expanded(
                          child: usbDevicesAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, stack) => Center(child: Text('Error fetching found bikes list: $error')),
                            data: (devices) {
                              if (devices.isEmpty) {
                                return const Center(
                                  child: Text('No USB or BLE devices available, please press Scan to start searching.'),
                                );
                              }

                              return ListView.builder(
                                itemCount: devices.length,
                                itemBuilder: (context, index) {
                                  final item = devices[index];
                                  final deviceId = item.deviceId;
                                  final isSelected = selectedDevice == deviceId;

                                  return ListTile(
                                    title: Text(item.deviceName ?? 'Unknown'),
                                    trailing: Text(item.connectionType?.value ?? 'N/A'),
                                    tileColor: isSelected ? theme.primaryColor.withOpacity(0.2) : null,
                                    onTap: () {
                                      ref.read(selectedDeviceProvider.notifier).state = deviceId;
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            ElevatedButton(
                              onPressed: selectedDevice != null ? () {

                                ref.read(bikeReadingProvider.notifier).startBikeReadingListening(selectedDevice);

                                //reading.bikeType.name
                                //todo
                                ref.read(bikeMetadataProvider.notifier).fetch(selectedDevice, 'CliffHanger');

                              } : null,
                              child: Text('Connect / Disconnect')
                            ),

                            ElevatedButton.icon(
                              onPressed: () {
                                usbNotifier.toggleScanning();
                                if (!isScanning) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Scanning for new bikes...')),
                                  );
                                }
                              },
                              icon: isScanning ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2.0),
                              )
                                  : const Icon(Icons.usb),
                              label: Text(isScanning ? 'Stop' : 'Scan'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              /// Bike Readings Section
              Expanded(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bike Readings', style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 12),
                        ref.watch(bikeReadingProvider).when(
                          data: (reading) {
                            if (reading == null) {
                              return const Text('No data received yet.');
                            }

                            final readingMap = {
                              'Bike ID': reading.bikeId,
                              'Model': reading.bikeType.name,
                              'Motor RPM': reading.motorRpm.toString(),
                              'Battery Charge': '${reading.batteryCharge}%',
                              'Odometer': '${reading.odoMeterKm} km',
                              'Last Error': reading.lastError,
                              if (reading.lastTheftAlert != null)
                                'Theft Alert': reading.lastTheftAlert!,
                            };

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: readingMap.length,
                              separatorBuilder: (context, index) => const Divider(height: 16),
                              itemBuilder: (context, index) {
                                final key = readingMap.keys.elementAt(index);
                                final value = readingMap.values.elementAt(index);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(key, style: theme.textTheme.titleMedium),
                                    Text(value.toString(), style: theme.textTheme.bodyMedium),
                                  ],
                                );
                              },
                            );
                          },
                          loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
                          error: (err, stack) => Text('Failed to get readings: $err'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              const SizedBox(width: 16),

              /// Model Overview Section
              Expanded(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ref.watch(bikeMetadataProvider).when(
                      data: (bikeData) {
                        if (bikeData == null) return const Text('Select a bike and press Connect.');

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Model Overview', style: theme.textTheme.headlineSmall),
                            const SizedBox(height: 12),
                            Text(
                              bikeData.resourceId.toString(),//todo
                              style: theme.textTheme.headlineSmall?.copyWith(color: theme.primaryColor),
                            ),
                            const SizedBox(height: 8),
                            Text(bikeData.bikeDescription, style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 20),
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(bikeData.bikeImageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, st) => Center(child: Text('Failed to load metadata: $err')),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}