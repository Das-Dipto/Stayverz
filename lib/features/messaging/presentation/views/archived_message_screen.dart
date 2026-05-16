import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import '../../../../widgets/chat_shmmer_effect.dart';
import '../../../../widgets/own_app_bar.dart';
import '../../controllers/inbox_controller.dart';


class ArchivedMessageScreen extends GetView<InboxController> {
  const ArchivedMessageScreen({super.key});
  static const String route = '/archived-message';

  @override
  Widget build(BuildContext context) {
    controller.setupArchivedScrollListener(); // Scroll listener for lazy load
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 90,
        child: Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
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
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  ' Archived Messages',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF090909),
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.27,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    body: Obx(() {
      if (controller.isArchivedLoading.value && controller.archivedChats.isEmpty) {
        // First load spinner
        return ChatShimmer(
          itemCount: 7,
          // isDarkMode:
        );
      }

      if (controller.archivedChats.isEmpty) {
        // No archived chats
        return const Center(
          child: Text(
            'No archived messages',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        );
      }

      // Show archived chat list
      return ListView.separated(
        controller: controller.archivedScrollController,
        padding: EdgeInsets.fromLTRB(
            20, 35, 20, MediaQuery.of(context).padding.bottom + 35),
        itemCount: controller.archivedChats.length + 1,
        separatorBuilder: (context, index) => const Divider(height: 40),
        itemBuilder: (context, index) {
          if (index < controller.archivedChats.length) {
            final chat = controller.archivedChats[index];
            final fromUser = chat.fromUser;
            final toUsers = chat.toUser;

            String roleText = '';
            if (toUsers.isNotEmpty) {
              roleText = toUsers.first.username.contains('host') ? 'Host' : '';
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile image
                    Container(
                      width: 50,
                      height: 50,
                      decoration: ShapeDecoration(
                        shape: const OvalBorder(),
                        image: DecorationImage(
                          image: NetworkImage(
                            fromUser?.image ??
                                'https://via.placeholder.com/50',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Name + message
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              fromUser?.fullName ?? fromUser?.username ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.38,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (roleText.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFF1F87E2),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  roleText,
                                  style: const TextStyle(
                                    color: Color(0xFF1F87E2),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.33,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat.latestMessage?.content ?? '',
                          style: const TextStyle(
                            color: Color(0xFF989B9D),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Archive button
                SizedBox(
                  width: 52,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xB2E0E0E0)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      // Unarchive the chat and remove from list
                      controller.archiveChat(roomId: chat.id, archived: false);
                      await controller.loadChatRooms();
                    },
                    child: Image.asset(
                      'assets/archive_icon.png',
                      fit: BoxFit.cover,
                      height: 19,
                      width: 19,
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Bottom loader for lazy load
            return Obx(() => controller.isArchivedLoadingMore.value
                ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
                : const SizedBox());
          }
        },
      );
    }),

    );
  }
}

// Hello I am Tamim