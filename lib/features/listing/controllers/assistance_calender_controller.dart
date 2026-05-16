import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../assistance_service/models/assistance_price_update_model.dart';
import '../models/calendar/assistance_calender_responce_model.dart';

class AssistanceCalendarController extends GetxController {
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxList<DateTime> selectedDates = <DateTime>[].obs;
  final RxList<DateTime> blockedDates = <DateTime>[].obs;
  final RxList<DateTime> bookedDates = <DateTime>[].obs; // <-- NEW for booked
  final Rx<AssistanceCalendarResponse?> calendarResponse = Rx<AssistanceCalendarResponse?>(null);

  RxInt price = 0.obs;
  final RxBool isData = false.obs;

  late Rx<DateTime> firstDate;
  late Rx<DateTime> lastDate;

  AssistanceCalendarController() {
    final year = selectedYear.value;
    firstDate = DateTime(year, 1, 1).obs;
    lastDate = DateTime(year, 12, 31).obs;
  }

  void updatePrice(String value) {
    int parsed = int.tryParse(value) ?? 0;
    price.value = parsed;
  }

  void updateYear(int year) {
    selectedYear.value = year;
    firstDate.value = DateTime(year, 1, 1);
    lastDate.value = DateTime(year, 12, 31);
    clearSelection();
  }

  DateTime? _startDate;
  DateTime? _endDate;

  /// Normalize date (remove time)
  DateTime normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Load blocked & booked dates separately
  void loadCalendarDates() {
    blockedDates.clear();
    bookedDates.clear();

    if (calendarResponse.value != null) {
      final calendarData = calendarResponse.value!.data?.calendarData;
      calendarData?.forEach((key, value) {
        final date = DateTime.parse(key);
        final normalized = normalize(date);

        if (value.isBooked == true) {
          bookedDates.add(normalized);
        } else if (value.isBlocked == true) {
          blockedDates.add(normalized);
        }
      });
    }
  }

  /// Check if date is booked
  bool isBooked(DateTime date) {
    if (calendarResponse.value == null) return false;
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final dayData = calendarResponse.value!.data?.calendarData?[dateKey];
    return dayData != null && dayData.isBooked == true;
  }

  User? getBookingUser(DateTime date) {
    if (calendarResponse.value == null) return null;

    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final dayData = calendarResponse.value!.data?.calendarData?[dateKey];

    if (dayData != null && (dayData.isBooked ?? false)) {
      return dayData.bookingData?.first?.user;
    }
    return null;
  }

  /// Check if date is blocked
  bool isBlocked(DateTime date) {
    if (calendarResponse.value == null) return false;
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final dayData = calendarResponse.value!.data?.calendarData?[dateKey];
    return dayData != null && dayData.isBlocked == true;
  }

  /// Toggle range selection (skip booked dates)
  void toggleDate(DateTime date) {
    date = normalize(date);
    if (isBooked(date)) return; // ❌ do not allow selecting booked dates

    if (_startDate == null || (_startDate != null && _endDate != null)) {
      _startDate = date;
      _endDate = null;
      selectedDates.clear();
      selectedDates.add(date);
    } else if (_startDate != null && _endDate == null) {
      _endDate = date;
      final range = getDateRange(_startDate!, _endDate!);
      final validRange = cutOffAtInvalidDate(range);
      selectedDates.assignAll(validRange);
    }
  }

  /// Generate full date range from start to end (inclusive)
  List<DateTime> getDateRange(DateTime start, DateTime end) {
    List<DateTime> range = [];
    final direction = start.isBefore(end) ? 1 : -1;
    DateTime current = start;

    while (true) {
      range.add(current);
      if (isSameDate(current, end)) break;
      current = current.add(Duration(days: direction));
    }
    return range;
  }

  /// Trim range if a booked date is inside
  List<DateTime> cutOffAtInvalidDate(List<DateTime> range) {
    List<DateTime> valid = [];
    for (var date in range) {
      if (isBooked(date)) break; // ❌ stop if booked found
      valid.add(date);
    }
    return valid;
  }

  void clearSelection() {
    selectedDates.clear();
    _startDate = null;
    _endDate = null;
  }

  /// Dragging support
  void beginDragSelection(DateTime date) {
    if (isBooked(date)) return; // ❌ skip booked
    _startDate = normalize(date);
    _endDate = null;
    selectedDates.clear();
    selectedDates.add(_startDate!);
  }

  void dragTo(DateTime date) {
    if (_startDate == null) return;
    if (isBooked(date)) return;
    _endDate = normalize(date);
    final range = getDateRange(_startDate!, _endDate!);
    final validRange = cutOffAtInvalidDate(range);
    selectedDates.assignAll(validRange);
  }

  void endDragSelection() {
    if (_startDate != null && _endDate != null) {
      final range = getDateRange(_startDate!, _endDate!);
      final validRange = cutOffAtInvalidDate(range);
      selectedDates.assignAll(validRange);
    }
  }

  /// Get label for date
  String getLabelForDate(DateTime date) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final dayData = calendarResponse.value?.data?.calendarData?[dateKey];

    if (dayData == null) return '';

    if (dayData.isBooked == true) return 'Booked';
    if (dayData.isBlocked == true) return 'Blocked';
    if ((dayData.price ?? 0) > 0) return '৳ ${dayData.price!.toStringAsFixed(0)}';

    return '';
  }

  List<AssistancePriceUpdatePayload> generateBookingPayload({
    required double price,
    required String note,
  }) {
    final List<AssistancePriceUpdatePayload> result = [];

    for (DateTime date in selectedDates) {
      if (isBooked(date)) continue; // ❌ ignore booked dates

      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final dayData = calendarResponse.value?.data?.calendarData?[dateKey];

      if (dayData != null) {
        result.add(
          AssistancePriceUpdatePayload(
            id: dayData.id!,
            price: price.toStringAsFixed(0),
            isBlocked: false,
            note: note,
            startDate: dateKey,
            endDate: dateKey,
          ),
        );
      }
    }
    return result;
  }

  List<AssistancePriceUpdatePayload> generateBlockedPayload(String? note) {
    final List<AssistancePriceUpdatePayload> result = [];

    for (DateTime date in selectedDates) {
      if (isBooked(date)) continue; // ❌ ignore booked dates

      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final dayData = calendarResponse.value?.data?.calendarData?[dateKey];

      if (dayData != null) {
        result.add(
          AssistancePriceUpdatePayload(
            id: dayData.id!,
            price: "${dayData.price}",
            isBlocked: true,
            note: note ?? dayData.note ?? '',
            startDate: dateKey,
            endDate: dateKey,
          ),
        );
      }
    }
    return result;
  }
}

class BookingInfo {
  final bool isBooked;
  final User? user;

  BookingInfo({required this.isBooked, this.user});
}

// Hello I am Tamim