import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../widgets/listing_card_widget.dart';
import '../../controllers/listing_controller.dart';

class StepEleventhCreateListingBody extends GetView<ListingController> {
  StepEleventhCreateListingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review your my_listing',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(12),
        Text(
        'Here’s what we’ll show to guests. Make sure everything looks good.',
          style: TextStyle(
            color: const Color(0xFF33496C) /* Text */,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        const Gap(30),
    Obx(() {
    if (controller.uploadedPhotoUrls.isEmpty) {
    return SizedBox();
    }

    return ListingCard(
    name: controller.titleController.text,
    message: controller.descriptionController.text,
    imageURL: controller.uploadedPhotoUrls.first,
    isLarge: true,
    );
    }),
        const Gap(30),
        Text(
          'What’s next?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(20),
        Container(
          padding: EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white /* white */,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: const Color(0xFFF0F1F5) /* Grey-10 */,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_box_outlined),
                  const Gap(6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm a few details and publish',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                      ),
                      Text(
                        'We will need to verify your identity.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const Divider(height: 30,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_box_outlined),
                  const Gap(6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set up your calendar',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                      ),
                      Text(
                        'Choose which dates your property available for guests',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const Divider(height: 30,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_box_outlined),
                  const Gap(6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adjust your listings',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                      ),
                      Text(
                        'Update policy , guests count, house rules and more',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Gap(60)
      ],
    );
  }
}

// Hello I am Tamim