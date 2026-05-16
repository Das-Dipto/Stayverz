import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuildEmptyStateWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool showRefreshButton;
  const BuildEmptyStateWidget({super.key, this.onRetry, this.showRefreshButton = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const Gap(16),
          Text(
            'No listings found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const Gap(8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if(showRefreshButton)...[const Gap(24),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Refresh'),
          ),]
        ],
      ),
    );
  }
}

// Hello I am Tamim