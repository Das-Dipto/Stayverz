import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';

import '../../../controllers/profile_controller.dart';
import '../../../widgets/own_app_bar.dart';

class ReferralLink extends StatefulWidget {
  const ReferralLink({super.key});

  @override
  State<ReferralLink> createState() => _ReferralLinkState();
}

class _ReferralLinkState extends State<ReferralLink> {
  final ProfileController controller = Get.find<ProfileController>();


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
              'Referral',
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
        padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
        children: [
          Gap(10),
          Text(
            'Suggest a host, Earn both of\nYou up to 5,000 Taka',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
          Gap(20),
          Image.asset('assets/referral.png', height: 112, width: 97),
          Gap(15),
          Text(
            'Guests earn 1 point for every 100 takas they spend on bookings. Up to 3 bookings',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Gap(40),
          Text(
            'How it works',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
          Gap(30),
          Row(
            children: [
              Icon(OwnIcons.refer_host_icon),
              Gap(10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New host and referee earning ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                    Text(
                      'New host and referee both will earn 3 percent each for first 3 successful bookings',
                      style: TextStyle(
                        color: const Color(0xFF67666B) /* Grey-70 */,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(16),
          Row(
            children: [
              Icon(OwnIcons.share_recommendation_icon),
              Gap(10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    'Tell us who you\'re referring',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                    Text(
                      'You can refer your friend to host a home or an experience.',
                      style: TextStyle(
                        color: const Color(0xFF67666B) /* Grey-70 */,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(16),
          Row(
            children: [
              Icon(OwnIcons.send_icon),
              Gap(10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send them your referral link',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),

                    Text(
                      'Make sure your friend creates their my_listing using your unique link.',
                      style: TextStyle(
                        color: const Color(0xFF67666B) /* Grey-70 */,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(16),
          Row(
            children: [
              Icon(OwnIcons.refer_host_icon),
              Gap(10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Referral',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),

                    Text(
                      'Add \'Referral\' button and include earn up to 10000 BDT for each referral',
                      style: TextStyle(
                        color: const Color(0xFF67666B) /* Grey-70 */,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(20),
          InkWell(
            onTap:  () async {
            var data=  await controller.getReferralLink();
             String? datatype= controller.referData.value?.shortLink ?? '';
             String? dataCode = controller.referData.value?.referralCode ?? '';
              _showReferralBottomSheet(context, datatype, dataCode);
            },
            child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: EdgeInsets.symmetric(horizontal: 80),
                    decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: const Color(0xFFA9A9B0) /* Grey-50 */,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 10,
                offset: Offset(0, 0),
                spreadRadius: 2,
              )
            ],
                    ),
                    child: Text(
            'Create referral link',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black /* Black */,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
                    ),
                  ),
          ),
          Gap(25),
        ],
      ),
    );
  }

  void _showReferralBottomSheet(BuildContext context, String data, String referrerCode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title and Close icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Referral",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Referrer code: ",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                              ),
                              TextSpan(
                                text: referrerCode,
                                style: TextStyle(
                                  color: const Color(0x86000000) /* Grey-50 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: referrerCode));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Referral code copied!'),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).size.height - 100),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Referrer link: ",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                              ),
                              TextSpan(
                                text: data,
                                style: TextStyle(
                                  color: const Color(0x86000000) /* Grey-50 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: data));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Referral link copied!'),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).size.height - 100),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Hello I am Tamim