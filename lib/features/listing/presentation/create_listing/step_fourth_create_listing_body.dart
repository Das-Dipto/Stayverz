import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/features/listing/presentation/create_listing/add_manual_location_screen.dart';
import 'add_map_location_screen.dart';


class StepFourthCreateListingBody extends GetView<ListingController> {
  StepFourthCreateListingBody({super.key});

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add the location of your property',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF3D3F40),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(12),
        Text(
          'You should provide the location of your property with full details of property rooms and other things.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: const Color(0xFF989B9D),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
        const Gap(28),
        SizedBox(
          height: 60,
          width: double.infinity,
          child: OutlinedButton.icon(
              onPressed: () => Get.to(AddManualLocationScreen()),
              icon: Icon(Icons.add, color: Colors.black87, size: 24),
              style: OutlinedButton.styleFrom(
                alignment: AlignmentGeometry.centerLeft,

              ),
              label: Text(
                'Input / add manually',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF3D3F40),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.33,
                ),
              )
          ),
        ),

        const Gap(14),

        Obx(() {
          return SizedBox(
            height: 60,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.to(() => AddMapLocationScreen()),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: controller.hasMapLocation
                      ? Colors.grey.shade300
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.map_outlined),
                      Gap(8),
                      const Text(
                        'Select from the map',
                        style: TextStyle(
                          color: Color(0xFF3D3F40),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),

                  controller.hasMapLocation
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.map_outlined,color: Colors.white,),
                ],
              ),
            ),
          );
        }),


      ],
    );
  }
}

// Hello I am Tamim