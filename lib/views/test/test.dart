import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: const BackButton(),
        title: const Text(''),
      ),
      body: FinanceContent(),
    );
  }
}

class FinanceContent extends StatelessWidget {
  FinanceContent({super.key});

  // Data for charts
  final List<double> last12MonthsData = [
    800, 1900, 3000, 2400, 1800, 2800, 1800, 1200, 2200, 900, 1600, 1800
  ];

  final List<double> last6MonthsData = [
    0, 4200, 0, 3000, 4000, 2000
  ];

  final List<double> yearCompare2024 = [
    500, 800, 600, 700, 500, 600, 700, 600, 800, 1000, 1200, 2800
  ];

  final List<double> yearCompare2025 = [
    600, 500, 400, 900, 1400, 0, 0, 0, 0, 0, 0, 0
  ];

  final List<double> incomePayments = [20, 25, 30, 35, 60, 70, 85];
  final List<double> withdrawalPayments = [10, 20, 40, 50, 60, 70, 80];

  final List<double> historicalData = [2000, 5000, 3000, 9000, 4000];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Earnings Card
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                  const Text(
                    '₺ 25468',
                    style: TextStyle(
                      fontSize: 24,
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            // Two boxes summary
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.monetization_on, color: Colors.orange),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Total Revenue yours earning',
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '₺ 25468',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.bar_chart, color: Colors.blue),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Suggestion Reward',
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '₺ 5468',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                  maxY: 3500,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            );
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
                          if (value % 1000 == 0) {
                            return Text(
                              '₺ ${value.toInt()}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1000,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: last12MonthsData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
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
            ChartContainer(
              title: 'Last 6 Months received payments',
              height: 220,
              child: Column(
                children: [
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 5000,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                                if (value.toInt() >= 0 && value.toInt() < months.length) {
                                  return Text(
                                    months[value.toInt()],
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  );
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
                                if (value % 1000 == 0) {
                                  return Text(
                                    '₺ ${value.toInt()}',
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1000,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: last6MonthsData.asMap().entries.map((entry) {
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Earning ₺ 2548648',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
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
                    horizontalInterval: 1000,
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
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            );
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
                          if (value % 1000 == 0) {
                            return Text(
                              '₺ ${value.toInt()}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: 3000,
                  lineBarsData: [
                    // 2024 Line
                    LineChartBarData(
                      spots: yearCompare2024.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
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
                    // 2025 Line
                    LineChartBarData(
                      spots: yearCompare2025.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
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
                        lineTouchData: LineTouchData(enabled: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
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
                                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
                                if (value.toInt() >= 0 && value.toInt() < months.length) {
                                  if (value.toInt() % 2 == 0) {
                                    return Text(
                                      months[value.toInt()],
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
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
                                return Text(
                                  '${value.toInt()}%',
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                );
                              },
                              interval: 40,
                              reservedSize: 30,
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minY: 0,
                        maxY: 100,
                        minX: 0,
                        maxX: 6,
                        lineBarsData: [
                          LineChartBarData(
                            spots: incomePayments.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(), entry.value);
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
                        lineTouchData: LineTouchData(enabled: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
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
                                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
                                if (value.toInt() >= 0 && value.toInt() < months.length) {
                                  if (value.toInt() % 2 == 0) {
                                    return Text(
                                      months[value.toInt()],
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
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
                                return Text(
                                  '${value.toInt()}%',
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                );
                              },
                              interval: 40,
                              reservedSize: 30,
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minY: 0,
                        maxY: 100,
                        minX: 0,
                        maxX: 6,
                        lineBarsData: [
                          LineChartBarData(
                            spots: withdrawalPayments.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(), entry.value);
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
            ChartContainer(
              title: 'Historical Financial Overview',
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const years = ['2020', '2021', '2022', '2023', '2024'];
                          if (value.toInt() >= 0 && value.toInt() < years.length) {
                            return Text(
                              years[value.toInt()],
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            );
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
                          if (value % 2000 == 0) {
                            return Text(
                              '₺ ${value.toInt()}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2000,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: historicalData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
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
                        sections: [
                          PieChartSectionData(
                            color: Colors.blue.shade300,
                            value: 20,
                            radius: 20,
                            title: '',
                          ),
                          PieChartSectionData(
                            color: Colors.green.shade300,
                            value: 15,
                            radius: 20,
                            title: '',
                          ),
                          PieChartSectionData(
                            color: Colors.orange.shade300,
                            value: 10,
                            radius: 20,
                            title: '',
                          ),
                          PieChartSectionData(
                            color: Colors.red.shade300,
                            value: 15,
                            radius: 20,
                            title: '',
                          ),
                          PieChartSectionData(
                            color: Colors.purple.shade300,
                            value: 10,
                            radius: 20,
                            title: '',
                          ),
                          PieChartSectionData(
                            color: Colors.amber.shade300,
                            value: 15,
                            radius: 20,
                            title: '',
                          ),
                          PieChartSectionData(
                            color: Colors.teal.shade300,
                            value: 15,
                            radius: 20,
                            title: '',
                          ),
                        ],
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
                        sections: [
                          PieChartSectionData(
                            color: Colors.red.shade300,
                            value: 15,
                            radius: 20,
                            title: '',
                          ),
                          PieChartSectionData(
                            color: Colors.orange.shade300,
                            value: 10,
                            radius: 20,
                            title: '',
                          ),
                          PieChartSectionData(
                            color: Colors.grey.shade300,
                            value: 75,
                            radius: 20,
                            title: '',
                          ),
                        ],
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '2024',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '2025',
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            // Insight Stats
            Row(
              children: [
                Expanded(
                  child: InsightCard(
                    title: 'Last 7 days',
                    value: '585',
                    subtitle: 'nights booked',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InsightCard(
                    title: 'Last 30 days',
                    value: '₺154k',
                    subtitle: 'Booking Value',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InsightCard(
                    title: 'Last 365 days',
                    value: '72.5%',
                    subtitle: '5-star rating',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Earning Reports
            const Text(
              'Earning reports',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            // Progress Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularProgressWidget(
                  progress: 0.7,
                  color: Colors.orange,
                  title: 'May',
                  year: '2025',
                ),
                CircularProgressWidget(
                  progress: 0.9,
                  color: Colors.green,
                  title: 'April',
                  year: '2025',
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class ChartContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final double height;

  const ChartContainer({
    super.key,
    required this.title,
    required this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const InsightCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class CircularProgressWidget extends StatelessWidget {
  final double progress;
  final Color color;
  final String title;  // non-nullable
  final String year;   // non-nullable

  const CircularProgressWidget({
    super.key,
    required this.progress,
    required this.color,
    required this.title,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,  // ✅ removed ??""
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      year,   // ✅ removed ??""
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// Hello I am Tamim