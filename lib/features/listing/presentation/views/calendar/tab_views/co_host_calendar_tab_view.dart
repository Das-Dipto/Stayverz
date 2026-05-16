import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/features/listing/models/co_host_listing_response_model.dart';
import 'package:stayverz_flutter_app/widgets/build_empty_state_widget.dart';

import '../../../../../../widgets/build_error_widget.dart';
import '../../../../../../widgets/listing_card_widget.dart';
import '../host_calender_view.dart';

class CoHostCalendarTabView extends GetView<ListingController> {
  const CoHostCalendarTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      if(controller.isCoHostListingLoading.value) {
        return Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              ),
            ],
          ),
        );
      }

      List<CoHostListingData> listItems = controller.coHostListings.toList(growable: true);
      listItems.removeWhere((e) => e.status != 'published');

      if (listItems.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 48.0),
          child: BuildEmptyStateWidget(
            onRetry: controller.refreshListings,
          ),
        );
      }

      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final listing = listItems[index];
            return Obx(() {
              return InkWell(
                onTap: () {

                  Get.to(HostCalenderView(
                      image: listing.coverPhoto,
                      id: "${listing.listingId}",
                      title: listing.title ?? '')
                  );

                },
                child:
                ListingCard(
                  name: listing.title,
                  message: 'BDT ${listing.price?.toStringAsFixed(0)}/per night',
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