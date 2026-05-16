import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../widgets/own_title_app_bar.dart';
import '../../controllers/listing_controller.dart';
import '../../controllers/listing_edit_controller.dart';
import '../../models/aminities_new_model.dart';

class EditAmenitiesListingScreen extends StatefulWidget {
  final dynamic lsit;
  final String uniqueId;

  const EditAmenitiesListingScreen({
    super.key,
    required this.lsit, required this.uniqueId,
  });

  @override
  State<EditAmenitiesListingScreen> createState() =>
      _EditAmenitiesListingScreenState();
}

class _EditAmenitiesListingScreenState
    extends State<EditAmenitiesListingScreen> {
  final ListingController controller = Get.find<ListingController>();
  final ListingEditController listingEditController =
  Get.find<ListingEditController>();

  /// a_type → section title
  final Map<String, String> amenityTypeTitles = {
    'stand_out': 'Any extraordinary amenities?',
    'entire_place': 'Entire place amenities',
    'safety': 'Safety items',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAmenities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OwnTitleAppBar(
        appBarText: 'Edit your Listing',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoadingg.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasErrorg.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${controller.errorMessageg.value}'),
                const Gap(16),
                ElevatedButton(
                  onPressed: controller.fetchAmenities,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        /// 🔹 Preselect amenities (EDIT MODE)
        if (listingEditController.selectedAmenities.isEmpty &&
            widget.lsit != null) {
          final selectedIds = widget.lsit
              .map((e) => e.amenity?.id)
              .whereType<int>()
              .toList();

          listingEditController.selectedAmenities.value = selectedIds;
          controller.selectedAmenityIds.value = selectedIds;
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Gap(10),
            const Text(
              'Select Amenities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.black),

            /// 🔹 LOOP THROUGH API TITLES (Apartment Access, Safety, etc.)
            ...controller.amenitiesList.map((category) {
              final amenities = category.data ?? [];

              /// group by a_type
              final Map<String, List<AmenityModel>> grouped = {};
              for (final amenity in amenities) {
                final key = amenity.aType ?? '';
                grouped.putIfAbsent(key, () => []);
                grouped[key]!.add(amenity);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),

                  /// 🔹 MAIN TITLE (Apartment Access)
                  Text(
                    category.title ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent
                    ),
                  ),

                  /// 🔹 a_type sections
                  ...grouped.entries.map((entry) {
                    final sectionTitle =
                        amenityTypeTitles[entry.key] ?? entry.key;

                    return _buildSection(
                      sectionTitle,
                      entry.value,
                    );
                  }),
                ],
              );
            }),

            // const Gap(20),
            //
            // /// 🔹 Save Button
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       height: 40,
            //       width: 90,
            //       child: OutlinedButton(
            //         onPressed: () async {
            //           if (controller.selectedAmenityIds.isEmpty) {
            //             Fluttertoast.showToast(
            //               msg: 'Please select at least one amenity',
            //               toastLength: Toast.LENGTH_SHORT,
            //               gravity: ToastGravity.TOP,
            //             );
            //             return;
            //           }
            //
            //        await controller.updateAmenities(
            //             listingId: widget.uniqueId, // your unique_id
            //             amenityIds: controller.selectedAmenityIds.toList(),
            //           );
            //
            //           controller.selectedAmenityIds.clear();
            //
            //           Get.back();
            //         },
            //         style: OutlinedButton.styleFrom(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(6),
            //           ),
            //         ),
            //         child: const Text(
            //           'Save',
            //           style: TextStyle(
            //             color: Color(0xFF19191A),
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            const Gap(20),
          ],
        );
      }),
      bottomNavigationBar:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width-40,
            child: OutlinedButton(
              onPressed: () async {
                if (controller.selectedAmenityIds.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Please select at least one amenity',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                  );
                  return;
                }

                await controller.updateAmenities(
                  listingId: widget.uniqueId, // your unique_id
                  amenityIds: controller.selectedAmenityIds.toList(),
                );

                controller.selectedAmenityIds.clear();

                Get.back();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF19191A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  /// 🔹 Section Builder (UNCHANGED UI)
  Widget _buildSection(
      String title,
      List<AmenityModel> amenities,
      ) {
    if (amenities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(20),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF33496C),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Gap(10),
        ...amenities.map(
              (amenity) => Obx(
                () => _AmenityCard(
              amenity: amenity,
              isSelected:
              controller.selectedAmenityIds.contains(amenity.id),
              onTap: () =>
                  controller.toggleAmenity(amenity.id!),
            ),
          ),
        ),
      ],
    );
  }
}

/// 🔹 Amenity Card (UNCHANGED)
class _AmenityCard extends StatelessWidget {
  final AmenityModel amenity;
  final bool isSelected;
  final VoidCallback onTap;

  const _AmenityCard({
    required this.amenity,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 58,
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 0.95,
                    color: Color(0xFFF0F1F5),
                  ),
                  borderRadius: BorderRadius.circular(7.61),
                ),
              ),
              child: Row(
                children: [
                  const Gap(5),
                  Expanded(
                    child: Text(
                      amenity.name ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Gap(5),
                  _buildAmenityIcon(amenity.iconMobile),
                ],
              ),
            ),
          ),

          /// 🔹 Selected Indicator
          if (isSelected)
            Positioned(
              top: 9,
              left: 3,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAmenityIcon(String? url) {
    if (url == null || url.isEmpty) {
      return const SizedBox.shrink();
    }

    if (url.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        url,
        width: 30,
        height: 30,
        placeholderBuilder: (_) => const SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(strokeWidth: 1),
        ),
      );
    }

    return Image.network(
      url,
      width: 30,
      height: 30,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
      const Icon(Icons.error_outline),
    );
  }
}

// Hello I am Tamim