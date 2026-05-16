import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../widgets/own_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class RefundPolicy extends StatefulWidget {
  const RefundPolicy({super.key});

  @override
  State<RefundPolicy> createState() => _RefundPolicyState();
}

class _RefundPolicyState extends State<RefundPolicy> {
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
              'Refund Policy',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF4F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),
            Text(
              'Stayverz – Refund Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.5,
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

                  sectionTitle('1. Eligibility for Refunds'),
                  bulletText('Full Refund: Guests who cancel at least 48 hours before check-in are eligible for a full refund.'),
                  const Gap(12),
                  bulletText('Partial Refund: Cancellations made within 48 hours of check-in are eligible for a 50% refund of the total booking amount.'),
                  const Gap(12),
                  bulletText('No Refund: No refund will be issued for:'),
                  bulletSubText(' Same-day cancellations'),
                  bulletSubText(' No-shows'),
                  bulletSubText(' Bookings marked as non-refundable'),

                  const Gap(24),
                  sectionTitle('2. Special Circumstances'),
                  bulletText('Refunds may be granted outside the standard policy in the following cases:'),
                  bulletSubText(' Verified emergencies (e.g., medical issue, travel restrictions)'),
                  bulletSubText(' Unsafe or uninhabitable property conditions upon arrival'),
                  bulletSubText(' Misrepresentation of the my_listing (subject to verification)'),
                  const Gap(12),
                  paragraphText('All such cases will be reviewed individually, and Stayverz reserves the right to approve or deny a refund based on the evidence provided.'),

                  const Gap(24),
                  sectionTitle('3. Refund Timeline'),
                  paragraphText('Approved refunds will be processed within 5–10 business days to the original payment method. Processing time may vary depending on your financial institution.'),

                  const Gap(24),
                  sectionTitle('4. Disputes'),
                  paragraphText('Any refund disputes must be submitted in writing to Stayverz support within 7 days of check-out. Supporting documents may be required.'),
                ],
              ),
            ),
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
          height: 1.3,
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
          const Text(
            '• ',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
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

  Widget bulletSubText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 2, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 15, height: 1.5)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.5,
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 15.5,
          height: 1.7,
          color: Colors.black87,
        ),
      ),
    );
  }

}

// Hello I am Tamim