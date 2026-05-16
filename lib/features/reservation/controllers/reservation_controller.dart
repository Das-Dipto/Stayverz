import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/network/error_display_manager.dart';
import '../../../controllers/main_controller.dart';
import 'package:stayverz_flutter_app/features/reservation/models/review_model.dart';
import '../../assistance_service/models/assiatance_review_model.dart';
import '../../assistance_service/models/assistance_book_model.dart';
import '../../assistance_service/models/assistance_reservation_model.dart';
import '../../booking/data/models/assistance_guest_data.dart';
import '../models/reservation_by_id_moel.dart';
import '../models/reservation_stats_model.dart';
import '../repositories/reservation_repository_interface.dart';

class ReservationController extends GetxController {
  final _errorDisplay = Get.find<ErrorDisplayManager>();
  final ReservationRepositoryInterface _repository;

  ReservationController(this._repository);
  final RxInt selectedTabIndex = 0.obs;
  final RxInt selectedTabIndexAssitance = 0.obs;
  final RxInt selectedAllReservationTabIndex = 0.obs;
  Rx<int> selectedReportType = Rx<int>(0);
  Rx<int> selectedReportAssistanceType = Rx<int>(0);
  // State variables
  final RxBool isLoading = false.obs;
  final RxBool isAllReservationLoading = false.obs;
  final RxBool isAssistanceAllReservationLoading = false.obs;
  final RxList<Reservation> currentlyHostingReservations = <Reservation>[].obs;
  final RxList<Reservation> checkingOutReservations = <Reservation>[].obs;
  final RxList<Reservation> arrivingSoonReservations = <Reservation>[].obs;
  final RxList<Reservation> upcomingReservations = <Reservation>[].obs;
  final RxList<Reservation> pendingReviewReservations = <Reservation>[].obs;

  final RxList<Reservation> currentlyHostingAllReservations =
      <Reservation>[].obs;
  final RxList<Reservation> upcomingAllReservations = <Reservation>[].obs;
  final RxList<Reservation> completedAllReservations = <Reservation>[].obs;

  //implement for assistance reservation call api--
  final RxList<AssistanceBookingData> currentAssistanceCurrentReservations =
      <AssistanceBookingData>[].obs;
  final RxList<AssistanceBookingData> currentAssistanceUpcomingReservations =
      <AssistanceBookingData>[].obs;
  final RxList<AssistanceBookingData> currentAssistanceCompleteReservations =
      <AssistanceBookingData>[].obs;

  final RxList<AssistanceBookingData> currentlyAssistanceReservations =
      <AssistanceBookingData>[].obs;
  final RxList<AssistanceBookingData> checkingOutAssistanceReservations =
      <AssistanceBookingData>[].obs;
  final RxList<AssistanceBookingData> arrivingSoonAssistanceReservations =
      <AssistanceBookingData>[].obs;
  final RxList<AssistanceBookingData> upcomingAssistanceReservations =
      <AssistanceBookingData>[].obs;
  final RxList<AssistanceBookingData> pendingAssistanceReviewReservations =
      <AssistanceBookingData>[].obs;

  Rx<ReservationStats?> reservationStats = Rx<ReservationStats?>(null);

  final hasShownReviewDialog = false.obs;

  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasError = false.obs;
  final RxBool hasAssistanceError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString errorMessageAssistance = ''.obs;

  // Pagination settings
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    
    // Only fetch reservation data for hosts, not guests
    final mainController = Get.find<MainController>();
    if (mainController.uType.value == 'host') {
      fetchReservationStats();
      fetchReservationStatsAssistance();
    }
    
