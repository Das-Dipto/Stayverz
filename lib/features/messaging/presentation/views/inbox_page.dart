import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/main_controller.dart';
import 'package:stayverz_flutter_app/widgets/profile_avatar_widget.dart';
import '../../../../core/utils/main_utils.dart';
import '../../../../widgets/chat_shmmer_effect.dart';
import '../../../../widgets/custom_tab_button.dart';
import '../../../../widgets/own_app_bar.dart';
import '../../controllers/inbox_controller.dart';
import '../../data/models/chat_room_model.dart' show ChatRoomData, User;
import 'inbox_settings_screen.dart';
import 'message_conversation_page.dart';
import 'message_search_screen.dart';

class InboxScreen extends GetView<InboxController> {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mc = Get.find<MainController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute == '/inbox') { // Replace with your actual route
        controller.loadChatRooms();
        
        // Set default tab based on user type
        if (mc.uType.value == 'guest') {
          controller.selectTab(2); // Select Guest/Host tab for guests
        }
      }
    });
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 135,
        child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Inbox Messages',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: const Color(0xFF090909),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(
                              () => MessageSearchScreen(),
                          transition: Transition.downToUp, // slide animation
                          duration: const Duration(milliseconds: 450),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF7F7F7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Icon(Icons.search),
                      ),
                    ),
                    const Gap(14),
                    InkWell(
                      onTap: () {  Get.toNamed(InboxSettingsScreen.route)?.then((_) {
                        // This will run when you come back from InboxSettingsScreen
                        controller.loadChatRooms();
                      });},
                      child: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(10),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF7F7F7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Icon(Icons.settings_outlined)
                      ),
                    ),
                  ],
                ),
                const  Gap(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTabButton(
                      text: 'All',
                      isSelected: controller.selectedTabIndex == 0,
                      onTap: () => controller.selectTab(0),
                    ),
                    CustomTabButton(
                      text: 'Unread',
                      isSelected: controller.selectedTabIndex == 1,
                      onTap: () => controller.selectTab(1),
                    ),
                    CustomTabButton(
                      text: mc.uType.value == 'guest'?"Host": 'Guest',
                      isSelected: controller.selectedTabIndex == 2,
                      onTap: () => controller.selectTab(2),
                    ),
                    CustomTabButton(
                      text: 'Stayverz',
                      isSelected: controller.selectedTabIndex == 3,
                      onTap: () => controller.selectTab(3),
                    ),
                  ],
                )
              ],
            );
          }
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // Show error message if any
              if (controller.errorMessage != null) {
                return _buildErrorView();
              }

              // Show loading indicator
              if (controller.isLoading && !controller.isReloadConv.value) {
                return SizedBox();

                //   ChatShimmer(
                //   itemCount: 10,
                //   isDarkMode: Theme.of(context).brightness == Brightness.dark,
                // );
              }

              // Show empty state for filtered results
              if (controller.filteredChatRooms.isEmpty) {
                return _buildEmptyView();
              }

              // Show filtered chat rooms list
              return RefreshIndicator(
                onRefresh: controller.refreshChatRooms,
                color: const Color(0xFFF15925),
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 16, bottom: 40,right: 16,top: 10),
                  itemBuilder: (context, index) {
                    final room = controller.filteredChatRooms[index];
                    return InboxListItem(room: room);
                  },
                  separatorBuilder: (context, index) => const Divider(
                    height: 30,
                    thickness: 0.8,
                  ),
                  itemCount: controller.filteredChatRooms.length,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey,
          ),
          const Gap(16),
          Obx(() {
            final errorMsg = controller.errorMessage;
            return Text(
              errorMsg ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            );
          }),
          const Gap(24),
          ElevatedButton(
            onPressed: controller.retryConnection,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF15925),
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You have no messages right now!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF3D3F40),
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          const Gap(8),
          const Text(
            'When you contact a host or send a reservation request, you\'ll see your messages here.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Color(0xFF989B9D),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }
}

class InboxListItem extends StatelessWidget {
  final ChatRoomData room;

