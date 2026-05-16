import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../controllers/profile_controller.dart';

class GuestReviewScreen extends GetView<ProfileController> {
  const GuestReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger fetch when screen opens (only once)
    Future.microtask(() {
      controller.getUserReviews();
      controller.getMyGivenReviews();
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            'Reviews',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.deepOrange.shade400,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelColor: Colors.black,          // Selected tab text color
                  unselectedLabelColor: Colors.black54,
                  tabs: const [
                    Tab(text: 'My Reviews'),
                    Tab(text: 'Given Reviews'),
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            /// My Reviews Tab
            Obx(() {
              final reviews = controller.userReviews;
              if (controller.isLoadingReview.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (reviews.isEmpty) return const _EmptyReviewState();
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => const Gap(16),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return ReviewCardWidget(
                    userImage: review.reviewBy?.image ?? '',
                    userName: review.reviewBy?.fullName ?? 'Unknown User',
                    listingTitle: review.listing?.title ?? 'No Title',
                    listingImage: review.listing?.coverPhoto ?? '',
                    rating: review.rating ?? 0,
                    reviewText: review.review?.trim().isEmpty == true
                        ? 'No review text provided.'
                        : review.review!,
                    date: review.createdAt ?? '',
                  );
                },
              );
            }),

            /// Given Reviews Tab
            Obx(() {
              final reviews = controller.givenReviews;
              if (controller.isLoadingGivenReview.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (reviews.isEmpty) return const _EmptyReviewState(
                message: 'You haven’t given any reviews yet.',
              );
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => const Gap(16),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return ReviewCardWidget(
                    userImage: review.reviewBy?.image ?? '',
                    userName: review.reviewBy?.fullName ?? 'Unknown User',
                    listingTitle: review.listing?.title ?? 'No Title',
                    listingImage: review.listing?.coverPhoto ?? '',
                    rating: review.rating ?? 0,
                    reviewText: review.review?.trim().isEmpty == true
                        ? 'No review text provided.'
                        : review.review!,
                    date: review.createdAt ?? '',
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Empty review state
class _EmptyReviewState extends StatelessWidget {
  final String message;

  const _EmptyReviewState({
    this.message = 'No Reviews Yet',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.reviews_outlined,
              size: 70,
              color: Colors.orange,
            ),
            const Gap(16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(8),
            if (message.contains('haven’t'))
              Text(
                'Book a stay and share your experience!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }
}


/// 📭 Empty review state widget
// class _EmptyReviewState extends StatelessWidget {
//   const _EmptyReviewState();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.reviews_outlined,
//               size: 70,
//               color: Colors.grey,
//             ),
//             const Gap(16),
//             Text(
//               'No Reviews Yet',
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const Gap(8),
//             Text(
//               'You haven’t written any reviews yet.\nBook a stay and share your experience!',
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class ReviewCardWidget extends StatelessWidget {
  final String userImage;
  final String userName;
  final String listingTitle;
  final String listingImage;
  final int rating;
  final String reviewText;
  final String date;

  const ReviewCardWidget({
    super.key,
    required this.userImage,
    required this.userName,
    required this.listingTitle,
    required this.listingImage,
    required this.rating,
    required this.reviewText,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Reviewer Row
          Row(
            children: [
              CircleAvatar(
                backgroundImage: userImage.isNotEmpty
                    ? NetworkImage(userImage)
                    : const AssetImage('assets/images/user_placeholder.png')
                as ImageProvider,
                radius: 22,
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                date.split('T').first,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),

          const Gap(12),

          /// Listing preview
          if (listingImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                listingImage,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          const Gap(10),

          Text(
            listingTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),

          const Gap(6),

          /// Rating stars
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 18,
              ),
            ),
          ),

          const Gap(8),

          Text(
            reviewText,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
// Hello I am Tamim