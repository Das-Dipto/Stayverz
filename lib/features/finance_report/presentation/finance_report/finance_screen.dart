import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../services/network/error_display_manager.dart';
import 'package:stayverz_flutter_app/features/finance_report/controllers/finance_report_controller.dart';
import 'package:stayverz_flutter_app/features/finance_report/presentation/finance_report/tab_views/finance_host_report_tab_view.dart';
import 'package:stayverz_flutter_app/widgets/own_title_app_bar.dart';

import '../../../../generated/assets.dart';
import 'tab_views/finance_host_assistance_report_tab_view.dart';

class FinanceScreen extends GetView<FinanceReportController> {
  const FinanceScreen({super.key});

  Future<void> _loadProfile() async {
    try {
      await controller.fetchFinanceReport();
      Get.snackbar("Success", "Finance report refreshed");
    } catch (e) {
      Get.find<ErrorDisplayManager>().showError('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: "Earning reports",
        backgroundColor: Colors.white,
        fontColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 1.58),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const Gap(6),
                const Text(
                  'Error loading finance report',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // ✅ Pull down to refresh
        return RefreshIndicator(
          onRefresh: _loadProfile,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            children: [
              Obx(() {
                return Row(
                  spacing: 16,
                  children: [
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.selectedReportType.value = 0;
                            controller.fetchFinanceReport();
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: controller.selectedReportType.value == 0 ? Colors.deepOrange : const Color(0xFFDCDEE3) /* Grey-30 */,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                spacing: 6,
                                children: [
                                  Image.asset(
                                    Assets.assetsPP,
                                    width: 60,
                                    height: 60,
                                  ),
                                  Text("Property")
                                ],
                              ),
                            ),
                          ),
                        )
                    ),
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.selectedReportType.value = 1;
                            controller.fetchAssistanceFinanceReport();
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: controller.selectedReportType.value == 1 ? Colors.deepOrange : const Color(0xFFDCDEE3) /* Grey-30 */,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                spacing: 6,
                                children: [
                                  Image.asset(
                                    Assets.assetsAsP,
                                    width: 60,
                                    height: 60,
                                  ),
                                  Text("Assistances")
                                ],
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                );
              }),
              const Gap(24),
              Obx(() {
                if(controller.selectedReportType.value == 1) {
                  return FinanceHostAssistanceReportTabView();
                }
                return FinanceHostReportTabView();
              }), // your content here
            ],
          ),
        );
      }),
    );
  }
}

// Hello I am Tamim