  const InboxListItem({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    MainController mc = Get.find<MainController>();
    InboxController Inbox = Get.find<InboxController>();
    final myUserId = mc.userId.value;
    final matchWithParticipant = "${room.sender?.userId ?? 0}" == myUserId;
    bool isGroupChat = false;

    List nameSplit = (room.name ?? '').split(':');

    if(nameSplit.length > 2) {
      isGroupChat = true;
    }else{
      isGroupChat = false;
    }

    List<User> roomMembers = [];
   // only change else if to if here
    if(isGroupChat && mc.uType.value == 'host') {
        User uo = room.receiverList.firstWhere((e) => "${e.userId}" != myUserId);
        roomMembers = [room.sender!, uo];
    }
    if(isGroupChat && mc.uType.value == 'guest') {
        roomMembers = room.receiverList;
    }
    // only change else if to if here

    User? receiverUser;
    User? senderUser;
    if(matchWithParticipant) {
      receiverUser = room.receiver;
      senderUser = room.sender;
    } else {
      receiverUser = room.sender;
      senderUser = room.receiver;
    }
    Color statusTextColor = Colors.orangeAccent;
    if(room.status == 'confirmed') {
      statusTextColor = Colors.teal;
    }
    if(room.status == 'cancelled') {
      statusTextColor = Colors.red;
    }

    String theLastMessage = room.lastMessage ?? '';

    if(MainUtils.looksLikeJson(theLastMessage)) {
      var data;
      try {
        data = json.decode(theLastMessage);
      }catch(e) {
      }
     theLastMessage = "Property: ${data?['message'] ?? ''}";
    }

    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Archive Chat',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: const Text(
                'Are you sure you want to archive this conversation?',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: ()async {
                    Navigator.of(context).pop(); // close dialog first

                    // 🔥 CALL CONTROLLER METHOD
                  await  Inbox.archiveChat(
                      roomId: "${room.id}",   // dynamic id
                      archived: true,    // 👈 pass TRUE
                    );

                    await Inbox.loadChatRooms();

                     Inbox.onReady();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF15925),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  ),
                  child: const Text(
                    'Yes, Archive',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },

      onTap: () {
        Get.toNamed(
          MessageConversationScreen.routeName,
          arguments: {
            'conversationId': room.id,
            'receiver': receiverUser ?? '', // Fallback to room.id if toUser.id is null
            'sender': senderUser ?? '',
            'is_group_chat': isGroupChat,
            'room_members': roomMembers,
            'status': room.status
          },
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 70),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile avatar with online indicator
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Stack(  
                clipBehavior: Clip.none,
                children: [
                  ProfileAvatarWidget(
                    url: isGroupChat ? roomMembers[0].avatar ?? '' : receiverUser?.avatar ?? '',
                    radius: 23,
                    size: 28,
                    iconColor: Colors.white60
                  ),
                  if(isGroupChat)Positioned(
                    right: -12,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ProfileAvatarWidget(
                            url: roomMembers[1].avatar ?? '',
                            radius: 22,
                            size: 28,
                            iconColor: Colors.white60
                        ),
                      ),
                    ),
                  ),
                  // Online indicator
                  if ((receiverUser?.isOnline ?? false) && !isGroupChat)
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First row: Status and Date
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          (room.status ?? 'Chat').capitalize ?? 'Chat',
                          style: TextStyle(
                            color: statusTextColor,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatDate(room.lastMessageTime),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Second row: Name and unread count
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          isGroupChat ? roomMembers.map((tt) => (tt.name ?? '').split(" ").first).toList().join(", ") : receiverUser?.name ?? 'Unknown User',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (room.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF15925),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            room.unreadCount > 99 ? '99+' : '${room.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Third row: Last message preview
                  Text(
                    theLastMessage.trim(),
                    style: TextStyle(
                      color: room.unreadCount > 0 ? Colors.black87 : Colors.grey[600],
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: room.unreadCount > 0 ? FontWeight.w600 : FontWeight.w300,
                      height: 1.3,
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
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    }
  }
}

// Hello I am Tamim