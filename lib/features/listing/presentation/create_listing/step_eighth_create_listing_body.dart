import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';

class StepEighthCreateListingBody extends GetView<ListingController> {
  StepEighthCreateListingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Now let’s give your house a title',
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
        'Short tile works best. Have fun with it you can always change it later',
          style: TextStyle(
            color: const Color(0xFF33496C) /* Text */,
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
 
          ),
        ),
        const Gap(30),
        CustomInputText(
          controller: controller.titleController,
          helperText: 'Write your awesome title',
          maxLines: 6,
          maxLength: 200,
        ),
        const Gap(40)
      ],
    );
  }
}

// Hello I am Tamim