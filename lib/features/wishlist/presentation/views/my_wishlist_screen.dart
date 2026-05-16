import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/features/wishlist/presentation/bindings/wishlist_binding.dart';
import 'package:stayverz_flutter_app/features/wishlist/presentation/controllers/wishlist_controller.dart';

import '../../../../generated/assets.dart';
import '../../../../views/home_root/guest_bottom_navigation_bar_view.dart';
import '../../../public_listings/data/models/wish_list_model.dart';
import '../../../public_listings/presentation/views/public_listing_details_view.dart';

class MyWishlistScreen extends GetView<WishlistController> {
  const MyWishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize bindings when the view is first built
    if (!Get.isRegistered<WishlistController>()) {
      WishlistBinding().dependencies();
    }
    
    // Fetch wishlist items when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchWishlistItems();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, // Sets the back arrow color
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.wishlistItems.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orangeAccent,
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${controller.errorMessage.value}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchWishlistItems(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.wishlistItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Your wishlist is empty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 8),
                // const Text(
                //   'Browse listings and add them to your wishlist',
                //   style: TextStyle(color: Colors.grey),
                // ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.to(GuestBottomNavigationBarView()), // Go back to browse listings
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Browse Listings'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchWishlistItems(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.wishlistItems.length,
            itemBuilder: (context, index) {
              final item = controller.wishlistItems[index];
              return _buildWishlistItem(item);
            },
          ),
        );
      }),
    );
  }

  Widget _buildWishlistItem(WishlistItem item) {
    final listing = item.listing;

    if (listing == null) {
      // If no my_listing data, show placeholder or empty container
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Get.to(PublicListingDetailsView(), arguments: {'id': listing.uniqueId});
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  child: Image.network(
                    listing.coverPhoto ?? '',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.assetsDefaultImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        if (listing.id != null) {
                          controller.removeFromWishlist(listing.id!);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Item details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.address ?? 'No Address',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\৳ ${listing.price?.toStringAsFixed(2) ?? '0.00'} / night',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            (listing.avgRating ?? 0).toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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

}

// Hello I am Tamim