    // Listen for user type changes
    ever(mainController.uType, (String userType) {
      if (userType == 'host') {
        // User switched to host - load reservation data
        fetchReservationStats();
        fetchReservationStatsAssistance();
      } else if (userType == 'guest') {
        // User switched to guest - clear reservation data
        currentlyHostingReservations.clear();
        checkingOutReservations.clear();
        arrivingSoonReservations.clear();
        upcomingReservations.clear();
        pendingReviewReservations.clear();
        currentlyHostingAllReservations.clear();
        upcomingAllReservations.clear();
        completedAllReservations.clear();
        currentAssistanceCurrentReservations.clear();
        currentAssistanceUpcomingReservations.clear();
        currentAssistanceCompleteReservations.clear();
        currentlyAssistanceReservations.clear();
        checkingOutAssistanceReservations.clear();
        arrivingSoonAssistanceReservations.clear();
        upcomingAssistanceReservations.clear();
      }
    });
    
    // Note: Dialog is now shown by TodayScreen to avoid duplicate dialogs
    // This listener only updates the tab index when there are pending reviews
    ever(reservationStats, (stats) {
      if (stats != null && (stats.pendingReviewCount ?? 0) > 0) {
        // Just update the stats, dialog is handled by TodayScreen
        debugPrint('Pending reviews detected: ${stats.pendingReviewCount}');
      }
    });
  }

  Future<void> fetchReservationStats({String? type}) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final currentlyHostingResponse = await _repository.getReservationStats(
        type: 'currently_hosting',
      );
      currentlyHostingReservations.value = currentlyHostingResponse.data ?? [];

      final checkingOutResponse = await _repository.getReservationStats(
        type: 'checking_out',
      );
      checkingOutReservations.value = checkingOutResponse.data ?? [];

      final arrivingSoonResponse = await _repository.getReservationStats(
        type: 'arriving_soon',
      );
      arrivingSoonReservations.value = arrivingSoonResponse.data ?? [];

      final upcomingResponse = await _repository.getReservationStats(
        type: 'upcoming',
      );
      upcomingReservations.value = upcomingResponse.data ?? [];

      final pendingReviewResponse = await _repository.getReservationStats(
        type: 'pending_review',
      );
      pendingReviewReservations.value = pendingReviewResponse.data ?? [];

      reservationStats.value = currentlyHostingResponse.stats;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReservationStatsAssistance({String? type}) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final currentlyHostingResponse = await _repository
          .getAssistanceReservation(type: 'currently_hosting');
      currentlyAssistanceReservations.value =
          currentlyHostingResponse.data ?? [];

      final checkingOutResponse = await _repository.getAssistanceReservation(
        type: 'checking_out',
      );
      checkingOutAssistanceReservations.value = checkingOutResponse.data ?? [];

      final arrivingSoonResponse = await _repository.getAssistanceReservation(
        type: 'arriving_soon',
      );
      arrivingSoonAssistanceReservations.value =
          arrivingSoonResponse.data ?? [];

      final upcomingResponse = await _repository.getAssistanceReservation(
        type: 'upcoming',
      );
      upcomingAssistanceReservations.value = upcomingResponse.data ?? [];

      final pendingReviewResponse = await _repository.getAssistanceReservation(
        type: 'pending_review',
      );
      pendingAssistanceReviewReservations.value =
          pendingReviewResponse.data ?? [];
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHostAllReservation() async {
    isAllReservationLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final currentlyHostingResponse = await _repository.getHostReservation(
        type: 'currently_hosting',
      );
      currentlyHostingAllReservations.value =
          (currentlyHostingResponse.data ?? [])
              .map(
                (e) => Reservation(
                  id: e.id,
                  checkIn: e.checkIn,
                  checkOut: e.checkOut,
                  invoiceNo: e.invoiceNo,
                  chatRoomId: e.chatRoomId,
                  guestName: e.guest?.fullName,
                  listingTitle: e.listing?.title,
                ),
              )
              .toList();

      final upcomingResponse = await _repository.getHostReservation(
        type: 'upcoming',
      );
      upcomingAllReservations.value =
          (upcomingResponse.data ?? [])
              .map(
                (e) => Reservation(
                  id: e.id,
                  checkIn: e.checkIn,
                  checkOut: e.checkOut,
                  invoiceNo: e.invoiceNo,
                  chatRoomId: e.chatRoomId,
                  guestName: e.guest?.fullName,
                  listingTitle: e.listing?.title,
                ),
              )
              .toList();

      final completedResponse = await _repository.getHostReservation(
        type: 'completed',
      );
      completedAllReservations.value =
          (completedResponse.data ?? [])
              .map(
                (e) => Reservation(
                  id: e.id,
                  checkIn: e.checkIn,
                  checkOut: e.checkOut,
                  invoiceNo: e.invoiceNo,
                  chatRoomId: e.chatRoomId,
                  guestName: e.guest?.fullName,
                  listingTitle: e.listing?.title,
                ),
              )
              .toList();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isAllReservationLoading.value = false;
    }
  }

  Future<void> fetchAssistanceAllReservation() async {
    isAssistanceAllReservationLoading.value = true;
    hasAssistanceError.value = false;
    errorMessageAssistance.value = '';

    try {
      // ---------- Currently Hosting ----------
      final currentlyHostingResponse = await _repository
          .getAssistanceReservation(type: 'currently_hosting');
      currentAssistanceCurrentReservations.value =
          currentlyHostingResponse.data ?? [];

      // ---------- Upcoming ----------
      final upcomingResponse = await _repository.getAssistanceReservation(
        type: 'upcoming',
      );
      currentAssistanceUpcomingReservations.value = upcomingResponse.data ?? [];

      // ---------- Completed ----------
      final completedResponse = await _repository.getAssistanceReservation(
        type: 'completed',
      );
      currentAssistanceCompleteReservations.value =
          completedResponse.data ?? [];
    } catch (e, stackTrace) {
      hasAssistanceError.value = true;
      errorMessageAssistance.value = e.toString();
    } finally {
      isAssistanceAllReservationLoading.value = false;
    }
  }

  final Rx<RoomReservation?> selectedReservation = Rx<RoomReservation?>(null);
  final Rx<AssistanceGuestDataNew?> selectedGuestReservation =
      Rx<AssistanceGuestDataNew?>(null);
  final Rx<AssistanceBookingModel?> selectedAssistanceReservation =
      Rx<AssistanceBookingModel?>(null);
  final RxBool isReservationLoading = false.obs;
  final RxBool isGuestReservationLoading = false.obs;
  final RxBool reservationHasError = false.obs;
  final RxBool reservationGuestHasError = false.obs;
  final RxString reservationErrorMessage = ''.obs;
  final RxString reservationGuestErrorMessage = ''.obs;

  Future<void> fetchReservationById({required String id}) async {
    isReservationLoading.value = true;
    reservationHasError.value = false;
    reservationErrorMessage.value = '';

    try {
      final reservation = await _repository.getReservationById(id: id);
      selectedReservation.value = reservation;
    } catch (e) {
      reservationHasError.value = true;
      reservationErrorMessage.value = e.toString();
    } finally {
      isReservationLoading.value = false;
    }
  }

  Future<void> fetchGuestReservationById({required String id}) async {
    isGuestReservationLoading.value = true;
    reservationGuestHasError.value = false;
    reservationGuestErrorMessage.value = '';

    try {
      final reservation = await _repository.getAssistanceGuestReservationById(
        id: id,
      );
      selectedGuestReservation.value = reservation;
    } catch (e) {
      reservationGuestHasError.value = true;
      reservationGuestErrorMessage.value = e.toString();
    } finally {
      isGuestReservationLoading.value = false;
    }
  }

  final RxBool isAssistanceReservationLoading = false.obs;
  final RxBool reservationAssistanceHasError = false.obs;
  final RxString reservationAssistanceErrorMessage = ''.obs;

  Future<void> fetchAssistanceReservationById({required String id}) async {
    isAssistanceReservationLoading.value = true;
    reservationAssistanceHasError.value = false;
    reservationAssistanceErrorMessage.value = '';

    try {
      final reservation = await _repository.getAssistanceReservationById(
        id: id,
      );
      selectedAssistanceReservation.value = reservation;
    } catch (e) {
      reservationAssistanceHasError.value = true;
      reservationAssistanceErrorMessage.value = e.toString();
    } finally {
      isAssistanceReservationLoading.value = false;
    }
  }

  final RxBool isReviewSubmitting = false.obs;
  final RxBool reviewHasError = false.obs;
  final RxString reviewErrorMessage = ''.obs;
  final Rx<ReviewResponse?> reviewResponse = Rx<ReviewResponse?>(null);
  final Rx<AssistanceReviewResponse?> reviewAssiatanceResponse =
      Rx<AssistanceReviewResponse?>(null);

  Future<void> submitBookingReview({
    required String id,
    required int rating,
    required String review,
    required String person,
    required String bisbook,
  }) async {
    isReviewSubmitting.value = true;
    reviewHasError.value = false;
    reviewErrorMessage.value = '';

    try {
      final request = ReviewRequest(id: id, rating: rating, review: review);

      final response = await _repository.submitBookingReviewWithModel(
        request: request,
        person: person,
        bisbook: bisbook,
      );

      reviewResponse.value = response;
    } catch (e) {
      reviewHasError.value = true;
      reviewErrorMessage.value = e.toString();
    } finally {
      isReviewSubmitting.value = false;
    }
  }

  Future<void> submitAssistanceBookingReview({
    required String invId,
    required int rating,
    required String review,
  }) async {
    isReviewSubmitting.value = true;
    reviewHasError.value = false;
    reviewErrorMessage.value = '';

    try {
      final request = AssistanceReviewRequest(rating: rating, review: review);

      final response = await _repository.submitAssistanceBookingReviewWithModel(
        invId: invId,
        request: request,
      );

      reviewAssiatanceResponse.value = response;
    } catch (e) {
      reviewHasError.value = true;
      reviewErrorMessage.value = e.toString();
    } finally {
      isReviewSubmitting.value = false;
    }
  }

  var isDeclineLoading = <String, bool>{}.obs;
  Future<void> cancelBookingAssistance(String bookingId, String reason) async {
    try {
      isDeclineLoading[bookingId] = true;

      final result = await _repository.cancelBookingAssistance(
        reason: reason,
        bookingId: bookingId,
      );

      result.fold(
        (failure) {
          _errorDisplay.showError(failure.message);
        },
        (_) {
          Get.snackbar("Success", "Booking declined successfully");
        },
      );
    } finally {
      isDeclineLoading[bookingId] = false;
    }
  }

  Future<void> fetchPendingReview() async {
    try {
      final response =
      await _repository.getReservationStats(type: 'pending_review');
      pendingReviewReservations.value = response.data ?? [];
      reservationStats.value = response.stats;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> fetchReservationByType(String type) async {
    try {
      final response = await _repository.getReservationStats(type: type);
      switch (type) {
        case 'currently_hosting':
          currentlyHostingReservations.value = response.data ?? [];
          break;
        case 'checking_out':
          checkingOutReservations.value = response.data ?? [];
          break;
        case 'arriving_soon':
          arrivingSoonReservations.value = response.data ?? [];
          break;
        case 'upcoming':
          upcomingReservations.value = response.data ?? [];
          break;
        case 'pending_review':
          pendingReviewReservations.value = response.data ?? [];
          break;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  void onTabSelected(int index) {
    selectedTabIndex.value = index;
    switch (index) {
      case 0:
        if (currentlyHostingReservations.isEmpty) {
          fetchReservationByType('currently_hosting');
        }
        break;
      case 1:
        if (checkingOutReservations.isEmpty) {
          fetchReservationByType('checking_out');
        }
        break;
      case 2:
        if (arrivingSoonReservations.isEmpty) {
          fetchReservationByType('arriving_soon');
        }
        break;
      case 3:
        if (upcomingReservations.isEmpty) {
          fetchReservationByType('upcoming');
        }
        break;
      case 4:
        if (pendingReviewReservations.isEmpty) {
          fetchReservationByType('pending_review');
        }
        break;
    }
  }
}
