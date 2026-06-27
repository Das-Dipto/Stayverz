import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/network/error_display_manager.dart';
import 'package:stayverz_flutter_app/features/booking/data/models/booking_model.dart';
import 'package:stayverz_flutter_app/features/booking/domain/repositories/booking_repository_interface.dart';
import '../../../controllers/main_controller.dart';
import '../../assistance_service/models/assistance_review_model.dart';
import '../data/models/assistance_book_data.dart';
import '../data/models/assistance_book_model.dart';
import '../data/models/booking_details_model.dart';
import '../data/models/cupon_balance_model.dart';
import '../data/models/cupon_claim_model.dart';
import '../data/models/cupon_model.dart';
import '../data/models/user_moel_cupon_list.dart';

class BookingController extends GetxController {
  final _errorDisplay = Get.find<ErrorDisplayManager>();
  final BookingRepositoryInterface _repository;

  BookingController(this._repository);
  final couponCodeController = TextEditingController();
  // Bookings
  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxList<BookingModel> pastTrips = <BookingModel>[].obs;
  final RxList<BookingModel> upcomingTrips = <BookingModel>[].obs;
  final RxList<BookingModel> canceledTrips = <BookingModel>[].obs;
  final RxList<BookingModel> ongoingTrips = <BookingModel>[].obs;

  final RxList<AssistanceTrip> bookingsAssistance = <AssistanceTrip>[].obs;
  final RxList<AssistanceTrip> pastAssistanceTrips = <AssistanceTrip>[].obs;
  final RxList<AssistanceTrip> upcomingAssistanceTrips = <AssistanceTrip>[].obs;
  final RxList<AssistanceTrip> canceledAssistanceTrips = <AssistanceTrip>[].obs;
  final RxList<AssistanceTrip> ongoingAssistanceTrips = <AssistanceTrip>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isAssisLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString errorAssitacneMessage = ''.obs;
  final RxString errorAssisMessage = ''.obs;
  final RxString cuponCode = ''.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = RxInt(1);
  final int pageSize = 10;
  final RxDouble decrasePrice = 0.0.obs;
  Rx<int> selectedReportType = Rx<int>(0);
  // Review
  final Rx<BookingDetails?> bookingDetails = Rx<BookingDetails?>(null);
  final Rx<AssistanceBookingReviewModel?> bookingAssistacneDetails = Rx<AssistanceBookingReviewModel?>(null);
  final Rx<AssistanceBook?> bookingAssitanceDetails = Rx<AssistanceBook?>(null);
  final RxBool isReviewLoading = false.obs;
  final RxBool isAssistanceReviewLoading = false.obs;
  final RxBool isSubmittingReview = false.obs;

  // Coupon Balance
  final Rxn<UserCouponBalance> userCouponBalance = Rxn<UserCouponBalance>();
  final RxBool isCouponLoading = false.obs;
  final RxString couponErrorMessage = ''.obs;

  // Coupon List
  final RxBool isCouponListLoading = false.obs;
  final RxString couponListErrorMessage = ''.obs;
  final RxList<UserCoupon> userCoupons = <UserCoupon>[].obs;
  final Rx<CouponMetaData?> metaData = Rx<CouponMetaData?>(null);

  @override
  void onInit() {
    super.onInit();
    
    // Listen to user type changes to handle guest/host switching
    final mainController = Get.find<MainController>();
    
    // Initial load based on current user type
    if (mainController.uType.value == 'guest') {
      fetchBookings();
      fetchAssistanceBookings();
    }
    
    // Listen for user type changes
    ever(mainController.uType, (String userType) {
      if (userType == 'guest') {
        // User switched to guest - load booking data
        fetchBookings();
        fetchAssistanceBookings();
      } else if (userType == 'host') {
        // User switched to host - clear booking data
        bookings.clear();
        bookingsAssistance.clear();
        hasMore.value = true;
        currentPage.value = 1;
      }
    });
  }

  // ------------------- Booking Logic -------------------

