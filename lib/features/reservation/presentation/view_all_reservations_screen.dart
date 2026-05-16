import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/components/your_reservations_component.dart';
import 'package:stayverz_flutter_app/widgets/own_title_app_bar.dart';
import '../../../components/your_assistance_component.dart';
import '../../../generated/assets.dart';
import '../../../widgets/your_reservation_components_shimmer_loading.dart';
import '../controllers/reservation_controller.dart';

class ViewAllReservationsScreen extends GetView<ReservationController> {
  const ViewAllReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchHostAllReservation();
      controller.fetchAssistanceAllReservation();
      controller.fetchReservationStats();
    });

    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: "Reservations",
        backgroundColor: Colors.white,
        fontColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ---------- Selection Buttons ----------
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.selectedReportType.value = 0,
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: controller.selectedReportType.value == 0
                                  ? Colors.deepOrange
                                  : const Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            children: [
                              Image.asset(
                                Assets.assetsPP,
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(height: 6),
                              const Text("Property"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.selectedReportType.value = 1,
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: controller.selectedReportType.value == 1
                                  ? Colors.deepOrange
                                  : const Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            children: [
                              Image.asset(
                                Assets.assetsAsP,
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(height: 6),
                              const Text("Assistances"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),


          Expanded(
            child: Obx(() {
              // ---------- Property Reservations ----------
              if (controller.selectedReportType.value == 0) {
                if (controller.isAllReservationLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: const YourReservationComponentsShimmerLoading(),
                  );
                }

                return DefaultTabController(
                  length: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: YourReservationsComponent(
                      enableScroll: true,
                      tabs: const ['Currently Hosting', 'Upcoming', 'Completed'],
                      currentlyHostingReservations: controller.currentlyHostingAllReservations.value,
                      upcomingReservations: controller.upcomingAllReservations.value,
                      completedReservations: controller.completedAllReservations.value,
                      onTap: (index) => controller.selectedAllReservationTabIndex.value = index,
                      selectedTabIndex: controller.selectedAllReservationTabIndex.value,
                    ),
                  ),
                );
              }

              // ---------- Assistance Reservations ----------
              else if (controller.selectedReportType.value == 1) {
                if (controller.isAssistanceAllReservationLoading.value) {
                  return const YourReservationComponentsShimmerLoading();
                }

                return DefaultTabController(
                  length: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: YourAssistanceReservationsComponent(
                      enableScroll: true,
                      tabs: const ['Currently Hosting', 'Upcoming', 'Completed'],
                      currentlyHostingReservations: controller.currentAssistanceCurrentReservations.value,
                      upcomingReservations: controller.currentAssistanceUpcomingReservations.value,
                      completedReservations: controller.currentAssistanceCompleteReservations.value,
                      onTap: (index) => controller.selectedAllReservationTabIndex.value = index,
                      selectedTabIndex: controller.selectedAllReservationTabIndex.value,
                    ),
                  ),
                );
              }

              // ---------- Fallback ----------
              else {
                return const Center(child: Text("No data available"));
              }
            }),
          )


        ],
      ),
    );
  }
}


// Hello I am Tamim