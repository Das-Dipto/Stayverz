import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/features/listing/models/host_listing_configuration_model.dart';

import '../../../../core/constants/app_colors.dart';

class StepThirdCreateListingBody extends GetView<ListingController> {
  StepThirdCreateListingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What are your property type?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(30),
        Obx(() {
          final List<PlaceType> firstStepContents = controller.listingConfiguration.value?.placeTypes ?? [];
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Obx(() {
                bool isSelected = firstStepContents[index].id == controller.selectedPlaceType.value?.id;

                if(firstStepContents.elementAt(index).name == 'Shared Room'){
                  return SizedBox();
                }

                return InkWell(
                    onTap: () {
                      if(controller.selectedPlaceType.value != null && isSelected) {
                        controller.selectedPlaceType.value = null;
                        return;
                      }
                      controller.selectedPlaceType.value = firstStepContents[index];
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.white /* white */,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: isSelected ? 1.5 : 1,
                            color: isSelected ? AppColors.primaryColor : const Color(0xFFF0F1F5) /* Grey-10 */,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(isSelected)Padding(
                            padding: const EdgeInsets.only(right: 10.0, top: 4),
                            child: Icon(Icons.circle, color: Colors.green, size: 16),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  firstStepContents.elementAt(index).name ?? '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1.50,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  firstStepContents
                                          .elementAt(index)
                                          .shortDescription ??
                                      '',
                                  style: TextStyle(
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
                          buildImage(   firstStepContents.elementAt(index).iconMobile),

                          const Gap(8),
                        ],
                      ),
                    ),
                  );
                }
              );
            },
            separatorBuilder: (context, index) => Gap(10),
            itemCount: firstStepContents.length,
          );
        }),
      ],
    );
  }
  Widget buildImage(String? url) {
    final imageUrl = url ?? '';

    if (imageUrl.endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        width: 52,
        height: 52,
        excludeFromSemantics: true,
        placeholderBuilder: (context) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        // Handle error fallback
        errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
      );
    } else {
      return Image.network(
        imageUrl,
        width: 52,
        height: 52,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildErrorIcon() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}

class ThirdStepContent {
  String? asset, title, subtitle;
  ThirdStepContent({this.asset, this.title, this.subtitle});
}

// Hello I am Tamim