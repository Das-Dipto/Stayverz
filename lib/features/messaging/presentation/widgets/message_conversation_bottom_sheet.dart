import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/messaging/controllers/conversation_controller.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';

import '../../../listing/models/listing_model.dart';
import '../views/quick_replies_page.dart';
import '../views/share_recommendation_page.dart';

/// Bottom sheet widget for message conversation actions (photo, camera, file)
class MessageConversationBottomSheet extends GetView<ConversationController> {
  const MessageConversationBottomSheet({super.key});

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
          
          // Action items
          ListTile(
            leading: const Icon(
              OwnIcons.quick_replies_icon,
              color: Color(0xFFF15925),
            ),
            title: const Text(
              'Quick Replies',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Get.back();
              // TODO: Implement photo picker
              _handleQuickRepliesSelection();
            },
          ),
          
          ListTile(
            leading: const Icon(
              OwnIcons.share_recommendation_icon,
              color: Color(0xFFF15925),
            ),
            title: const Text(
              'Share Recommendation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Get.back();
              // TODO: Implement camera
              _handleShareRecommendationSelection();
            },
          ),
          // Safe area padding at bottom
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _handleQuickRepliesSelection() async {
    var result = await Get.to(QuickRepliesScreen());
    controller.messageController.text = result ?? '';
    controller.canSendMessage.value = true;
  }

  void _handleShareRecommendationSelection() async {
    Get.toNamed(ShareRecommendationScreen.routeName);
  }

}

// Hello I am Tamim