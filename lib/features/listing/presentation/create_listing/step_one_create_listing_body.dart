import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StepOneCreateListingBody extends StatelessWidget {
  StepOneCreateListingBody({super.key});

  final List<FirstStepContent> firstStepContents = [
    FirstStepContent(
        asset: "./assets/share_details_vector.png",
        title: "A. Share details about your location.",
        subtitle: "Customizing your property will allow guests to become more familiar with"
    ),
    FirstStepContent(
        asset: "./assets/enhance_visibility_vector.png",
        title: "B. Enhance its visibility",
        subtitle: "Incorporate 4 to 6 or more images along with details of the property"
    ),
    FirstStepContent(
        asset: "./assets/complete_vector.png",
        title: "C. Complete",
        subtitle: "Decide what type of guest you’re looking for, How much you want to charge and your offer"
    ),
    FirstStepContent(
        asset: "./assets/post_earn_vector.png",
        title: "D. Post & Earn",
        subtitle: "Post your property and start earning"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Starting with Stayverz is simple, much like learning A, B, C and D.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(30),
        Container(
          padding: EdgeInsets.symmetric(vertical: 22),
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
          child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstStepContents.elementAt(index).title ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              firstStepContents.elementAt(index).subtitle ?? '',
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
                      ),
                      Image.asset(
                        firstStepContents.elementAt(index).asset ?? '',
                        colorBlendMode: BlendMode.luminosity,
                        width: 62,
                        height: 62,

                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(height: 40, thickness: 0.7,),
              itemCount: firstStepContents.length
          ),
        ),
        Gap(50),
      ],
    );
  }
}


class FirstStepContent {
  String? asset, title, subtitle;
  FirstStepContent({this.asset, this.title, this.subtitle});
}
// Hello I am Tamim