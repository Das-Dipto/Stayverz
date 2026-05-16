import 'package:get/get.dart';

class WhenController extends GetxController {
  RxBool showCalendar = false.obs;
  RxString whenText = 'Any week'.obs;
  RxList<DateTime?> selectedRange = <DateTime?>[].obs;
  RxString startDate =''.obs;
  RxString endDate =''.obs;
  RxBool isOpen = false.obs;

  void openGuest() => isOpen.value = true;

  void closeGuest() => isOpen.value = false;

  void openCalendar() {
    showCalendar.value = true;
  }

  void cancelCalendar() {
    selectedRange.clear();
    showCalendar.value = false;
  }

  void confirmRange() {
    if (selectedRange.length == 2 &&
        selectedRange[0] != null &&
        selectedRange[1] != null) {
      final start = selectedRange[0]!;
      final end = selectedRange[1]!;
      startDate.value="${selectedRange[0]!}";
      endDate.value="${selectedRange[1]!}";

      whenText.value = "${_formatShort(start)} – ${_formatShort(end)}";
    }
    showCalendar.value = false;
  }

  // 🔥 Clear All Data
  void clearAll() {
    selectedRange.clear();
    whenText.value = 'Any week';
    showCalendar.value = false;
    isOpen.value = false;
  }

  String _formatShort(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${months[date.month - 1]} ${date.day}";
  }

  String _format(DateTime d) => "${d.day}/${d.month}/${d.year}";
}

// Hello I am Tamim