  Future<void> fetchBookings({bool loadMore = false}) async {
    // Only allow booking fetch for guests
    final mainController = Get.find<MainController>();
    if (mainController.uType.value != 'guest') {
      return; // Exit silently for hosts
    }
    
    if ((isLoading.value && !loadMore) || (!hasMore.value && loadMore)) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (!loadMore) {
        currentPage.value = 1;
        hasMore.value = true;
      }

      final result = await _repository.getUserBookings(
        page: currentPage.value,
        pageSize: 50,
      );

      result.fold(
        (error) {
          errorMessage.value = error;
          if (loadMore) currentPage.value--;
          _errorDisplay.showError(error);
        },
        (response) {
          final now = DateTime.now();
          final allBookings = response.data;

          canceledTrips.assignAll(
            allBookings.where((b) => b.status == 'cancelled').toList(),
          );
          upcomingTrips.assignAll(
            allBookings
                .where(
                  (b) =>
                      b.status == 'confirmed' &&
                      DateTime.tryParse(b.checkIn)?.isAfter(now) == true,
                )
                .toList(),
          );
          pastTrips.assignAll(
            allBookings
                .where(
                  (b) =>
                      b.status == 'confirmed' &&
                      DateTime.tryParse(b.checkOut)?.isBefore(now) == true,
                )
                .toList(),
          );
          ongoingTrips.assignAll(
            allBookings.where((b) {
              if (b.status != 'confirmed') return false;
              final checkIn = DateTime.tryParse(b.checkIn);
              final checkOut = DateTime.tryParse(b.checkOut);
              return checkIn != null &&
                  checkOut != null &&
                  now.isAfter(checkIn) &&
                  now.isBefore(checkOut);
            }).toList(),
          );

          if (loadMore) {
            bookings.addAll(allBookings);
          } else {
            bookings.assignAll(allBookings);
          }

          hasMore.value = response.metaData.next != null;
          if (allBookings.isNotEmpty) currentPage.value++;
        },
      );
    } catch (e) {
      final errorMsg = 'An unexpected error occurred: $e';
      errorMessage.value = errorMsg;
      if (loadMore) currentPage.value--;
      _errorDisplay.showError(errorMsg);
    } finally {
      isLoading.value = false;
    }
  }


  final RxBool isAssistanceLoading = false.obs;
  final RxString errorAssistanceMessage = ''.obs;

  Future<void> fetchAssistanceBookings() async {
    // Only allow assistance booking fetch for guests
    final mainController = Get.find<MainController>();
    if (mainController.uType.value != 'guest') {
      return; // Exit silently for hosts
    }
    
    try {
      isAssistanceLoading.value = true;
      errorAssistanceMessage.value = '';

      final result = await _repository.getAssistanceTrips();

      result.fold(
            (error) {
              errorAssistanceMessage.value = error;
          _errorDisplay.showError(error);
        },
            (response) {
          final allTrips = response.data ?? [];
          final now = DateTime.now();

          // Categorize trips
          canceledAssistanceTrips.assignAll(
            allTrips.where((t) => t.status?.toLowerCase() == 'cancelled').toList(),
          );

          upcomingAssistanceTrips.assignAll(
            allTrips
                .where((t) =>
            t.status?.toLowerCase() == 'confirmed' &&
                DateTime.tryParse(t.checkIn ?? '')?.isAfter(now) == true)
                .toList(),
          );

          pastAssistanceTrips.assignAll(
            allTrips
                .where((t) =>
            t.status?.toLowerCase() == 'confirmed' &&
                DateTime.tryParse(t.checkOut ?? '')?.isBefore(now) == true)
                .toList(),
          );

          ongoingAssistanceTrips.assignAll(
            allTrips.where((t) {
              if (t.status?.toLowerCase() != 'confirmed') return false;
              final checkIn = DateTime.tryParse(t.checkIn ?? '');
              final checkOut = DateTime.tryParse(t.checkOut ?? '');
              return checkIn != null &&
                  checkOut != null &&
                  now.isAfter(checkIn) &&
                  now.isBefore(checkOut);
            }).toList(),
          );

          bookingsAssistance.assignAll(allTrips);
        },
      );
    } catch (e) {
      final msg = 'An unexpected error occurred: $e';
      errorAssistanceMessage.value = msg;
      _errorDisplay.showError(msg);
    } finally {
      isAssistanceLoading.value = false;
    }
  }

  Future<void> fetchBookingsFresh() async {
  final mainController = Get.find<MainController>();
  if (mainController.uType.value != 'guest') return;

  try {
    isLoading.value = true;
    errorMessage.value = '';
    currentPage.value = 1;
    hasMore.value = true;

    final result = await _repository.getUserBookings(
      page: 1,
      pageSize: 50,
    );

    result.fold(
      (error) {
        errorMessage.value = error;
      },
      (response) {
        bookings.assignAll(response.data);
      },
    );
  } catch (e) {
    errorMessage.value = 'An unexpected error occurred: $e';
  } finally {
    isLoading.value = false;
  }
}

  Future<void> refreshBookings() async {
    await fetchBookings(loadMore: false);
    await fetchAssistanceBookings();
  }

  Future<void> loadMoreBookings() async {
    if (hasMore.value) {
      await fetchBookings(loadMore: true);
    }
  }

  // ------------------- Booking Review -------------------

  Future<void> fetchBookingReviewDetails(String bookingId) async {
    try {
      isReviewLoading.value = true;
      bookingDetails.value = null;
      errorMessage.value = '';

      final result = await _repository.getBookingReviewDetails(
        bookingId: bookingId,
      );

      result.fold(
        (error) {
          errorMessage.value = error;
          _errorDisplay.showError(error);
        },
        (details) {
          bookingDetails.value = details;
        },
      );
    } catch (e) {
      final errorMsg = 'Failed to load booking review details: $e';
      errorMessage.value = errorMsg;
      _errorDisplay.showError(errorMsg);
    } finally {
      isReviewLoading.value = false;
    }
  }


  Future<void> fetchAssistanceBookingReviewDetails(String bookingId) async {
    try {
      isAssistanceReviewLoading.value = true;
      bookingAssistacneDetails.value = null;
      errorAssitacneMessage.value = '';

      final result = await _repository.getAssistanceBookingReviewDetails(
        bookingId: bookingId,
      );

      result.fold(
            (error) {
              errorAssitacneMessage.value = error;
          _errorDisplay.showError(error);
        },
            (details) {
              bookingAssistacneDetails.value = details;
        },
      );
    } catch (e) {
      final errorMsg = 'Failed to load booking review details: $e';
      errorAssitacneMessage.value = errorMsg;
      // _errorDisplay.showError(errorMsg);
    } finally {
      isAssistanceReviewLoading.value = false;
    }
  }


  Future<void> fetchAssistanceDetails(String bookingId) async {
    try {
      isAssisLoading.value = true;
      bookingAssitanceDetails.value = null;
      errorAssisMessage.value = '';

      final result = await _repository.getAssistanceBookingData(
        bookingId: bookingId,
      );

      result.fold(
            (error) {
              errorAssisMessage.value = error;
          _errorDisplay.showError(error);
        },
            (details) {
              bookingAssitanceDetails.value = details;
        },
      );
    } catch (e) {
      final errorMsg = 'Failed to load booking review details: $e';
      errorAssisMessage.value = errorMsg;
      _errorDisplay.showError(errorMsg);
    } finally {
      isAssisLoading.value = false;
    }
  }

  Future<void> submitBookingReview({
    required String id,
    required double rating,
    required String review,
    required String person,
    required String bisbook,
  }) async {
    isSubmittingReview.value = true;
    errorMessage.value = '';

    final result = await _repository.submitBookingReview(
      id: id,
      rating: rating,
      review: review,
      person: person,
      bisbook: bisbook,
    );

    result.fold(
      (error) {
        Get.back();
        errorMessage.value = error;
        Get.snackbar(
          'Error',
          error,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      },
      (_) {
        // ✅ Only pop on success
        Get.back();
        Get.snackbar(
          'Success',
          'Review submitted successfully',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      },
    );

    isSubmittingReview.value = false;
  }



  Future<void> submitAssistanceBookingReview({
    required String id,
    required double rating,
    required String review,
  }) async {
    isSubmittingReview.value = true;
    errorMessage.value = '';

    final result = await _repository.submitAssistanceBookingReview(
      id: id,
      rating: rating,
      review: review,
    );

    result.fold(
          (error) {
        Get.back();
        errorMessage.value = error;
        Get.snackbar(
          'Error',
          error,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      },
          (_) {
        // ✅ Only pop on success
        Get.back();
        Get.snackbar(
          'Success',
          'Review submitted successfully',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      },
    );

    isSubmittingReview.value = false;
  }

  // ------------------- Coupon Balance -------------------
  RxBool isCancellingBooking = false.obs;


  Future<bool> cancelBooking({
    required String bookingId,
    required String cancellationReason,
    bool showLoadingDialog = true,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      // Validate inputs
      if (bookingId.trim().isEmpty) {
        _errorDisplay.showError('Booking ID cannot be empty');
        return false;
      }

      if (cancellationReason.trim().isEmpty) {
        _errorDisplay.showError('Cancellation reason is required');
        return false;
      }

      // Set loading state
      isCancellingBooking.value = true;
      errorMessage.value = '';

      // // Show loading dialog if requested
      // if (showLoadingDialog) {
      //   _showLoadingDialog();
      // }

      final result = await _repository.cancelBooking(
        bookingId: bookingId,
        cancellationReason: cancellationReason,
      );

      return result.fold(
            (error) {
          // Handle error
          errorMessage.value = error;

          // Close loading dialog if it's open
          // if (showLoadingDialog && Get.isDialogOpen == true) {
          //   Get.back();
          // }

          // Show error snackbar
          _errorDisplay.showError(error);

          // Execute error callback if provided
          onError?.call();

          return false;
        },
            (response) {
          // Handle success

          // Close loading dialog if it's open
          if (showLoadingDialog && Get.isDialogOpen == true) {
            Get.back();
          }

          // Extract success message from response or use default
          final successMessage = response.data?.message?.isNotEmpty == true
              ? response.data!.message
              : 'Booking cancelled successfully';
               Get.back();
          // Show success snackbar
          // Get.snackbar(
          //   'Success',
          //   successMessage,
          //   backgroundColor: Colors.green.shade600,
          //   colorText: Colors.white,
          //   snackPosition: SnackPosition.TOP,
          //   duration: const Duration(seconds: 3),
          //   margin: const EdgeInsets.all(16),
          //   borderRadius: 8,
          //   icon: const Icon(Icons.check_circle, color: Colors.white),
          // );

          // Execute success callback if provided
          onSuccess?.call();

          return true;
        },
      );
    } catch (e) {
      // Handle unexpected errors
      errorMessage.value = 'Unexpected error: ${e.toString()}';

      // Close loading dialog if it's open
      if (showLoadingDialog && Get.isDialogOpen == true) {
        Get.back();
      }

      _errorDisplay.showError('Unexpected error occurred. Please try again.');
      onError?.call();

      return false;
    } finally {
      // Always reset loading state
      isCancellingBooking.value = false;
    }
  }


  Future<bool> cancelAssistanceBooking({
    required String bookingId,
    required String cancellationReason,
    bool showLoadingDialog = true,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      // Validate inputs
      if (bookingId.trim().isEmpty) {
        _errorDisplay.showError('Booking ID cannot be empty');
        return false;
      }

      if (cancellationReason.trim().isEmpty) {
        _errorDisplay.showError('Cancellation reason is required');
        return false;
      }

      // Set loading state
      isCancellingBooking.value = true;
      errorMessage.value = '';

      // // Show loading dialog if requested
      // if (showLoadingDialog) {
      //   _showLoadingDialog();
      // }

      final result = await _repository.cancelAssistanceBooking(
        bookingId: bookingId,
        cancellationReason: cancellationReason,
      );

      return result.fold(
            (error) {
          // Handle error
          errorMessage.value = error;

          // Close loading dialog if it's open
          // if (showLoadingDialog && Get.isDialogOpen == true) {
          //   Get.back();
          // }

          // Show error snackbar
          _errorDisplay.showError(error);

          // Execute error callback if provided
          onError?.call();

          return false;
        },
            (response) {
          // Handle success

          // Close loading dialog if it's open
          if (showLoadingDialog && Get.isDialogOpen == true) {
            Get.back();
          }

          // Extract success message from response or use default
          final successMessage = response.data?.message?.isNotEmpty == true
              ? response.data!.message
              : 'Booking cancelled successfully';
          Get.back();
          // Show success snackbar
          // Get.snackbar(
          //   'Success',
          //   successMessage,
          //   backgroundColor: Colors.green.shade600,
          //   colorText: Colors.white,
          //   snackPosition: SnackPosition.TOP,
          //   duration: const Duration(seconds: 3),
          //   margin: const EdgeInsets.all(16),
          //   borderRadius: 8,
          //   icon: const Icon(Icons.check_circle, color: Colors.white),
          // );

          // Execute success callback if provided
          onSuccess?.call();

          return true;
        },
      );
    } catch (e) {
      // Handle unexpected errors
      errorMessage.value = 'Unexpected error: ${e.toString()}';

      // Close loading dialog if it's open
      if (showLoadingDialog && Get.isDialogOpen == true) {
        Get.back();
      }

      _errorDisplay.showError('Unexpected error occurred. Please try again.');
      onError?.call();

      return false;
    } finally {
      // Always reset loading state
      isCancellingBooking.value = false;
    }
  }

// Helper method for showing error snackbar - REMOVED, using ErrorDisplayManager instead

// Helper method for showing loading dialog
//   void _showLoadingDialog() {
//     Get.dialog(
//       Dialog(
//         backgroundColor: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircularProgressIndicator(),
//               const SizedBox(height: 16),
//               Text(
//                 'Cancelling booking...',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//     );
//   }
  // ------------------- Coupon Balance -------------------

  /// Initialize coupon data - call this when coupon functionality is needed
  Future<void> initializeCouponData() async {
    await Future.wait([
      fetchUserCouponBalance(),
      fetchUserCoupons(),
    ]);
  }

  Future<void> fetchUserCouponBalance() async {
    // Only allow coupon balance fetch for guests
    final mainController = Get.find<MainController>();
    if (mainController.uType.value != 'guest') {
      return; // Exit silently for hosts
    }
    
    try {
      isCouponLoading.value = true;
      userCouponBalance.value = null;
      couponErrorMessage.value = '';

      final result = await _repository.getUserCouponBalance();

      result.fold(
        (error) {
          couponErrorMessage.value = error;
          _errorDisplay.showError(error);
        },
        (balance) {
          userCouponBalance.value = balance;
        },
      );
    } catch (e) {
      final errorMsg = 'Failed to load coupon balance: $e';
      couponErrorMessage.value = errorMsg;
      _errorDisplay.showError(errorMsg);
    } finally {
      isCouponLoading.value = false;
    }
  }

  // ------------------- Coupon List -------------------

  Future<void> fetchUserCoupons({int page = 1, int pageSize = 10}) async {
    try {
      isCouponListLoading.value = true;
      couponListErrorMessage.value = '';
      userCoupons.clear();

      final result = await _repository.getUserCoupons(
        page: page,
        pageSize: pageSize,
      );

      result.fold(
        (error) {
          couponListErrorMessage.value = error;
          _errorDisplay.showError(error);
        },
        (response) {
          userCoupons.addAll(response.data);
          metaData.value = response.metaData;
        },
      );
    } catch (e) {
      final msg = 'Failed to fetch user coupons: $e';
      couponListErrorMessage.value = msg;
      _errorDisplay.showError(msg);
    } finally {
      isCouponListLoading.value = false;
    }
  }

  final RxBool isClaimingCoupon = false.obs;
  final Rx<CouponCalimData?> claimedCoupon = Rx<CouponCalimData?>(null);
  final RxString claimErrorMessage = ''.obs;

  // Future<void> claimReferralCoupon() async {
  //   try {
  //     isClaimingCoupon.value = true;
  //     claimErrorMessage.value = '';
  //     claimedCoupon.value = null;
  //
  //     final result = await _repository.claimGuestReferralCoupon();
  //
  //     result.fold(
  //           (error) {
  //         claimErrorMessage.value = error;
  //         _errorDisplay.showError(error);
  //         print("fsdfsdsfdf----------");
  //       },
  //           (response) {
  //         if (response.data != null) {
  //           claimedCoupon.value = response.data!;
  //           Get.snackbar(
  //             'Success',
  //             'Coupon claimed: ৳${response.data!.amount}',
  //             backgroundColor: Colors.green,
  //             colorText: Colors.white,
  //             snackPosition: SnackPosition.TOP,
  //             duration: const Duration(seconds: 2),
  //           );
  //         } else {
  //           claimErrorMessage.value = 'No coupon returned.';
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     final errorMsg = 'Something went wrong: $e';
  //     claimErrorMessage.value = errorMsg;
  //     _errorDisplay.showError(errorMsg);
  //   } finally {
  //     isClaimingCoupon.value = false;
  //   }
  // }

  Future<bool> claimReferralCoupon() async {
    try {
      isClaimingCoupon.value = true;
      claimErrorMessage.value = '';
      claimedCoupon.value = null;

      final result = await _repository.claimGuestReferralCoupon();

      bool isSuccess = false;
      result.fold(
        (error) {
          claimErrorMessage.value = error;
          _errorDisplay.showError(error);
          isSuccess = false;
        },
        (response) {
          if (response.data != null) {
            claimedCoupon.value = response.data!;
            Get.snackbar(
              'Success',
              'Coupon claimed: ৳${response.data!.amount}',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 2),
            );
            isSuccess = true;
          } else {
            claimErrorMessage.value = 'No coupon returned.';
            isSuccess = false;
          }
        },
      );
      return isSuccess;
    } catch (e) {
      final errorMsg = 'Something went wrong: $e';
      claimErrorMessage.value = errorMsg;
      _errorDisplay.showError(errorMsg);
      return false;
    } finally {
      isClaimingCoupon.value = false;
    }
  }

  final Rx<CouponData?> appliedCoupon = Rxn<CouponData>();

  Future<void> applyReferralCoupon({
    required String code,
    required String orderTotal,
  }) async {
    try {
      isClaimingCoupon.value = true;
      claimErrorMessage.value = '';
      appliedCoupon.value = null;

      final result = await _repository.applyReferralCoupon(
        code: code,
        orderTotal: orderTotal,
      );

      result.fold(
        (error) {
          claimErrorMessage.value = error;
          _errorDisplay.showError(error);
        },
        (response) {
          if (response.data.isValid) {
            appliedCoupon.value = response.data;
            decrasePrice.value = double.parse(
              double.parse(
                '${response.data.discountAmount}',
              ).toStringAsFixed(2),
            ); // ✅ Store here
            cuponCode.value = code;
            // couponCodeController.clear();
            Get.snackbar(
              'Success',
              'Coupon applied: ${response.data.discountDisplay}',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 2),
            );
          } else {
            claimErrorMessage.value = response.data.message;

            Get.snackbar('Invalid Coupon', response.data.message);
          }
        },
      );
    } catch (e) {
      final errorMsg = 'Something went wrong: $e';
      claimErrorMessage.value = errorMsg;
      _errorDisplay.showError(errorMsg);
    } finally {
      isClaimingCoupon.value = false;
    }
  }
}

// Hello I am Tamim