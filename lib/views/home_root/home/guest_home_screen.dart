import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../widgets/own_app_bar.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  RxInt data = 0.obs;
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
                //color: Colors.grey.withOpacity(0.1),
              ),
              // child: IconButton(
              //   onPressed: () {
              //     Get.back();
              //   },
              //   icon: const Icon(Icons.arrow_back_ios, size: 20),
              //   color: Colors.black,
              // ),
            ),
            Text(
              '    ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            // Icon(
            //   Icons.notifications_active_outlined,
            //   size: 19,
            //   color: Colors.black.withOpacity(0.8),
            // ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        data.value;
        return ListView(
          children: [
            SizedBox(
              height: 540,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 278,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/view.jpg"),
                          fit: BoxFit.fill,
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ), // Customize color & width
                          // Only bottom border is added; left border is omitted
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 302,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: ShapeDecoration(
                        color: Colors.white /* white */,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFDCDEE3) /* Grey-30 */,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Gap(65),
                          Text(
                            'Experience The Comforts Of Your HomeAway From Home',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 21,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Gap(35),
                          Text(
                            'Your one-stop shop for finding the perfect place to stay or my_listing your unique property for rent.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF67666B) /* Grey-70 */,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Select The Option That Suits Your Requirements',
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
            Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Whether you\'re renting or booking we\'re here to help you move forward.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF67666B) /* Grey-70 */,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
            Gap(30),
            Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (data.value == 0) {
                        data.value = 1;
                      } else {
                        data.value = 0;
                      }
                    },
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9999),
                      bottomLeft: Radius.circular(9999),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: (MediaQuery.of(context).size.width - 70) / 2,
                      height: 40,
                      decoration:
                          data.value == 0
                              ? ShapeDecoration(
                                color: Colors.white /* white */,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.10,
                                    color: const Color(
                                      0xFFF15925,
                                    ) /* Brand-color */,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(9999),
                                    bottomLeft: Radius.circular(9999),
                                  ),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                    spreadRadius: 2,
                                  ),
                                ],
                              )
                              : ShapeDecoration(
                                color: const Color(0xFFDCDEE3) /* Grey-30 */,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(9999),
                                    bottomLeft: Radius.circular(9999),
                                  ),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                      child: Text(
                        'Host Property',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              data.value == 0
                                  ? Colors.black
                                  : Color(0xFFA9A9B0),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      if (data.value == 1) {
                        data.value = 0;
                      } else {
                        data.value = 1;
                      }
                    },
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(9999),
                      bottomRight: Radius.circular(9999),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: (MediaQuery.of(context).size.width - 70) / 2,
                      height: 40,
                      decoration:
                          data.value == 1
                              ? ShapeDecoration(
                                color: Colors.white /* white */,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.10,
                                    color: const Color(
                                      0xFFF15925,
                                    ) /* Brand-color */,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(9999),
                                    bottomRight: Radius.circular(9999),
                                  ),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                    spreadRadius: 2,
                                  ),
                                ],
                              )
                              : ShapeDecoration(
                                color: const Color(0xFFDCDEE3) /* Grey-30 */,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(9999),
                                    bottomRight: Radius.circular(9999),
                                  ),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                      child: Text(
                        'Book Property',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              data.value == 1
                                  ? Colors.black
                                  : Color(0xFFA9A9B0) /* Grey-50 */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(20),
            Obx(() => data==0?Container(
              padding: EdgeInsets.only(
                left: 20,
                top: 40,
                right: 20,
                bottom: 20,
              ),
              decoration: ShapeDecoration(
                color: Colors.white /* white */,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFDCDEE3) /* Grey-30 */,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: Column(
                children: [
                  Image.asset(
                    'assets/home_icon_1.png',
                    height: 116,
                    width: 132,
                    fit: BoxFit.fill,
                  ),
                  Gap(40),
                  Text(
                    'Refer and Earn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  Gap(16),
                  Text(
                    'Refer friends & family to be Stayverz hosts! Earn when they list their and guests\' book',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF67666B) /* Grey-70 */,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  Gap(100),
                  Image.asset(
                    'assets/home_icon_2.png',
                    height: 116,
                    width: 126,
                    fit: BoxFit.fill,
                  ),
                  Gap(35),
                  Text(
                    'Rock-Bottom Commissions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  Gap(16),
                  Text(
                    'Experience exceptional services with the lower commissions for a limited time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF67666B) /* Grey-70 */,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  Gap(90),
                  Image.asset(
                    'assets/home_icon_3.png',
                    height: 116,
                    width: 126,
                    fit: BoxFit.fill,
                  ),
                  Gap(16),
                  Text(
                    'Damage Protection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  Gap(16),
                  Text(
                    'After only 6 months, verified hosts enjoy damage protection for added assurance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF67666B) /* Grey-70 */,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ):
            Container(
              padding: EdgeInsets.only(
                left: 20,
                top: 40,
                right: 20,
                bottom: 20,
              ),
              decoration: ShapeDecoration(
                color: Colors.white /* white */,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFDCDEE3) /* Grey-30 */,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: Column(
                children: [
                  Image.asset(
                    'assets/book_p1.png',
                    height: 116,
                    width: 132,
                    fit: BoxFit.fill,
                  ),
                  Gap(40),
                  Text(
                    'Visually Verified Properties',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'We verify each property and ensure you get exactly what you see when you are booking',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF67666B) /* Grey-70 */,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  Gap(50),
                  Image.asset(
                    'assets/book_p2.png',
                    height: 116,
                    width: 126,
                    fit: BoxFit.fill,
                  ),
                  Gap(35),
                  Text(
                    'Secured Payment System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'We are here to safeguard your financial information throughout the booking process',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF67666B) /* Grey-70 */,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  Gap(40),
                  Image.asset(
                    'assets/book_p3.png',
                    height: 116,
                    width: 126,
                    fit: BoxFit.fill,
                  ),
                  Gap(10),
                  Text(
                    'Professional Support',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'Our customer service team is comprised of knowledgeable professionals ready to assist you with any questions or concerns',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF67666B) /* Grey-70 */,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),),
            Gap(60),
            Container(
              width: 420,
              height: 420,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/circel_image.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 230,
                    child: Text(
                      'Our Features For Your Comfort',
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
                  Gap(10),
                  SizedBox(
                    width: 260,
                    child: Text(
                      'These are also locations where it\'s easy to feel healthier, happier and less stressed than your own home',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF67666B) /* Grey-70 */,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(30),
            Container(
              child: Image.asset('assets/home_icon_4.png', fit: BoxFit.fill),
            ),
            Gap(60),
            Text(
              'Flexible Filter',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'These are also locations where it\'s easy to feel healthier, happier and less stressed than in America. And for more destinations on the Global Retirement Index.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF67666B) /* Grey-70 */,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
            Gap(30),
            Container(
              child: Image.asset('assets/home_icon_5.png', fit: BoxFit.fill),
            ),
            Gap(25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Video Preview to Make a Right Choice',
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
            Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'These are also locations where it\'s easy to feel healthier, happier and less stressed than in America. And for more destinations on the Global Retirement Index.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF67666B) /* Grey-70 */,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
            Gap(120),
            Container(
              height: 230,
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 199,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/home_icon6.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 44,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      decoration: ShapeDecoration(
                        color: Colors.white /* white */,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFE6E8EE) /* Stroke */,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Gap(10),
                          Icon(Icons.search, color: const Color(0xFF33496C)),
                          Gap(5),
                          Expanded(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: const Color(0xFF33496C) /* Text */,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF15925) /* Brand-color */,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.filter_alt_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: 277,
                      height: 65,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        'Easy Booking And \nPlaning',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'These are also locations where it\'s easy to feel healthier, happier and less stressed than in America. And for more destinations on the Global Retirement Index.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF67666B) /* Grey-70 */,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
            Gap(50),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2) /* BG */,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/stayverz_logo.png',
                    height: 36,
                    width: 150,
                    fit: BoxFit.fill,
                  ),
                  Gap(10),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 45),
                  //   child: Text(
                  //     'Subscribe on our newsletter to get our news',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       color: const Color(0xFF67666B) /* Grey-70 */,
                  //       fontSize: 16,
                  //       fontFamily: 'Inter',
                  //       fontWeight: FontWeight.w400,
                  //       height: 1.50,
                  //     ),
                  //   ),
                  // ),
                  // Gap(16),
                  // Container(
                  //   width: 296,
                  //   height: 44,
                  //   alignment: Alignment.centerRight,
                  //   decoration: ShapeDecoration(
                  //     color: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(7.22),
                  //     ),
                  //     shadows: [
                  //       BoxShadow(
                  //         color: Color(0x26000000),
                  //         blurRadius: 10,
                  //         offset: Offset(0, 0),
                  //         spreadRadius: 2,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Container(
                  //     width: 94,
                  //     height: 40,
                  //     alignment: Alignment.center,
                  //     decoration: ShapeDecoration(
                  //       color: const Color(0xFFF15925) /* Brand-color */,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(7.22),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'Subscribe',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 18,
                  //         fontFamily: 'Cabin Condensed',
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Hello I am Tamim