import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/controllers/public_listings_controller.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/tab_views/update_search_view.dart';

import '../../../../../core/utils/shimmer_view.dart';
import '../../../../../generated/assets.dart';
import '../../../../wishlist/presentation/controllers/wishlist_controller.dart';
import '../list_search_screen.dart';
import '../public_listing_details_view.dart';

class PropertyTabView extends GetView<PublicListingsController> {
  const PropertyTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        const Gap(18),
        _buildCategoryTabs(),
        const Gap(8),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.listings.isEmpty) {
              return const ShimmerListLoader();
            }
            if (controller.hasError.value) {
              return _buildErrorWidget();
            }
            if (controller.listings.isEmpty) {
              return _buildEmptyState();
            }
            return _buildListingsGrid();
          }),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 44,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDCDEE3)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          const Gap(10),
          const Icon(Icons.search, color: Colors.black54, size: 22),
          const Gap(10),
          Expanded(
            child: InkWell(
              onTap: () async {
                //await Get.to(ListSearchScreen());
            Get.to(UpdateSearchView());
               // controller.refreshListings();
              },
              child: Text("Search..."),
            ),
          ),
          VerticalDivider(thickness: 0.8, endIndent: 6, indent: 6, width: 0),
          SizedBox(
            height: 40,
            width: 40,
            child: GestureDetector(
              //  onTap: _showFilterDialog,
              onTap: () {
                showCustomBottomSheet(context);
              },
              child: Icon(
                Icons.filter_alt_outlined,
                color: Colors.black54,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // 90% of screen height
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Top close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),

                  // Optional title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Apply Filter',
                        style: TextStyle(
                          color: Colors.black /* white */,
                          fontSize: 18,
                          fontFamily: 'Kumbh Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.12,
                        ),
                      ),
                    ),
                  ),

                  //  SizedBox(height: 10),

                  // Scrollable list only
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Property type',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Kumbh Sans',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                        ),
                        Gap(10),
                        buildRoomTypeTile(
                          context: context,
                          title: "Single Room",
                          assetPath: 'assets/sigle_room.png',
                          key: 'single_room',
                        ),

                        Gap(10),
                        buildRoomTypeTile(
                          context: context,
                          title: "Entire Place",
                          assetPath: 'assets/full_room.png',
                          key: 'entire_place',
                        ),
                        Gap(16),
                        const Text(
                          'Price Range',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          final minLimit = 800.0;
                          final maxLimit = 99999.0;
                          final currentRange = controller.priceRange.value;
                          return Column(
                            children: [
                              RangeSlider(
                                values: currentRange,
                                min: minLimit,
                                max: maxLimit,
                                // divisions: 100,
                                labels: RangeLabels(
                                  '৳${currentRange.start.round()}',
                                  '৳${currentRange.end.round()}',
                                ),
                                onChanged: (RangeValues values) {
                                  controller.updatePriceRange(values);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('\৳${currentRange.start.round()}'),
                                    Text('\৳${currentRange.end.round()}'),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 16),
                        Text(
                          'Beds and bathrooms',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Kumbh Sans',
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                        Gap(10),
                        Text(
                          'Bedrooms',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Kumbh Sans',
                            fontWeight: FontWeight.w500,
                            height: 2,
                          ),
                        ),
                        Gap(10),
                        Wrap(
                          children: [
                            buildGuestOptionButton("Any"),
                            buildGuestOptionButton("1"),
                            buildGuestOptionButton("2"),
                            buildGuestOptionButton("3"),
                            buildGuestOptionButton("4"),
                            buildGuestOptionButton("5"),
                            buildGuestOptionButton("6"),
                            buildGuestOptionButton("7"),
                            buildGuestOptionButton("8+"),
                          ],
                        ),
                        Gap(15),
                        Text(
                          'Bathrooms',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Kumbh Sans',
                            fontWeight: FontWeight.w500,
                            height: 2,
                          ),
                        ),
                        Gap(10),
                        Wrap(
                          children: [
                            buildBathroomsOptionButton("Any"),
                            buildBathroomsOptionButton("1"),
                            buildBathroomsOptionButton("2"),
                            buildBathroomsOptionButton("3"),
                            buildBathroomsOptionButton("4"),
                            buildBathroomsOptionButton("5"),
                            buildBathroomsOptionButton("6"),
                            buildBathroomsOptionButton("7"),
                            buildBathroomsOptionButton("8+"),
                          ],
                        ),
                        Gap(15),
                        Text(
                          'Beds',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Kumbh Sans',
                            fontWeight: FontWeight.w500,
                            height: 2,
                          ),
                        ),
                        Gap(10),
                        Wrap(
                          children: [
                            buildBathOptionButton("Any"),
                            buildBathOptionButton("1"),
                            buildBathOptionButton("2"),
                            buildBathOptionButton("3"),
                            buildBathOptionButton("4"),
                            buildBathOptionButton("5"),
                            buildBathOptionButton("6"),
                            buildBathOptionButton("7"),
                            buildBathOptionButton("8+"),
                          ],
                        ),
                        const Text(
                          'Amenities',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          final amenities =
                              controller.filterConfig.value?.amenities;
                          if (amenities == null) {
                            return const SizedBox.shrink();
                          }
                          final standOutAmenities =
                          amenities.standOut
                              .where((amenity) => amenity.status == false)
                              .toList();
                          final safetyAmenities =
                          amenities.safety
                              .where((amenity) => amenity.status == false)
                              .toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Entire Place Amenities
                              if (amenities.entirePlace.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    'Entire Place',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                  amenities.entirePlace
                                      .where(
                                        (amenity) =>
                                    amenity.status == false,
                                  ) // ✅ only show active ones
                                      .map((amenity) {
                                    final isSelected = controller
                                        .selectedAmenities
                                        .contains(amenity.id);
                                    return FilterChip(
                                      label: Text(amenity.name),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        controller.toggleAmenity(
                                          amenity.id,
                                        );
                                      },
                                      backgroundColor: Colors.grey[200],
                                      selectedColor: Colors.blue[100],
                                      checkmarkColor: Colors.blue[800],
                                    );
                                  })
                                      .toList(),
                                ),
                              ],
                              // Regular Amenities
                              if (amenities.regular.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    'Regular',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                  amenities.regular
                                      .where(
                                        (amenity) =>
                                    amenity.status == false,
                                  ) // ✅ filter by status
                                      .map((amenity) {
                                    final isSelected = controller
                                        .selectedAmenities
                                        .contains(amenity.id);
                                    return FilterChip(
                                      label: Text(amenity.name),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        controller.toggleAmenity(
                                          amenity.id,
                                        );
                                      },
                                      backgroundColor: Colors.grey[200],
                                      selectedColor: Colors.blue[100],
                                      checkmarkColor: Colors.blue[800],
                                    );
                                  })
                                      .toList(),
                                ),
                              ],
                              // Stand Out Amenities
                              if (standOutAmenities.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    'Stand Out',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                  standOutAmenities.map((amenity) {
                                    final isSelected = controller
                                        .selectedAmenities
                                        .contains(amenity.id);
                                    return FilterChip(
                                      label: Text(amenity.name),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        controller.toggleAmenity(
                                          amenity.id,
                                        );
                                      },
                                      backgroundColor: Colors.grey[200],
                                      selectedColor: Colors.blue[100],
                                      checkmarkColor: Colors.blue[800],
                                    );
                                  }).toList(),
                                ),
                              ],
                              // Safety Amenities
                              if (safetyAmenities.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    'Safety',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                  safetyAmenities.map((amenity) {
                                    final isSelected = controller
                                        .selectedAmenities
                                        .contains(amenity.id);
                                    return FilterChip(
                                      label: Text(amenity.name),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        controller.toggleAmenity(
                                          amenity.id,
                                        );
                                      },
                                      backgroundColor: Colors.grey[200],
                                      selectedColor: Colors.blue[100],
                                      checkmarkColor: Colors.blue[800],
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          );
                        }),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // Bottom buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.resetFilters();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Clear All',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.applyFilters();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Apply Filters',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildRoomTypeTile({
    required BuildContext context,
    required String title,
    required String assetPath,
    required String key,
  }) {
    return Obx(() {
      final isSelected = controller.isSelected(key);
      return GestureDetector(
        onTap: () => controller.toggleRoomType(key),
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          height: 90,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 73,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.94, color: Color(0xFFF0F1F5)),
                      borderRadius: BorderRadius.circular(7.53),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gap(90),
                      Container(
                        width: 3.77,
                        height: 53.67,
                        decoration: ShapeDecoration(
                          color: Color(0xFFF15925),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9415.72),
                          ),
                        ),
                      ),
                      Gap(10),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.07,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 30,
                top: 0,
                child: Container(
                  width: 70.10,
                  height: 70.10,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage(assetPath),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.94, color: Color(0xFFA9A9B0)),
                      borderRadius: BorderRadius.circular(7.53),
                    ),
                  ),
                ),
              ),

              if (isSelected)
                Positioned(
                  top: 22,
                  right: 25,
                  child: Icon(
                    Icons.circle_sharp,
                    size: 14,
                    color: Colors.redAccent,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildGuestOptionButton(String label) {
    return Obx(() {
      final isSelected = controller.selectedGuestOption.value == label;
      return GestureDetector(
        onTap: () => controller.selectGuestOption(label),
        child: Container(
          height: 35,
          width: 60,
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 8, bottom: 8), // spacing
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.redAccent : Colors.grey,
              width: 1.5,
            ),
            color: isSelected ? Colors.transparent : Colors.transparent,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.redAccent : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }

  Widget buildBathroomsOptionButton(String label) {
    return Obx(() {
      final isSelected = controller.selectedBatroomOption.value == label;
      return GestureDetector(
        onTap: () => controller.selectBatroomOption(label),
        child: Container(
          height: 35,
          width: 60,
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 8, bottom: 8), // spacing
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.redAccent : Colors.grey,
              width: 1.5,
            ),
            color: isSelected ? Colors.transparent : Colors.transparent,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.redAccent : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }

  Widget buildBathOptionButton(String label) {
    return Obx(() {
      final isSelected = controller.selectedBatOption.value == label;
      return GestureDetector(
        onTap: () => controller.selectBatOption(label),
        child: Container(
          height: 35,
          width: 60,
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 8, bottom: 8), // spacing
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.redAccent : Colors.grey,
              width: 1.5,
            ),
            color: isSelected ? Colors.transparent : Colors.transparent,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.redAccent : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        // Show loading indicator while categories are loading
        if (controller.isLoadingFilters.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: 6,
            itemBuilder: (_, __) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 40,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            },
            shrinkWrap: true,
          );
        }

        // Check if categories are loaded
        if (controller.categories.isEmpty) {
          return const SizedBox(height: 40);
        }

        // Log available categories for debugging

        // Desired order of categories
        final desiredOrder = [
          'Apartment',
          'Home',
          'Resort',
          'Guesthouse',
          'Hotel',
        ];

        // Sort categories based on desired order
        final sortedCategories = List.from(controller.categories)
          ..sort((a, b) {
            final aIndex = desiredOrder.indexOf(a.name.trim());
            final bIndex = desiredOrder.indexOf(b.name.trim());
            final safeAIndex = aIndex >= 0 ? aIndex : 1000; // unknown categories go last
            final safeBIndex = bIndex >= 0 ? bIndex : 1000;
            return safeAIndex.compareTo(safeBIndex);
          });

        // Build horizontal ChoiceChips
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: [
              // Add 'All' option first
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: const Text('All'),
                  selected: controller.selectedCategoryId.value == null,
                  selectedColor: Colors.deepOrangeAccent.shade200,
                  backgroundColor: Colors.transparent,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: controller.selectedCategoryId.value == null
                        ? Colors.white
                        : Colors.black54,
                  ),
                  onSelected: (selected) {
                    if (selected) controller.filterByCategoryId(null);
                  },
                ),
              ),

              // Add all sorted categories
              ...sortedCategories.map((category) {
                final isSelected =
                    controller.selectedCategoryId.value == category.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Row(
                      children: [
                        Image.network(
                            category.iconMobile,
                            height: 22,
                            width: 22,
                            errorBuilder: (BuildContext context, Object child, StackTrace? stackTrace) {
                              return SizedBox();
                            }
                        ),
                        const SizedBox(width: 6),
                        Text(category.name),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: Colors.deepOrangeAccent.shade200,
                    backgroundColor: Colors.transparent,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                    shape: isSelected
                        ? null
                        : RoundedRectangleBorder(
                      side: BorderSide(width: 0.7, color: Colors.black12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    visualDensity: VisualDensity.comfortable,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onSelected: (selected) {
                      if (selected) {
                        controller.filterByCategoryId(category.id);
                      }
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }),
    );

  }

  Widget _buildListingsGrid() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            !controller.isLoading.value) {
          controller.loadMoreListings();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount:
        controller.listings.length + (controller.isLoading.value ? 1 : 0),
        separatorBuilder: (context, index) => const Gap(16),
        itemBuilder: (context, index) {
          if (index == controller.listings.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final listing = controller.listings[index];
          return GestureDetector(
            onTap: () {
              // Navigate to my_listing details page
              // This would be implemented in a future update
              Get.to(
                PublicListingDetailsView(),
                arguments: {'id': listing.id},
              );
            },
            child: Container(
              height: 500,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 290,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 200),
                        autoPlayCurve: Curves.decelerate,
                        enlargeCenterPage: true,
                        enlargeFactor: 0,
                        onPageChanged:
                            (int index, CarouselPageChangedReason response) {},
                        scrollDirection: Axis.horizontal,
                      ),
                      items:
                      [...(listing.images), listing.coverPhoto].map((i) {
                        return CachedNetworkImage(
                          imageUrl: i,
                          imageBuilder:
                              (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder:
                              (context, url) => Shimmer.fromColors(
                            baseColor: Colors.black26,
                            highlightColor: Colors.white24,
                            child: Container(
                              height: 290,
                              color: Colors.black,
                            ),
                          ),
                          errorWidget:
                              (context, url, error) => Container(
                            height: 290,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  Assets.assetsDefaultImage,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 230,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFF0F1F5) /* Grey-10 */,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            topRight: Radius.circular(18),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(10),
                                  Text(
                                    listing.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF004E70) /* Info */,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Gap(6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                      Gap(5),
                                      Expanded(
                                        child: Text(
                                          listing.address,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(
                                              0xFF33496C,
                                            ) /* Text */,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 1.50,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  Gap(8),
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating: listing.avgRating,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20,
                                        ignoreGestures: true,
                                        itemBuilder:
                                            (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      const Gap(5),
                                      Text(
                                        '(${listing.totalRatingCount})',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(15),
                                  Container(
                                    height: 42,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: const Color(
                                            0xFFE6E8EE,
                                          ) /* Stroke */,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x0C101828),
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'Price: ${listing.price}/- TK',
                                      style: TextStyle(
                                        color: Colors.black /* Black */,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 1.50,
                                      ),
                                    ),
                                  ),
                                  Gap(35),
                                  Container(
                                    width: 44,
                                    height: 40,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF2F2F2) /* BG */,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        final listingId = listing.id;
                                        if (listingId != null) {
                                          Get.find<WishlistController>()
                                              .toggleWishlist(listingId);
                                        }
                                      },
                                      child: Obx(() {
                                        final listingId = listing.id;
                                        final isInWishlist =
                                            listingId != null &&
                                                (Get.find<WishlistController>()
                                                    .inWishlistMap[listingId] ??
                                                    false);

                                        return Opacity(
                                          opacity: 0.72,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFFF2F2F2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(9999),
                                              ),
                                            ),
                                            child: Icon(
                                              isInWishlist
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color:
                                              isInWishlist
                                                  ? const Color(0xFFF15925)
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Gap(10),
                          Container(
                            width: 54,
                            height: 230,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFDCDEE3) /* Grey-30 */,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Gap(10),
                                Icon(
                                  Icons.person_outline_outlined,
                                  color: const Color(0xFF33496C),
                                  size: 16,
                                ),
                                Text(
                                  '${listing.guestCount} person',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF33496C) /* Text */,
                                    fontSize: 9,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Gap(5),
                                Icon(
                                  Icons.roofing_rounded,
                                  color: const Color(0xFF33496C),
                                  size: 16,
                                ),
                                Text(
                                  '${listing.bedroomCount}\n Bedrooms',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF33496C) /* Text */,
                                    fontSize: 9,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Gap(5),
                                Icon(
                                  Icons.bed,
                                  color: const Color(0xFF33496C),
                                  size: 16,
                                ),
                                Text(
                                  '${listing.bedCount} Bed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF33496C) /* Text */,
                                    fontSize: 9,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Gap(5),
                                Icon(
                                  Icons.bathtub_outlined,
                                  color: const Color(0xFF33496C),
                                  size: 16,
                                ),
                                Text(
                                  '${listing.bathroomCount} Baths',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF33496C) /* Text */,
                                    fontSize: 9,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Gap(0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 16,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .68,
                      height: 40,
                      padding: EdgeInsets.only(left: 70, right: 30),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF15925) /* Brand-color */,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'View Details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 12,
                            height: 20,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 19,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 14,
                            height: 20,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 19,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _share(
                            context,
                            'https://stayverz.com/rooms/${listing.uniqueId}',
                          );
                        },
                        child: Opacity(
                          opacity: 1,
                          child: Container(
                            width: 30,
                            height: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F2F2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                            child: const Icon(
                              Icons.share,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (listing.host.currentSuperhostTier != null)
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: Colors.white, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // If you want to show the silver_host icon, uncomment the below line:
                            // Image.asset('assets/silver_host.png', height: 18, width: 18),
                            // const SizedBox(width: 6),
                            Text(
                              "${listing.host.currentSuperhostTier}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 12.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(0.5, 0.5),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
          // return GestureDetector(
          //   onTap: () {
          //     // Navigate to my_listing details page
          //     // This would be implemented in a future update
          //     Get.to(PublicListingDetailsView(), arguments: {'id': my_listing.uniqueId});
          //   },
          //   child: Container(
          //     height: 360,
          //     clipBehavior: Clip.antiAliasWithSaveLayer,
          //     decoration: const BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(16)),
          //     ),
          //     child: Stack(
          //       children: [
          //         Positioned(
          //           top: 0,
          //           left: 0,
          //           right: 0,
          //           child: Image.network(
          //             my_listing.coverPhoto,
          //             height: 200,
          //             width: double.infinity,
          //             fit: BoxFit.cover,
          //             errorBuilder: (context, error, stackTrace) {
          //               return Container(
          //                 height: 200,
          //                 decoration: BoxDecoration(
          //                     image: DecorationImage(
          //                       image: AssetImage(Assets.assetsDefaultImage),
          //                       fit: BoxFit.cover
          //                     )
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //         Positioned(
          //           bottom: 0,
          //           left: 0,
          //           right: 0,
          //           child: Container(
          //             height: 180,
          //             decoration: const ShapeDecoration(
          //               color: Colors.white,
          //               shape: RoundedRectangleBorder(
          //                 side: BorderSide(width: 1, color: Color(0xFFF0F1F5)),
          //                 borderRadius: BorderRadius.only(
          //                   bottomLeft: Radius.circular(16),
          //                   topRight: Radius.circular(18),
          //                 ),
          //               ),
          //             ),
          //             child: Row(
          //               children: [
          //                 Expanded(
          //                   child: Padding(
          //                     padding: const EdgeInsets.only(left: 10),
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         const Gap(10),
          //                         Text(
          //                           my_listing.title,
          //                           textAlign: TextAlign.center,
          //                           maxLines: 1,
          //                           overflow: TextOverflow.ellipsis,
          //                           style: const TextStyle(
          //                             color: Color(0xFF004E70),
          //                             fontSize: 16,
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                         ),
          //                         const Gap(5),
          //                         Text(
          //                           my_listing.address,
          //                           maxLines: 1,
          //                           overflow: TextOverflow.ellipsis,
          //                           style: const TextStyle(
          //                             fontSize: 14,
          //                             color: Colors.grey,
          //                           ),
          //                         ),
          //                         const Gap(10),
          //                         Row(
          //                           children: [
          //                             RatingBar.builder(
          //                               initialRating: my_listing.avgRating,
          //                               minRating: 0,
          //                               direction: Axis.horizontal,
          //                               allowHalfRating: true,
          //                               itemCount: 5,
          //                               itemSize: 20,
          //                               ignoreGestures: true,
          //                               itemBuilder:
          //                                   (context, _) => const Icon(
          //                                     Icons.star,
          //                                     color: Colors.amber,
          //                                   ),
          //                               onRatingUpdate: (rating) {},
          //                             ),
          //                             const Gap(5),
          //                             Text(
          //                               '(${my_listing.totalRatingCount})',
          //                               style: const TextStyle(
          //                                 fontSize: 14,
          //                                 color: Colors.grey,
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                         const Gap(10),
          //                         Row(
          //                           children: [
          //                             _buildFeatureChip(
          //                               '${my_listing.bedroomCount} Bedroom',
          //                             ),
          //                             const Gap(5),
          //                             _buildFeatureChip(
          //                               '${my_listing.bathroomCount} Bathroom',
          //                             ),
          //                             const Gap(5),
          //                             _buildFeatureChip(
          //                               '${my_listing.bedCount} Bed',
          //                             ),
          //                           ],
          //                         ),
          //                         const Gap(15),
          //                         Text.rich(
          //                           TextSpan(
          //                             children: [
          //                               TextSpan(
          //                                 text: '\$${my_listing.price.toInt()}',
          //                                 style: const TextStyle(
          //                                   fontSize: 20,
          //                                   fontWeight: FontWeight.bold,
          //                                 ),
          //                               ),
          //                               const TextSpan(
          //                                 text: ' / night',
          //                                 style: TextStyle(
          //                                   fontSize: 14,
          //                                   color: Colors.grey,
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         // const Gap(15),
          //                         // SizedBox(
          //                         //   height: 44,
          //                         //   child: ElevatedButton(
          //                         //     onPressed: () {
          //                         //       // Navigate to booking page
          //                         //       // This would be implemented in a future update
          //                         //     },
          //                         //     style: ElevatedButton.styleFrom(
          //                         //       backgroundColor: Colors.red,
          //                         //       foregroundColor: Colors.white,
          //                         //       shape: RoundedRectangleBorder(
          //                         //         borderRadius: BorderRadius.circular(
          //                         //           8,
          //                         //         ),
          //                         //       ),
          //                         //     ),
          //                         //     child: const Text('Book Now'),
          //                         //   ),
          //                         // ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const Gap(16),
          Text(
            'No listings found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const Gap(8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const Gap(24),
          ElevatedButton(
            onPressed: () => controller.refreshListings(),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }


  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const Gap(16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const Gap(24),
          ElevatedButton(
            onPressed: () => controller.refreshListings(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _share(BuildContext context, String link) {
    Share.share(link);
  }

}

// Hello I am Tamim