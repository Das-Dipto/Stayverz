import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/assistance_service/controllers/assistance_service_controller.dart';
import 'package:stayverz_flutter_app/widgets/own_title_app_bar.dart';
import 'steps/step_four_create_assistance_service_body.dart';
import 'steps/step_one_create_assistance_service_body.dart';
import 'steps/step_three_create_assistance_service_body.dart';
import 'steps/step_two_create_assistance_service_body.dart' show StepTwoCreateAssistanceServiceBody;


class CreateAssistanceServiceScreen extends GetView<AssistanceServiceController> {
  static const String route = '/create_assistance_service';
  const CreateAssistanceServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return PopScope(
          canPop: controller.currentState.value == 0,
          onPopInvokedWithResult: (canPop, value) {
            if(!canPop) {
              controller.goBack();
            }
          },
          child: Scaffold(
            appBar: OwnTitleAppBar(
              appBarText: controller.currentState.value ==3 ? (controller.selectedExperiences.value?.name ?? '') : (controller.selectedCategory.value?.name ?? ''),
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
                    case 0:
                      return StepOneCreateAssistanceServiceBody();
                    case 1:
                      return StepTwoCreateAssistanceServiceBody();
                    case 2:
                      return StepThreeCreateAssistanceServiceBody();
                    case 3:
                      return StepFourCreateAssistanceServiceBody();
                    default:
                      return StepOneCreateAssistanceServiceBody();
                  }
                }
              ),
            ),
          ),
        );
      }
    );
  }
}

// Hello I am Tamim