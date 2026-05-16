import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/public_listing_details_view.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/tab_views/update_search_view.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../generated/assets.dart';
import '../../../wishlist/presentation/controllers/wishlist_controller.dart';
import '../controllers/public_listings_controller.dart';

class TitleViewScreen extends StatefulWidget {
  static const String route = '/title_view_screen';
  final String title;
  const TitleViewScreen({super.key, required this.title});

  @override
  State<TitleViewScreen> createState() => _TitleViewScreenState();
}

class _TitleViewScreenState extends State<TitleViewScreen> {
  final ScrollController _scrollController = ScrollController();
  final RxInt _currentImageIndex = 0.obs;

  // Get your controller instance
  final controller = Get.find<PublicListingsController>();

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    controller.fetchSectionViewListings(title: widget.title);

    // Setup pagination
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when reaching 80% of scroll
      controller.fetchSectionViewListings(title: widget.title, loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _share(BuildContext context, String url) async {
    await Share.share(url, subject: 'Check this out!');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light, // Dark icons for white background
      statusBarBrightness: Brightness.light,    // iOS
    ));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFFE4E9EC)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 26),
                  ),
                  Gap(10),
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF3D3F40),
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.29,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildSearchBar(context),
            const SizedBox(height: 12),
            Expanded(child: _buildListings()),
          ],
        ),
      ),
    );
  }

  Widget _buildListings() {
    return Obx(() {
      if (controller.isLoadingListings.value &&
          controller.newListings.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.hasErrorListings.value && controller.newListings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.errorMessageListings.value),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  controller.fetchSectionViewListings(title: widget.title);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.newListings.isEmpty) {
        return const Center(child: Text('No properties found'));
      }

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount:
            controller.newListings.length +
            (controller.isLoadMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.newListings.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _buildPropertyCard(context, index);
        },
      );
    });
  }

  Widget _buildPropertyCard(BuildContext context, int index) {
    final item = controller.newListings[index];

    // ✅ Each card gets its OWN RxInt so dots don't bleed across cards
    final currentImageIndex = 0.obs;

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 32;
    const imageHeight = 324.88;

    return GestureDetector(
      onTap: () {
        Get.to(PublicListingDetailsView(), arguments: {'id': item.uniqueId});
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
                      itemCount:
                          (item.images != null && item.images.isNotEmpty)
                              ? (item.images.length > 10
                                  ? 10
                                  : item.images.length)
                              : 1, // show only 1 default image
                      onPageChanged: (pageIndex) {
                        currentImageIndex.value = pageIndex;
                      },
                      itemBuilder: (context, imageIndex) {
                        // Decide which image to show
                        final imageUrl =
                            (item.images != null && item.images.isNotEmpty)
                                ? item.images[imageIndex]
                                : Assets
                                    .assetsDefaultImage; // your default image asset

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
                          final wishlistController =
                              Get.find<WishlistController>();
                          final isFav =
                              id != null &&
                              (wishlistController.inWishlistMap[id] ?? false);
                          return Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color:
                                isFav ? const Color(0xFFF15925) : Colors.white,
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
                          _share(
                            context,
                            'https://stayverz.com/rooms/${item.uniqueId}',
                          );
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
                        final images =
                            (item.images != null && item.images.isNotEmpty)
                                ? item.images
                                : [Assets.assetsDefaultImage]; // default image
                        final imageCount =
                            images.length > 10 ? 10 : images.length;

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
                                color:
                                    currentImageIndex.value == dotIndex
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
                ),
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

                  // SUBTITLE
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
                          horizontal: 12.58,
                          vertical: 6.29,
                        ),
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
  }

  Widget _buildSearchBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Base design dimensions from Figma
    const designWidth = 393.0;
    const designHeight = 850.0;

    final horizontalScale = screenWidth / designWidth;
    final verticalScale = screenHeight / designHeight;

    // Dynamic values scaled from Figma
    final containerWidth = 353.0 * horizontalScale;
    final containerHeight = 48.0 * verticalScale;
    final padding = 14.0 * horizontalScale;
    final iconSize = 20.0 * horizontalScale;
    final fontSize = 14.0 * horizontalScale;
    final spacing = 8.0 * horizontalScale;
    final borderRadius = 8.0 * horizontalScale;

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 16, right: 16),
        height: containerHeight,
        padding: EdgeInsets.symmetric(horizontal: padding),
        decoration: ShapeDecoration(
          color: const Color(0xFFF3F3F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () {
            Get.to(UpdateSearchView());
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search Icon Box (matches Figma's grey square placeholder)
              Container(
                width: iconSize,
                height: iconSize,
                decoration: const BoxDecoration(),
                child: Icon(
                  Icons.search,
                  size: iconSize * 0.85,
                  color: const Color(0xFF989B9D),
                ),
              ),
              SizedBox(width: spacing),
              // Placeholder Text
              Text(
                'Start your search',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF989B9D),
                  fontSize: fontSize,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.29,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hello I am Tamim