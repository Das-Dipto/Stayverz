import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/widgets/listing_card_widget.dart';
import '../../../../controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/features/listing/models/listing_model.dart';

import '../../edit_listing_screen.dart';

class HostTabListingView extends GetView<ListingController> {
  const HostTabListingView({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if (controller.isHostListingLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.listings.isEmpty) {
        return Center(child: Text('No listings found'));
      }

      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final listing = controller.listings[index];
            return Obx(() {

              return InkWell(
                onTap: () {
                  Get.to(() =>  EditListingScreen(), arguments: {'id': listing.unique_id});
                },
                child: ListingCard(
                  name: listing.title,
                  imageURL: listing.cover_photo,
                  message: 'BDT ${listing.price.toStringAsFixed(0)}/per night',
                  // Note: ListingCard currently uses a hardcoded image

                  isLarge: controller.isGridView.value,
                ),
              );
            }
            );
          },
          separatorBuilder: (context, index) => const Gap(12),
          itemCount: controller.listings.length
      );
    });


  }
}

// Hello I am Tamim