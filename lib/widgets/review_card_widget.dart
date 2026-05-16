import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../core/constants/app_colors.dart';
import 'profile_avatar_widget.dart';

class ReviewCardWidget extends StatelessWidget {
  const ReviewCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white /* white */,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFF0F1F5) /* Grey-10 */,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: ShapeDecoration(
              color: Colors.white /* white */,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.94,
                  color: const Color(0xFFF0F1F5) /* Grey-10 */,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [

                  Container(
                    width: 79.10,
                    height: 79.10,
                    padding: const EdgeInsets.symmetric(horizontal: 10.36, vertical: 14.12),
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://media.cnn.com/api/v1/images/stellar/prod/140127103345-peninsula-shanghai-deluxe-mock-up.jpg"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.94,
                          color: const Color(0xFFA9A9B0) /* Grey-50 */,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  VerticalDivider(indent: 4, endIndent: 4, color: AppColors.primaryColor, thickness: 5, width: 26,),
                  Expanded(
                    child: Text(
                      'Couple Non-Ac room at uttara.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.07,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Gap(14),
          Row(
            children: [
              ProfileAvatarWidget(
                url: '',
                radius: 20,
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mohammad Deluar Hossain',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star,color: Colors.orangeAccent, size: 18,),
                            Icon(Icons.star,color: Colors.orangeAccent, size: 18,),
                            Icon(Icons.star,color: Colors.orangeAccent, size: 18,),
                            Icon(Icons.star,color: Colors.orangeAccent, size: 18,),
                            Icon(Icons.star,color: Colors.orangeAccent, size: 18,)
                          ],
                        ),
                        Text(
                          'Nov 12, 2024',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
          const Gap(14),
          Text(
            'Thanks For your Amazing Services. I Always Get feedback very quick & smooth as well..... & yes It\'s a New Concept For Dhaka...... I Appreciate Your Concept......',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          )
        ],
      ),
    );
  }

}


// Hello I am Tamim