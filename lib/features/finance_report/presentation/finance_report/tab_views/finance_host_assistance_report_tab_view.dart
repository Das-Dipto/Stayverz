import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../controllers/finance_report_controller.dart';
import '../../earning_reports_screen.dart';
import '../../suggestion_reward_screen.dart';
import '../../widgets/finance_bottom_sheet_content.dart';
import '../../widgets/finance_chart_container.dart';
import '../../widgets/finance_circular_widget.dart';
import '../../widgets/finance_insight_card.dart';

class FinanceHostAssistanceReportTabView extends GetView<FinanceReportController> {
  FinanceHostAssistanceReportTabView({super.key});

  // Helper function to get color based on month name
  Color _getColorForMonth(String? monthName) {
    if (monthName == null) return Colors.grey.shade400;
    switch (monthName.toLowerCase()) {
      case 'january':
        return Colors.blue.shade300;
      case 'february':
        return Colors.green.shade300;
      case 'march':
        return Colors.orange.shade300;
      case 'april':
        return Colors.purple.shade300;
      case 'may':
        return Colors.red.shade300;
      case 'june':
        return Colors.teal.shade300;
      case 'july':
        return Colors.indigo.shade300;
      case 'august':
        return Colors.amber.shade300;
      case 'september':
        return Colors.cyan.shade300;
      case 'october':
        return Colors.pink.shade300;
      case 'november':
        return Colors.brown.shade300;
      case 'december':
        return Colors.lime.shade300;
      default:
        return Colors.grey.shade400;
    }
  }

