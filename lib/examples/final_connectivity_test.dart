import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/connectivity_controller.dart';
import 'package:stayverz_flutter_app/services/network/connectivity_service.dart';

/// Final connectivity test page - updated for simplified API
class FinalConnectivityTest extends StatelessWidget {
  const FinalConnectivityTest({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConnectivityController>();
    final service = Get.find<ConnectivityService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Connectivity Test'),
      ),
      body: GetX<ConnectivityController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Status display
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Connected: ${controller.isConnected}'),
                        Text('Disconnected: ${controller.isDisconnected}'),
                        Text('Message: ${controller.connectionMessage}'),
                        Text('Retrying: ${controller.isRetrying}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Manual check button
                ElevatedButton(
                  onPressed: () async {
                    final result = await controller.checkConnectivity();
                    Get.snackbar('Check', result ? 'Connected' : 'Disconnected');
                  },
                  child: const Text('Check Now'),
                ),

                const SizedBox(height: 8),

                // Retry button
                ElevatedButton(
                  onPressed: controller.isRetrying
                      ? null
                      : () => controller.retryConnection(),
                  child: controller.isRetrying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Retry Connection'),
                ),

                const SizedBox(height: 8),

                // Get connection info
                ElevatedButton(
                  onPressed: () {
                    final info = controller.getConnectionInfo();
                    Get.snackbar(
                      'Connection Info',
                      'Status: ${info['status']}\nConnected: ${info['isConnected']}',
                      duration: const Duration(seconds: 3),
                    );
                  },
                  child: const Text('Show Connection Info'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Hello I am Tamim