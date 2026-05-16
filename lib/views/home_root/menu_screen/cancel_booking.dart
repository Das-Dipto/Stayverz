import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/own_app_bar.dart';

class CancelBooking extends StatefulWidget {
  const CancelBooking({super.key});

  @override
  State<CancelBooking> createState() => _CancelBookingState();
}

class _CancelBookingState extends State<CancelBooking> {
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
            const Gap(20),
            Expanded(
              child: Text(
                'Cancel Booking',
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
              'Stayverz – Cancel Booking Policy',
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
                      'By booking through Stayverz, you agree to the following cancellation terms:'),

                  const Gap(16),
                  sectionTitle('Flexible'),
                  bulletText(
                      'Full refund for cancellations made at least 24 hours before check-in.'),
                  bulletText(
                      'For bookings longer than one day, no refund applies if canceled by guests.'),

                  const Gap(16),
                  sectionTitle('Semi-Flexible'),
                  bulletText(
                      'Full refund for cancellations made at least 72 hours before check-in.'),
                  bulletText(
                      'For bookings longer than one day, no refund applies after the 72-hour window.'),
                  bulletText('Single-day bookings are non-refundable.'),

                  const Gap(16),
                  sectionTitle('Non-Refundable'),
                  bulletText('No refund for cancellations made.'),
                ],
              ),
            ),

            const Gap(24),
            Text(
              'Our hosts decide the policy for cancellation. Please check the host\'s cancellation policy for their property.',
              style: GoogleFonts.poppins(
                fontSize: 15.5,
                height: 1.7,
                color: Colors.black87,
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
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 15.5,
        height: 1.8,
        color: Colors.black87,
      ),
    );
  }
}

// Hello I am Tamim