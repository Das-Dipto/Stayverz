import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/own_app_bar.dart';

class DamageProtection extends StatefulWidget {
  const DamageProtection({super.key});

  @override
  State<DamageProtection> createState() => _DamageProtectionState();
}

class _DamageProtectionState extends State<DamageProtection> {
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
            const Gap(20),
            Expanded(
              child: Text(
                'Damage Protection Acknowledgment',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),
            Text(
              'Stayverz – Damage Protection Acknowledgment',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const Gap(20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  paragraphText(
                      'By accessing or using the Stayverz platform and its associated properties, you acknowledge and agree to the following terms related to damage protection:'),

                  const Gap(16),
                  sectionTitle('Responsibility for Damages'),
                  bulletText(
                      'You are responsible for maintaining the property in good condition throughout the duration of use.'),
                  bulletText(
                      'Any damages caused by negligence, misuse, or failure to comply with property rules may result in repair or replacement charges.'),

                  const Gap(16),
                  sectionTitle('Reporting Requirements'),
                  bulletText(
                      'All damages must be reported immediately via the Stayverz platform or to the designated property manager.'),
                  bulletText(
                      'Failure to report damage in a timely manner may result in additional liability.'),

                  const Gap(16),
                  sectionTitle('Assessment and Resolution'),
                  bulletText(
                      'Stayverz or its designated partners will assess the extent of the damage and determine the appropriate action.'),
                  bulletText(
                      'This may include repair, replacement, or billing of associated costs to the responsible party, in accordance with applicable policies.'),

                  const Gap(16),
                  sectionTitle('Damage Protection Limits'),
                  bulletText(
                      'If damage protection coverage is included, it applies only to accidental damages within specified limits and under approved conditions.'),
                  bulletText(
                      'Intentional or reckless damage is not covered.'),

                  const Gap(16),
                  sectionTitle('Acknowledgment of Liability'),
                  paragraphText(
                      'By proceeding, you acknowledge that you understand and accept these conditions, and that you may be held liable for any damages outside of the protection plan coverage.'),
                ],
              ),
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  Widget bulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, height: 1.6)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15.5,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paragraphText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 15.5,
          height: 1.8,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// Hello I am Tamim