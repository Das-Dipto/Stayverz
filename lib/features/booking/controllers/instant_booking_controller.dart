import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/network/error_display_manager.dart';
import 'package:stayverz_flutter_app/main.dart';
import '../../assistance_service/models/assistance_booking_list_model.dart';
import '../../listing/models/assistance_book_guest_model.dart';
import '../data/models/book_and_go_model.dart';
import '../data/models/host_model_instant.dart';
import '../domain/repositories/booking_repository_interface.dart';

class InstantBookingController extends GetxController {
  final _errorDisplay = Get.find<ErrorDisplayManager>();
  var isDeclineLoading = <String, bool>{}.obs;
  var selectedIndex = 0.obs;
  Rx<int> selectedReportType = Rx<int>(0);

  Rx<int> selectedReportAssistanceType = Rx<int>(0);

  // Bookings by status
  var pendingBookings = <BookingData1>[].obs;
  var acceptedBookings = <BookingData1>[].obs;
  var declinedBookings = <BookingData1>[].obs;

  // Pagination info
  var pendingPage = 1;
  var acceptedPage = 1;
  var declinedPage = 1;

  var pendingAssistancePage = 1;
  var acceptedAssistancePage = 1;
  var declinedAssistancePage = 1;

  var pendingGuestAssistancePage = 1;
  var acceptedGuestAssistancePage = 1;
  var declinedGuestAssistancePage = 1;

  var isLoadingHost = false.obs;
  var isLoadingGuest = false.obs;
  var errorMessageHost = ''.obs;
  var errorMessageGuest = ''.obs;

  // Host bookings by status
  var pendingHostBookings = <BookingData2>[].obs;
  var acceptedHostBookings = <BookingData2>[].obs;
  var declinedHostBookings = <BookingData2>[].obs;

  var pendingAssistanceBookings = <AssistanceReservationBookData>[].obs;
  var acceptedAssistanceBookings = <AssistanceReservationBookData>[].obs;
  var declinedAssistanceBookings = <AssistanceReservationBookData>[].obs;

  var pendingGuestAssistanceBookings = <AssistanceGuestData>[].obs;
  var acceptedGuestAssistanceBookings = <AssistanceGuestData>[].obs;
  var declinedGuestAssistanceBookings = <AssistanceGuestData>[].obs;

  // Pagination info
  var pendingHostPage = 1;
  var acceptedHostPage = 1;
  var declinedHostPage = 1;

  var pendingGuestPage = 1;
  var acceptedGuestPage = 1;
  var declinedGuestPage = 1;

  var selectedIndexx = 0.obs;
  var selectedAssistanceIndex = 0.obs;
  var selectedAssistanceGuestIndex = 0.obs;

  var isLoading1 = false.obs;
  var errorMessage1 = ''.obs;

  var isAcceptLoading = <String, bool>{}.obs; // key = bookingId
  var errorMessagePost = ''.obs;

  final BookingRepositoryInterface repository;

  InstantBookingController({required this.repository});

  @override
  void onInit() {
    if (mainControl.uType.value == 'host') {
      fetchHostInstantBookings('pending_conf');
      fetchHostInstantBookingsAssistance("pending_confirmation");
    } else if (mainControl.uType.value == 'guest') {
      fetchGuestInstantBookings('pending_conf');
    }

    super.onInit();
  }

