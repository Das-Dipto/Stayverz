import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/widgets/listing_card_widget.dart';

import '../../../../../assistance_service/bindings/assistance_service_binding.dart';
import '../../../../../assistance_service/presentation/views/edit_assistance_listing_screen.dart';
import '../../../../controllers/listing_controller.dart';
import '../../edit_listing_screen.dart';

class AssistanceListingTabView extends GetView<ListingController> {
  const AssistanceListingTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isAssistanceListingLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if(controller.assistanceListings.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text("No assistance found!"),
          ),
        );
      }

      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final listing = controller.assistanceListings[index];

            return Obx(() {

              final isFirst = index == 0;
              final isLast = index == controller.listings.length - 1;
              return InkWell(
                onTap: () {
                  AssistanceServiceBinding().dependencies();
                  Get.to(() =>  EditAssistanceListingScreen(), arguments: {'id': listing.uniqueId});
                },
                child:Container(
                  margin: EdgeInsets.only(
                    top: isFirst ? 16 : 0,
                    bottom: isLast ? 16 : 0,
                  ),
                  padding: EdgeInsets.all(6),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 0.94,
                        color: Color(0xFFF0F1F5),
                      ),
                      borderRadius: BorderRadius.circular(7.53),
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 10.36, vertical: 14.12),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (listing.coverPhoto ?? '').isEmpty
                                    ? const AssetImage('assets/default_image.jpg') as ImageProvider
                                    : NetworkImage(listing.coverPhoto!),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(4)
                            // shape: RoundedRectangleBorder(
                            //   side: const BorderSide(
                            //     width: 0.94,
                            //     color: Color(0xFFA9A9B0),
                            //   ),
                            //   borderRadius: BorderRadius.circular(7.53),
                            // ),
                          ),
                        ),
                        const Gap(6),
                        Container(
                          width: 4,
                          margin: EdgeInsets.symmetric(vertical: 2),
                          decoration: ShapeDecoration(
                            color: const Color(0x84F15925),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9415.72),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listing.title ?? '',
                                style: const TextStyle(
                                  color: Color(0xFF004E70),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                (listing.status=="in_progress"?"In progress":listing.status ?? '').capitalizeFirst ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Row(
                                children: [
                                  ...List.generate(
                                    5, (i) {
                                    return Icon(Icons.star, size: 16, color: i < listing.avgRating!.toInt() ? Colors.yellow : Colors.grey);
                                  },
                                  ),
                                  const Gap(3),
                                  Text(
                                    "(${listing.avgRating})",
                                    style: const TextStyle(
                                      color: Color(0xFF67666B),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                  ),
                                ],
                              ),
                              if(listing.price != null)Text(
                                'Price: ${listing.price}/-',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ListingCard(
                //   name: listing.title,
                //   message: 'BDT ${listing.price?.toStringAsFixed(0)}/per night',
                //   // Note: ListingCard currently uses a hardcoded image
                //   imageURL: listing.coverPhoto,
                //   isLarge: controller.isGridView.value,
                // ),
              );
            }
            );
          },
          separatorBuilder: (context, index) => const Gap(12),
          itemCount: controller.assistanceListings.length
      );
    });
  }
}

// Hello I am Tamim