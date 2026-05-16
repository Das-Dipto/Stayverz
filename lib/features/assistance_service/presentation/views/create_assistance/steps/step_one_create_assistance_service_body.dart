import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/features/assistance_service/controllers/assistance_service_controller.dart';
import 'package:stayverz_flutter_app/features/assistance_service/models/assistance_categories_response.dart';
import 'package:stayverz_flutter_app/features/assistance_service/presentation/widgets/assistance_category_shimmer_loading.dart';

class StepOneCreateAssistanceServiceBody extends GetView<AssistanceServiceController> {
  StepOneCreateAssistanceServiceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What will you offer guests during their visit?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(30),
        Obx(() {

            if(controller.isCategoryLoading.value) {
              return AssistanceCategoryShimmerLoading();
            }

            final List<AssistanceCategory> firstStepContents = controller.assistanceCategories.toList();
            return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Obx(() {
                      bool isSelected = firstStepContents[index].id == controller.selectedCategory.value?.id;
                      return InkWell(
                        onTap: () {


                          // return;
                          if(controller.selectedCategory.value != null && isSelected) {
                            controller.selectedCategory.value = null;
                            return;
                          }
                          controller.selectedCategory.value = firstStepContents[index];
                          controller.goNextAfterSelectingCategory();
                        },
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                // width: isSelected ? 1.5 : 1,
                                width: 1,
                                // color: isSelected ? AppColors.primaryColor : const Color(0xFFF0F1F5),
                                color: const Color(0xFFF0F1F5),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            gradient: LinearGradient(
                                colors: getContainerColor(firstStepContents[index].name ?? '')
                            ),
                          ),
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  Text(
                                    firstStepContents[index].name ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: getSubcategory(firstStepContents[index].subCategory ?? []).map((e) => Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(28),
                                              color: Colors.white38
                                            ),
                                            child: Text(e.name ?? ''),
                                          )).toList(),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                          child: SizedBox())
                                    ],
                                  )
                                ],
                              ),
                              Positioned(
                                  right: -35,
                                  bottom: -15,
                                  child: buildImage(firstStepContents[index].icon, width: 120, height: 120)),
                            ],
                          ),
                        ),
                      );
                    }
                  );
                },
                separatorBuilder: (context, index) => Gap(10),
                itemCount: firstStepContents.length
            );
          })
      ],
    );
  }

  List<AssistanceCategory> getSubcategory(List<AssistanceCategory> data) {
    if(data.length > 5) {
      return [...data.getRange(0, 4), AssistanceCategory(name: 'show more')];
    }
    return data;
  }

  List<Color> getContainerColor(String name) {
    switch(name) {
      case 'Food':
        return [
          Color(0xff4C4C4C),
          Color(0xff2B2B2B),
        ];
      case 'Tour':
        return [
          Color(0xffCBF1FF),
          Color(0xff8DCFE7),
        ];
      case 'Music':
        return [
          Color(0xffFFF8D7),
          Color(0xffFFF3B8),
        ];
      case 'Tutor':
        return [
          Color(0xffFFEBDC),
          Color(0xffFFBC88),
        ];
      case 'Fitness':
        return [
          Color(0xffFFE4EB),
          Color(0xffE7B8FF),
        ];
      case 'Beauty':
        return [
          Color(0xffCBF1FF),
          Color(0xff8DCFE7),
        ];
      case 'Shilpo':
        return [
          Color(0xffFFF5EB),
          Color(0xffFFE6C1),
        ];
      case 'Planner':
        return [
          Color(0xffEAC6FF),
          Color(0xff7916CA),
        ];
      default:
        return [
          Color(0xffEFE3D6),
          Color(0xffE0D2C2),
        ];
    }
  }

  Widget buildImage(String? url, {double? width, double? height}) {
    final imageUrl = url ?? '';

    if (imageUrl.endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        width: width ?? 52,
        height: height ?? 52,
        excludeFromSemantics: true,
        placeholderBuilder: (context) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: width ?? 52,
            height: height ?? 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // Handle error fallback
        errorBuilder: (context, error, stackTrace) => _buildErrorIcon(width: width, height: height),
      );
    } else {
      return Image.network(
        imageUrl,
        width: width ?? 52,
        height: height ?? 52,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildErrorIcon(width: width, height: height),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: width ?? 52,
              height: height ?? 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildErrorIcon({double? width, double? height}) {
    return Container(
      width: width ?? 52,
      height: height ?? 52,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}


class SecondStepContent {
  String? asset, title, subtitle;
  SecondStepContent({this.asset, this.title, this.subtitle});
}
// Hello I am Tamim