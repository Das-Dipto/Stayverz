import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/generated/assets.dart';

import '../../../../widgets/own_title_app_bar.dart';
import '../../controllers/public_assistance_service_controller.dart';

class PublicAssistanceAllReviewScreen extends GetView<PublicAssistanceServiceController> {
  static const String route = '/public_assistance_view_all';
  const PublicAssistanceAllReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: "All Reviews",
        onPressed: () {},
        buttonIconColor: Colors.black,
        backgroundColor: Colors.white,
        fontColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    Icon(Icons.star, color: Colors.black87, size: 20,),
                    Text(
                      "${controller.publicListingDetails.value?.avgRating ?? '0'}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black /* Black */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
                Text(
                  "${controller.publicListingDetails.value?.totalRatingCount ?? '0'}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black /* Black */,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
            const Gap(38),
            ListView.separated(
                itemBuilder: (context, index) {
                  var review = controller.publicListingDetails.value?.reviews?[index];
                  return Column(
                    spacing: 10,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: ShapeDecoration(
                              shape: CircleBorder(
                              ),
                              color: Colors.deepOrangeAccent,
                            ),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: ShapeDecoration(
                                shape: CircleBorder(
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                review?.reviewBy?.image ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, data, stack) => Image.asset(
                                  Assets.assetsDefaultImage,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review?.reviewBy?.name ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black /* Black */,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 1.50,
                                ),
                              ),
                              Row(
                                children: [
                                  ...List.generate(review?.rating ?? 0,(i) => Icon(Icons.star_sharp, size: 16,)),
                                  const Gap(4),
                                  Icon(Icons.circle, size: 3,),
                                  const Gap(4),
                                  Text(
                                    '${review?.reviewTimeString}'.capitalizeFirst ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black /* Black */,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        spacing: 6,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review?.review ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          Row()
                        ],
                      )
                    ],
                  );
                },
                clipBehavior: Clip.none,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Gap(24),
                itemCount: (controller.publicListingDetails.value?.reviews ?? []).length
            )
          ],
        ),
      ),
    );
  }
}

// Hello I am Tamim