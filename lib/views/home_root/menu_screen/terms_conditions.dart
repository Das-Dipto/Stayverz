import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/views/home_root/menu_screen/cancel_booking.dart';
import 'package:stayverz_flutter_app/views/home_root/menu_screen/damage_protection.dart';
import 'package:stayverz_flutter_app/views/home_root/menu_screen/refund_policy.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';

import '../../../widgets/own_app_bar.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
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
                color: Colors.transparent,
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back, size: 20,),
                color: Colors.black,
              ),
            ),
            Text(
              'Terms & Conditions',
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
          Text(
            'Terms and Condition',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.23,
            ),
          ),
          Gap(30),
          InkWell(
            onTap: (){
              Get.to(DamageProtection());
            },
            child: Container(
                    width: double.infinity,
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: ShapeDecoration(
            color: Colors.white /* white */,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            shadows: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 10,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
                    ),
                  child: Row(
                    children: [
            Icon(OwnIcons.favourite_icon,color: Colors.black87,size: 16,),
            Gap(12),
            Expanded(
              child: Text(
                'Damage Protection Acknowledgment',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                  letterSpacing: -0.48,
                ),
              ),
            ),
            Gap(5),
            Icon(OwnIcons.right_arrow_icon,color: const Color(0xFFF15925),),
                    ],
                  ),
                  ),
          ),
          Gap(16),
          InkWell(
            onTap: (){
              Get.to(CancelBooking());
            },
            child: Container(
              width: double.infinity,
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: ShapeDecoration(
                color: Colors.white /* white */,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                shadows: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(OwnIcons.reservation_icon,color: Colors.black87,),
                  Gap(8),
                  Expanded(
                    child: Text(
                      'Cancel Booking',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.48,
                      ),
                    ),
                  ),
                  Gap(5),
                  Icon(OwnIcons.right_arrow_icon,color:const Color(0xFFF15925),),
                ],
              ),
            ),
          ),
          Gap(16),
          InkWell(
            onTap: (){
              Get.to(RefundPolicy());
            },
            child: Container(
              width: double.infinity,
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: ShapeDecoration(
                color: Colors.white /* white */,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                shadows: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.wallet_rounded,color: Colors.black87,),
                  Gap(8),
                  Expanded(
                    child: Text(
                      'Refund Policy',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.48,
                      ),
                    ),
                  ),
                  Gap(5),
                  Icon(OwnIcons.right_arrow_icon,color: const Color(0xFFF15925),),
                ],
              ),
            ),
          ),
          Gap(16),

        ],
      ),
    );
  }
}

// Hello I am Tamim