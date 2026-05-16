import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/utils/main_utils.dart';

import '../../../../../controllers/profile_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../widgets/own_title_app_bar.dart';
import 'host_benefits_status_screen.dart';
import 'host_progress_status_screen.dart';

class SuperHostPerformanceDashboardScreen extends StatefulWidget {
  final int id;
  const SuperHostPerformanceDashboardScreen({super.key, required this.id});

  @override
  State<SuperHostPerformanceDashboardScreen> createState() =>
      _SuperHostPerformanceDashboardScreenState();
}

class _SuperHostPerformanceDashboardScreenState extends State<SuperHostPerformanceDashboardScreen> {

  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.getSuperhostProgress(widget.id);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Super Host',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
        isBackButtonHide: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Obx(() {
          if (controller.isLoadingListdata.value) {
            return const Center(child: Text("Loading...."));
          }

          if (controller.errorListdata.value.isNotEmpty) {
            return Center(child: Text(controller.errorListdata.value, style: TextStyle(color: Colors.red)));
          }

          final superhost = controller.superhostData.value;

          if (superhost == null || superhost.data == null) {
            return const Center(child: Text('No Superhost Data Found'));
          }

          final currentMetrics = superhost.data!.currentOngoingProgress?.currentMetrics;
          final silverData =  superhost.data?.currentOngoingProgress!.tiersProgress?[0];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Your SuperHost  Status',
                  style: TextStyle(
                    color: const Color(0xFFF15925) /* Brand-color */,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
              Gap(16),
              superhost.data?.currentOngoingProgress?.achievedTier==null?Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black, // default color
                    ),
                    children: const [
                      TextSpan(text: 'Your Next Tier '),
                      TextSpan(
                        text: 'SILVER',
                        style: TextStyle(
                          color: Colors.redAccent, // highlight Silver
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ):
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      if(superhost.data?.currentOngoingProgress?.achievedTier=="SILVER")
                      Column(
                        children: [
                          Center(child: Image.asset(Assets.assetsSilverHost,height: 90,width: 90,)),
                          Text("SILVER"),
                        ],
                      ),
                      if(superhost.data?.currentOngoingProgress?.achievedTier=="GOLD")
                      Column(
                        children: [
                          Center(child: Image.asset(Assets.assetsGoldHost,height: 90,width: 90,)),
                          Text("GOLD"),
                        ],
                      ),
                      if(superhost.data?.currentOngoingProgress?.achievedTier=="PLATINUM")
                      Column(
                        children: [
                          Center(child: Image.asset(Assets.assetsPlatinumHost,height: 90,width: 90,)),
                          Text("PLATINUM"),
                        ],
                      ),
                    ],
                  )
              ),
              const Gap(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assessment period',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${MainUtils.formatDateMonth("${superhost.data?.currentOngoingProgress?.evaluationPeriodStart}")} - ${MainUtils.formatDateMonth("${superhost.data?.currentOngoingProgress?.evaluationPeriodEnd}")} ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      superhost.data?.officialStatusHistory==null||superhost.data!.officialStatusHistory!.length==0?SizedBox():Icon(Icons.keyboard_arrow_down, size: 28),
                    ],
                  ),
                ],
              ),
              const Gap(8),
              Text(
                'Current Assessment',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(8),
              Text(
                'Every 4 months, we check if you\'ve met the Superhost criteria for the past year. If you do, you\'ll become a Superhost.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              const Gap(23),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Get.to(HostProgressStatusScreen()),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.black12,
                  ),
                  child: Text(
                    'Host Progress status',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ),

              const Gap(32),
             if(superhost.data?.currentOngoingProgress?.achievedTier==null||superhost.data?.currentOngoingProgress?.achievedTier=="SILVER")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.6, // adjust height
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Gap(14),
                                    // Top bar with Close button
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Text('Overall rating',style: TextStyle(
                                              color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700
                                          ),),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                    // Scrollable text content
                                    Expanded(
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Text(
                                          '''To meet this criteria, you need a 4.8 or higher average overall rating based on reviews from Jul 1, 2024 to Jun 30, 2025.
                    A guest's rating is incorporated into your average overall rating on the date their review is published - not when their reservation happens. A review is published when both you and the guest review a stay, or when the 14-day review period is over, whichever comes first.
                    So if a guest's reservation happened during one assessment period, and their review was published after the assessment period ended, their rating will count towards your average overall rating for the next period.
                    *It may take up to 24 hours for your hosting stats to reflect the latest info.''',
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ),
                                    ),

                                    // Done button at bottom
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white, // white background
                                            foregroundColor: Colors.black, // text color
                                            side: BorderSide(color: Colors.black), // optional: add black border
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8), // optional rounded corners
                                            ),
                                          ),
                                          onPressed: () => Get.back(),
                                          child: Text('Done'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      },
                      child: HostProgressCard(
                        ratingText: '${silverData?.progressDetails?.reviewScore?.current}',
                        titleText: 'Overall rating',
                        subtitleText: 'Criteria: ${silverData?.criteria?.reviewScoreMin}',
                        statusText:silverData?.progressDetails?.reviewScore?.met==false?'Haven\'t met':'Doing great!',
                        statusIcon: silverData?.progressDetails?.reviewScore?.met==true?Icons.check: Icons.close,
                        leadingIcon: Icons.star,
                        circleIconColor: Colors.white,
                        color:silverData?.progressDetails?.reviewScore?.met==true?Colors.green: Colors.black12,
                      ),
                    ),
                  ),
                  Gap(10),

                  Expanded(
                    child: HostProgressCard(
                      ratingText: '00',
                      titleText: 'Response rate',
                      subtitleText: 'Criteria: 00%',
                      statusText: 'Haven\'t met',
                      isDisabled: true,
                      statusIcon: silverData?.progressDetails?.reviewScore?.met==true?Icons.check: Icons.close,
                      leadingIcon: Icons.percent,
                      circleIconColor: Colors.grey,
                      color:silverData?.progressDetails?.reviewScore?.met==true?Colors.grey: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    child: InkWell(
                      onTap: (){
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.6, // adjust height
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Gap(14),
                                    // Top bar with Close button
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Text('Overall rating',style: TextStyle(
                                              color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700
                                          ),),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                    // Scrollable text content
                                    Expanded(
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Text(
                                          '''You can meet this criteria in one of two different ways, depending on whether you host longer or shorter stays:
                    10 completed stays between Jul 1, 2024 and Jun 30, 2025
                    
                    - or -
                    
                    100 completed nights and at least 3 completed stays, between Jul 1, 2024 and Jun 30, 2025
                    
                    *It may take up to 24 hours for your hosting stats to reflect the latest info.''',
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ),
                                    ),

                                    // Done button at bottom
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white, // white background
                                            foregroundColor: Colors.black, // text color
                                            side: BorderSide(color: Colors.black), // optional: add black border
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8), // optional rounded corners
                                            ),
                                          ),
                                          onPressed: () => Get.back(),
                                          child: Text('Done'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      },

                      child: HostProgressCard(
                        ratingText: '${((silverData?.progressDetails?.hostedDays?.current ?? 0) /
                            (silverData?.progressDetails?.hostedDays?.requiredValue ?? 1) * 100).toStringAsFixed(1)}%',
                        titleText: 'Stays, ${silverData?.progressDetails?.hostedDays?.current} nights',
                        subtitleText: 'Criteria: ${silverData?.progressDetails?.hostedDays?.current} \ncomplete stay or ${silverData?.progressDetails?.hostedDays?.requiredValue} \nnights stays',
                        statusText:silverData?.progressDetails?.hostedDays?.met==false?'Haven\'t met':'Doing great!',
                        statusIcon: silverData?.progressDetails?.hostedDays?.met==false?Icons.close:Icons.check,
                        leadingIcon: null,
                        circleIconColor: Colors.white,
                        color:silverData?.progressDetails?.hostedDays?.met==false? Colors.black12:Colors.green,
                      ),
                    ),
                  ),
                  Gap(10),

                  Expanded(
                    child: InkWell(
                      onTap: (){
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.6, // adjust height
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Gap(14),
                                    // Top bar with Close button
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Text('Overall rating',style: TextStyle(
                                              color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700
                                          ),),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                    // Scrollable text content
                                    Expanded(
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Text(
                                          '''To meet this criteria, cancel fewer than 1% of your reservations between Jul 1, 2024 and Jun 30, 2025.
                    The date you cancel a booking determines when the cancellation is counted in your cancellation rate, regardless of when the reservation was scheduled to take place. Your cancellation rate doesn't include cancellations made under our Extenuating Circumstances policy.
                    
                    *It may take up to 24 hours for your hosting stats to reflect the latest info.''',
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                        ),
                                      ),
                                    ),

                                    // Done button at bottom
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white, // white background
                                            foregroundColor: Colors.black, // text color
                                            side: BorderSide(color: Colors.black), // optional: add black border
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8), // optional rounded corners
                                            ),
                                          ),
                                          onPressed: () => Get.back(),
                                          child: Text('Done'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      },
                      child: HostProgressCard(
                        ratingText: '${silverData?.progressDetails?.cancellationRate?.current}%',
                        titleText: 'Cancellation rate',
                        subtitleText: 'Criteria: Less than ${silverData?.criteria?.cancellationRateMaxPercent}%',
                        statusText:silverData?.progressDetails?.cancellationRate?.met==false?'Haven\'t met' : 'Doing great!',
                        statusIcon: silverData?.progressDetails?.cancellationRate?.met==true?Icons.check: Icons.close,
                        leadingIcon: null,
                        color: silverData?.progressDetails?.cancellationRate?.met==false?Colors.black12:Colors.green,
                        circleIconColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(23),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Get.to(HostBenefitsStatusScreen()),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.black12,
                  ),
                  child: Text(
                    'See Benefits',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            ],
          );
        },)
      ),
    );
  }
}

