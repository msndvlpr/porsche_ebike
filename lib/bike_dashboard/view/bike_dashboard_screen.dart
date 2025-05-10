import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/hardware_connectivity_provider.dart';
import '../state/network_metadata_provider.dart';
import '../widget/live_indicator.dart';


class BikeDashboardScreen extends ConsumerWidget {
  const BikeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final usbDevicesAsync = ref.watch(devicesProvider);
    final usbNotifier = ref.watch(devicesProvider.notifier);
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final connectedDevice = ref.watch(connectedDeviceProvider);
    final isScanning = ref.watch(devicesProvider.select((stateNotifier) =>
       stateNotifier is AsyncData && (ref.read(devicesProvider.notifier)).isScanning));
    final isStreaming = ref.watch(bikeReadingProvider.select((stateNotifier) =>
    stateNotifier is AsyncData && (ref.read(bikeReadingProvider.notifier)).isStreaming));
    final theme = Theme.of(context);


    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Porsche eBike Performance Diagnostics Tool',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      body: Container(margin: EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Discovered Bikes Section
              Expanded(flex: 3,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Discovered Bikes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.grey[800])),
                        const SizedBox(height: 28),
                        Expanded(
                          child: usbDevicesAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, stack) => Center(child: Text('Error fetching found bikes list: $error')),
                            data: (devices) {
                              if (devices.isEmpty) {
                                return const Center(
                                  child: Text('No devices available, please press Scan to start searching.'),
                                );
                              }

                              return ListView.separated(
                                itemCount: devices.length,
                                separatorBuilder: (context, index) => const Divider(thickness: 0.2, height: 0, color: Colors.grey),
                                padding: EdgeInsets.symmetric(vertical: 0),
                                itemBuilder: (context, index) {
                                  final item = devices[index];
                                  final deviceId = item.deviceId;
                                  final isSelected = selectedDevice == deviceId;

                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: isSelected ? theme.primaryColor.withOpacity(0.2) : null,
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                      leading: Text(item.deviceName ?? 'Unknown', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
                                      trailing: Text(item.connectionType?.value ?? 'N/A', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                                      onTap: () {
                                        ref.read(selectedDeviceProvider.notifier).state = deviceId;
                                      },
                                    ),
                                  );
                                },
                              );

                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            SizedBox(width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(elevation: 12, shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)
                                  )),
                                onPressed: selectedDevice != null ? () {

                                  if(selectedDevice != connectedDevice){
                                    /// Let's connect the device and start reading data stream
                                    ref.read(bikeReadingProvider.notifier).connectDeviceAndStartListening(selectedDevice);
                                    /// Set the device as connected, which means disconnect others
                                    ref.read(connectedDeviceProvider.notifier).state = selectedDevice;

                                  } else {
                                    /// Let's disconnect from the device
                                    /// Stop the data stream but still show tha last data reading on the center pane
                                    ref.watch(bikeReadingProvider.notifier).stopBikeReadingListening();
                                    ref.read(connectedDeviceProvider.notifier).state = null;
                                  }


                                } : null,
                                child: Text((selectedDevice == connectedDevice && selectedDevice != null) ? 'Disconnect' : 'Connect')
                              ),
                            ),

                            SizedBox(height: 12),

                            SizedBox(width: double.infinity,
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(elevation: 12, shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                  )),
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
                                    : Row (children: [const Icon(Icons.usb), const SizedBox(width: 4), const Icon(Icons.bluetooth)]),
                                label: Text(isScanning ? 'Stop' : 'Scan')
                              ),
                            ),

                            SizedBox(height: 12)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// Bike Readings Section
              Expanded(flex: 3,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Bike Readings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.grey[800])),
                            Spacer(),

                            /// Live indicator shown only if we have a reading
                            ref.watch(bikeReadingProvider).maybeWhen(
                              data: (reading) => reading != null ? LiveIndicator(isLive: isStreaming) : const SizedBox.shrink(),
                              orElse: () => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ref.watch(bikeReadingProvider).when(
                          data: (reading) {
                            if (reading == null) {
                              return const Text('No data received yet.');
                            }

                            final readingMap = {
                              'Bike ID': reading.bikeId,
                              'Bike Model': reading.bikeModel.name,
                              'State of Charge': '${reading.batteryCharge} %',
                              'Motor RPM': reading.motorRpm.toString(),
                              'ODOMeter': '${reading.odoMeterKm} km',
                              'Last Know Error': reading.lastError,
                              if (reading.lastTheftAlert != null)
                                'Last Anti-Theft Alert': reading.lastTheftAlert!,
                              if (reading.gyroscope != null)
                                'Gyroscope': 'x: ${reading.gyroscope![0]}, y: ${reading.gyroscope![1]}, z: ${reading.gyroscope![2]}',
                              if (reading.totalAirtime != null)
                                'Total Air-Time (s)': reading.totalAirtime!,
                            };

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: readingMap.length,
                              separatorBuilder: (context, index) => const Divider(thickness: 0.2, height: 22, color: Colors.grey),
                              itemBuilder: (context, index) {
                                final key = readingMap.keys.elementAt(index);
                                final value = readingMap.values.elementAt(index);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(key, style: theme.textTheme.bodyMedium),
                                    Text(value.toString(), style: theme.textTheme.titleMedium),
                                  ],
                                );
                              },
                            );
                          },
                          loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
                          error: (err, stack) => Text('Failed to get readings: $err'),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// Model Overview Section
              Expanded(flex: 5,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ref.watch(bikeMetadataProvider).when(
                      data: (bikeData) {
                        if (bikeData == null) return const Text('Select a bike and press Connect.');

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Model Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.grey[800])),
                            const SizedBox(height: 22),
                            Text(
                              bikeData.bikeModel,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                            ),
                            const SizedBox(height: 22),
                            Text(bikeData.bikeDescription, style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 30),
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