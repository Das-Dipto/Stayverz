import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../services/video_player/video_player.dart';
import '../../../widgets/own_app_bar.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  List<String> list=[
    "assets/img1.png",
    "assets/img2.png",
    "assets/img3.png",
    "assets/img4.png",
    "assets/img5.png",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 60,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.1),
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: Colors.black,
              ),
            ),
            Text(
              'About Us',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            Gap(40),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Gap(16),
          Image.asset('assets/stayverz_logo.png',height: 38,width: 150,),
          Gap(10),
          Text(
            'Why Choose us?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 36,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.08,
            ),
          ),
          Gap(20),
          Text(
            'Unlock a world of unique stays. Ditch the ordinary hotel experience and discover the comfort and character of a Stayverz vacation rental.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Gap(50),
          Image.asset('assets/sheck.png', height: 95,width: 95,fit: BoxFit.contain,),
          Gap(10),
          Text(
            'Price Promise ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          Gap(20),
          Text(
            'Book in clicks. Our user-friendly platform lets you reserve your stay in minutes',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Gap(50),
          Image.asset('assets/celander.png', height: 95,width: 95,fit: BoxFit.contain,),
          Gap(10),
          Text(
            'Effortless Booking',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          Gap(20),
          Text(
            'Book in clicks. Our user-friendly platform lets you reserve your stay in minutes',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Gap(50),
          Image.asset('assets/care.png', height: 95,width: 95,fit: BoxFit.contain,),
          Gap(10),
          Text(
            'Professional Care',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          Gap(20),
          Text(
            'Our friendly booking experts are happy to answer any questions you have',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Gap(50),
          Text(
            'ABOUT STAYVERZ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 36,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.08,
            ),
          ),
          Gap(20),
          Text(
            'Who we are?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          Gap(10),
          Text(
            'Stayverz (TRAD/DNCC/042928/2023) is your gateway to unique short-term rentals in Bangladesh. We connect guests with hosts who offer comfortable homes, allowing them to experience destinations like locals. And bringing an opportunity for the hosts to earn 2/3 times more than their usual monthly rental income.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Gap(20),
          Text(
            'What do we do?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          Gap(10),
          Text(
            'We offer a curated selection of rentals, from cozy apartments to luxurious places, ensuring a perfect fit for everyone. Our user-friendly platform makes booking a smooth process, and our friendly customer service team is always available to assist you.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Gap(20),
          Text(
            'Ready to explore?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          Gap(10),
          Text(
            'Book your Stayverz rental today and create unforgettable memories!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
           YouTubeVideoPlayer(videoId: "L1XMUK9BOWU",),
          Gap(40),
          Container(
          padding: EdgeInsets.all(8),
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
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/cooked_food_icon.png"),
                          fit: BoxFit.cover,
                        ),
                        shape: OvalBorder(),
                      ),
                    ),
                    Gap(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Shahadat Hossain',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                        Text(
                          'Guest',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Gap(8),
                Divider(color: const Color(0xFFDCDEE3),),
                Gap(8),
                Text(
                  'আলহামদুলিল্লাহ চমৎকার সার্ভিস পেয়েছি। যা যা উল্লেখিত ছিল, যেসকল সুবিধা পাওয়ার কথা ছিলো সকল কিছুই ফুলফিল ভাবে পেয়েছি। আমার অভিজ্ঞতা চমৎকার ছিলো।',
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
          Gap(40),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length, // Max 4 items
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              mainAxisSpacing: 12, // Vertical gap
              crossAxisSpacing: 12, // Horizontal gap
             mainAxisExtent: 120
              // width / height to maintain height = 175
            ),
            itemBuilder: (context, index) {
              return Container(
                height: 70,

                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(list[index]),
                    // fit: BoxFit.contain,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
              );
            },
          ),
          Gap(20)







        ],
      ),
    );
  }
}

// Hello I am Tamim