import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/widgets/listing_card_widget.dart';

import '../../../../controllers/listing_controller.dart';
import '../../edit_listing_screen.dart';

class CoHostListingTabView extends GetView<ListingController> {
  const CoHostListingTabView({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if (controller.isCoHostListingLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if(controller.coHostListings.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text("No co-host found!"),
          ),
        );
      }

      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final listing = controller.coHostListings[index];

            return Obx(() {


              return InkWell(
                onTap: () {
                  Get.to(() =>  EditListingScreen(), arguments: {'id': listing.uniqueId});
                },
                child:

                ListingCard(
                  name: listing.title,
                  message: 'BDT ${listing.price?.toStringAsFixed(0)}/per night',
                  // Note: ListingCard currently uses a hardcoded image
                  imageURL: listing.coverPhoto,
                  isLarge: controller.isGridView.value,
                ),
              );
            }
            );
          },
          separatorBuilder: (context, index) => const Gap(12),
          itemCount: controller.coHostListings.length
      );
    });
  }
}

// Hello I am Tamim