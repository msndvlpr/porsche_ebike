import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:intl/intl.dart';
import '../state/hardware_connection_provider.dart';

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

final Map<String, String> _bikeReadings = {
  'Bike Id': '5236942',
  'Bike Model': 'MetroBee',
  'State of Charge': '90%',
  'ODO Meter': '1.268 km',
  'Last Known Error': '5001',
  'Last anti-theft alert': DateFormat('yyyy.MM.dd HH:mm').format(DateTime(2025, 5, 11, 21, 11)),
};

class BikeDashboardScreen extends ConsumerWidget {
  const BikeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usbDevicesAsync = ref.watch(usbDevicesProvider);
    final usbNotifier = ref.watch(usbDevicesProvider.notifier);
    final selectedDeviceId = ref.watch(selectedDeviceProvider);
    final isScanning = ref.watch(usbDevicesProvider.select((stateNotifier) =>
    stateNotifier is AsyncData && (ref.read(usbDevicesProvider.notifier)).isScanning));

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor.withOpacity(0.8),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Discovered bikes pane
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Discovered Bikes', style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 12),
                      Expanded(
                        child: usbDevicesAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (error, stack) =>
                              Center(child: Text('Error fetching found bikes list: $error')),
                          data: (devices) {
                            if (devices.isEmpty) {
                              return const Center(
                                child: Text('No USB or BLE devices available, please press Scan to start searching.'),
                              );
                            }

                            return ListView.builder(
                              itemCount: devices.length,
                              itemBuilder: (context, index) {
                                final device = devices[index];
                                final deviceId = '${device.deviceId}';
                                final isSelected = selectedDeviceId == deviceId;

                                return ListTile(
                                  title: Text(device.deviceName ?? 'Unknown'),
                                  trailing: Text(device.deviceType?.value ?? 'N/A'),
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
                            onPressed: selectedDeviceId != null
                                ? () {
                              // Connect/disconnect logic here with selectedDeviceId
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Trying to connect to $selectedDeviceId')),
                              );
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                            ),
                            child: Text(true ? 'Disconnect' : 'Connect'),
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
                            icon: isScanning
                                ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2.0),
                            )
                                : const Icon(Icons.usb),
                            label: Text(isScanning ? 'Stop' : 'Scan'),
                          ),
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bike Readings', style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _bikeReadings.length,
                        separatorBuilder: (context, index) => const Divider(height: 16),
                        itemBuilder: (context, index) {
                          final key = _bikeReadings.keys.elementAt(index);
                          final value = _bikeReadings.values.elementAt(index);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(key, style: theme.textTheme.titleMedium),
                              Text(value, style: theme.textTheme.bodyMedium),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Model Overview Section
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Model Overview', style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 12),
                      Text(
                        'MetroBee',
                        style: theme.textTheme.headlineSmall?.copyWith(color: theme.primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Conquer the concrete jungle with effortless speed and style. Glide through traffic, beat rush-hour, and make every ride a breeze.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(child: Icon(Icons.image_outlined, size: 60, color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}