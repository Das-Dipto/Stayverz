import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatShimmer extends StatelessWidget {
  final int itemCount;
  final bool isDarkMode;

  const ChatShimmer({
    super.key,
    this.itemCount = 8,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    final highlightColor = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final isMe = index % 2 == 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar for others
              if (!isMe)
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: const CircleAvatar(radius: 18, backgroundColor: Colors.white),
                ),

              if (!isMe) const SizedBox(width: 8),

              // Chat bubble
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 40 + (index % 3) * 10, // variable bubble height
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                    ),
                  ),
                ),
              ),

              if (isMe) const SizedBox(width: 8),

              // Optional avatar for self (right bubble)
              if (isMe)
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: const CircleAvatar(radius: 18, backgroundColor: Colors.white),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Hello I am Tamim