import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/calender_controller.dart';
import '../../../controllers/listing_controller.dart';
import '../../../repositories/listing_repository_interface.dart';
import '../../../../messaging/presentation/views/message_conversation_page.dart';
import '../../../../reservation/controllers/reservation_controller.dart';
import '../../../../../widgets/own_app_bar.dart';
import '../../../../../widgets/profile_avatar_widget.dart';

class HostCalenderView extends StatefulWidget {
  final String title;
  final String id;
  final String? image;
  const HostCalenderView({
    super.key,
    required this.title,
    required this.id,
    this.image,
  });

  @override
  State<HostCalenderView> createState() => _HostCalenderViewState();
}

class _HostCalenderViewState extends State<HostCalenderView> {
  final controller = ListingController(Get.find<ListingRepositoryInterface>());
  final ReservationController controllerReserve = Get.find<ReservationController>();
  final CalendarController Calendercontroller = Get.put(CalendarController());
  final Map<DateTime, GlobalKey> dateCellKeys = {};

  final List<GlobalKey> _monthKeys = List.generate(12, (_) => GlobalKey());

  DateTime? _getDateFromPosition(Offset globalPosition) {
    for (var entry in dateCellKeys.entries) {
      final key = entry.value;
      final context = key.currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final size = box.size;
      final rect = Rect.fromLTWH(
        position.dx,
        position.dy,
        size.width,
        size.height,
      );
      if (rect.contains(globalPosition)) {
        return entry.key;
      }
    }
    return null;
  }

  Map<String, dynamic> getCurrentYearDates() {
    final now = DateTime.now();
    final year = now.year;

    final firstDate = DateTime(year, 1, 1);
    final lastDate = DateTime(year, 12, 31);

    return {'year': year, 'firstDate': firstDate, 'lastDate': lastDate};
  }

