import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/features/assistance_service/models/public_assistance_params.dart';
import 'package:stayverz_flutter_app/features/assistance_service/presentation/views/public_assistance_details_screen.dart';

import '../../../../generated/assets.dart';
import '../../../public_listings/presentation/views/assistance_list_search_screen.dart';
import '../../controllers/public_assistance_service_controller.dart';
import '../../models/assistance_listing_response_model.dart';

class CategoryWiseAssistanceListingScreen
    extends GetView<PublicAssistanceServiceController> {
  static const String route = '/public_assistance_service';
  const CategoryWiseAssistanceListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // Check if data is loading or empty
          if (controller.assistanceListings.isEmpty) {
            return const Center(
              child: Text(
                'No data found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            );
          }

          // Otherwise, show the GridView
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  children: [
                    _buildSearchBar(context),
                    const Gap(18),
                    Expanded(
                      child: GridView.builder(
                        itemCount: controller.assistanceListings.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.86,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          AssistanceListingData item = controller.assistanceListings[index];

                          return InkWell(
                            onTap: () {
                              PublicAssistanceParams params =
                              PublicAssistanceParams.fromJson(Get.arguments);
                              Get.toNamed(
                                PublicAssistanceDetailsScreen.route,
                                arguments: PublicAssistanceParams(
                                  categoryId: params.categoryId,
                                  subcategoryId: "${item.aSubCategoryId ?? ''}",
                                  assistanceId: item.uniqueId ?? '',
                                ).toJson(),
                              );
                              controller.fetchAssistanceSingleListingDetails();
                            },
                            child: Container(
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.22),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x15000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ✅ Image takes a fixed flex portion
                                  Expanded(
                                    flex: 6,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4.22),
                                      ),
                                      child: Image.network(
                                        item.coverPhoto ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            Assets.assetsDefaultImage,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  // ✅ Text section takes remaining space, won't overflow
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            item.title ?? '',
                                            style: const TextStyle(
                                              color: Color(0xFF191919),
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            item.currentLocationName ?? '',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w300,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Price ৳${item.price ?? 0}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w300,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ]));
        }),
      ),
    );
  }
  Widget _buildSearchBar(BuildContext context) {
    return Container(
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
                await Get.to(AssistanceListSearchScreen());
                // controller.refreshListings();
              },
              child: Text("Search..."),
            ),
          ),
        ],
      ),
    );
  }
}

// Hello I am Tamim