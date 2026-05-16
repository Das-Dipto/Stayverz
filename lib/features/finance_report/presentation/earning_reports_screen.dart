import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/constants/app_colors.dart';
import 'package:stayverz_flutter_app/features/finance_report/controllers/finance_report_controller.dart';

import '../../../widgets/own_title_app_bar.dart';
import '../models/host_monthly_earning_response_model.dart';

class EarningReportsScreen extends GetView<FinanceReportController> {
  EarningReportsScreen({super.key});

  final bool isCurrentMonth = Get.arguments?['current'] ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: "Earning reports",
        backgroundColor: Colors.white,
        fontColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const Gap(16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () => controller.fetchFinanceReport(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final MonthlyEarningData? data = isCurrentMonth
              ? controller.currentMonthEarning.value
              : controller.previousMonthEarning.value;

          if (data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_outlined, color: Colors.grey, size: 48),
                  const Gap(16),
                  Text(
                    'No data available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () => controller.fetchFinanceReport(),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${data.selectedMonthName ?? ''} ${data.selectedYear ?? ''}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Align(
                    alignment: Alignment.center,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'You earned ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          TextSpan(
                            text: '৳ ${data.totalNetEarningsForMonth ?? '0'}',
                            style: const TextStyle(
                              color: Color(0xFFF15925),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          const TextSpan(
                            text: '.',
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
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Gap(30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(width: 1, color: Colors.black12)
                      ),
                    ),
                    child: Column(
                      spacing: 16,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Gross earnings',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            Text(
                              '৳ ${data.grossBookingEarningsForMonth ?? '0'}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Host service fee',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '৳ ${data.totalHostServiceFeeForMonth ?? '0'}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const Divider(height: 1,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total (BDT)',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '৳ ${data.netFromBookingsForMonth ?? '0'}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(18),
                  const Text(
                    'Performance stats',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 74,
                        width: 169,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(7.53),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              padding: const EdgeInsets.symmetric(horizontal: 10.36, vertical: 14.12),
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: NetworkImage("https://princeoftravel.com/wp-content/uploads/2023/03/Park-Hyatt-Toronto-21.jpg"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(6)
                              ),
                            ),
                            VerticalDivider(
                              thickness: 3.5,
                              indent: 10,
                              endIndent: 10,
                              color: AppColors.primaryColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Nights booked',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 2.26,
                                  ),
                                ),
                                Text(
                                  '${data.performanceStats?.totalNightsBookedForMonth ?? 0}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1.33,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 74,
                        width: 169,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              padding: const EdgeInsets.symmetric(horizontal: 10.36, vertical: 14.12),
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: NetworkImage("https://princeoftravel.com/wp-content/uploads/2023/03/Park-Hyatt-Toronto-21.jpg"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(6)
                              ),
                            ),
                            VerticalDivider(
                              thickness: 3.5,
                              indent: 10,
                              endIndent: 10,
                              color: AppColors.primaryColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Avg nights stay',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 2.26,
                                  ),
                                ),
                                Text(
                                  "${data.performanceStats?.averageNightsPerStayForMonth ?? 0.0}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1.33,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(18),
                  const Text(
                    'Listings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  const Gap(8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final listing = data.listingsContributingToEarnings?[index];
                      return Container(
                        height: 74,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 0.94,
                              color: Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(7.53),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              padding: const EdgeInsets.symmetric(horizontal: 10.36, vertical: 14.12),
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: listing?.listingCoverPhoto != null
                                      ? NetworkImage(listing!.listingCoverPhoto!)
                                      : const AssetImage('assets/default_image.jpg') as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    listing?.listingTitle ?? 'Unknown',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.07,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.50,
                                    ),
                                  ),
                                  Text(
                                    'Earning: ৳${listing?.earningsFromThisListingForMonth ?? '0'}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.88,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Gap(8);
                    },
                    itemCount: data.listingsContributingToEarnings?.length ?? 0,
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
