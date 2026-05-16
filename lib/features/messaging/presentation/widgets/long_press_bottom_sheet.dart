import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../data/models/message_model.dart';

/// Bottom sheet widget for message long press actions (copy, delete, etc.)
class LongPressBottomSheet extends StatelessWidget {
  final MessageData message;

  const LongPressBottomSheet({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Message preview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message.content ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Action items
          ListTile(
            leading: const Icon(
              Icons.copy,
              color: Color(0xFFF15925),
            ),
            title: const Text(
              'Copy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Get.back();
              _handleCopyMessage();
            },
          ),
          
          // if (_canDeleteMessage()) ...[
          //   ListTile(
          //     leading: const Icon(
          //       Icons.edit,
          //       color: Color(0xFFF15925),
          //     ),
          //     title: const Text(
          //       'Edit',
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     onTap: () {
          //       Get.back();
          //       _handleEditMessage();
          //     },
          //   ),
          //
          //   ListTile(
          //     leading: const Icon(
          //       Icons.delete,
          //       color: Colors.red,
          //     ),
          //     title: const Text(
          //       'Delete',
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w500,
          //         color: Colors.red,
          //       ),
          //     ),
          //     onTap: () {
          //       Get.back();
          //       _handleDeleteMessage();
          //     },
          //   ),
          // ],
          
          // Safe area padding at bottom
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _handleCopyMessage() {
    Clipboard.setData(ClipboardData(text: message.content ?? ''));
    Get.snackbar(
      'Copied',
      'Message copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFF15925),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleEditMessage() {
    // TODO: Implement message editing
    // This would typically open an edit dialog or navigate to edit screen
    Get.snackbar(
      'Edit',
      'Message editing not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleDeleteMessage() {
    // Show confirmation dialog before deleting
    // Get.dialog(
    //   AlertDialog(
    //     title: const Text('Delete Message'),
    //     content: const Text('Are you sure you want to delete this message? This action cannot be undone.'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Get.back(),
    //         child: const Text('Cancel'),
    //       ),
    //       TextButton(
    //         onPressed: () {
    //           Get.back();
    //           _performDeleteMessage();
    //         },
    //         style: TextButton.styleFrom(
    //           foregroundColor: Colors.red,
    //         ),
    //         child: const Text('Delete'),
    //       ),
    //     ],
    //   ),
    // );
  }

  void _performDeleteMessage() {
    // TODO: Implement actual message deletion via controller/repository
    Get.snackbar(
      'Deleted',
      'Message deletion not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  bool _canDeleteMessage() {
    // TODO: Check if current user can delete this message
    // Typically only the sender can delete their own messages
    // For now, allow deletion for all messages (placeholder logic)
    return true;
  }
}

// Hello I am Tamim