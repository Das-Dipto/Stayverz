import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/own_app_bar.dart';
import '../../repositories/notification_repository_impl.dart';
import '../controller/notification_controller.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();
  late final NotificationController controller;

  @override
  void initState() {
    super.initState();

    // Initialize controller if not already registered
    if (!Get.isRegistered<NotificationController>()) {
      Get.put(
        NotificationController(
          repository: NotificationRepositoryImpl(),
        ),
      );
    }
    controller = Get.find<NotificationController>();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (!controller.isLoading.value &&
          controller.notifications.length < controller.totalNotifications.value) {
        controller.loadMoreNotifications();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OwnAppBar(
        appHeight:60,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
        child: const Align(
          alignment: AlignmentDirectional.center,
          child: Text(
            'Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF090909),
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Obx(() {
        // Show loading indicator on initial load
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF090909)),
            ),
          );
        }

        // Show error message if any (only when no data)
        if (controller.errorMessage.isNotEmpty &&
            controller.notifications.isEmpty) {
          return _buildErrorState();
        }

        // Show empty state
        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        // Show notifications list
        return RefreshIndicator(
          onRefresh: () => controller.refreshNotifications(),
          color: const Color(0xFF090909),
          child: ListView.separated(
            controller: _scrollController,
            itemCount: controller.notifications.length +
                (controller.isLoading.value ? 1 : 0),
            padding: const EdgeInsets.symmetric(vertical: 24),
            separatorBuilder: (context, index) {
              if (index >= controller.notifications.length) {
                return const SizedBox.shrink();
              }
              return const Divider(
                height: 24,
                thickness: 1,
                color: Color(0xFFF5F5F5),
              );
            },
            itemBuilder: (context, index) {
              // Show loading indicator at the bottom while loading more
              if (index >= controller.notifications.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF090909)),
                    ),
                  ),
                );
              }

              final notification = controller.notifications[index];
              return _buildNotificationItem(notification);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationItem(notification) {
    return InkWell(
      onTap: () {
        // Show native Flutter dialog
        showDialog(
          context: Get.context!,
          barrierDismissible: true,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Notification",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      notification.data?.message ?? "No message available",
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        // Optional: navigate if link exists
        if (notification.data?.link != null &&
            notification.data!.link.isNotEmpty) {
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundImage: (notification.user != null &&
                      notification.user!.image != null &&
                      notification.user!.image!.isNotEmpty)
                      ? NetworkImage(notification.user!.image!) as ImageProvider
                      : const AssetImage("assets/default_avatar.jpg") as ImageProvider,
                ),
                if (!notification.isRead)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF090909),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.data?.message ?? 'No message available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: notification.isRead
                          ? const Color(0xFF989B9D)
                          : const Color(0xFF3D3F40),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: notification.isRead
                          ? FontWeight.w400
                          : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatDate(notification.createdAt),
                        style: const TextStyle(
                          color: Color(0xFF989B9D),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                      ),
                      if (notification.eventType.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            notification.eventType,
                            style: const TextStyle(
                              color: Color(0xFF989B9D),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 64,
                color: Color(0xFF989B9D),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Notifications',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF090909),
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No notification isn\'t available \nright now!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF989B9D),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF5F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Color(0xFFFF6B6B),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Failed to Load',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF090909),
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getErrorMessage(controller.errorMessage.value),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF989B9D),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.refreshNotifications(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF090909),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(String error) {
    if (error.contains('Authentication failed')) {
      return 'Please login again to continue';
    } else if (error.contains('No internet connection')) {
      return 'Please check your internet connection';
    } else if (error.contains('timeout')) {
      return 'Request timed out. Please try again';
    }
    return 'Something went wrong. Please try again';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }
}

// Hello I am Tamim