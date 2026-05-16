import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/finance_report/controllers/finance_report_controller.dart';
import 'package:stayverz_flutter_app/widgets/own_title_app_bar.dart';
import 'package:stayverz_flutter_app/widgets/profile_avatar_widget.dart';

import '../models/my_referrals_response_model.dart';

class SuggestionRewardScreen extends GetView<FinanceReportController> {
  final Color primaryColor = Color(0xFF424242); // Dark grey for AppBar
  final Color accentColor = Color(0xFFFFA726); // Orange for highlights

  final List<String> hostNames = ['Siam', 'Rakib', 'Karim'];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSuggestionRewardData();
    });
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: "Suggestion Reward",
        backgroundColor: Colors.white,
        fontColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          children: [
            // Suggested Host List Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggested Host List',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    MyReferralsData? item = controller.suggestedHostList[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: HostCard(
                        name: item?.referredUser?.full_name ?? '_',
                        uType: item?.referredUser?.uType ?? '_',
                        url: item?.referredUser?.image ?? '',
                        totalEarning: item?.rewardValueFromThisReferral ?? '',
                        totalBooking:
                            item?.rewardedBookingCount?.toString() ?? '0',
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(8);
                  },
                  itemCount: controller.suggestedHostList.length,
                ),
              ],
            ),
            const Gap(30),
            Container(
              padding: EdgeInsets.fromLTRB(14, 8, 10, 8),
              decoration: ShapeDecoration(
                color: Colors.white /* white */,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(width: 1, color: Colors.black12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '৳ ${controller.myBalance.value?.totalAvailableCredit ?? '0.0'}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: controller.onClaimClicked,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.zero,
                      ),
                      child: controller.isClaiming.value ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.white),) : Text(
                        'Claim Coupon',
                        style: TextStyle(
                          color: Colors.white /* Black */,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(30),
            // Coupon List Section
            Text(
              'Coupon List',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = controller.myCouponList[index];
                return CouponItem(
                  code: item?.code ?? '',
                  isUsed: item?.usedBy != null,
                );
              },
              separatorBuilder: (context, index) => const Gap(8),
              itemCount: controller.myCouponList.length,
            ),
          ],
        );
      }),
    );
  }
}

class HostCard extends StatelessWidget {
  final String name, url, uType, totalBooking, totalEarning;

  HostCard({
    required this.name,
    required this.uType,
    required this.url,
    required this.totalBooking,
    required this.totalEarning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: Colors.white /* white */,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(width: 1, color: Colors.black12),
        ),
        // shadows: [
        //   BoxShadow(
        //     color: Color(0x3F000000),
        //     blurRadius: 4.30,
        //     offset: Offset(0, 0),
        //     spreadRadius: 0,
        //   )
        // ],
      ),
      child: Row(
        children: [
          ProfileAvatarWidget(url: url, radius: 28),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(uType, style: TextStyle(fontSize: 12)),
              Text(
                'Total Booking : $totalBooking',
                style: TextStyle(fontSize: 10),
              ),
              Text(
                'Total Earnings : \u09F3 $totalEarning',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CouponItem extends GetView<FinanceReportController> {
  final String code;
  final bool isUsed;

  CouponItem({required this.code, this.isUsed = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: Colors.black12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     spreadRadius: 1,
        //     blurRadius: 3,
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            code,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
              decoration:
                  isUsed ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          SizedBox(
            height: 20,
            width: 20,
            child: IconButton(
              icon: Icon(Icons.content_copy, color: Colors.black87, size: 18),
              padding: EdgeInsets.zero,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code)).then((_) {
                  Fluttertoast.showToast(
                    msg: "$code copied to clipboard",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey[700],
                    textColor: Colors.white,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Hello I am Tamim