  List<PieChartSectionData> _generatePieChartSections(
      List<dynamic>? monthlyBookingAmounts,
      ) {
    if (monthlyBookingAmounts == null || monthlyBookingAmounts.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: 1, // Placeholder to show the circle
          radius: 20,
          title: '',
        ),
      ];
    }

    final allZero = monthlyBookingAmounts.every((item) {
      // Ensure item is not null and access properties safely
      final bookingAmountStr = item?.bookingAmountEarned?.toString();
      final value = double.tryParse(bookingAmountStr ?? '0') ?? 0.0;
      return value == 0.0;
    });

    if (allZero) {
      return [
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: 1, // Placeholder to show the circle
          radius: 20,
          title: '',
        ),
      ];
    }

    return monthlyBookingAmounts.map((item) {
      // Ensure item is not null and access properties safely
      final monthNameStr = item?.monthName as String?;
      final bookingAmountStr = item?.bookingAmountEarned?.toString();
      return PieChartSectionData(
        color: _getColorForMonth(monthNameStr),
        value: double.tryParse(bookingAmountStr ?? '0') ?? 0.0,
        radius: 20,
        title: '',
      );
    }).toList();
  }

  // Data for charts
  final List<double> last12MonthsData = [
    800,
    1900,
    3000,
    2400,
    1800,
    2800,
    1800,
    1200,
    2200,
    900,
    1600,
    1800,
  ];

  final List<double> last6MonthsData = [0, 4200, 0, 3000, 4000, 2000];

  final List<double> yearCompare2024 = [
    500,
    800,
    600,
    700,
    500,
    600,
    700,
    600,
    800,
    1000,
    1200,
    2800,
  ];

  final List<double> yearCompare2025 = [
    600,
    500,
    400,
    900,
    1400,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  final List<double> incomePayments = [20, 25, 30, 35, 60, 70, 85];
  final List<double> withdrawalPayments = [10, 20, 40, 50, 60, 70, 80];

  final List<double> historicalData = [2000, 5000, 3000, 9000, 4000];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Earnings Card
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your earnings for this month',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '৳ ${controller.assistanceFinanceReport.value?.currentMonthTotalEarnings ?? "0.0"}',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Summary breakdown
        const Text(
          'Summary breakdown of Host\'s Earnings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 12),

        // Two boxes summary
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: Colors.black12),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.2),
                    //     blurRadius: 7,
                    //     offset: const Offset(0, 0),
                    //   ),
                    // ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '৳',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Previous yearly earning',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '৳ ${controller.assistanceFinanceReport.value?.summaryPreviousYearBookingEarnings ?? 0}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(SuggestionRewardScreen());
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: Colors.black12),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.2),
                    //     blurRadius: 7,
                    //     offset: const Offset(0, 0),
                    //   ),
                    // ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bar_chart,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Suggestion',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '৳ ${controller.assistanceFinanceReport.value?.summaryLifetimeSuggestionRewards ?? 0}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Last 12 Months Chart
        ChartContainer(
          title: 'Last 12 Months Payments Overview',
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 9999999,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() <
                              controller
                                  .assistanceBarchartForLastTwelveMonthsPaymentsOverview
                                  .length) {
                        final item =
                        controller
                            .assistanceBarchartForLastTwelveMonthsPaymentsOverview[value
                            .toInt()];
                        if (item != null && item.monthName != null) {
                          // Convert full month name to 3-character abbreviation
                          final shortMonthName = item.monthName!.substring(
                            0,
                            3,
                          );
                          return Text(
                            shortMonthName,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
                        }
                      }
                      return const Text('');
                    },
                    reservedSize: 15,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      if (value % 100000 == 0) {
                        return Text(
                          '৳ ${value / 100000}K',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1000000,
                getDrawingHorizontalLine:
                    (value) => FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups:
              controller.assistanceBarchartForLastTwelveMonthsPaymentsOverview
                  .asMap()
                  .entries
                  .map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: double.parse(
                        "${entry.value?.bookingAmountEarned ?? "0"}",
                      ),
                      color: Colors.deepOrange,
                      width: 16,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              })
                  .toList(),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Last 6 Months Chart
        ChartContainer(
          title: 'Last 6 Months received payments',
          height: 220,
          child: Column(
            children: [
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 9999999,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() <
                                    controller
                                        .assistanceBarchartForLastSixMonthsPaymentsOverview
                                        .length) {
                              final item =
                              controller
                                  .assistanceBarchartForLastSixMonthsPaymentsOverview[value
                                  .toInt()];
                              if (item != null && item.monthName != null) {
                                // Convert full month name to 3-character abbreviation
                                final shortMonthName = item.monthName!
                                    .substring(0, 3);
                                return Text(
                                  shortMonthName,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                );
                              }
                            }

                            return const Text('');
                          },
                          reservedSize: 20,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value % 100000 == 0) {
                              return Text(
                                '৳ ${value / 100000}K',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1000000,
                      getDrawingHorizontalLine:
                          (value) => FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups:
                    controller.assistanceBarchartForLastSixMonthsPaymentsOverview
                        .asMap()
                        .entries
                        .map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: double.parse(
                              "${entry.value?.receivedPaymentAmount ?? '0'}",
                            ),
                            color: Colors.grey,
                            width: 16,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    })
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total Earning ৳ ${controller.assistanceFinanceReport.value?.totalEarningsLast6MonthsFromPayouts ?? '0.0'}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(8),
                    SizedBox(
                      height: 16,
                      child: TextButton(
                        onPressed: () {
                          Get.bottomSheet(
                            BottomSheetContent(),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0),
                              ),
                            ),
                            enableDrag: true,
                            isDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Years Comparison Chart
        ChartContainer(
          title: 'Previous Years Comparison',
          height: 220,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 100000,
                getDrawingHorizontalLine:
                    (value) => FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() <
                              controller
                                  .assistanceFinanceReport
                                  .value!
                                  .previousYearMonthlyBookingAmounts!
                                  .length) {
                        final item =
                        controller
                            .assistanceFinanceReport
                            .value!
                            .previousYearMonthlyBookingAmounts?[value
                            .toInt()];
                        if (item != null && item.monthName != null) {
                          // Convert full month name to 3-character abbreviation
                          final shortMonthName = item.monthName!.substring(
                            0,
                            3,
                          );
                          return Text(
                            shortMonthName,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
                        }
                      }
                      return const Text('');
                    },
                    reservedSize: 20,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value % 100000 == 0) {
                        return Text(
                          '৳ ${value / 100000}K',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 35,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 11,
              minY: 0,
              maxY: 999999,
              lineBarsData: [
                // 2024 Line
                LineChartBarData(
                  spots:
                  controller
                      .assistanceFinanceReport
                      .value!
                      .previousYearMonthlyBookingAmounts!
                      .asMap()
                      .entries
                      .map((entry) {
                    return FlSpot(
                      entry.key.toDouble(),
                      double.parse(
                        "${entry.value.bookingAmountEarned ?? '0'}",
                      ),
                    );
                  })
                      .toList(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.1),
                  ),
                ),
                // 2025 Line
                LineChartBarData(
                  spots:
                  controller
                      .assistanceFinanceReport
                      .value!
                      .currentYearMonthlyBookingAmounts!
                      .asMap()
                      .entries
                      .map((entry) {
                    return FlSpot(
                      entry.key.toDouble(),
                      double.parse(
                        "${entry.value.bookingAmountEarned ?? '0'}",
                      ),
                    );
                  })
                      .toList(),
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orange.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Income & Withdrawal Charts
        Row(
          children: [
            Expanded(
              child: ChartContainer(
                title: 'Income Payments',
                height: 170,
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(enabled: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 10000,
                      getDrawingHorizontalLine:
                          (value) => FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() <
                                    controller
                                        .assistanceFinanceReport
                                        .value!
                                        .last6MonthsReceivedPaymentsGraph!
                                        .length) {
                              final item =
                              controller
                                  .assistanceFinanceReport
                                  .value
                                  ?.last6MonthsReceivedPaymentsGraph?[value
                                  .toInt()];
                              if (item != null && item.monthName != null) {
                                // Convert full month name to 3-character abbreviation
                                final shortMonthName = item.monthName!
                                    .substring(0, 3);
                                return Text(
                                  shortMonthName,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                );
                              }
                            }
                            return const Text('');
                          },
                          reservedSize: 20,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value % 10000 == 0) {
                              return Text(
                                '${value / 10000}%',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              );
                            }
                            return const Text('');
                          },
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minY: 0,
                    maxY: 99999,
                    minX: 0,
                    maxX: 6,
                    lineBarsData: [
                      LineChartBarData(
                        spots:
                        controller
                            .assistanceFinanceReport
                            .value!
                            .last6MonthsReceivedPaymentsGraph!
                            .asMap()
                            .entries
                            .map((entry) {
                          return FlSpot(
                            entry.key.toDouble(),
                            double.parse(
                              "${entry.value.bookingAmountEarned ?? '0'}",
                            ),
                          );
                        })
                            .toList(),
                        isCurved: true,
                        color: Colors.black,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ChartContainer(
                title: 'Withdrawal Payments',
                height: 170,
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(enabled: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 10000,
                      getDrawingHorizontalLine:
                          (value) => FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() <
                                    controller
                                        .assistanceFinanceReport
                                        .value!
                                        .last6MonthsReceivedPaymentsGraph!
                                        .length) {
                              final item =
                              controller
                                  .assistanceFinanceReport
                                  .value
                                  ?.last6MonthsReceivedPaymentsGraph?[value
                                  .toInt()];
                              if (item != null && item.monthName != null) {
                                // Convert full month name to 3-character abbreviation
                                final shortMonthName = item.monthName!
                                    .substring(0, 3);
                                return Text(
                                  shortMonthName,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                );
                              }
                            }
                            return const Text('');
                          },
                          reservedSize: 20,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value % 10000 == 0) {
                              return Text(
                                '${value / 10000}%',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              );
                            }
                            return const Text('');
                          },
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minY: 0,
                    maxY: 99999,
                    minX: 0,
                    maxX: 6,
                    lineBarsData: [
                      LineChartBarData(
                        spots:
                        controller
                            .assistanceFinanceReport
                            .value!
                            .last6MonthsReceivedPaymentsGraph!
                            .asMap()
                            .entries
                            .map((entry) {
                          return FlSpot(
                            entry.key.toDouble(),
                            double.parse(
                              "${entry.value.receivedPaymentAmount ?? '0'}",
                            ),
                          );
                        })
                            .toList(),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Historical Financial Overview
        ChartContainer(
          title: 'Historical Financial Overview',
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 999999,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() <
                              controller
                                  .assistanceFinanceReport
                                  .value!
                                  .historicalYearlyIncomeSummary!
                                  .length) {
                        final item =
                        controller
                            .assistanceFinanceReport
                            .value!
                            .historicalYearlyIncomeSummary?[value
                            .toInt()];
                        if (item != null && item.totalIncome != null) {
                          return Text(
                            "${item.year}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
                        }
                      }
                      return const Text('');
                    },
                    reservedSize: 20,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value % 100000 == 0) {
                        return Text(
                          '৳ ${value / 100000}K',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 100000,
                getDrawingHorizontalLine:
                    (value) => FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups:
              controller
                  .assistanceFinanceReport
                  .value!
                  .historicalYearlyIncomeSummary!
                  .asMap()
                  .entries
                  .map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: double.parse(
                        "${entry.value.totalIncome ?? '0'}",
                      ),
                      color: Colors.black87,
                      width: 8,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                      ),
                    ),
                  ],
                );
              })
                  .toList(),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Yearly Income Summary
        const Text(
          'Yearly Income Summary',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 16),

        // Donut Charts
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 150,
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: 270,
                    centerSpaceRadius: 40,
                    sections: _generatePieChartSections(
                      controller
                          .assistanceFinanceReport
                          .value!
                          .previousYearMonthlyBookingAmounts,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 150,
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: 270,
                    centerSpaceRadius: 40,
                    sections: _generatePieChartSections(
                      controller
                          .assistanceFinanceReport
                          .value!
                          .currentYearMonthlyBookingAmounts,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Donut Chart Labels
        Row(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.assistanceFinanceReport.value?.previousYearMonthlyBookingAmounts?.first.year}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.assistanceFinanceReport.value?.currentYearMonthlyBookingAmounts?.first.year}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Insight Section
        const Text(
          'Insight',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 16),

        // Insight Stats
        Row(
          children: [
            Expanded(
              child: InsightCard(
                title: 'Last 7 days',
                value:
                '${controller.assistanceFinanceReport.value?.insights?.last7DaysNightsBooked ?? 0}',
                subtitle: 'nights booked',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InsightCard(
                title: 'Last 30 days',
                value:
                '৳${controller.assistanceFinanceReport.value?.insights?.last30DaysBookingValue ?? 0}',
                subtitle: 'Booking Value',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InsightCard(
                title: 'Last 365 days',
                value:
                '${controller.assistanceFinanceReport.value?.insights?.last365Days5StarRatingPercentage ?? 0}%',
                subtitle: '5-star rating',
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Earning Reports
        const Text(
          'Earning reports',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 16),

        // Progress Indicators
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(
                    EarningReportsScreen(),
                    arguments: {"current": false},
                  );
                },
                child: CircularProgressWidget(
                  progress: 0.7,
                  color: Colors.orange,
                  title:
                  "${controller.assistancePreviousMonthEarning.value?.selectedMonthName ?? 0} ${controller.assistancePreviousMonthEarning.value?.selectedYear ?? 0}",
                  year:
                  '৳ ${controller.assistancePreviousMonthEarning.value?.totalNetEarningsForMonth ?? 0}',
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(
                    EarningReportsScreen(),
                    arguments: {"current": true},
                  );
                },
                child: CircularProgressWidget(
                  progress: 0.9,
                  color: Colors.green,
                  title:
                  "${controller.assistanceCurrentMonthEarning.value?.selectedMonthName ?? 0} ${controller.assistanceCurrentMonthEarning.value?.selectedYear ?? 0}",
                  year:
                  '৳ ${controller.assistanceCurrentMonthEarning.value?.totalNetEarningsForMonth ?? 0}',
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}

// Hello I am Tamim