import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:stayverz_flutter_app/core/constants/app_colors.dart';
import 'package:stayverz_flutter_app/core/utils/main_utils.dart';
import 'package:stayverz_flutter_app/features/assistance_service/bindings/assistance_service_binding.dart';
import 'package:stayverz_flutter_app/features/assistance_service/controllers/assistance_service_edit_controller.dart';
import 'package:stayverz_flutter_app/features/assistance_service/controllers/public_assistance_service_controller.dart';
import 'package:stayverz_flutter_app/features/listing/bindings/listing_binding.dart';
import 'package:stayverz_flutter_app/features/messaging/data/models/chat_room_model.dart' hide Listing;
import 'package:stayverz_flutter_app/main.dart';
import 'package:stayverz_flutter_app/widgets/profile_avatar_widget.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../../../../widgets/chat_shmmer_effect.dart';
import '../../../assistance_service/models/public_assistance_params.dart';
import '../../../../widgets/own_app_bar.dart';
import '../../../../widgets/recommended_listing_card_widget.dart';
import '../../../assistance_service/presentation/views/edit_assistance_listing_screen.dart';
import '../../../assistance_service/presentation/views/public_assistance_details_screen.dart';
import '../../../assistance_service/repositories/assistance_service_repository_impl.dart';
import '../../../assistance_service/repositories/assistance_service_repository_interface.dart';
import '../../../booking/presentation/views/book_and_go_screen.dart';
import '../../../booking/presentation/views/host_instant_booking_screen.dart';
import '../../../listing/controllers/listing_edit_controller.dart';
import '../../../listing/presentation/views/edit_listing_screen.dart';
import '../../../public_listings/presentation/views/public_listing_details_view.dart';
import '../../data/models/message_model.dart';
import '../../controllers/conversation_controller.dart';
import '../widgets/message_conversation_bottom_sheet.dart';
import '../widgets/long_press_bottom_sheet.dart';

class MessageConversationScreen extends GetView<ConversationController> {
  static const String routeName = '/message-conversation';

  final String conversationId;
  final dynamic? receiver;
  final dynamic? sender;
  final List<dynamic> roomMembers;
  final bool isGroupChat;
  final String status;

