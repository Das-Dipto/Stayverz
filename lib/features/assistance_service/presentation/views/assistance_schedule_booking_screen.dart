
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../main.dart';
import '../../../../widgets/own_title_app_bar.dart';
import '../../controllers/public_assistance_service_controller.dart';
import 'assistance_reservation_info_form_screen.dart';
import 'package:stayverz_flutter_app/features/messaging/data/models/chat_room_model.dart' as chat_room;
import '../../../messaging/presentation/views/message_conversation_page.dart';
import '../../../../widgets/own_icons_icons.dart';


class AssistanceScheduleBookingScreen extends GetView<PublicAssistanceServiceController> {
  static const String route = '/assistance_schedule_booking';
  const AssistanceScheduleBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      selectedDayHighlightColor: Colors.red,

      // ✅ Logic for selectable days
      selectableDayPredicate: (day) {
        final key =
            "${day.year.toString().padLeft(4, '0')}-"
            "${day.month.toString().padLeft(2, '0')}-"
            "${day.day.toString().padLeft(2, '0')}";

        final data = controller.publicListingDetails.value?.calendarData?[key];

        // 🚫 Blocked/booked logic
        if (data != null && (data.isBooked == true || data.isBlocked == true)) {
          // ✅ Check previous day
          final prevDay = day.subtract(const Duration(days: 1));
          final prevKey =
              "${prevDay.year.toString().padLeft(4, '0')}-"
              "${prevDay.month.toString().padLeft(2, '0')}-"
              "${prevDay.day.toString().padLeft(2, '0')}";

          final prevData = controller.publicListingDetails.value?.calendarData?[prevKey];

          // Allow selection if previous date is free
          if (prevData == null || (prevData.isBooked != true && prevData.isBlocked != true)) {
            return true; // ✅ selectable
          }

          return false; // ❌ otherwise block
        }

        return true; // ✅ normal free day
      },
    );

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (canPop, value) {
        controller.selectedDates.clear();
      },
      child: Scaffold(
        appBar: OwnTitleAppBar(
          appBarText: "Booking Calender",
          onPressed: () => Get.back(),
          buttonIconColor: Colors.black,
          backgroundColor: Colors.white,
          fontColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Schedule your booking',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                      ),
                      CalendarDatePicker2(
                        config: config,
                        value: controller.selectedDates,
                        onValueChanged: (dates) {
                          if (dates.length >= 2) {
                            final start = dates[0];
                            final end = dates[1];

                            DateTime? adjustedEnd;

                            for (DateTime day = start.add(const Duration(days: 1));
                            day.isBefore(end.add(const Duration(days: 1)));
                            day = day.add(const Duration(days: 1))) {
                              final key =
                                  "${day.year.toString().padLeft(4, '0')}-"
                                  "${day.month.toString().padLeft(2, '0')}-"
                                  "${day.day.toString().padLeft(2, '0')}";

                              final data = controller.publicListingDetails.value?.calendarData?[key];

                              if (data != null && (data.isBooked == true || data.isBlocked == true)) {
                                // ✅ Check previous day
                                final prevDay = day.subtract(const Duration(days: 1));
                                final prevKey =
                                    "${prevDay.year.toString().padLeft(4, '0')}-"
                                    "${prevDay.month.toString().padLeft(2, '0')}-"
                                    "${prevDay.day.toString().padLeft(2, '0')}";

                                final prevData = controller.publicListingDetails.value?.calendarData?[prevKey];

                                // If previous date is free, allow current blocked date as selectable
                                if (prevData == null || (prevData.isBooked != true && prevData.isBlocked != true)) {
                                  adjustedEnd = day; // allow selection of this blocked date
                                } else {
                                  adjustedEnd = day.subtract(const Duration(days: 1)); // stop before blocked
                                }
                                break;
                              }
                            }

                            if (adjustedEnd != null) {
                              controller.updateSelectedDates([start, adjustedEnd]);
                              controller.selectedDateCount.value = adjustedEnd.difference(start).inDays;
                            } else {
                              controller.updateSelectedDates(dates);
                              controller.selectedDateCount.value = end.difference(start).inDays;
                            }
                          } else {
                            controller.updateSelectedDates(dates);
                            controller.selectedDateCount.value = 0;
                          }
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(9),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: ShapeDecoration(
                          color: Colors.white /* white */,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFF0F1F5) /* Grey-10 */,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFD9D9D9),
                                      shape: OvalBorder(),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image:
                                          controller.publicListingDetails.value?.host?.image ==
                                              null ||
                                              controller.publicListingDetails.value?.host?.image ==
                                                  ""
                                              ? AssetImage("assets/default_image.jpg")
                                              : NetworkImage(
                                            controller.publicListingDetails.value?.host?.image  ??
                                                "",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        shape: OvalBorder(),
                                      ),
                                    ),
                                  ),
                                  Gap(20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hosted by',
                                          style: TextStyle(
                                            color: const Color(0xFF67666B) /* Grey-70 */,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 1.50,
                                          ),
                                        ),
                                        Gap(5),
                                        Text(
                                          controller.publicListingDetails.value?.host?.firstName ?? '',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            height: 1.50,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Joined in ${formatToDayMonthYear("${controller.publicListingDetails.value?.host?.dateJoined}")}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF67666B) /* Grey-70 */,
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 1.50,
                                              ),
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 18,
                                                  color: Colors.yellow,
                                                ),
                                                Gap(5),
                                                Text(
                                                  '${(controller.publicListingDetails.value?.reviews ?? []).length} Reviews',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!mainControl.isLogin.value) {
                                      Get.toNamed(AppRoute.login);
                                      return;
                                    }

                                    final dates = controller.selectedDates;

                                    if (dates.length < 2) {
                                      Fluttertoast.showToast(
                                        msg: "Please select both check-in and check-out dates.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                      );
                                      return;
                                    }

                                    int totalNights = controller.selectedDateCount.value;

                                    if (totalNights <= 0) {
                                      Fluttertoast.showToast(
                                        msg: "Invalid date range. Check-out must be after check-in.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                      );
                                      return;
                                    }

                                    final hostId = controller.publicListingDetails.value?.host?.id;
                                    if (hostId == null) {
                                      Fluttertoast.showToast(
                                        msg: "Host information not available.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                      );
                                      return;
                                    }

                                    String formatDate(DateTime? dt) {
                                      if (dt == null) return "";
                                      return DateFormat('yyyy-MM-dd').format(dt);
                                    }

                                    final String checkInDate = formatDate(dates[0]);
                                    final String checkOutDate = formatDate(dates[1]);

                                    // capture context before async gap
                                    final currentContext = context;

                                    /// Show message dialog
                                    String? userMessage = await showDialog<String>(
                                      context: currentContext,
                                      barrierDismissible: true,
                                      builder: (dialogContext) {
                                        final TextEditingController messageController = TextEditingController();
                                        return AlertDialog(
                                          title: const Text('Send Message'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Check-in: ",
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey.shade400),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Text(
                                                      checkInDate,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Gap(5),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Check-out: ",
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey.shade400),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Text(
                                                      checkOutDate,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              TextField(
                                                controller: messageController,
                                                maxLines: 4,
                                                decoration: const InputDecoration(
                                                  hintText: 'Write your message here...',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(dialogContext).pop(null),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                final text = messageController.text.trim();
                                                if (text.isEmpty) {
                                                  Fluttertoast.showToast(msg: 'Message cannot be empty');
                                                  return;
                                                }
                                                Navigator.of(dialogContext).pop(text);
                                              },
                                              child: const Text('Submit'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    /// If cancelled or empty
                                    if (userMessage == null || userMessage.isEmpty) return;

                                    /// Build request body
                                    final messageRequest = {
                                      "listing": controller.publicListingDetails.value?.id,
                                      "to_user": hostId,
                                      "booking_data": {
                                        "check_in": checkInDate,
                                        "check_out": checkOutDate,
                                        "total_guest_count":
                                        controller.publicListingDetails.value?.maxPerson ?? 1,
                                      },
                                      "message": userMessage,
                                    };

                                    // check context still mounted before showing loading
                                    if (!currentContext.mounted) return;

                                    /// Show native loading dialog
                                    showDialog(
                                      context: currentContext,
                                      barrierDismissible: false,
                                      builder: (loadingContext) {
                                        return const PopScope(
                                          canPop: false,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                    );

                                    /// API call
                                    await controller.startUserChatRequest(body: messageRequest);

                                    /// Close loading dialog safely
                                    if (currentContext.mounted) {
                                      Navigator.of(currentContext, rootNavigator: true).pop();
                                    }

                                    /// Navigate or show error
                                    if (controller.chatRoomId.value.isNotEmpty) {
                                      Get.toNamed(
                                        MessageConversationScreen.routeName,
                                        arguments: {
                                          'conversationId': controller.chatRoomId.value,
                                          'participantId': mainControl.userId.value,
                                          'participantName':
                                          "${controller.publicListingDetails.value?.host?.firstName ?? ''} ${controller.publicListingDetails.value?.host?.lastName ?? ''}",
                                          'participantAvatar':
                                          controller.publicListingDetails.value?.host?.image ?? '',
                                          'isOnline': false,
                                          'receiver': chat_room.User(
                                            id: "${controller.publicListingDetails.value?.host?.id ?? ''}",
                                            name:
                                            "${controller.publicListingDetails.value?.host?.firstName ?? ''} ${controller.publicListingDetails.value?.host?.lastName ?? ''}",
                                            avatar:
                                            controller.publicListingDetails.value?.host?.image ?? '',
                                            email:
                                            controller.publicListingDetails.value?.host?.email ?? '',
                                          ),
                                        },
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: controller.errorMessage.value.isNotEmpty
                                            ? controller.errorMessage.value
                                            : 'Failed to start chat.',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: EdgeInsets.zero,
                                    side: const BorderSide(width: 0.6, color: Colors.black12),
                                    elevation: 2,
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(OwnIcons.message_icon, size: 16, color: Colors.black),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Message',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(width: 1, color: Colors.deepOrange)
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 3,
                        offset: Offset(0, 0),
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 4,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Text(
                              '৳${controller.publicListingDetails.value?.price}/',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Text(
                              'per day',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              int totalNights = controller.selectedDateCount.value;

                              // Validation: ensure date range is valid
                              if (totalNights <= 0) {
                                Fluttertoast.showToast(
                                  msg: "Please select a valid date range or room.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                );
                                return;
                              }

                              Get.toNamed(AssistanceReservationInfoFormScreen.route);
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 48),
                                backgroundColor: Colors.deepOrange
                            ),
                            child: Text(
                              'Next',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String formatToDayMonthYear(String input) {
    try {
      DateTime dateTime = DateTime.parse(input);
      return DateFormat('d MMM yyyy').format(dateTime); // e.g. 4 Jun 2025
    } catch (e) {
      return 'Invalid date';
    }
  }

}

// Hello I am Tamim