import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/constants/app_colors.dart';
import 'package:stayverz_flutter_app/features/messaging/controllers/conversation_controller.dart';
import 'package:stayverz_flutter_app/widgets/listing_card_widget.dart';
import 'package:stayverz_flutter_app/widgets/own_title_app_bar.dart';

import '../../../listing/controllers/listing_controller.dart';

class ShareRecommendationScreen extends GetView<ListingController> {

  static const String routeName = '/share-recommendation';
  final convControl = Get.put(ConversationController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: "Share Your Recommendation",
        backgroundColor: Colors.white,
        fontColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {

        if (controller.isHostListingLoading.value && controller.listings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${controller.errorMessage.value}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshListings,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

          List hostListing = controller.listings.value;

          hostListing.removeWhere((e) => e.status != 'published');

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              children: [
                Text(
                  'Suggest ideas to help Nurbol  create an unforgettable trip.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
                const Gap(15),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = hostListing[index];
                      return GestureDetector(
                        onTap: () {
                          if(convControl.recommendedPropertyId != null && convControl.recommendedPropertyId == item.id) {
                            convControl.recommendedPropertyId = null;
                            convControl.recommendedPropertyData = null;
                            return;
                          }
                          convControl.recommendedPropertyId = item.id;
                          convControl.recommendedPropertyData = item;
                        },
                        child: Obx(() {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ListingCard(
                                name: item.title,
                                imageURL: item.cover_photo,
                                message: 'BDT ${item.price.toStringAsFixed(0)}/per night',
                                isSelected: convControl.recommendedPropertyId == item.id,
                              ),
                            );
                          }
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Gap(12),
                    itemCount: controller.listings.length
                ),
                const Gap(90)
              ],
            ),
          );
        }
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                    convControl.recommendedPropertyId = null;
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      side: BorderSide(width: 1, color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                      )
                  ),
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black /* white */,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500
                    ),
                  )),
            ),
            const Gap(10),
            Expanded(
              child: Obx(() {
                  return ElevatedButton(
                      onPressed: convControl.recommendedPropertyId == null ? null : convControl.shareProperty,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF929294),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)
                          )
                      ),
                      child: Text(
                        'Share',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white /* white */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500
                        ),
                      ));
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}



// Hello I am Tamim