class HostProgressCard extends StatelessWidget {
  final String? ratingText, titleText, subtitleText, statusText;
  final IconData? statusIcon, leadingIcon;
  final Color? color, circleIconColor;
  final bool isDisabled;

  const HostProgressCard({
    super.key,
    this.ratingText,
    this.statusText,
    this.titleText,
    this.subtitleText,
    this.statusIcon,
    this.leadingIcon,
    this.color,
    this.circleIconColor,
    this.isDisabled = false, // default to false
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isDisabled, // disables interaction
      child: Opacity(
        opacity: isDisabled ? 0.3 : 1.0, // lower opacity when disabled
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              width: 174,
              height: 201,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x26000000),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.asset('./assets/card_shap1.png'),
                      Image.asset('./assets/card_shap.png'),
                      Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(left: 30, top: 16),
                        padding: const EdgeInsets.all(6),
                        decoration: const ShapeDecoration(
                          color: Color(0xFFDCDEE3),
                          shape: OvalBorder(),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const ShapeDecoration(
                            color: Color(0xFFF0F1F5),
                            shape: OvalBorder(),
                            shadows: [
                              BoxShadow(
                                color: Color(0x26000000),
                                blurRadius: 10,
                                offset: Offset(0, 0),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: OvalBorder(),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x26000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 0),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ratingText ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (leadingIcon != null)
                                  Icon(leadingIcon, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    titleText ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  Text(
                    subtitleText ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF67666B),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 115,
              height: 32,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: const BorderSide(width: 4, color: Colors.black12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Gap(4),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: color,
                    child: Icon(
                      statusIcon,
                      size: 10,
                      color: circleIconColor,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    statusText ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF67666B),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Hello I am Tamim