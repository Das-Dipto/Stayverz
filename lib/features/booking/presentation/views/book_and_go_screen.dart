import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../services/network/error_display_manager.dart';
import 'package:stayverz_flutter_app/widgets/own_title_app_bar.dart';
import '../../../../generated/assets.dart';
import '../../../../views/home_root/booking/payment_web_view_screen.dart';
import '../../../listing/models/assistance_book_guest_model.dart';
import '../../../reservation/presentation/reservation_details_screen.dart';
import '../../controllers/assistance_booking_controller.dart';
import '../../controllers/instant_booking_controller.dart';
import '../../../listing/controllers/listing_controller.dart';
import '../../data/models/book_and_go_model.dart';
import '../../data/repositories/booking_repository_impl.dart';
import 'assistance/guest_reservation_details_screen.dart';

class BookAndGoScreen extends GetView<InstantBookingController> {
  static const String routeName = '/instant-booking-screen';

  BookAndGoScreen({super.key});

  final ListingController _bookingController = Get.find<ListingController>();

  @override
  Widget build(BuildContext context) {
    final instantBookStatus =
        (Get.arguments != null && Get.arguments['status'] != null)
            ? Get.arguments['status'] as String
            : null;

    // Handle initial tab selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool isAssistance = Get.arguments?['assistance'] ?? false;
      _bookingController.selectedReportType.value = isAssistance ? 1 : 0;
      if (instantBookStatus != null) {
        final status = instantBookStatus.toLowerCase();
        if (status == "pending") {
          if(isAssistance) {
            controller.changeGuestAssistanceTab(0);
          } else {
            controller.changeTabb(0);
          }
        } else if (status == "accepted") {
          if(isAssistance) {
            controller.changeGuestAssistanceTab(1);
          } else{
            controller.changeTabb(1);
          }
        } else if (status == "decline") {
          if(isAssistance) {
            controller.changeGuestAssistanceTab(2);
          } else {
            controller.changeTabb(2);
          }
        } else {
          if(isAssistance) {
            controller.changeGuestAssistanceTab(0);
          } else {
            controller.changeTabb(0);
          }
        }
      } else {
        if(isAssistance) {
          controller.changeGuestAssistanceTab(0);
        } else {
          controller.changeTabb(0);
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OwnTitleAppBar(
        appBarText: "Bookings",
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Gap(10),

          // 🟠 NEW TOP TAB: Property / Assistance
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap:
                          () => _bookingController.selectedReportType.value = 0,
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color:
                                  _bookingController.selectedReportType.value ==
                                          0
                                      ? Colors.deepOrange
                                      : const Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: [
                              Image.asset(
                                Assets.assetsPP,
                                width: 50,
                                height: 50,
                              ),
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
                        _bookingController.selectedReportType.value = 1;
                        controller.changeGuestAssistanceTab(
                          controller.selectedAssistanceGuestIndex.value,
                        );
                      },
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color:
                                  _bookingController.selectedReportType.value ==
                                          1
                                      ? Colors.deepOrange
                                      : const Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: [
                              Image.asset(
                                Assets.assetsAsP,
                                width: 50,
                                height: 50,
                              ),
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

          // 🟠 CONDITIONAL VIEW based on selectedReportType
          Expanded(
            child: Obx(() {
              if (_bookingController.selectedReportType.value == 0) {
                // ✅ PROPERTY VIEW
                return Column(
                  children: [
                    const Gap(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        tabButton("Pending", 0),
                        tabButton("Accept", 1),
                        tabButton("Decline", 2),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading1.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.errorMessage1.value.isNotEmpty) {
                          return Center(
                            child: Text(controller.errorMessage1.value),
                          );
                        }

                        switch (controller.selectedIndex.value) {
                          case 0:
                            return bookingListView(controller.pendingBookings);
                          case 1:
                            return bookingListView(controller.acceptedBookings);
                          case 2:
                            return bookingListView(controller.declinedBookings);
                          default:
                            return const SizedBox();
                        }
                      }),
                    ),
                  ],
                );
              } else {
                // 🟢 ASSISTANCE VIEW (you can customize this)
                return Column(
                  children: [
                    const Gap(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        tabButtonGuest("Pending", 0),
                        tabButtonGuest("Accept", 1),
                        tabButtonGuest("Decline", 2),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoadingGuest.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.errorMessageGuest.value.isNotEmpty) {
                          return Center(
                            child: Text(controller.errorMessageGuest.value),
                          );
                        }

                        switch (controller.selectedAssistanceGuestIndex.value) {
                          case 0:
                            return bookingListViewGuest(
                              controller.pendingGuestAssistanceBookings,
                            );
                          case 1:
                            return bookingListViewGuest(
                              controller.acceptedGuestAssistanceBookings,
                            );
                          case 2:
                            return bookingListViewGuest(
                              controller.declinedGuestAssistanceBookings,
                            );
                          default:
                            return const SizedBox();
                        }
                      }),
                    ),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  /// --- TAB BUTTONS (Pending / Accept / Decline)
  Widget tabButton(String text, int index) {
    return GestureDetector(
      onTap: () => controller.changeTabb(index),
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          decoration: BoxDecoration(
            color:
                controller.selectedIndex.value == index
                    ? Colors.orangeAccent
                    : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
              color:
                  controller.selectedIndex.value == index
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget tabButtonGuest(String text, int index) {
    return GestureDetector(
      onTap: () => controller.changeGuestAssistanceTab(index),
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          decoration: BoxDecoration(
            color:
                controller.selectedAssistanceGuestIndex.value == index
                    ? Colors.orangeAccent
                    : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
              color:
                  controller.selectedAssistanceGuestIndex.value == index
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  /// --- BOOKING LIST VIEW
  Widget bookingListView(List<BookingData1> data) {
    if (data.isEmpty) {
      return const Center(child: Text("No bookings found."));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return InkWell(
          onTap:
              () => Get.to(
                ReservationDetailsScreen(
                  bookId: item.invoiceNo,
                  isShowPhone: true,
                  title: '${item.listing?.title}',
                ),
              ),
          child: Container(
            padding: const EdgeInsets.only(left: 20, bottom: 10, right: 10),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(item.listing.coverPhoto),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.listing.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Date: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${item.checkIn} - ${item.checkOut}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Host: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(item.host.fullName),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (item.status == 'accepted')
                            InkWell(
                              onTap: () async {
                                final bookingCode = item.invoiceNo ?? '';
                                final paymentData = await _bookingController
                                    .createPayment(bookingCode);
                                if (paymentData != null) {
                                  final resultWebView = await Get.to(
                                    () => PaymentWebViewScreen(
                                      url: paymentData.paymentGatewayUrl,
                                      booKiD: bookingCode,
                                    ),
                                  );
                                  if (resultWebView == "success") {
                                    controller.fetchGuestInstantBookings(
                                      'pending_conf',
                                    );
                                    controller.fetchGuestInstantBookings(
                                      'accepted',
                                    );
                                    controller.fetchGuestInstantBookings(
                                      'declined',
                                    );
                                    Get.snackbar(
                                      "Payment",
                                      "Payment successful ✅",
                                    );
                                  } else if (resultWebView == "fail") {
                                    Get.snackbar("Payment", "Payment failed ❌");
                                  } else if (resultWebView == "cancel") {
                                    Get.snackbar(
                                      "Payment",
                                      "Payment cancelled ⚠️",
                                    );
                                  }
                                } else {
                                  Get.find<ErrorDisplayManager>().showError("Payment failed");
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.deepOrangeAccent,
                                ),
                                child: const Text(
                                  "Payment",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder:
          (context, index) =>
              Divider(height: 20, thickness: 1, color: Colors.grey.shade300),
    );
  }

  Widget bookingListViewGuest(List<AssistanceGuestData> data) {
    if (data.isEmpty) {
      return const Center(child: Text("No bookings found."));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return InkWell(
          onTap:
              () => Get.to(
                ReservationGuetsDetailsScreen(
                  bookId: "${item.invoiceNo}",
                  isShowPhone: true,
                  title: '${item.listing?.title}',
                ),
              ),
          child: Container(
            padding: const EdgeInsets.only(left: 20, bottom: 10, right: 10),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage("${item.listing?.coverPhoto}"),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.listing?.title}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Date: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${item.checkIn} - ${item.checkOut}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     const Text(
                              //       "Host: ",
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //     Text(" "),
                              //   ],
                              // ),
                            ],
                          ),
                          const Spacer(),
                          if (item.status == 'accepted')
                            InkWell(
                              onTap: () async {
                                final bookingCode = item.invoiceNo ?? '';
                                Get.put(BookingRepositoryImpl());
                                AssistanceBookingController abc = Get.put(AssistanceBookingController(Get.find<BookingRepositoryImpl>()));
                                final paymentData = await abc
                                    .createPayment({
                                  "invoiceNo": bookingCode
                                });
                                if (paymentData != null) {
                                  final resultWebView = await Get.to(
                                    () => PaymentWebViewScreen(
                                      url: paymentData.paymentGatewayUrl ?? '',
                                      booKiD: bookingCode,
                                    ),
                                  );
                                  if (resultWebView == "success") {
                                    controller.fetchGuestInstantBookingsAssistance(
                                      'pending_confirmation',
                                    );
                                    controller.fetchGuestInstantBookingsAssistance(
                                      'accepted',
                                    );
                                    controller.fetchGuestInstantBookingsAssistance(
                                      'declined',
                                    );
                                    Get.snackbar(
                                      "Payment",
                                      "Payment successful ✅",
                                    );
                                  } else if (resultWebView == "fail") {
                                    Get.snackbar("Payment", "Payment failed ❌");
                                  } else if (resultWebView == "cancel") {
                                    Get.snackbar(
                                      "Payment",
                                      "Payment cancelled ⚠️",
                                    );
                                  }
                                } else {
                                  Get.find<ErrorDisplayManager>().showError("Payment failed");
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.deepOrangeAccent,
                                ),
                                child: const Text(
                                  "Payment",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder:
          (context, index) =>
              Divider(height: 20, thickness: 1, color: Colors.grey.shade300),
    );
  }
}

// Hello I am Tamim