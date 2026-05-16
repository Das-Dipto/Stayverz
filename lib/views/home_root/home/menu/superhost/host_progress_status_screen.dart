import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stayverz_flutter_app/generated/assets.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';

import '../../../../../widgets/own_title_app_bar.dart';

class HostProgressStatusScreen extends StatefulWidget {
  const HostProgressStatusScreen({super.key});

  @override
  State<HostProgressStatusScreen> createState() =>
      _HostProgressStatusScreenState();
}

class _HostProgressStatusScreenState
    extends State<HostProgressStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Your Super Host Status',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Your Superhost  Status',
                style: TextStyle(
                  color: const Color(0xFFF15925) /* Brand-color */,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
            ),
            const Gap(32),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                HostProgressCard(
                  assets: Assets.assetsSilverHost,
                  titleText: 'Overall rating',
                  subtitleText: 'Criteria: 4.8',
                  statusText: 'Haven\'t met',
                  statusIcon: Icons.close,
                  leadingIcon: Icons.star,
                  color: Colors.black12,
                ),

                HostProgressCard(
                  assets: Assets.assetsGoldHost,
                  titleText: 'Response rate',
                  subtitleText: 'Criteria: 90%',
                  statusText: 'Haven\'t met',
                  statusIcon: Icons.close,
                  leadingIcon: Icons.percent,
                  color: Colors.black12,
                ),
                HostProgressCard(
                  assets: Assets.assetsPlatinumHost,
                  titleText: 'Stays, 0 nights',
                  subtitleText: 'Criteria: 10 \ncomplete stay or 100 \nnights over 3+ stays',
                  statusText: 'Haven\'t met',
                  statusIcon: Icons.close,
                  leadingIcon: null,
                  color: Colors.black12,
                ),
              ],
            ),
            const Gap(16),

          ],
        ),
      ),
    );
  }
}

class HostProgressCard extends StatelessWidget {
  final String? assets, titleText, subtitleText, statusText;
  final IconData? statusIcon, leadingIcon;
  final Color? color, circleIconColor;
  const HostProgressCard({
    super.key,
    this.assets,
    this.statusText,
    this.titleText,
    this.subtitleText,
    this.statusIcon,
    this.leadingIcon,
    this.color,
    this.circleIconColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.42,
      height: 222,
      padding: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFF0F1F5) /* Grey-10 */,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Center(
            child: Column(
              spacing: 6,
              children: [
                if(assets != null) Image.asset(
                  assets!,
                  height: 60,
                ),
                Text(
                  'Silver Host (Tier 1)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          Text(
            'Criteria (within a quarter):',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          const Gap(6),
          Column(
            spacing: 2,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(OwnIcons.review_icon, size: 14,color: Colors.black54),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      'Review score : > 4.49',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(OwnIcons.hosted_successfull_icon, size: 14,color: Colors.black54),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      'Hosted successfully for 20 days',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(OwnIcons.response_time_icon, size: 14,color: Colors.black54),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      'Response time : ≤ 24 hours',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(OwnIcons.cancellation_rate_icon, size: 14,color: Colors.black54,),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      'Cancellation rate : < 3%',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }
}

// Hello I am Tamim