  RxInt daa = 0.obs;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentMonth = DateTime.now().month;
      final context = _monthKeys[currentMonth - 1].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 1000),
          alignment: 0.2,
        );
      }
    });

    // Trigger initial calendar fetch
    controller.getListingCalendar(
      fromDate: formatDate(Calendercontroller.firstDate.value),
      toDate: formatDate(Calendercontroller.lastDate.value),
      listingId: int.parse(widget.id),
    );
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 55,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),

              Expanded(
                child: Text(
                  "Calender",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Gap(10),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 90,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 73,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      decoration: ShapeDecoration(
                        color: Colors.white /* white */,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.94,
                            color: const Color(0xFFF0F1F5) /* Grey-10 */,
                          ),
                          borderRadius: BorderRadius.circular(7.53),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Gap(100),
                          Container(
                            width: 3.77,
                            height: 53.67,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF15925) /* Brand-color */,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9415.72),
                              ),
                            ),
                          ),
                          Gap(10),
                          Expanded(
                            child: Text(
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.07,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30,
                    top: 0,
                    child: Container(
                      width: 79.10,
                      height: 79.10,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.36,
                        vertical: 14.12,
                      ),
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image:
                              widget.image == ""
                                  ? AssetImage('assets/default_image.jpg')
                                  : NetworkImage("${widget.image}"),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.94,
                            color: const Color(0xFFA9A9B0) /* Grey-50 */,
                          ),
                          borderRadius: BorderRadius.circular(7.53),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      'Year - ${Calendercontroller.selectedYear.value}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showYearPickerDialog(
                        context,
                        Calendercontroller.selectedYear.value,
                        (yearPicked) {
                          Calendercontroller.updateYear(yearPicked);
                          Calendercontroller.selectedYear.value = yearPicked;
                          Calendercontroller.clearSelection();
                          controller.getListingCalendar(
                            fromDate: formatDate(
                              Calendercontroller.firstDate.value,
                            ),
                            toDate: formatDate(
                              Calendercontroller.lastDate.value,
                            ),
                            listingId: int.parse(widget.id),
                          );
                        },
                      );
                    },
                    child: Row(children: const [Icon(Icons.arrow_drop_down)]),
                  ),
                ],
              ),
            ),
            Gap(10),
            Obx(() {
              if (controller.isCalendarLoading.value &&
                  controller.isInitialLoad.value) {
                return Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: const Center(child: Text("Loading...")),
                );
              }

              if (controller.calendarError.isNotEmpty) {
                return Text('Error: ${controller.calendarError.value}');
              }

              final calendar = controller.calendarResponse.value;
              if (calendar == null) {
                return const Text('No calendar data');
              }

              Calendercontroller.calendarResponse.value =
                  controller.calendarResponse.value;
              final year = Calendercontroller.selectedYear.value;

              return Expanded(
                child: ListView.builder(
                  controller: controller.calenderViewController,
                  padding: EdgeInsets.only(bottom: 65),
                  itemCount: 12,
                  shrinkWrap: true,
                  itemBuilder: (context, monthIndex) {
                    final month = monthIndex + 1;
                    final daysInMonth = DateUtils.getDaysInMonth(year, month);
                    final firstDayOfMonth = DateTime(year, month, 1).weekday;
                    final startOffset = firstDayOfMonth == 7 ? 0 : firstDayOfMonth;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            monthName(month),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                                ['Su','Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                                    .map(
                                      (day) => SizedBox(
                                        width: 40,
                                        child: Center(
                                          child: Text(
                                            day,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onPanStart: (details) {
                              final date = _getDateFromPosition(
                                details.globalPosition,
                              );
                              if (date != null) {
                                final today = DateTime.now();
                                final isPast = date.isBefore(
                                  DateTime(today.year, today.month, today.day),
                                );
                                final isBlocked = Calendercontroller.isBlocked(
                                  date,
                                );
                                if (!isPast && !isBlocked) {
                                  Calendercontroller.beginDragSelection(date);
                                }
                              }
                            },
                            onPanUpdate: (details) {
                              final date = _getDateFromPosition(
                                details.globalPosition,
                              );
                              if (date != null) {
                                final today = DateTime.now();
                                final isPast = date.isBefore(
                                  DateTime(today.year, today.month, today.day),
                                );
                                final isBlocked = Calendercontroller.isBlocked(
                                  date,
                                );
                                if (!isPast && !isBlocked) {
                                  Calendercontroller.dragTo(date);
                                }
                              }
                            },
                            onPanEnd:
                                (_) => Calendercontroller.endDragSelection(),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: startOffset + daysInMonth,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    mainAxisSpacing: 6,
                                    crossAxisSpacing: 6,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (context, index) {
                                if (index < startOffset) {
                                  return const SizedBox.shrink();
                                }

                                final day = index - startOffset + 1;
                                final date = DateTime(year, month, day);
                                final today = DateTime.now();
                                final isPast = date.isBefore(
                                  DateTime(today.year, today.month, today.day),
                                );
                                final isBlocked = Calendercontroller.isBlocked(
                                  date,
                                );

                                dateCellKeys[date] =
                                    dateCellKeys[date] ?? GlobalKey();

                                return Obx(() {
                                  final isSelected = Calendercontroller
                                      .selectedDates
                                      .any(
                                        (d) => Calendercontroller.isSameDate(
                                          d,
                                          date,
                                        ),
                                      );
                                  final isDisabled = isPast;
                                  final bookedUser =
                                      Calendercontroller.getBookingUser(date);

                                  // Get booking ID for the date
                                  final bookingId =
                                      Calendercontroller
                                          .calendarResponse
                                          .value!
                                          .data
                                          .calendarData[DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(date)]
                                          ?.bookingData
                                          ?.booking
                                          ?.id;
                                  final reserveId =
                                      Calendercontroller
                                          .calendarResponse
                                          .value!
                                          .data
                                          .calendarData[DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(date)]
                                          ?.bookingData
                                          ?.booking
                                          ?.invoiceNo;
                                  // If booked, only show avatar
                                  Widget cellContent;
                                  if (bookedUser != null && bookingId != null) {
                                    cellContent = GestureDetector(
                                      onTap: () {
                                        // Fetch reservation data when the bottom sheet is opened
                                        controllerReserve.fetchReservationById(id: "${reserveId}");
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          builder: (context) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.85, // Set to 85% of screen height
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                                    ),
                                                    child: SingleChildScrollView(
                                                      child: Container(
                                                        padding: const EdgeInsets.all(16),
                                                        child: Obx(() {
                                                          if (controllerReserve.isReservationLoading.value) {
                                                            return Padding(
                                                              padding: const EdgeInsets.only(top: 150),
                                                              child: Center(child: CircularProgressIndicator()),
                                                            );
                                                          }
                                                          if (controllerReserve.reservationHasError.value) {
                                                            return Center(
                                                              child: Text(
                                                                controllerReserve.reservationErrorMessage.value,
                                                                style: const TextStyle(color: Colors.red),
                                                              ),
                                                            );
                                                          }
                                                          final reservation = controllerReserve.selectedReservation.value;
                                                          if (reservation == null) {
                                                            return const Center(child: Text("No reservation selected"));
                                                          }
                                                          String formatToDate(String dateTimeString) {
                                                            try {
                                                              DateTime parsed = DateTime.parse(dateTimeString);
                                                              return "${parsed.year.toString().padLeft(4, '0')}-"
                                                                  "${parsed.month.toString().padLeft(2, '0')}-"
                                                                  "${parsed.day.toString().padLeft(2, '0')}";
                                                            } catch (e) {
                                                              return dateTimeString;
                                                            }
                                                          }
                                                          return Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const Gap(20),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [

                                                                  Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                      color: Colors.green, // border color
                                                                      width: 2.0,          // thin border
                                                                    ),
                                                                  ),
                                                                  child: Image.network(
                                                                    controllerReserve.selectedReservation.value!.guest.image,
                                                                    height: 50,
                                                                    width: 50,
                                                                    fit: BoxFit.cover,
                                                                    errorBuilder: (context, error, stackTrace) {
                                                                      return const Icon(Icons.person, size: 28, color: Colors.grey);
                                                                    },
                                                                  ),
                                                                ),


                                                              const Gap(10),
                                                                    Text(
                                                                      controllerReserve.selectedReservation.value!.guest.fullName,
                                                                      style: const TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w600,
                                                                        height: 1.50,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Divider(height: 40, thickness: 0.7),
                                                                Text(
                                                                  '${controllerReserve.selectedReservation.value?.listing.title}',
                                                                  style: const TextStyle(
                                                                    color: Color(0xFF67666B),
                                                                    fontSize: 16,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                const Gap(8),
                                                                Text(
                                                                  '${controllerReserve.selectedReservation.value?.checkIn} - ${controllerReserve.selectedReservation.value?.checkOut} (${controllerReserve.selectedReservation.value?.nightCount} Night)',
                                                                  style: const TextStyle(
                                                                    color: Color(0xFF67666B),
                                                                    fontSize: 16,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                const Gap(8),
                                                                Text(
                                                                  '${controllerReserve.selectedReservation.value?.guestCount} Guests',
                                                                  style: const TextStyle(
                                                                    color: Color(0xFF67666B),
                                                                    fontSize: 16,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w500,
                                                                    height: 1.50,
                                                                  ),
                                                                ),
                                                                const Gap(10),
                                                                Text(
                                                                  'About ${controllerReserve.selectedReservation.value?.guest.fullName}',
                                                                  style: const TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w600,
                                                                    height: 1.50,
                                                                  ),
                                                                ),
                                                                const Gap(5),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "ID Verification : ",
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          (controllerReserve.selectedReservation.value?.guest.identityVerificationStatus ?? "")
                                                                              .replaceAll('_', ' ')
                                                                              .split(' ')
                                                                              .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '')
                                                                              .join(' '),
                                                                          style: const TextStyle(
                                                                            color: Color(0xFF67666B),
                                                                            fontSize: 16,
                                                                            fontFamily: 'Inter',
                                                                            fontWeight: FontWeight.w500,
                                                                            height: 1.50,
                                                                          ),
                                                                        ),
                                                                        const Gap(8),
                                                                        Icon(
                                                                          (() {
                                                                            final status = controllerReserve.selectedReservation.value?.guest.identityVerificationStatus ?? "";
                                                                            if (status.contains('not_verified')) {
                                                                              return Icons.close;
                                                                            } else if (status.contains('pending')) {
                                                                              return Icons.check_circle;
                                                                            } else {
                                                                              return Icons.check_circle;
                                                                            }
                                                                          })(),
                                                                          color: (() {
                                                                            final status = controllerReserve.selectedReservation.value?.guest.identityVerificationStatus ?? "";
                                                                            if (status.contains('not_verified')) {
                                                                              return Colors.red;
                                                                            } else if (status.contains('pending')) {
                                                                              return Colors.grey;
                                                                            } else {
                                                                              return Colors.green;
                                                                            }
                                                                          })(),
                                                                          size: 18,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Gap(5),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Account Type : ",
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          (() {
                                                                            final status = controllerReserve.selectedReservation.value?.guest.status ?? "N/A";
                                                                            return status.isNotEmpty ? status[0].toUpperCase() + status.substring(1).toLowerCase() : status;
                                                                          })(),
                                                                          style: TextStyle(
                                                                            color: controllerReserve.selectedReservation.value?.guest.status == "active" ? Colors.green : const Color(0xFF67666B),
                                                                            fontSize: 16,
                                                                            fontFamily: 'Inter',
                                                                            fontWeight: FontWeight.w500,
                                                                            height: 1.50,
                                                                          ),
                                                                        ),
                                                                        const Gap(8),
                                                                        Icon(
                                                                          (controllerReserve.selectedReservation.value?.guest.status ?? "").toLowerCase() == "active" ? Icons.check_circle : Icons.close,
                                                                          color: (controllerReserve.selectedReservation.value?.guest.status ?? "").toLowerCase() == "active" ? Colors.green : Colors.red,
                                                                          size: 18,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Gap(10),
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                                                  decoration: ShapeDecoration(
                                                                    color: Colors.white,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                    ),
                                                                    shadows: const [
                                                                      BoxShadow(
                                                                        color: Color(0x3F000000),
                                                                        blurRadius: 4,
                                                                        offset: Offset(0, 0),
                                                                        spreadRadius: 0,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text(
                                                                        'Booking Details',
                                                                        style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 16,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w600,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                      const Gap(8),
                                                                      const Text(
                                                                        'Guests',
                                                                        style: TextStyle(
                                                                          color: Color(0xFF282C35),
                                                                          fontSize: 16,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${controllerReserve.selectedReservation.value?.guestCount} guest',
                                                                        style: const TextStyle(
                                                                          color: Color(0xFF282C35),
                                                                          fontSize: 12,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w400,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                      const Divider(height: 5),
                                                                      const Text(
                                                                        'Check-In',
                                                                        style: TextStyle(
                                                                          color: Color(0xFF282C35),
                                                                          fontSize: 16,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${controllerReserve.selectedReservation.value?.checkIn}',
                                                                        style: const TextStyle(
                                                                          color: Color(0xFF282C35),
                                                                          fontSize: 12,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w400,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                      const Divider(height: 5),
                                                                      const Text(
                                                                        'Checkout',
                                                                        style: TextStyle(
                                                                          color: Color(0xFF282C35),
                                                                          fontSize: 16,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${controllerReserve.selectedReservation.value?.checkOut}',
                                                                        style: const TextStyle(
                                                                          color: Color(0xFF282C35),
                                                                          fontSize: 12,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w400,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                      const Divider(height: 5),
                                                                      const Text(
                                                                        'Booking date',
                                                                        style: TextStyle(
                                                                          color: Color(0xFF282C35),
                                                                          fontSize: 16,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${formatToDate(controllerReserve.selectedReservation.value!.createdAt)}',
                                                                        style: const TextStyle(
                                                                          color: Color(0xFF282C35),
                                                                          fontSize: 12,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w400,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                      const Divider(height: 5),
                                                                      const Text(
                                                                        'Confirmation Code',
                                                                        style: TextStyle(
                                                                          color: Color(0xFF282C35),
                                                                          fontSize: 16,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w500,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${controllerReserve.selectedReservation.value?.reservationCode}',
                                                                        style: const TextStyle(
                                                                          color: Color(0xFF282C35),
                                                                          fontSize: 12,
                                                                          fontFamily: 'Inter',
                                                                          fontWeight: FontWeight.w400,
                                                                          height: 1.50,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Gap(20),
                                                                const Text(
                                                                  'Guest Payment',
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w600,
                                                                    height: 1.50,
                                                                  ),
                                                                ),
                                                                const Gap(10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      '৳${controllerReserve.selectedReservation.value?.priceInfo.entries.first.value.price} x ${controllerReserve.selectedReservation.value?.nightCount} nights',
                                                                      style: const TextStyle(
                                                                        color: Color(0xFF67666B),
                                                                        fontSize: 16,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w500,
                                                                        height: 1.50,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '৳${(controllerReserve.selectedReservation.value?.priceInfo.entries.first.value.price ?? 0) * controllerReserve.selectedReservation.value!.nightCount}',
                                                                      textAlign: TextAlign.right,
                                                                      style: const TextStyle(
                                                                        color: Color(0xFF67666B),
                                                                        fontSize: 16,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w500,
                                                                        height: 1.50,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'Guest service charge',
                                                                      style: TextStyle(
                                                                        color: Color(0xFF67666B),
                                                                        fontSize: 12,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w400,
                                                                        height: 1.50,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '৳${controllerReserve.selectedReservation.value?.guestServiceCharge ?? 0}',
                                                                      textAlign: TextAlign.right,
                                                                      style: const TextStyle(
                                                                        color: Color(0xFF67666B),
                                                                        fontSize: 12,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w400,
                                                                        height: 1.50,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'Total Price',
                                                                      style: TextStyle(
                                                                        color: Color(0xFF424141),
                                                                        fontSize: 12,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w400,
                                                                        height: 1.50,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '৳${controllerReserve.selectedReservation.value?.totalPrice ?? 0}',
                                                                      textAlign: TextAlign.right,
                                                                      style: const TextStyle(
                                                                        color: Color(0xFF424141),
                                                                        fontSize: 12,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w400,
                                                                        height: 1.50,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Gap(16),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'Host Service Fee',
                                                                      style: TextStyle(
                                                                        color: Color(0xFF67666B),
                                                                        fontSize: 16,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w500,
                                                                        height: 1.50,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '৳${controllerReserve.selectedReservation.value?.hostServiceCharge}',
                                                                      textAlign: TextAlign.right,
                                                                      style: const TextStyle(
                                                                        color: Color(0xFF67666B),
                                                                        fontSize: 16,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w500,
                                                                        height: 1.50,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Gap(20),
                                                                const Text(
                                                                  'Cancellation Policy',
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w600,
                                                                    height: 1.50,
                                                                  ),
                                                                ),
                                                                const Gap(10),
                                                                const Text(
                                                                  'Non-refundable',
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w500,
                                                                    height: 1.50,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  'You will not receive a refund if you cancel\nyour reservation.',
                                                                  style: TextStyle(
                                                                    color: Color(0xFF67666B),
                                                                    fontSize: 16,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                                const Gap(15),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 16,
                                                    right: 16,
                                                    child: IconButton(
                                                      icon: const Icon(Icons.close, color: Colors.black),
                                                      onPressed: () => Navigator.of(context).pop(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.shade200
                                        ),
                                        width: 32,
                                        height: 32,
                                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                                        clipBehavior: Clip.hardEdge,
                                        child: Image.network(
                                            bookedUser.image ?? "",
                                          fit: BoxFit.cover,
                                          errorBuilder: (a,b,c) {
                                              return Icon(Icons.person, color: Colors.white54,);
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Otherwise show normal date + label
                                    cellContent = Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(
                                            milliseconds: 350,
                                          ),
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : isBlocked
                                                    ? Colors.red
                                                    : isPast
                                                    ? Colors.grey
                                                    : Colors.black87,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            fontSize: 10,
                                          ),
                                          child: Text(
                                            '$day',
                                            style: TextStyle(
                                              decoration:
                                                  Calendercontroller.getLabelForDate(
                                                            date,
                                                          ) ==
                                                          'Blocked'
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          Calendercontroller.getLabelForDate(
                                            date,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : isBlocked
                                                    ? Colors.red
                                                    : Colors.redAccent,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  return GestureDetector(
                                    onTap:
                                        isDisabled
                                            ? null
                                            : () =>
                                                Calendercontroller.toggleDate(
                                                  date,
                                                ),
                                    child: AnimatedContainer(
                                      key: dateCellKeys[date],
                                      duration: const Duration(
                                        milliseconds: 350,
                                      ),
                                      alignment: Alignment.center,
                        
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color:
                                              isSelected
                                                  ? Colors.red
                                                  : isBlocked
                                                  ? Colors.grey.shade100
                                                  : isPast
                                                  ? Colors.grey.shade300
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color:
                                                isSelected
                                                    ? Colors.red
                                                    : isBlocked
                                                    ? Colors.grey
                                                    : Colors.grey.shade400,
                                          ),
                                        ),
                                        child: cellContent,
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 40, right: 16, bottom: 6),
        height: 45,
        decoration: BoxDecoration(
          color: Colors.deepOrangeAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Open Button
            Expanded(
              child: InkWell(
                onTap: () {
                  if (Calendercontroller.selectedDates.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please select at least one date",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                    );
                  } else {
                    final selectedDates = Calendercontroller.selectedDates;
                    String? firstDateKey;
                    double? defaultPrice;
                    String? defaultNote;

                    if (selectedDates.isNotEmpty) {
                      firstDateKey = DateFormat(
                        'yyyy-MM-dd',
                      ).format(selectedDates.first);
                      final dayData =
                          Calendercontroller
                              .calendarResponse
                              .value
                              ?.data
                              .calendarData[firstDateKey];
                      defaultPrice = dayData?.price;
                      defaultNote = dayData?.note;
                    }

                    final noteController = TextEditingController(
                      text: defaultNote ?? '',
                    );
                    Calendercontroller.updatePrice(
                      defaultPrice?.toStringAsFixed(0) ?? '0',
                    );
                    final priceFieldController = TextEditingController(
                      text: defaultPrice?.toStringAsFixed(0) ?? '',
                    );

                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.noHeader,
                      animType: AnimType.scale,
                      dismissOnTouchOutside: false,
                      //   barrierColor: Colors.black.withOpacity(0.5),
                      padding: EdgeInsets.all(12),

                      body: Obx(() {
                        final price = Calendercontroller.price.value;
                        final guestFee =
                            controller
                                .calendarResponse
                                .value!
                                .data
                                .listing
                                .guestServiceCharge;
                        final hostFee =
                            controller
                                .calendarResponse
                                .value!
                                .data
                                .listing
                                .hostServiceCharge;

                        final guestGatewayFee = price * guestFee;
                        final totalGuestPrice = price + guestGatewayFee;
                        final hostEarning = price - (price * hostFee);

                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.75,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "Update & Note",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: priceFieldController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    labelText: "Price",
                                    hintText: "Enter price",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    Calendercontroller.updatePrice(value);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: noteController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: "Note",
                                    hintText: "Enter note",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("Base Price"),
                                    Spacer(),
                                    Text('$price'),
                                  ],
                                ),
                                Gap(10),
                                Row(
                                  children: [
                                    Text("Guest Gateway fee"),
                                    Spacer(),
                                    Text(
                                      '${guestGatewayFee.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                                Divider(thickness: 2, color: Colors.black),
                                Row(
                                  children: [
                                    Text("Total Guest price"),
                                    Spacer(),
                                    Text(
                                      '${totalGuestPrice.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      "You Earn",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${hostEarning.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Calendercontroller.selectedDates
                                            .clear();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final int? price = int.tryParse(
                                          priceFieldController.text,
                                        );
                                        final String note =
                                            noteController.text.trim().isEmpty
                                                ? ""
                                                : noteController.text.trim();
                                        if (price == null) {
                                          Get.snackbar(
                                            "Invalid Input",
                                            "Please enter a valid price and note.",
                                            backgroundColor: Colors.redAccent,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }
                                        if (Calendercontroller
                                            .selectedDates
                                            .isEmpty) {
                                          Get.snackbar(
                                            "No Dates Selected",
                                            "Please select at least one valid date.",
                                            backgroundColor:
                                                Colors.orangeAccent,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }
                                        final payload =
                                            Calendercontroller.generateBookingPayload(
                                              note: note,
                                              price: price.toDouble(),
                                            );
                                        final response = await controller
                                            .submitListingCalendar(
                                              listingId: int.parse(widget.id),
                                              bookingList: payload,
                                            );
                                        // Close loading
                                        Get.back();
                                        if (response != null) {
                                          controller.getListingCalendar(
                                            fromDate: formatDate(
                                              Calendercontroller
                                                  .firstDate
                                                  .value,
                                            ),
                                            toDate: formatDate(
                                              Calendercontroller.lastDate.value,
                                            ),
                                            listingId: int.parse(widget.id),
                                          );
                                          Calendercontroller.clearSelection(); // Optional: Reset selection
                                          Get.snackbar(
                                            "Success",
                                            "Dates have been successfully Update.",
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                          );
                                          Get.back();
                                        }
                                      },
                                      child: const Text("Submit"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ).show();
                  }
                },
                child: Center(
                  child: Text(
                    'Open',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Vertical Divider
            Container(width: 1, height: 30, color: Colors.white),

            // Book Now Button
            Expanded(
              child: InkWell(
                onTap: () {
                  if (Calendercontroller.selectedDates.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please select at least one date",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                    );
                  } else {
                    //  final TextEditingController noteController = TextEditingController();
                    final selectedDates = Calendercontroller.selectedDates;
                    String? firstDateKey;
                    double? defaultPrice;
                    String? defaultNote;

                    if (selectedDates.isNotEmpty) {
                      firstDateKey = DateFormat(
                        'yyyy-MM-dd',
                      ).format(selectedDates.first);
                      final dayData =
                          Calendercontroller
                              .calendarResponse
                              .value
                              ?.data
                              .calendarData[firstDateKey];
                      defaultPrice = dayData?.price;
                      defaultNote = dayData?.note;
                    }
                    final noteController = TextEditingController(
                      text: defaultNote ?? '',
                    );
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.scale,
                      headerAnimationLoop: false,
                      title: 'Confirm Action',
                      desc: 'Are you sure you want to block these dates?',

                      // Add a text input field here
                      body: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Add a note (optional):',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: noteController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Write your note here...',
                              ),
                            ),
                          ],
                        ),
                      ),
                      btnCancelOnPress: () {
                        // Optional: clear the note on cancel
                        noteController.clear();
                      },
                      btnOkText: 'Yes, Block',
                      btnCancelText: 'Cancel',
                      btnOkColor: Colors.red,
                      btnOkOnPress: () async {
                        final noteText =
                            noteController.text.isEmpty
                                ? null
                                : noteController.text;
                        final payload =
                            Calendercontroller.generateBlockedPayload(noteText);

                        // You can include the note in your payload or use it as needed

                        final response = await controller.submitListingCalendar(
                          listingId: int.parse(widget.id),
                          bookingList: payload,
                          // You may want to send the noteText as part of the request if applicable
                        );

                        if (response != null) {
                          controller.getListingCalendar(
                            fromDate: formatDate(
                              Calendercontroller.firstDate.value,
                            ),
                            toDate: formatDate(
                              Calendercontroller.lastDate.value,
                            ),
                            listingId: int.parse(widget.id),
                          );
                          Calendercontroller.clearSelection(); // Optional: Reset selection
                          noteController.clear(); // Clear note after success

                          Get.snackbar(
                            "Success",
                            "Dates have been successfully booked.",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        }
                      },
                    ).show();
                  }
                },
                child: Center(
                  child: Text(
                    'Block Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String monthName(int month) {
    // String currentMonth = DateFormat.LLLL().format(DateTime.now());
    List months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    // int searchIndex = months.indexWhere((e) => currentMonth == e);
    // List remaining = months.sublist(searchIndex, months.length);
    //
    // months.removeRange(searchIndex, months.length);
    // months = remaining + months;

    return months[month - 1];
  }

  void showYearPickerDialog(
    BuildContext context,
    int initialYear,
    Function(int) onYearSelected,
  ) {
    int selectedYear = initialYear;
    final currentYear = DateTime.now().year;
    final years = List.generate(50, (i) => currentYear - 1 + i);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      body: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Year',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  width: double.maxFinite,
                  child: GridView.builder(
                    itemCount: years.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                    itemBuilder: (context, index) {
                      final year = years[index];
                      final isSelected = year == selectedYear;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedYear = year;
                          });
                          Get.back();
                          onYearSelected(year);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                          ),
                          child: Text(
                            year.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );
        },
      ),
    ).show();
  }
}

// Hello I am Tamim