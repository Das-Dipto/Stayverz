import 'package:dartz/dartz.dart';
import 'package:stayverz_flutter_app/features/booking/data/models/booking_list_response.dart';
import '../../../assistance_service/models/assistance_booking_list_model.dart';
import '../../../assistance_service/models/assistance_review_model.dart';
import '../../../booking/data/models/book_and_go_model.dart';
import '../../../booking/data/models/host_model_instant.dart';
import '../../../booking/data/models/post_booking_model.dart';
import '../../../../core/error/failures.dart';
import '../../../listing/models/assistance_book_guest_model.dart';
import '../../data/models/assistance_book_data.dart';
import '../../data/models/assistance_book_model.dart';
import '../../data/models/assistance_booking_model.dart';
import '../../data/models/book_cancellation.dart';
import '../../data/models/booking_details_model.dart';
import '../../data/models/cupon_balance_model.dart';
import '../../data/models/cupon_claim_model.dart';
import '../../data/models/cupon_model.dart';
import '../../data/models/post_assistance_payment_model.dart';
import '../../data/models/user_moel_cupon_list.dart';

abstract class BookingRepositoryInterface {
  Future<Either<String, BookingListResponse>> getUserBookings({
    int page,
    int pageSize,
  });

  Future<Either<String, AssistanceTripResponse>> getAssistanceTrips();

  Future<Either<String, BookingDetails>> getBookingReviewDetails({
    required String bookingId,
  });

  Future<Either<String, AssistanceBookingReviewModel>>
  getAssistanceBookingReviewDetails({required String bookingId});

  Future<Either<String, AssistanceBook>> getAssistanceBookingData({
    required String bookingId,
  });

  Future<Either<String, Map<String, dynamic>>> submitBookingReview({
    required String id,
    required double rating,
    required String review,
    required String person,
    required String bisbook,
  });

  Future<Either<String, Map<String, dynamic>>> submitAssistanceBookingReview({
    required String id,
    required double rating,
    required String review,
  });

  Future<Either<String, BookingCancellationResponse>> cancelBooking({
    required String bookingId,
    required String cancellationReason,
  });

  Future<Either<String, BookingCancellationResponse>> cancelAssistanceBooking({
    required String bookingId,
    required String cancellationReason,
  });

  Future<Either<String, UserCouponBalance>> getUserCouponBalance();

  Future<Either<String, UserCouponListResponseModel>> getUserCoupons({
    required int page,
    required int pageSize,
  });

  Future<Either<String, CouponClaimResponseModel>> claimGuestReferralCoupon();

  Future<Either<String, CouponResponse>> applyReferralCoupon({
    required String code,
    required String orderTotal,
  });

  Future<Either<Failure, BookAndGo>> getInstantBookings({
    required String status,
    int page = 1,
  });

  Future<Either<Failure, BookingResponse>> getHostInstantBookings({
    required String status,
    int page = 1,
  });

  Future<Either<Failure, AssistanceReservationListResponse>>
  getAssistanceInstantBookings({required String status, int page = 1});

  Future<Either<Failure, AssistanceGuestResponse>>
  getAssistanceGuestInstantBookings({required String status, int page = 1});

  Future<Either<Failure, PostBookingResponse>> acceptBooking(String bookingId);

  Future<Either<Failure, PostBookingResponse>> acceptBookingAssistance(
    String bookingId,
  );

  Future<Either<Failure, void>> declineBooking({
    required String bookingId,
    required String reason,
  });

  Future<Either<Failure, void>> declineBookingAssistance({
    required String bookingId,
    required String reason,
  });

  Future<AssistanceBookingModel?> postBooking(Map<String, dynamic> bookingData);

  Future<PostAssistancePaymentModel?> postPayment(
    Map<String, dynamic> bookingData,
  );
}

// Hello I am Tamim