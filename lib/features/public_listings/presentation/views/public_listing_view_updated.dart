import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/controllers/public_listings_controller.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/public_listing_details_view.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/tab_views/update_search_view.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/title_view_screen.dart';
import '../../../../../core/utils/shimmer_view.dart';
import '../../../../../generated/assets.dart';


class PropertyTabViewUpdated extends GetView<PublicListingsController> {
  const PropertyTabViewUpdated({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        const Gap(12),
        _buildCategoryTabs(context),
        const Gap(1),
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
    return Center(
      child: Container(
        margin:EdgeInsets.symmetric(horizontal: 16.0),
       width: MediaQuery.of(context).size.width,
       padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: ShapeDecoration(
          color: const Color(0xFFF3F3F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Get.to(UpdateSearchView());
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search Icon Box (matches Figma's grey square placeholder)
              SizedBox(
                width: 23,
                height: 23,
                child: Icon(
                  Icons.search,
                  size: 23,
                  color: const Color(0xFF989B9D),
                ),
              ),
             Gap(8),
              Text(
                'Start your search',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF989B9D),
                  fontSize: 14,
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

  Widget _buildCategoryTabs(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,

      padding: const EdgeInsets.symmetric(horizontal: 15), // exact 16px both side
      child: Obx(() {

        // ── Loading Shimmer ─────────────────────────────
        if (controller.isLoadingFilters.value) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                6,
                    (_) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade50,
                  child: Container(
                    height: 32,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: const Color(0xFFBABEC1)),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (controller.categories.isEmpty) {
          return const SizedBox(height: 40);
        }

        final desiredOrder = [
          'Apartment',
          'Home',
          'Resort',
          'Guesthouse',
          'Hotel',
        ];

        final sortedCategories = List.from(controller.categories)
          ..sort((a, b) {
            final aIndex = desiredOrder.indexOf(a.name.trim());
            final bIndex = desiredOrder.indexOf(b.name.trim());
            return (aIndex == -1 ? 999 : aIndex)
                .compareTo(bIndex == -1 ? 999 : bIndex);
          });

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [

              // ── ALL Chip ─────────────────────────────
              Obx(() {
                final isAllSelected =
                    controller.selectedHomeCategoryId.value == null;

                return GestureDetector(
                  onTap: () => controller.onCategorySelected(
                    categoryId: null,
                    tabName: 'All',
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: ShapeDecoration(
                      color: isAllSelected
                          ? const Color(0xFFFF5A3D)
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: isAllSelected
                              ? const Color(0xFFFF5A3D)
                              : const Color(0xFFD3D4D5),
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      'All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isAllSelected
                            ? Colors.white
                            : const Color(0xFF090909),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: isAllSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        height: 1.44,
                      ),
                    ),
                  ),
                );
              }),

              // ── Category Chips ───────────────────────
              ...sortedCategories.map((category) {
                return Obx(() {
                  final isSelected =
                      controller.selectedHomeCategoryId.value == category.id;

                  return GestureDetector(
                    onTap: () => controller.onCategorySelected(
                      categoryId: category.id,
                      tabName: category.name ?? 'All',
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: ShapeDecoration(
                        color: isSelected
                            ? const Color(0xFFFF5A3D)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: isSelected
                                ? const Color(0xFFFF5A3D)
                                : const Color(0xFFD1D3D3),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon
                          Image.network(
                            category.iconMobile,
                            width: 16,
                            height: 16,
                            color: isSelected ? Colors.white : null,
                            colorBlendMode:
                            isSelected ? BlendMode.srcIn : BlendMode.dst,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.category_outlined,
                              size: 14,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF090909),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Label
                          Text(
                            category.name ?? '',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF090909),
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              height: 1.44,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildListingsGrid() {
    return Obx(() {
      if (controller.isLoadingg.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.hasErrorg.value) {
        return Center(child: Text(controller.errorMessage.value));
      }

      if (controller.homeSections.isEmpty) {
        return const Center(child: Text('No data found'));
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.homeSections.length,
        separatorBuilder: (_, __) => const Gap(24),
        itemBuilder: (context, sectionIndex) {
          final section = controller.homeSections[sectionIndex];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Section title
              InkWell(
                onTap: () {
                  Get.to(TitleViewScreen(title: section.sectionTitle));
                },
                child: Builder(
                  builder: (context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    const designWidth = 393.0;
                    final scale = screenWidth / designWidth;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ── Section Title (flexible so it never overlaps) ──
                        Expanded(
                          child: Text(
                            section.sectionTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF090909),
                              fontSize: 16.77 * scale,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),

                        SizedBox(width: 8 * scale),

                        // ── See All ──
                        GestureDetector(
                          onTap: () {
                            Get.to(TitleViewScreen(title: section.sectionTitle));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'See all',
                                style: TextStyle(
                                  color: const Color(0xFFFF5A3D),
                                  fontSize: 13 * scale,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(width: 2 * scale),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12 * scale,
                                color: const Color(0xFFFF5A3D),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Gap(15),

              /// 🔹 Horizontal listings
              SizedBox(
                height: 196,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: section.items.length,
                  separatorBuilder: (_, __) => const Gap(16),
                  itemBuilder: (context, itemIndex) {
                    final listing = section.items[itemIndex];

                    return SizedBox(
                      width: 145,
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            PublicListingDetailsView(),
                            arguments: {'id': listing.uniqueId},
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Image
                            Container(
                              width: 147,
                              height: 143,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: CachedNetworkImage(
                                  imageUrl: listing.coverPhoto,
                                  fit: BoxFit.cover,
                                  memCacheHeight: 800, // Resize image in memory cache
                                  memCacheWidth: 800,
                                  maxHeightDiskCache: 1200, // Resize image for disk cache
                                  maxWidthDiskCache: 1200,
                                  cacheKey: listing.coverPhoto, // Optional, helps reuse cache
                                  placeholder: (_, __) => Shimmer.fromColors(
                                    baseColor: Colors.black26,
                                    highlightColor: Colors.black12,
                                    child: Container(color: Colors.black),
                                  ),
                                  errorWidget: (_, __, ___) => Image.asset(
                                    Assets.assetsDefaultImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                              ),
                            ),

                            const Gap(8),

                            /// Title
                            Text(
                              listing.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF3D3F40),
                                fontSize: 12.58,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Gap(5),

                            /// Price + rating
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${listing.price}/- Per night',
                                    style: const TextStyle(
                                      color: Color(0xFF989B9D),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  listing.avgRating > 0
                                      ? '* ${listing.avgRating.toStringAsFixed(1)}'
                                      : '',
                                  style: const TextStyle(
                                    color: Color(0xFF989B9D),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    });
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