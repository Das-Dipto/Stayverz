import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../widgets/own_app_bar.dart';
import '../../../user_feedback/presentation/give_user_feedback_screen.dart';
import 'archived_message_screen.dart';

class InboxSettingsScreen extends StatelessWidget {

  const InboxSettingsScreen({super.key});
  static const String route = '/inbox-settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 90,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF7F7F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Message Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF090909),
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.27,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                  onPressed: () {Get.toNamed(ArchivedMessageScreen.route);},
                  icon: Image.asset(
                      'assets/archive_icon.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover
                  ),
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                  ),
                  label: Row(
                    children: [
                      const Gap(8),
                      Expanded(
                        child: Text(
                          'Archived messages',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: const Color(0xFF3D3F40),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.38,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey.shade500)
                    ],
                  )
              ),
            ),
            const Gap(14),
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                  onPressed: () {Get.toNamed(GiveUserFeedbackScreen.route);},
                  icon: Image.asset(
                      'assets/feedback_icon.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  label: Row(
                    children: [
                      const Gap(8),
                      Expanded(
                        child: Text(
                          'Give Feedback',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: const Color(0xFF3D3F40),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.38,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey.shade500)
                    ],
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Hello I am Tamim