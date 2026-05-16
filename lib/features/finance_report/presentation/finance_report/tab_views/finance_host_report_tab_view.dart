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

class FinanceHostReportTabView extends GetView<FinanceReportController> {
  FinanceHostReportTabView({super.key});

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
          value: 1,
          radius: 20,
          title: '',
        ),
      ];
    }

    final allZero = monthlyBookingAmounts.every((item) {
      final bookingAmountStr = item?.bookingAmountEarned?.toString();
      final value = double.tryParse(bookingAmountStr ?? '0') ?? 0.0;
      return value == 0.0;
    });

    if (allZero) {
      return [
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: 1,
          radius: 20,
          title: '',
        ),
      ];
    }

    return monthlyBookingAmounts.map((item) {
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading indicator while data is being fetched
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Show error message if there's an error
      if (controller.hasError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error loading data',
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
              Text(controller.errorMessage.value),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchFinanceReport(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final report = controller.hostFinanceReport.value;

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
                  '৳ ${report?.currentMonthTotalEarnings ?? "0.0"}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
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
                              const Text(
                                'Total Previous yearly earning',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '৳ ${report?.summaryPreviousYearBookingEarnings ?? 0}',
                                style: const TextStyle(
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
                              const Text(
                                'Suggestion',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '৳ ${report?.summaryLifetimeSuggestionRewards ?? 0}',
                                style: const TextStyle(
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
          if (controller.barchartForLastTwelveMonthsPaymentsOverview.isNotEmpty)
            ChartContainer(
              title: 'Last 12 Months Payments Overview',
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 9999999,
                  barTouchData:  BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 &&
                              index <
                                  controller
                                      .barchartForLastTwelveMonthsPaymentsOverview
                                      .length) {
                            final item = controller
                                .barchartForLastTwelveMonthsPaymentsOverview[
                            index];
                            if (item != null && item.monthName != null) {
                              final shortMonthName =
                              item.monthName!.substring(0, 3);
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
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData:  FlBorderData(show: false),
                  barGroups: controller.barchartForLastTwelveMonthsPaymentsOverview
                      .asMap()
                      .entries
                      .map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: double.tryParse(
                            entry.value?.bookingAmountEarned ?? '0',
                          ) ??
                              0,
                          color: Colors.deepOrange,
                          width: 16,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Last 6 Months Chart
          if (controller.barchartForLastSixMonthsPaymentsOverview.isNotEmpty)
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
                        barTouchData:  BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 &&
                                    index <
                                        controller
                                            .barchartForLastSixMonthsPaymentsOverview
                                            .length) {
                                  final item = controller
                                      .barchartForLastSixMonthsPaymentsOverview[
                                  index];
                                  if (item != null && item.monthName != null) {
                                    final shortMonthName =
                                    item.monthName!.substring(0, 3);
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
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData:  FlBorderData(show: false),
                        barGroups: controller
                            .barchartForLastSixMonthsPaymentsOverview
                            .asMap()
                            .entries
                            .map((entry) {
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: double.tryParse(
                                  entry.value?.receivedPaymentAmount ?? '0',
                                ) ??
                                    0,
                                color: Colors.grey,
                                width: 16,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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
                          'Total Earning ৳ ${report?.totalEarningsLast6MonthsFromPayouts ?? '0.0'}',
                          style: const TextStyle(
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
                              padding: const EdgeInsets.symmetric(horizontal: 6),
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
          if (report?.previousYearMonthlyBookingAmounts != null &&
              report?.currentYearMonthlyBookingAmounts != null)
            ChartContainer(
              title: 'Previous Years Comparison',
              height: 220,
              child: LineChart(
                LineChartData(
                  lineTouchData: const LineTouchData(enabled: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 100000,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 &&
                              index <
                                  (report?.previousYearMonthlyBookingAmounts
                                      ?.length ??
                                      0)) {
                            final item = report
                                ?.previousYearMonthlyBookingAmounts?[index];
                            if (item != null && item.monthName != null) {
                              final shortMonthName =
                              item.monthName!.substring(0, 3);
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
                  borderData:  FlBorderData(show: false),
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: 999999,
                  lineBarsData: [
                    // Previous Year Line
                    LineChartBarData(
                      spots: (report?.previousYearMonthlyBookingAmounts ?? [])
                          .asMap()
                          .entries
                          .map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          double.tryParse(entry.value.bookingAmountEarned ?? '0') ??
                              0,
                        );
                      }).toList(),
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
                    // Current Year Line
                    LineChartBarData(
                      spots: (report?.currentYearMonthlyBookingAmounts ?? [])
                          .asMap()
                          .entries
                          .map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          double.tryParse(entry.value.bookingAmountEarned ?? '0') ??
                              0,
                        );
                      }).toList(),
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
                      lineTouchData: const LineTouchData(enabled: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10000,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 &&
                                  index <
                                      (report
                                          ?.last6MonthsReceivedPaymentsGraph
                                          ?.length ??
                                          0)) {
                                final item = report
                                    ?.last6MonthsReceivedPaymentsGraph?[index];
                                if (item != null && item.monthName != null) {
                                  final shortMonthName =
                                  item.monthName!.substring(0, 3);
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
                      borderData:  FlBorderData(show: false),
                      minY: 0,
                      maxY: 99999,
                      minX: 0,
                      maxX: 6,
                      lineBarsData: [
                        LineChartBarData(
                          spots: (report?.last6MonthsReceivedPaymentsGraph ?? [])
                              .asMap()
                              .entries
                              .map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              double.tryParse(
                                entry.value.bookingAmountEarned ?? '0',
                              ) ??
                                  0,
                            );
                          }).toList(),
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
                      lineTouchData: const LineTouchData(enabled: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10000,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 &&
                                  index <
                                      (report
                                          ?.last6MonthsReceivedPaymentsGraph
                                          ?.length ??
                                          0)) {
                                final item = report
                                    ?.last6MonthsReceivedPaymentsGraph?[index];
                                if (item != null && item.monthName != null) {
                                  final shortMonthName =
                                  item.monthName!.substring(0, 3);
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
                      borderData:  FlBorderData(show: false),
                      minY: 0,
                      maxY: 99999,
                      minX: 0,
                      maxX: 6,
                      lineBarsData: [
                        LineChartBarData(
                          spots: (report?.last6MonthsReceivedPaymentsGraph ?? [])
                              .asMap()
                              .entries
                              .map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              double.tryParse(
                                entry.value.receivedPaymentAmount ?? '0',
                              ) ??
                                  0,
                            );
                          }).toList(),
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
          if (report?.historicalYearlyIncomeSummary != null &&
              report!.historicalYearlyIncomeSummary!.isNotEmpty)
            ChartContainer(
              title: 'Historical Financial Overview',
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 999999,
                  barTouchData:  BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 &&
                              index < report.historicalYearlyIncomeSummary!.length) {
                            final item = report.historicalYearlyIncomeSummary?[index];
                            if (item != null && item.year != null) {
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
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData:  FlBorderData(show: false),
                  barGroups: report.historicalYearlyIncomeSummary!
                      .asMap()
                      .entries
                      .map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: double.tryParse(entry.value.totalIncome ?? '0') ?? 0,
                          color: Colors.black87,
                          width: 8,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
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
                child: Builder(
                  builder: (context) {
                    if (report == null) {
                      return const SizedBox.shrink();
                    }

                    final sections = _generatePieChartSections(
                      report.previousYearMonthlyBookingAmounts,
                    );

                    if (sections.isEmpty) {
                      return const Center(child: Text('No data available'));
                    }

                    return SizedBox(
                      height: 150,
                      child: PieChart(
                        PieChartData(
                          startDegreeOffset: 270,
                          centerSpaceRadius: 40,
                          sections: sections,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final amounts = report?.currentYearMonthlyBookingAmounts;

                    if (amounts == null || amounts.isEmpty) {
                      return const Center(child: Text('No data available'));
                    }

                    return SizedBox(
                      height: 150,
                      child: PieChart(
                        PieChartData(
                          startDegreeOffset: 270,
                          centerSpaceRadius: 40,
                          sections: _generatePieChartSections(amounts),
                        ),
                      ),
                    );
                  },
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
                      '${report?.previousYearMonthlyBookingAmounts?.firstOrNull?.year ?? ''}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
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
                      '${report?.currentYearMonthlyBookingAmounts?.firstOrNull?.year ?? ''}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
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
                  '${report?.insights?.last7DaysNightsBooked ?? 0}',
                  subtitle: 'nights booked',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InsightCard(
                  title: 'Last 30 days',
                  value:
                  '৳${report?.insights?.last30DaysBookingValue ?? 0}',
                  subtitle: 'Booking Value',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InsightCard(
                  title: 'Last 365 days',
                  value:
                  '${report?.insights?.last365Days5StarRatingPercentage ?? 0}%',
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
          Obx(() {
            if (controller.isEarningLoading.value) {
              return Row(
                spacing: 16,
                children: [
                  Expanded(child: _buildEarningShimmer()),
                  Expanded(child: _buildEarningShimmer()),
                ],
              );
            }

            return Row(
              spacing: 16,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Get.to(
                      EarningReportsScreen(),
                      arguments: {"current": false},
                    ),
                    child: CircularProgressWidget(
                      progress: 0.7,
                      color: Colors.orange,
                      title:
                      "${controller.previousMonthEarning.value?.selectedMonthName} ${controller.previousMonthEarning.value?.selectedYear}",
                      year:
                      '৳ ${controller.previousMonthEarning.value?.totalNetEarningsForMonth ?? 0}',
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Get.to(
                      EarningReportsScreen(),
                      arguments: {"current": true},
                    ),
                    child: CircularProgressWidget(
                      progress: 0.9,
                      color: Colors.green,
                      title:
                      "${controller.currentMonthEarning.value?.selectedMonthName} ${controller.currentMonthEarning.value?.selectedYear}",
                      year:
                      '৳ ${controller.currentMonthEarning.value?.totalNetEarningsForMonth ?? 0}',
                    ),
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 40),
        ],
      );
    });
  }

  Widget _buildEarningShimmer() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

// Add this extension for firstOrNull if not available
extension FirstOrNullExtension<T> on List<T>? {
  T? get firstOrNull {
    if (this == null || this!.isEmpty) return null;
    return this!.first;
  }
}