import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/features/listing/presentation/create_listing/add_manual_location_screen.dart';
import 'add_map_location_screen.dart';

class StepFiveCreateListingBody extends GetView<ListingController> {
  StepFiveCreateListingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add the location of your property',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF3D3F40),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(12),
        const Text(
          'You should provide the location of your property with full details of property rooms and other things.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: Color(0xFF989B9D),
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
            onPressed: () {
              Get.to(() => AddManualLocationScreen(
                    uniqId: controller.createdListingId,
                  ));
            },
            icon: const Icon(Icons.add, color: Colors.black87, size: 24),
            style: OutlinedButton.styleFrom(
              alignment: AlignmentGeometry.centerLeft,
            ),
            label: const Text(
              'Input / add manually',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Color(0xFF3D3F40),
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.33,
              ),
            ),
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
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.map_outlined),
                      const Gap(8),
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
                      : const Icon(Icons.map_outlined, color: Colors.white),
                ],
              ),
            ),
          );
        }),
      


        Obx(() {
  final hasManual = controller.propertyCtrl.text.isNotEmpty ||
      controller.areaSearchCtrl.text.isNotEmpty;
  final hasMap = controller.hasMapLocation;

  if (!hasManual && !hasMap) return const SizedBox();

  return Container(
    margin: const EdgeInsets.only(top: 16),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.green.shade50,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.green.shade300),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
    
children: [
  Text(
    hasMap && hasManual
        ? 'Location added (Manual + Map)'
        : hasMap
            ? 'Location added via Map'
            : 'Location added manually',
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: Colors.green,
    ),
  ),
  if (controller.address.value.isNotEmpty) ...[
    const Gap(4),
    Text(
      controller.address.value,
      style: const TextStyle(fontSize: 13, color: Colors.black87),
    ),
  ] else if (controller.areaSearchCtrl.text.isNotEmpty) ...[
    const Gap(4),
    Text(
      controller.areaSearchCtrl.text,
      style: const TextStyle(fontSize: 13, color: Colors.black87),
    ),
  ],
],
    ),
  );
}),
      


      ],
    );
  }
}