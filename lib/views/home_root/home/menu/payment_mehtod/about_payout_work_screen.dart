import 'package:flutter/material.dart';
import '../../../../../widgets/own_title_app_bar.dart';

class HowPayoutWorksScreen extends StatelessWidget {
  const HowPayoutWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Payment Method',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          spacing: 28,
          children: [
            Text(
              'What you need to know about STAYVETRZ payouts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Your Stayverz payout is on its way! You choose how you\'d like to receive the money you earn hosting. The options vary depending on where you\'re based.\nThe timing depends on your guest\'s stay length, how long it takes your chosen payout method to process the funds, and whether you\'re new to hosting with Stayverz.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'When Stayverz releases payouts for shorter stays?\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\nFor stays 7 nights or shorter, expect your Stayverz payout to be sent within 24 hours of guest check-in. The final arrival time will depend on the processing speed of your chosen payout method.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'When Stayverz releases payouts for monthly stays?\n\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        'For stays 7 nights or shorter, expect your Stayverz payout to be sent within 24 hours of guest check-in. The final arrival time will depend on the processing speed of your chosen payout method.If the reservation is a stay of 8 nights or more, we\'ll send the payout after the guest checks in, and we\'ll send any payouts after contacting with both parties.\nUpcoming payouts are released to you based on the check-in date, for the duration of the reservation.\nOnce payouts are released by Stayverz, how long it takes you to get your money depends on your payout method\'s processing time.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'How long payouts take to process?\n\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        'There\'s a processing time before the money arrives with your payment provider, after Stayverz releases your payout. You can always contact your payment provider for further details on this timeline.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Make sure your payout method is added correctly.\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: '\nYou must set up at least one ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: 'Payment Method',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' so you can get paid.\nIf you want your payouts to be released automatically, you must ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: 'set a Default Payment Method.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\nYou can always check the status of your payout in your ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text: 'Earnings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' section. If you have multiple listings with check-ins on the same day, your money may usually be sent as a single payout.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Weekend or holidays might delay your payouts.\n\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  TextSpan(
                    text:
                        'If your added payout method is through bank, please know that banking systems don\'t process transactions on weekends or holidays, so your money will be processed the next business day.\nContact your bank directly if you have any questions.\nWhereas mobile financial banking systems allow payouts to be processed and sent on weekends and holidays as well.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

// Hello I am Tamim