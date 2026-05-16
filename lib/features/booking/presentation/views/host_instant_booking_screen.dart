import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../services/network/error_display_manager.dart';
import 'package:stayverz_flutter_app/features/booking/controllers/instant_booking_controller.dart';
import 'package:stayverz_flutter_app/features/reservation/presentation/assistance_reservation_details_screen.dart';

import '../../../../generated/assets.dart';
import '../../../../widgets/own_title_app_bar.dart';
import '../../../assistance_service/models/assistance_booking_list_model.dart';
import '../../../reservation/presentation/reservation_details_screen.dart';
import '../../data/models/host_model_instant.dart';

class HostInstantBookingScreen extends GetView<InstantBookingController> {
  static const String routeName = '/host-instant-booking-screen';

  final String? instantBookStatus;

  const HostInstantBookingScreen({
    super.key,
    this.instantBookStatus,
  });

  @override
  Widget build(BuildContext context) {
    final instantBookStatus =
    (Get.arguments != null && Get.arguments['status'] != null)
        ? Get.arguments['status'] as String
        : null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isAssistance = Get.arguments['assistance'] ?? false;
      controller.selectedReportAssistanceType.value = isAssistance ? 1 : 0;
      if (instantBookStatus != null) {
        final status = instantBookStatus.toLowerCase();
        if (status == "pending") {
          if(isAssistance) {
            controller.changeAssistanceTab(0);
          }else {
            controller.changeHostTab(0);
          }
        } else if (status == "accepted") {
          if(isAssistance) {
            controller.changeAssistanceTab(1);
          }else {
            controller.changeHostTab(1);
          }
        } else if (status == "decline") {
          if(isAssistance) {
            controller.changeAssistanceTab(2);
          }else {
            controller.changeHostTab(2);
          }
        } else {
          if(isAssistance) {
            controller.changeAssistanceTab(0);
          }else {
            controller.changeHostTab(0);
          }
        }
      } else {
        if(isAssistance) {
          controller.changeAssistanceTab(0);
        }else {
          controller.changeHostTab(0);
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OwnTitleAppBar(
        appBarText: "Instant Booking",
        fontColor: Colors.black,
        backgroundColor: Colors.white,
        isBackButtonHide: false,
      ),
      body: Column(
        children: [
          const Gap(15),

          /// ✅ Property / Assistance Toggle
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.selectedReportAssistanceType.value = 0;
                        // Reset tab + fetch Property data
                        controller.changeHostTab(controller.selectedIndexx.value);
                      },
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: controller.selectedReportAssistanceType.value == 0
                                  ? Colors.deepOrange
                                  : const Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                      onTap: () {
                        controller.selectedReportAssistanceType.value = 1;
                        // Reset tab + fetch Assistance data
                        controller.changeAssistanceTab(controller.selectedAssistanceIndex.value);
                      },
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: controller.selectedReportAssistanceType.value == 1
                                  ? Colors.deepOrange
                                  : const Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
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

          const Gap(10),

          /// ✅ Tabs (Pending / Accepted / Declined)
          Obx(() {
            final isAssistance = controller.selectedReportAssistanceType.value == 1;
            final selectedIndex = isAssistance
                ? controller.selectedAssistanceIndex.value
                : controller.selectedIndexx.value;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tabButton("Pending", 0, isAssistance),
                tabButton("Accept", 1, isAssistance),
                tabButton("Decline", 2, isAssistance),
              ],
            );
          }),

          const SizedBox(height: 15),

          /// ✅ Booking List (Dynamic by type + tab)
          Expanded(
            child: Obx(() {
              if (controller.isLoadingHost.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessageHost.value.isNotEmpty) {
                return Center(child: Text(controller.errorMessageHost.value));
              }

              final isAssistance = controller.selectedReportAssistanceType.value == 1;
              final index = isAssistance
                  ? controller.selectedAssistanceIndex.value
                  : controller.selectedIndexx.value;

              if (isAssistance) {
                switch (index) {
                  case 0:
                    return bookingListViewAssistance(controller.pendingAssistanceBookings);
                  case 1:
                    return bookingListViewAssistance(controller.acceptedAssistanceBookings);
                  case 2:
                    return bookingListViewAssistance(controller.declinedAssistanceBookings);
                }
              } else {
                switch (index) {
                  case 0:
                    return bookingListView(controller.pendingHostBookings);
                  case 1:
                    return bookingListView(controller.acceptedHostBookings);
                  case 2:
                    return bookingListView(controller.declinedHostBookings);
                }
              }
              return const SizedBox();
            }),
          ),
        ],
      ),
    );
  }

  /// ✅ Reusable Tab Button
  Widget tabButton(String text, int index, bool isAssistance) {
    return GestureDetector(
      onTap: () {
        if (isAssistance) {
          controller.changeAssistanceTab(index);
        } else {
          controller.changeHostTab(index);
        }
      },
      child: Obx(() {
        final selectedIndex = isAssistance
            ? controller.selectedAssistanceIndex.value
            : controller.selectedIndexx.value;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          decoration: BoxDecoration(
            color: selectedIndex == index ? Colors.orangeAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selectedIndex == index ? Colors.white : Colors.black,
            ),
          ),
        );
      }),
    );
  }

  /// ✅ Common Booking List View
  Widget bookingListView(List<BookingData2> data) {
    if (data.isEmpty) {
      return const Center(child: Text("No bookings found."));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];

        return InkWell(
          onTap: () {
            Get.to(
              ReservationDetailsScreen(
                bookId: item.invoiceNo,
                isShowPhone: true,
                title: '${item.listing?.title}',
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(left: 20, bottom: 10, right: 10),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(item.listing?.coverPhoto ?? ''),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.listing?.title ?? 'No title',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            "Date: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              "${item.checkIn?.toLocal().toString().split(' ')[0]} - ${item.checkOut?.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Guest: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              item.guest?.fullName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ✅ Show Accept/Decline buttons only if pending
                if (item.status == 'pending_conf')
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Accept Button
                        InkWell(
                          onTap: () async {
                            final bookingId = item.invoiceNo.toString();
                            await controller.acceptBooking(bookingId);

                            if (controller.errorMessagePost.value.isEmpty) {
                              controller.fetchHostInstantBookings('pending_conf');
                            }
                          },
                          child: Obx(() {
                            final loading =
                                controller.isAcceptLoading[item.invoiceNo.toString()] ?? false;

                            return Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:
                                loading ? Colors.grey : Colors.deepOrangeAccent,
                              ),
                              child: loading
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }),
                        ),

                        const Gap(10),

                        // Decline Button
                        InkWell(
                          onTap: () async {
                            final reasonText = ''.obs;

                            final reason = await Get.defaultDialog<String>(
                              title: "Decline Booking",
                              content: TextField(
                                onChanged: (val) => reasonText.value = val,
                                decoration: const InputDecoration(
                                  hintText: "Enter reason",
                                ),
                              ),
                              confirm: ElevatedButton(
                                onPressed: () =>
                                    Get.back(result: reasonText.value),
                                child: const Text("Submit"),
                              ),
                            );

                            if (reason != null && reason.isNotEmpty) {
                              await controller.declineBooking(
                                item.invoiceNo.toString(),
                                reason,
                              );
                            } else {
                              Get.find<ErrorDisplayManager>().showError("Reason is required");
                            }
                          },
                          child: Obx(() {
                            final loading =
                                controller.isDeclineLoading[item.invoiceNo.toString()] ??
                                    false;

                            return Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: loading ? Colors.grey : Colors.redAccent,
                              ),
                              child: loading
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                "Decline",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        height: 20,
        thickness: 1,
        color: Colors.grey.shade200,
      ),
    );
  }


  Widget bookingListViewAssistance(List<AssistanceReservationBookData> data) {
    if (data.isEmpty) {
      return const Center(child: Text("No bookings found."));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return InkWell(
          onTap: () {
            Get.to(
              ReservationAssistanceDetailsScreen(
                bookId: "${item.invoiceNo}",
                isShowPhone: true,
                title: '${item.listing?.title}',
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(left: 20, bottom: 10, right: 10),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(item.listing?.coverPhoto ?? ''),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.listing?.title ?? 'No title',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text("Date: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              "${item.checkIn?.toLocal().toString().split(' ')[0]} - ${item.checkOut?.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Guest: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              item.guest?.firstName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (item.status == 'pending_confirmation')
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Accept Button
                        InkWell(
                          onTap: () async {
                            final bookingId = item.invoiceNo.toString();
                            await controller.acceptBookingAssitance(bookingId);

                            if (controller.errorMessagePost.value.isEmpty) {
                              controller.fetchHostInstantBookingsAssistance('pending_confirmation');
                            }
                          },
                          child: Obx(() {
                            final loading =
                                controller.isAcceptLoading[item.invoiceNo.toString()] ?? false;

                            return Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:
                                loading ? Colors.grey : Colors.deepOrangeAccent,
                              ),
                              child: loading
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }),
                        ),

                        const Gap(10),

                        // Decline Button
                        InkWell(
                          onTap: () async {
                            final reasonText = ''.obs;

                            final reason = await Get.defaultDialog<String>(
                              title: "Decline Booking",
                              content: TextField(
                                onChanged: (val) => reasonText.value = val,
                                decoration: const InputDecoration(
                                  hintText: "Enter reason",
                                ),
                              ),
                              confirm: ElevatedButton(
                                onPressed: () =>
                                    Get.back(result: reasonText.value),
                                child: const Text("Submit"),
                              ),
                            );

                            if (reason != null && reason.isNotEmpty) {
                              await controller.declineBookingAssistance(
                                item.invoiceNo.toString(),
                                reason,
                              );
                            } else {
                              Get.find<ErrorDisplayManager>().showError("Reason is required");
                            }
                          },
                          child: Obx(() {
                            final loading =
                                controller.isDeclineLoading[item.invoiceNo.toString()] ??
                                    false;

                            return Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: loading ? Colors.grey : Colors.redAccent,
                              ),
                              child: loading
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                "Decline",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => Divider(
        height: 20,
        thickness: 1,
        color: Colors.grey.shade200,
      ),
    );
  }
}

// Hello I am Tamim