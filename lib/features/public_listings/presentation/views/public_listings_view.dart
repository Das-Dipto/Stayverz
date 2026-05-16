import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/public_listings/data/repositories/public_listings_repository.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/controllers/public_listings_controller.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/public_listing_view_updated.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/tab_views/assistance_tab_view.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/tab_views/property_tab_view.dart';

import '../../../../generated/assets.dart';
import '../../../wishlist/presentation/bindings/wishlist_binding.dart';
import '../../../wishlist/presentation/controllers/wishlist_controller.dart';
import '../../domain/repositories/listing_filter_config_repository.dart';

class PublicListingsView extends GetView<PublicListingsController> {
  PublicListingsView({Key? key}) : super(key: key) {
    // Initialize controller if not already done
    if (!Get.isRegistered<PublicListingsController>()) {
      Get.put(
        PublicListingsController(
          Get.find<PublicListingsRepository>(),
          Get.find<ListingFilterConfigRepository>(),
        ),
      );
    }
    if (!Get.isRegistered<WishlistController>()) {
      WishlistBinding().dependencies();
    }
    final wishlistController = Get.find<WishlistController>();
  }
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the controller instance
    final controller = Get.find<PublicListingsController>();
    // final witchcontroller = Get.find<WishlistController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Gap(24),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.selectedReportType.value = 0;
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: controller.selectedReportType.value == 0 ? Colors.deepOrange : const Color(0xFFDCDEE3) /* Grey-30 */,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Column(
                                spacing: 4,
                                children: [
                                  Image.asset(
                                    Assets.assetsPP,
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text("Property")
                                ],
                              ),
                            ),
                          ),
                        )
                    ),
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.selectedReportType.value = 1;
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: controller.selectedReportType.value == 1 ? Colors.deepOrange : const Color(0xFFDCDEE3) /* Grey-30 */,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Column(
                                spacing: 4,
                                children: [
                                  Image.asset(
                                    Assets.assetsAsP,
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text("Assistances")
                                ],
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                ),
              );
            }),
            const Gap(14),
           Expanded(
              child: Obx(() {
                if(controller.selectedReportType.value == 1) {
                  return AssistanceTabView();
                }
                return PropertyTabViewUpdated();
              }),
            )
          ],
        ),
      ),
    );
  }

}

// Hello I am Tamim