import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/public_listing_details_view.dart';

import '../../../../generated/assets.dart';
import '../../../wishlist/presentation/controllers/wishlist_controller.dart';
import '../../data/models/search_view_modle.dart';
import '../controllers/public_listings_controller.dart';

class NewSearchViewScreen extends GetView<PublicListingsController> {
  const NewSearchViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();

    final Map<String, dynamic> searchData = Get.arguments ?? storage.read('lastSearch') ?? {};

// Extract values safely
    final SectionModel? selectedLocation = searchData['location'];
    final String locationName = searchData['locationName'] ?? '';

   // final List<DateTime?> dateRange = searchData['dateRange'] ?? [];
    final String dateText = searchData['dateText'] ?? 'Any week';

    final int adults = searchData['adults'] ?? 0;
    final int children = searchData['children'] ?? 0;
    final int infants = searchData['infants'] ?? 0;
    final int pets = searchData['pets'] ?? 0;

    final int totalGuests = adults + children;

    final double lat = searchData['lat'] ?? 0.0;
    final double long = searchData['long'] ?? 0.0;

    final String locationId = "${searchData['locationId']}" ?? "";
    final String startDate = searchData['start_date'] ?? '';
    final String endDate = searchData['end_date'] ?? '';

    /// 🔹 Trigger API call once when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUpdatedListings(
        id: locationId.isNotEmpty ? int.tryParse(locationId) : null,
        latitude: locationId.isEmpty ? lat : null,
        longitude: locationId.isEmpty ? long : null,
        radius: locationId.isEmpty ? 6 : null,
        guests: totalGuests > 0 ? totalGuests : null,
        checkIn: startDate.isNotEmpty ? startDate : null,
        checkOut: endDate.isNotEmpty ? endDate : null,
        // loadMore: true
      );

    });

    return Scaffold(
    //  backgroundColor: const Color(0xFFF5F6F7),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              margin:  const EdgeInsets.only(left: 10,right: 10),
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFE4E9EC),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child:  Image.asset("assets/back_icons.png",height: 19,width:23,),

                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          locationName.isNotEmpty
                              ? locationName
                              : 'Any location',
                          style: const TextStyle(
                            color: Color(0xFF3D3F40),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            _InfoItem(
                              icon: Icons.calendar_today_outlined,
                              text: dateText,
                            ),
                            if (adults > 0)
                              _InfoItem(
                                icon: Icons.person,
                                text:
                                '$adults ${adults == 1 ? 'Adult' : 'Adults'}',
                              ),
                            if (children > 0)
                              _InfoItem(
                                icon: Icons.person_outline,
                                text:
                                '$children ${children == 1 ? 'Child' : 'Children'}',
                              ),
                            if (infants > 0)
                              _InfoItem(
                                icon: Icons.child_care,
                                text:
                                '$infants ${infants == 1 ? 'Infant' : 'Infants'}',
                              ),
                            if (pets > 0)
                              _InfoItem(
                                icon: Icons.pets,
                                text:
                                '$pets ${pets == 1 ? 'Pet' : 'Pets'}',
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoadingListings.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasErrorListings.value) {
          return Center(
            child: Text(controller.errorMessageListings.value),
          );
        }

        if (controller.newListings.isEmpty) {
          return const Center(child: Text('No results found',style: TextStyle(color: Colors.black,fontSize: 16 ),));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              controller.fetchUpdatedListings(loadMore: true);
            }
            return false;
          },
          child: ListView.separated(
             padding: const EdgeInsets.symmetric(horizontal: 10),
            separatorBuilder: (context, index) => const Gap(14),
            itemCount: controller.newListings.length,
            itemBuilder: (context, index) {
              final item = controller.newListings[index];
              final currentImageIndex = 0.obs;

              final screenWidth = MediaQuery.of(context).size.width;
              final cardWidth = screenWidth - 32;
              const imageHeight = 324.88;

              return GestureDetector(
                onTap: () {
                  Get.to(
                    PublicListingDetailsView(),
                    arguments: {'id': item.uniqueId},
                  );
                },
                child: Container(
                  width: cardWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.58),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── IMAGE SECTION ──────────────────────────────────────────
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(13),
                          bottom: Radius.circular(13),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: imageHeight,
                          child: Stack(
                            children: [
                              // PAGE VIEW
                              PageView.builder(
                                // Use default image if images list is null or empty
                                itemCount: (item.images != null && item.images.isNotEmpty)
                                    ? (item.images.length > 10 ? 10 : item.images.length)
                                    : 1, // show only 1 default image
                                onPageChanged: (pageIndex) {
                                  currentImageIndex.value = pageIndex;
                                },
                                itemBuilder: (context, imageIndex) {
                                  // Decide which image to show
                                  final imageUrl = (item.images != null && item.images.isNotEmpty)
                                      ? item.images[imageIndex]
                                      : Assets.assetsDefaultImage; // your default image asset

                                  // Show network image if available, else default asset
                                  if (item.images != null && item.images.isNotEmpty) {
                                    return Image.network(
                                      imageUrl,
                                      width: double.infinity,
                                      height: imageHeight,
                                      fit: BoxFit.fill,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey.shade100,
                                          child: Container(color: Colors.white),
                                        );
                                      },
                                      errorBuilder: (_, __, ___) {
                                        return Image.asset(
                                          Assets.assetsDefaultImage,
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          height: imageHeight,
                                        );
                                      },
                                    );
                                  } else {
                                    // Show default image if list is empty
                                    return Image.asset(
                                      Assets.assetsDefaultImage,
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: imageHeight,
                                    );
                                  }
                                },
                              ),

                              // ❤️ WISHLIST BUTTON (top-right)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    final id = item.id;
                                    if (id != null) {
                                      Get.find<WishlistController>().toggleWishlist(id);
                                    }
                                  },
                                  child: Obx(() {
                                    final id = item.id;
                                    final wishlistController = Get.find<WishlistController>();
                                    final isFav = id != null && (wishlistController.inWishlistMap[id] ?? false);
                                    return Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? const Color(0xFFF15925) : Colors.white,
                                      size: 25,
                                    );
                                  }),
                                ),
                              ),

                              // SHARE BUTTON
                              Positioned(
                                top: 12,
                                right: 55,
                                child: GestureDetector(
                                  onTap: () {
                                    _share(context, 'https://stayverz.com/rooms/${item.uniqueId}');
                                  },
                                  child: const Icon(
                                    Icons.share,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              // ●●● DOT INDICATOR
                              Positioned(
                                bottom: 12,
                                left: 0,
                                right: 0,
                                child: Obx(() {
                                  final images = (item.images != null && item.images.isNotEmpty)
                                      ? item.images
                                      : [Assets.assetsDefaultImage]; // default image
                                  final imageCount = images.length > 10 ? 10 : images.length;

                                  // Reset currentImageIndex if out of range
                                  if (currentImageIndex.value >= imageCount) {
                                    currentImageIndex.value = 0;
                                  }

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      imageCount,
                                          (dotIndex) => AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        width: 10,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: currentImageIndex.value == dotIndex
                                              ? Colors.white
                                              : Colors.white54,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          )
                        ),
                      ),

                      // ── DETAILS SECTION ────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TITLE + RATING ROW
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.title}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF090909),
                                      fontSize: 12.58,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.44,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 3),
                                    Text(
                                      "${item.avgRating} (${item.totalRatingCount ?? 0})",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1D2939),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // AREA / SUBTITLE
                            SizedBox(
                              width: 253.62,
                              child: Text(
                                '${item.area}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF989B9D),
                                  fontSize: 14.67,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.29,
                                ),
                              ),
                            ),

                            // PRICE + LOCATION BADGE ROW
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${item.price}/- ',
                                        style: const TextStyle(
                                          color: Color(0xFF090909),
                                          fontSize: 14.67,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          height: 1.29,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: 'night',
                                        style: TextStyle(
                                          color: Color(0xFF090909),
                                          fontSize: 14.67,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.29,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.58, vertical: 6.29),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1.05,
                                        color: Color(0xFF3D3F40),
                                      ),
                                      borderRadius: BorderRadius.circular(5.24),
                                    ),
                                  ),
                                  child: Text(
                                    '${item.thana}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF3D3F40),
                                      fontSize: 12.58,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.44,
                                    ),
                                  ),
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
            },
          ),
        );
      }),
    );
  }
}
void _share(BuildContext context, String link) {
  Share.share(link);
}
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF5D5F61),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

// Hello I am Tamim