import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/constants/app_colors.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/features/listing/presentation/create_listing/step_eleventh_create_listing_body.dart';
import 'package:stayverz_flutter_app/widgets/own_title_app_bar.dart';
import '../../../../../core/utils/enums/product_listing_enums.dart';
import 'step_eighth_create_listing_body.dart';
import 'step_five_create_listing_body.dart';
import 'step_fourth_create_listing_body.dart';
import 'step_ninth_create_listing_body.dart';
import 'step_one_create_listing_body.dart';
import 'step_second_create_listing_body.dart';
import 'step_seventh_create_listing_body.dart';
import 'step_sixth_create_listing_body.dart';
import 'step_tenth_create_listing_body.dart';
import 'step_third_create_listing_body.dart';


class CreateListingScreen extends GetView<ListingController> {
  static const String route = '/create_listing';
  const CreateListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Scaffold(
          appBar: OwnTitleAppBar(
            appBarText: "Step ${controller.getCurrentStep(controller.currentState.value)} / 10",
            onPressed: controller.goBack,
            buttonIconColor: Colors.black,
            backgroundColor: Colors.white,
            fontColor: Colors.black,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(vertical: 26, horizontal: 16),
            child: Obx(() {
                switch(controller.currentState.value) {
                  case CurrentState.SECOND:
              //      return StepSeventhCreateListingBody();
                   return StepSecondCreateListingBody();
                  case CurrentState.THIRD:
                    return StepThirdCreateListingBody();
                  case CurrentState.FOURTH:
                    return StepFourthCreateListingBody();
                  case CurrentState.FIFTH:
                    return StepFiveCreateListingBody();
                  case CurrentState.SIXTH:
                    return StepSixthCreateListingBody();
                  case CurrentState.SEVENTH:
                    return StepSeventhCreateListingBody();
                  case CurrentState.EIGHTH:
                    return StepEighthCreateListingBody();
                  case CurrentState.NINTH:
                    return StepNinthCreateListingBody();
                  case CurrentState.TENTH:
                    return StepTenthCreateListingBody();
                  case CurrentState.ELEVENTH:
                    return StepEleventhCreateListingBody();
                  default:
                   // return StepSixthCreateListingBody();
                    return StepOneCreateListingBody();
                }
              }
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Obx(() {

              if (controller.currentState.value == CurrentState.ELEVENTH) {
                return Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            controller.currentState.value = CurrentState.FIRST;
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.black12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Later",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.isLoadingNext.value
                              ? null
                              : controller.onPublishClick,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: controller.isLoadingNext.value
                              ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            "Publish",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                  controller.isLoadingNext.value ? null : controller.goNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isLoadingNext.value
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }
    );
  }
}

// Hello I am Tamim