  // Handle tab change
  void changeTabb(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        fetchGuestInstantBookings('pending_conf');
        break;
      case 1:
        fetchGuestInstantBookings('accepted');
        break;
      case 2:
        fetchGuestInstantBookings('declined');
        break;
    }
  }

  void changeGuestTabb(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        fetchGuestInstantBookings('pending_confirmation');
        break;
      case 1:
        fetchGuestInstantBookings('accepted');
        break;
      case 2:
        fetchGuestInstantBookings('declined');
        break;
    }
  }

  // Fetch bookings by status
  Future<void> fetchGuestInstantBookings(String status, {int page = 1}) async {
    isLoading1.value = true;
    errorMessage1.value = '';
    final result = await repository.getInstantBookings(
      status: status,
      page: page,
    );
    result.fold(
      (failure) {
        errorMessage1.value = failure.message;
      },
      (bookAndGo) {
        switch (status) {
          case 'pending_conf':
            if (page == 1) {
              pendingBookings.value = bookAndGo.data;
            } else {
              pendingBookings.addAll(bookAndGo.data);
            }
            pendingPage = bookAndGo.metaData.next ?? pendingPage;
            break;

          case 'accepted':
            if (page == 1) {
              acceptedBookings.value = bookAndGo.data;
            } else {
              acceptedBookings.addAll(bookAndGo.data);
            }
            acceptedPage = bookAndGo.metaData.next ?? acceptedPage;
            break;

          case 'declined':
            if (page == 1) {
              declinedBookings.value = bookAndGo.data;
            } else {
              declinedBookings.addAll(bookAndGo.data);
            }
            declinedPage = bookAndGo.metaData.next ?? declinedPage;
            break;
        }
      },
    );

    isLoading1.value = false;
  }

  // Load next page for pagination
  Future<void> loadNextPage() async {
    switch (selectedIndex.value) {
      case 0:
        if (pendingPage != null)
          fetchGuestInstantBookings('pending_conf', page: pendingPage);
        break;
      case 1:
        if (acceptedPage != null)
          fetchGuestInstantBookings('accepted', page: acceptedPage);
        break;
      case 2:
        if (declinedPage != null)
          fetchGuestInstantBookings('declined', page: declinedPage);
        break;
    }
  }

  // Handle tab change
  void changeHostTab(int index) {
    selectedIndexx.value = index;

    switch (index) {
      case 0:
        fetchHostInstantBookings('pending_conf');
        break;
      case 1:
        fetchHostInstantBookings('accepted');
        break;
      case 2:
        fetchHostInstantBookings('declined');
        break;
    }
  }

  void changeAssistanceTab(int index) {
    selectedAssistanceIndex.value = index;

    switch (index) {
      case 0:
        fetchHostInstantBookingsAssistance('pending_confirmation');
        break;
      case 1:
        fetchHostInstantBookingsAssistance('accepted');
        break;
      case 2:
        fetchHostInstantBookingsAssistance('declined');
        break;
    }
  }

  // Fetch host bookings by status
  Future<void> fetchHostInstantBookings(String status, {int page = 1}) async {
    isLoadingHost.value = true;
    errorMessageHost.value = '';

    final result = await repository.getHostInstantBookings(
      status: status,
      page: page,
    );

    result.fold(
      (failure) {
        errorMessageHost.value = failure.message;
      },
      (bookingResponse) {
        switch (status) {
          case 'pending_conf':
            if (page == 1) {
              pendingHostBookings.value = bookingResponse.data;
            } else {
              pendingHostBookings.addAll(bookingResponse.data);
            }
            pendingHostPage = bookingResponse.metaData.next ?? pendingHostPage;
            break;

          case 'accepted':
            if (page == 1) {
              acceptedHostBookings.value = bookingResponse.data;
            } else {
              acceptedHostBookings.addAll(bookingResponse.data);
            }
            acceptedHostPage =
                bookingResponse.metaData.next ?? acceptedHostPage;
            break;

          case 'declined':
            if (page == 1) {
              declinedHostBookings.value = bookingResponse.data;
            } else {
              declinedHostBookings.addAll(bookingResponse.data);
            }
            declinedHostPage =
                bookingResponse.metaData.next ?? declinedHostPage;
            break;
        }
      },
    );

    isLoadingHost.value = false;
  }

  Future<void> fetchHostInstantBookingsAssistance(
    String status, {
    int page = 1,
  }) async {
    isLoadingHost.value = true;
    errorMessageGuest.value = '';

    final result = await repository.getAssistanceInstantBookings(
      status: status,
      page: page,
    );

    result.fold(
      (failure) {
        errorMessageGuest.value = failure.message;
      },
      (bookingResponse) {
        switch (status) {
          case 'pending_confirmation':
            if (page == 1) {
              pendingAssistanceBookings.value = bookingResponse.data;
            } else {
              pendingAssistanceBookings.addAll(bookingResponse.data);
            }
            pendingAssistancePage = bookingResponse.page ?? pendingHostPage;
            break;

          case 'accepted':
            if (page == 1) {
              acceptedAssistanceBookings.value = bookingResponse.data;
            } else {
              acceptedAssistanceBookings.addAll(bookingResponse.data);
            }
            acceptedAssistancePage = bookingResponse.page ?? acceptedHostPage;
            break;

          case 'declined':
            if (page == 1) {
              declinedAssistanceBookings.value = bookingResponse.data;
            } else {
              declinedAssistanceBookings.addAll(bookingResponse.data);
            }
            declinedAssistancePage = bookingResponse.page ?? declinedHostPage;
            break;
        }
      },
    );

    isLoadingHost.value = false;
  }

  void changeGuestAssistanceTab(int index) {
    selectedAssistanceGuestIndex.value = index;

    switch (index) {
      case 0:
        fetchGuestInstantBookingsAssistance('pending_confirmation');
        break;
      case 1:
        fetchGuestInstantBookingsAssistance('accepted');
        break;
      case 2:
        fetchGuestInstantBookingsAssistance('declined');
        break;
    }
  }

  Future<void> fetchGuestInstantBookingsAssistance(
    String status, {
    int page = 1,
  }) async {
    isLoadingGuest.value = true;
    errorMessageHost.value = '';

    final result = await repository.getAssistanceGuestInstantBookings(
      status: status,
      page: page,
    );

    result.fold(
      (failure) {
        errorMessageHost.value = failure.message;
      },
      (bookingResponse) {
        switch (status) {
          case 'pending_confirmation':
            if (page == 1) {
              pendingGuestAssistanceBookings.value = bookingResponse.data!;
            } else {
              pendingGuestAssistanceBookings.addAll(
                bookingResponse.data as Iterable<AssistanceGuestData>,
              );
            }
            pendingGuestAssistancePage =
                bookingResponse.page ?? pendingGuestPage;
            break;

          case 'accepted':
            if (page == 1) {
              acceptedGuestAssistanceBookings.value = bookingResponse.data!;
            } else {
              acceptedGuestAssistanceBookings.addAll(
                bookingResponse.data as Iterable<AssistanceGuestData>,
              );
            }
            acceptedGuestAssistancePage =
                bookingResponse.page ?? acceptedGuestPage;
            break;

          case 'declined':
            if (page == 1) {
              declinedGuestAssistanceBookings.value = bookingResponse.data!;
            } else {
              declinedGuestAssistanceBookings.addAll(
                bookingResponse.data as Iterable<AssistanceGuestData>,
              );
            }
            declinedGuestAssistancePage =
                bookingResponse.page ?? declinedGuestPage;
            break;
        }
      },
    );

    isLoadingGuest.value = false;
  }

  // Load next page for pagination
  Future<void> loadNextHostPage() async {
    switch (selectedIndex.value) {
      case 0:
        if (pendingHostPage != null) {
          await fetchHostInstantBookings('pending_conf', page: pendingHostPage);
        }
        break;
      case 1:
        if (acceptedHostPage != null) {
          await fetchHostInstantBookings('accepted', page: acceptedHostPage);
        }
        break;
      case 2:
        if (declinedHostPage != null) {
          await fetchHostInstantBookings('declined', page: declinedHostPage);
        }
        break;
    }
  }

  /// Accept a booking by its ID
  Future<void> acceptBooking(String bookingId) async {
    try {
      isAcceptLoading[bookingId] = true;
      errorMessagePost.value = '';

      final result = await repository.acceptBooking(bookingId);

      result.fold(
        (failure) {
          errorMessagePost.value = failure.message;
          Get.snackbar(
            "Error",
            failure.message,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        },
        (_) {
          Get.snackbar(
            "Success",
            "Booking accepted successfully!",
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
          fetchHostInstantBookings('pending_conf', page: pendingHostPage);
          fetchHostInstantBookings('accepted', page: acceptedHostPage);
          fetchHostInstantBookings('declined', page: declinedHostPage);
        },
      );
    } catch (e) {
      errorMessagePost.value = e.toString();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isAcceptLoading[bookingId] = false;
    }
  }

  Future<void> acceptBookingAssitance(String bookingId) async {
    try {
      isAcceptLoading[bookingId] = true;
      errorMessagePost.value = '';

      final result = await repository.acceptBookingAssistance(bookingId);

      result.fold(
        (failure) {
          errorMessagePost.value = failure.message;
          Get.snackbar(
            "Error",
            failure.message,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        },
        (_) {
          Get.snackbar(
            "Success",
            "Booking accepted successfully!",
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
          fetchHostInstantBookingsAssistance(
            'pending_confirmation',
            page: pendingAssistancePage,
          );
          fetchHostInstantBookingsAssistance(
            'accepted',
            page: acceptedAssistancePage,
          );
          fetchHostInstantBookingsAssistance(
            'declined',
            page: declinedAssistancePage,
          );
        },
      );
    } catch (e) {
      errorMessagePost.value = e.toString();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isAcceptLoading[bookingId] = false;
    }
  }

  Future<void> declineBooking(String bookingId, String reason) async {
    try {
      isDeclineLoading[bookingId] = true;

      final result = await repository.declineBooking(
        reason: reason,
        bookingId: bookingId,
      );

      result.fold(
        (failure) {
          _errorDisplay.showError(failure.message);
        },
        (_) {
          Get.snackbar("Success", "Booking declined successfully");
          // Optional: refresh bookings
          fetchHostInstantBookings('pending_conf', page: pendingHostPage);
          fetchHostInstantBookings('accepted', page: acceptedHostPage);
          fetchHostInstantBookings('declined', page: declinedHostPage);
        },
      );
    } finally {
      isDeclineLoading[bookingId] = false;
    }
  }

  Future<void> declineBookingAssistance(String bookingId, String reason) async {
    try {
      isDeclineLoading[bookingId] = true;

      final result = await repository.declineBookingAssistance(
        reason: reason,
        bookingId: bookingId,
      );

      result.fold(
        (failure) {
          _errorDisplay.showError(failure.message);
        },
        (_) {
          Get.snackbar("Success", "Booking declined successfully");
          // Optional: refresh bookings
          fetchHostInstantBookingsAssistance(
            'pending_confirmation',
            page: pendingAssistancePage,
          );
          fetchHostInstantBookingsAssistance(
            'accepted',
            page: acceptedAssistancePage,
          );
          fetchHostInstantBookingsAssistance(
            'declined',
            page: declinedAssistancePage,
          );
        },
      );
    } finally {
      isDeclineLoading[bookingId] = false;
    }
  }
}

// Hello I am Tamim