import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';

class StepNinthCreateListingBody extends GetView<ListingController> {
  StepNinthCreateListingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create your description',
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
        'Share what makes your place special.',
          style: TextStyle(
            color: const Color(0xFF33496C) /* Text */,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        const Gap(30),
        CustomInputText(
          controller: controller.descriptionController,
          helperText: 'Description',
          maxLines: 6,
          maxLength: 2000,
        ),
        const Gap(20)
      ],
    );
  }
}

// Hello I am Tamim