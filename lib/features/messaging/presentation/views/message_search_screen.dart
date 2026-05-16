import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../widgets/own_app_bar.dart';
import '../../controllers/inbox_controller.dart';
import 'message_conversation_page.dart';


class MessageSearchScreen extends GetView<InboxController> {
  MessageSearchScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back),
                ),
                const Gap(10),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: controller.updateSearchText,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        Obx(
                              () => controller.searchText.isNotEmpty
                              ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              controller.clearSearch();
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                              size: 20,
                            ),
                          )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        // Loading shimmer
        if (controller.isChatSearching) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: 8,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 12,
                          color: Colors.grey.shade300,
                        ),
                        const Gap(6),
                        Container(
                          width: double.infinity,
                          height: 12,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Empty state
        if (controller.chatList.isEmpty) {
          return const Center(
            child: Text(
              "No chat results found.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        // Search results
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: controller.chatList.length,
          separatorBuilder: (_, __) => const Gap(12),
          itemBuilder: (context, index) {
            final chat = controller.chatList[index];
            final fromUser = chat.fromUser?.name ?? "Unknown";
            final toUser = chat.toUser?.name ?? "Unknown";

            return InkWell(
              onTap: (){
                Get.toNamed(
                  MessageConversationScreen.routeName,
                  arguments: {
                    'conversationId': chat.id,
                    'receiver': chat.toUser ?? '', // Fallback to room.id if toUser.id is null
                    'sender': chat.fromUser ?? '',
                    'is_group_chat': false,
                    'room_members': [],
                    'status': chat.status
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: chat.toUser?.avatar.isNotEmpty == true
                          ? NetworkImage(chat.toUser!.avatar)
                          : null,
                      child: chat.toUser?.avatar.isEmpty == true
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$fromUser → $toUser",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            chat.matchedMessage?.content ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 14),
                          ),
                          const Gap(4),
                          Text(
                            chat.listing?.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    // chat.status == "inquiry"
                    //     ? Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 6, vertical: 2),
                    //   decoration: BoxDecoration(
                    //     color: Colors.blue.shade100,
                    //     borderRadius: BorderRadius.circular(6),
                    //   ),
                    //   child: const Text(
                    //     "Inquiry",
                    //     style: TextStyle(
                    //       color: Colors.blue,
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    // )
                    //     : const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// Hello I am Tamim