import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/assistance_service/controllers/assistance_service_controller.dart';

import '../../../../../../core/constants/app_colors.dart';

class StepThreeCreateAssistanceServiceBody extends GetView<AssistanceServiceController> {
  const StepThreeCreateAssistanceServiceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            buildAssetImage(
                controller.imageUrl.value,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.55
            ),
            Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.55,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black87
                    ],
                  stops: [0, 100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.bottomLeft,
              child: Text(
                controller.selectedExperiences.value?.name ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400
                ),
              ),
            )
          ],
        ),
        const Gap(35),
        Center(
          child: Text(
            'Create your listing',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
        ),
        const Gap(12),
        Text(
          'Tell us about yourself and the experience you offer. Our team will review it to confirm it meets our requirements.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        const Gap(20),
        Center(
          child: Obx(() => SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: controller.isCreatingAssistance.value
                  ? null // disables the button while loading
                  : controller.goNextAfterCreateListing,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: controller.isCreatingAssistance.value
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white, // spinner color
                      strokeWidth: 2,
                    ),
                  )
                  : const Text(
                    'Create Now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
            ),
          )),
        ),
      ],
    );
  }

  Widget buildAssetImage(String? url, {double? width, double? height, Key? key}) {
    final imagePath = url ?? '';
    return ClipRRect(
      key: key,
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        width: width ?? 100,
        height: height ?? 100,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width ?? 100,
          height: height ?? 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

}

// Hello I am Tamim