  MessageConversationScreen({
    super.key,
    required this.conversationId,
    required this.receiver,
    required this.sender,
    required this.isGroupChat,
    required this.roomMembers,
    required this.status,
  }) {
    // Initialize controller with conversation data
    final controller = Get.find<ConversationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeConversation(conversationId);
      controller.receiver = receiver;
      controller.sender = sender;
    });
  }

  @override
  void onReady() {
    // Refresh conversation data when screen becomes active again (after returning from back navigation)
    if (conversationId.isNotEmpty) {
      final controller = Get.find<ConversationController>();
      controller.initializeConversation(conversationId);
    }
  }


  @override
  Widget build(BuildContext context) {
    final controller = this.controller;

    Color statusTextColor = Colors.orangeAccent;
    if (status == 'confirmed') {
      statusTextColor = Colors.teal;
    }
    if (status == 'cancelled') {
      statusTextColor = Colors.red;
    }

    return Scaffold(
      appBar: OwnAppBar(
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
        appHeight: 50,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: BackButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                ProfileAvatarWidget(
                  url:
                      isGroupChat
                          ? roomMembers[0].avatar ?? ''
                          : sender?.avatar ?? '',
                  radius: 15,
                  size: 28,
                  iconColor: Colors.white60,
                ),
                if (isGroupChat)
                  Positioned(
                    right: -12,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 17,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ProfileAvatarWidget(
                          url: roomMembers[1].avatar ?? '',
                          radius: 17,
                          size: 28,
                          iconColor: Colors.white60,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isGroupChat
                        ? roomMembers
                            .map((tt) => (tt.name ?? '').split(" ").first)
                            .toList()
                            .join(", ")
                        : sender?.name ?? 'Unknown User',
                  ),
                  const Gap(2),
                  Text(
                    status.capitalize ?? 'Chat',
                    style: TextStyle(
                      color: statusTextColor,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // User status and typing indicator header
          // Booking details card (if available)
          if (Get.arguments?['showBookingDetails'] == true)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.94, color: Color(0xFFF0F1F5)),
                  borderRadius: BorderRadius.circular(7.53),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 79.10,
                      height: 79.10,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.36,
                        vertical: 14.12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Messages list
          Expanded(
            child: Obx(() {
              // Chatshimmer
              // if (controller.isLoading && !controller.isReloadThisConv.value) {
              //   return ChatShimmer(
              //     itemCount: 10,
              //     isDarkMode: Theme.of(context).brightness == Brightness.dark,
              //   );
              // }

              if (controller.errorMessage != null) {
                return Center(
                  child: Text(
                    controller.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text('No messages yet. Start the conversation!'),
                );
              }

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shrinkWrap: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message =
                      controller.messages[controller.messages.length -
                          1 -
                          index];

                  // ✅ Skip if same content as immediately previous message from same user
                  if (index < controller.messages.length - 1) {
                    final prevMessage = controller.messages[controller.messages.length - 2 - index];
                    if (prevMessage.content == message.content &&
                        prevMessage.user?.userId == message.user?.userId &&
                        message.mType != MType.SYSTEM) {
                      return const SizedBox.shrink();
                    }
                  }

                  if (message.mType == MType.SYSTEM) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      margin: EdgeInsets.only(bottom: 16, top: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200 /* white */,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Text(
                              message.content ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          if (message.meta?.listing != null)
                            SizedBox(
                              height: 20,
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        backgroundColor: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              const Text(
                                                'Booking Details',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),

                                              const SizedBox(height: 20),

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  _buildInfoRow(
                                                    'Check-in',
                                                    message.meta?.booking?.bookingDate?.checkIn != null
                                                        ? DateFormat("MMM dd, yyyy").format(
                                                      message.meta!.booking!.bookingDate!.checkIn!,
                                                    )
                                                        : '',
                                                  ),

                                                  _buildInfoRow(
                                                    'Check-out',
                                                    message.meta?.booking?.bookingDate?.checkOut != null
                                                        ? DateFormat("MMM dd, yyyy").format(
                                                      message.meta!.booking!.bookingDate!.checkOut!,
                                                    )
                                                        : '',
                                                  ),

                                                  _buildInfoRow(
                                                    'Guests',
                                                    "${message.meta?.booking?.bookingDate?.totalGuestCount ?? 0}",
                                                  ),

                                                  const SizedBox(height: 16),

                                                  _buildInfoRow(
                                                    'Total Nights',
                                                    '${message.meta?.booking?.checkoutData?.nights ?? 0}',
                                                  ),

                                                  _buildInfoRow(
                                                    'Total Price',
                                                    '৳${message.meta?.booking?.checkoutData?.totalPrice ?? 0}',
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 20),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [

                                                  /// ✅ Close Button
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text('Close'),
                                                  ),

                                                  /// ✅ View Details Button
                                                  if (message.meta?.listing != null)
                                                    TextButton(
                                                      onPressed: () async {

                                                        Navigator.pop(context); // 🔥 Close dialog first

                                                        bool isListingObject =
                                                        message.meta?.listing is Listing;

                                                       final listingId = isListingObject
                                                          ? message.meta?.listing?.uniqueId ?? ''
                                                          : message.meta?.listing?.toString() ?? '';

                                                      final listingIdBook = isListingObject
                                                          ? message.meta?.listing?.id?.toString() ?? ''  // int → String
                                                          : message.meta?.listing?.toString() ?? '';

                                                        if (listingId.isEmpty) {
                                                          Fluttertoast.showToast(
                                                            msg: "Listing ID not found.",
                                                            backgroundColor: Colors.red,
                                                          );
                                                          return;
                                                        }

                                                        /// 🔥 Your existing logic below unchanged
                                                        /// You can still use Get.to / Get.toNamed if needed

                                                        if (mainControl.uType.value == 'host') {

                                                          try {

                                                            if (message.meta?.instantBook == true) {

                                                              Get.toNamed(
                                                                HostInstantBookingScreen.routeName,
                                                                arguments: {
                                                                  'status': message.meta?.instantBookStatus,
                                                                  'assistance': message.meta?.assistance
                                                                },
                                                              );

                                                            } else {

                           if (message.meta?.assistance == true) {
  AssistanceServiceBinding().dependencies();
  final listingController = Get.find<AssistanceServiceEditController>();
  
  listingController.clearAllStates(); // ✅ clear stale data
  
  await listingController.fetchAssistanceSingleListingDetails(
    id: listingId, // ✅ pass id directly, before navigation
  );
  
  Get.to(
    () => EditAssistanceListingScreen(),
    arguments: {'id': listingId}, // ✅ navigate after fetch
  );
  return;
}

                                                          ListingBinding().dependencies();

final listingController = Get.find<ListingEditController>();

// 🔍 LOG 1 - check what IDs we have
print('=== VIEW DETAILS PRESSED ===');
print('message.meta?.listing: ${message.meta?.listing}');
print('isListingObject: $isListingObject');
print('listingId: $listingId');
print('listingIdBook: $listingIdBook');

listingController.clearAllStates();

print('createdListingId after clear: ${listingController.createdListingId}'); // 🔍 LOG 2

try {
 await listingController.fetchListingDetailsHost(
  id: listingIdBook, // ✅ now always a proper String
);
  print('fetch completed, listingDetails: ${listingController.listingDetails.value}'); // 🔍 LOG 3
} catch (e) {
  print('fetch ERROR: $e'); // 🔍 LOG 4
}

Get.to(() => EditListingScreen(), arguments: {'id': listingId});
}

                                                          } catch (e) {

                                                            Fluttertoast.showToast(
                                                              msg: e.toString(),
                                                              backgroundColor: Colors.red,
                                                            );
                                                          }

                                                        } else {

                                                          if (message.meta?.instantBook == true) {

                                                            Get.toNamed(
                                                              BookAndGoScreen.routeName,
                                                              arguments: {
                                                                'status': message.meta?.instantBookStatus,
                                                                'assistance': message.meta?.assistance,
                                                              },
                                                            );

                                                          } else {

                                                            if (message.meta?.assistance == true) {

                                                              var arguments = PublicAssistanceParams(
                                                                assistanceId: listingId,
                                                              ).toJson();

                                                              Get.toNamed(
                                                                PublicAssistanceDetailsScreen.route,
                                                                arguments: arguments,
                                                              );

                                                              return;
                                                            }

                                                            Get.to(
                                                                  () => PublicListingDetailsView(),
                                                              arguments: {'id': listingIdBook},
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: const Text('View Details'),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                    EdgeInsets.zero,
                                  ),
                                ),
                                child: Text('View Details'),
                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  if (MainUtils.looksLikeJson(message.content ?? '')) {
                    var data;
                    try {
                      data = json.decode(message.content ?? '');
                    } catch (e) {
                    }
                    return InkWell(
                      onTap:
                          () =>
                              mainControl.uType.value == 'host'
                                  ? {
                                    ListingBinding().dependencies(),
                                    Get.to(
                                      () => EditListingScreen(),
                                      arguments: {
                                        'id': data?['property_id'] ?? '',
                                      },
                                    ),
                                  }
                                  : Get.to(
                                    PublicListingDetailsView(),
                                    arguments: {
                                      'id': data?['property_id'] ?? '',
                                    },
                                  ),
                      child: RecommendedListingCard(
                        name: data?['message'] ?? '',
                        message: data?['cost'] ?? '',
                        imageURL: data?['image'] ?? '',
                        width: MediaQuery.of(context).size.width * 0.6,
                        avatarImage:
                            "${message.user?.userId ?? 0}" ==
                                    controller.currentUserId
                                ? controller.receiver?.avatar ?? ''
                                : message.user?.image,
                        isCurrentUser:
                            "${message.user?.userId ?? 0}" ==
                            controller.currentUserId,
                      ),
                    );
                  }

                  return _buildMessageBubble(message);
                },
              );
            }),
          ),
          // Message input area
          Obx(() {
            if (!controller.isTyping.value) return SizedBox();
            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/typing-animation.gif', height: 35),
              ),
            );
          }),
          Obx(() {
            if (controller.isLoading && !controller.isReloadThisConv.value) {
              return SizedBox();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(color: Colors.white),
                  child: SafeArea(
                    child: Row(
                      children: [
                        if (mainControl.uType.value == 'host')
                          SizedBox(
                            height: 38,
                            width: 38,
                            child: IconButton(
                              onPressed: _showModalBottomSheet,
                              icon: const Icon(Icons.add, size: 22),
                            ),
                          ),
                        const Gap(8),
                        Expanded(
                          child: Obx(() => SizedBox(   // <-- wrap here
                            height: 44,
                            child: CustomInputText(
                              controller: controller.messageController,
                              focusNode: controller.focusNode,
                              onTap: controller.onTextFieldTap,
                              onChange: (value) => controller.onMessageTyping(value),
                              prefixIcon: IconButton(
                                onPressed: controller.toggleEmojiPicker,
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  controller.isEmojiPickerVisible
                                      ? Icons.keyboard
                                      : Icons.emoji_emotions_outlined,
                                  size: 26,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: controller.canSendMessage.value
                                    ? () => controller.sendMessage()
                                    : null,
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.send,
                                  size: 22,
                                  color: controller.canSendMessage.value
                                      ? AppColors.primaryColor
                                      : Colors.grey,
                                ),
                              ),
                              helperText: 'Type a message...',
                              fillColor: Colors.white,
                              borerRadius: 4,
                              borderColor: const Color(0xFFE6E8EE),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                // Emoji picker
                if (controller.isEmojiPickerVisible)
                  SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        // textEditingController automatically handles emoji insertion
                        // Just trigger typing event for UI updates
                        controller.onMessageTyping(
                          controller.messageController.text,
                        );
                      },
                      onBackspacePressed: () {
                        // textEditingController handles backspace button automatically when provided
                        controller.onMessageTyping(
                          controller.messageController.text,
                        );
                      },
                      textEditingController: controller.messageController,
                      config: const Config(
                        height: 250,
                        checkPlatformCompatibility: true,
                        categoryViewConfig: CategoryViewConfig(
                          backgroundColor: Colors.white,
                        ),
                        bottomActionBarConfig: BottomActionBarConfig(
                          backgroundColor: Colors.black12,
                          showSearchViewButton: false,
                          buttonIconColor: Colors.black54,
                        ),
                        emojiViewConfig: EmojiViewConfig(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageData message) {
    final isCurrentUser =
        "${message.user?.userId ?? 0}" == controller.currentUserId;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: ProfileAvatarWidget(
                url: message.user?.image ?? '',
                size: 18,
              ),
            ),
            const Gap(8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser && isGroupChat)
                  Padding(
                    padding: const EdgeInsets.only(left: 6, bottom: 4),
                    child: Text(
                      (message.user?.fullName ?? '').split(" ").first,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                GestureDetector(
                  onLongPress: () => _showLongPressModalBottomSheet(message),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isCurrentUser
                              ? const Color(0xFFF15925)
                              : const Color(0xFFDCDEE3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content ?? '',
                          style: TextStyle(
                            color: isCurrentUser ? Colors.white : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Gap(4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatMessageTime(message.createdAt),
                              style: TextStyle(
                                color:
                                    isCurrentUser
                                        ? Colors.white70
                                        : Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                            if (isCurrentUser) ...[
                              const Gap(4),
                              Icon(
                                (message.isRead ?? false)
                                    ? Icons.done_all
                                    : Icons.done,
                                size: 12,
                                color:
                                    (message.isRead ?? false)
                                        ? Colors.blue
                                        : Colors.white70,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentUser) ...[
            const Gap(8),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: ProfileAvatarWidget(
                url: message.user?.image ?? '',
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Now';
    }
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MessageConversationBottomSheet(),
    );
  }

  void _showLongPressModalBottomSheet(MessageData message) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LongPressBottomSheet(message: message),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Hello I am Tamim