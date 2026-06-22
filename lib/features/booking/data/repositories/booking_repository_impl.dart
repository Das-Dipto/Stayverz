import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/constants/api_routes.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import 'package:stayverz_flutter_app/features/booking/domain/repositories/booking_repository_interface.dart';
import 'package:stayverz_flutter_app/features/booking/data/models/booking_list_response.dart';
import '../../../../core/error/failures.dart';
import '../../../listing/models/assistance_book_guest_model.dart';
import '../models/assistance_booking_model.dart';
import '../../../assistance_service/models/assistance_booking_list_model.dart';
import '../../../assistance_service/models/assistance_review_model.dart';
import '../models/assistance_book_data.dart';
import '../models/assistance_book_model.dart';
import '../models/book_and_go_model.dart';
import '../models/host_model_instant.dart';
import '../models/book_cancellation.dart';
import '../models/booking_details_model.dart';
import '../models/cupon_balance_model.dart';
import '../models/cupon_claim_model.dart';
import '../models/cupon_model.dart';
import '../models/post_assistance_payment_model.dart';
import '../models/user_moel_cupon_list.dart';
import '../models/post_booking_model.dart';

class BookingRepositoryImpl implements BookingRepositoryInterface {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<Either<String, BookingListResponse>> getUserBookings({
    int? page,
    int? pageSize,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (pageSize != null) queryParams['page_size'] = pageSize;

      final response = await _apiClient.get(
        '/bookings/user/bookings/?page_size=0',
        //  queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        try {
          final bookingResponse = BookingListResponse.fromJson(response.data);
          return Right(bookingResponse);
        } catch (e) {
          return Left('Failed to parse booking data: $e');
        }
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to load bookings';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  @override
  Future<Either<String, AssistanceTripResponse>> getAssistanceTrips() async {
    try {
      final response = await _apiClient.get(
        '${ApiRoutes.assistanceBaseURL}/bookings',
      );

      if (response.statusCode == 200) {
        try {
          final tripResponse = AssistanceTripResponse.fromJson(response.data);
          return Right(tripResponse);
        } catch (e) {
          return Left('Failed to parse assistance trip data: $e');
        }
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to load assistance trips';
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      return Left('Network error: ${e.message}');
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  Future<Either<String, BookingDetails>> getBookingReviewDetails({
    required String bookingId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/bookings/user/bookings/$bookingId/',
        queryParameters: {'is_review': true},
      );

      if (response.statusCode == 200) {
        try {
          final bookingDetail = BookingDetails.fromJson(response.data);
          return Right(bookingDetail);
        } catch (e) {
          return Left('Failed to parse booking review details: $e');
        }
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to load booking review details';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, AssistanceBookingReviewModel>>
  getAssistanceBookingReviewDetails({required String bookingId}) async {
    try {
      final response = await _apiClient.get(
        '${ApiRoutes.assistanceBaseURL}/reviews/booking/$bookingId/my-review',
      );

      if (response.statusCode == 200) {
        try {
          final bookingDetail = AssistanceBookingReviewModel.fromJson(
            response.data,
          );
          return Right(bookingDetail);
        } catch (e) {
          return Left('Failed to parse booking review details: $e');
        }
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to load booking review details';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, AssistanceBook>> getAssistanceBookingData({
    required String bookingId,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiRoutes.assistanceBaseURL}/bookings/$bookingId/',
      );

      if (response.statusCode == 200) {
        try {
          final bookingDetail = AssistanceBook.fromJson(response.data);
          return Right(bookingDetail);
        } catch (e) {
          return Left('Failed to parse booking review details: $e');
        }
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to load booking review details';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, Map<String, dynamic>>> submitBookingReview({
    required String id,
    required double rating,
    required String review,
    required String person,
    required String bisbook,
  }) async {
    try {
      final body = {'id': id, 'rating': rating, 'review': review};

      final response = await _apiClient.post(
        '/bookings/$person/$bisbook/$id/reviews/',
        data: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Return raw map since you're not using a model
        return Right(response.data as Map<String, dynamic>);
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to submit review';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, Map<String, dynamic>>> submitAssistanceBookingReview({
    required String id,
    required double rating,
    required String review,
  }) async {
    try {
      final body = {'rating': rating, 'review': review};

      final response = await _apiClient.post(
        '${ApiRoutes.assistanceBaseURL}/reviews/guest/booking/$id',
        data: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Return raw map since you're not using a model
        return Right(response.data as Map<String, dynamic>);
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to submit review';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, BookingCancellationResponse>> cancelBooking({
    required String bookingId,
    required String cancellationReason,
  }) async {
    try {
      final body = {'id': bookingId, 'cancellation_reason': cancellationReason};

      final response = await _apiClient.post(
        '/bookings/user/bookings/$bookingId/cancel/',
        data: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parse response using the model
        final cancellationResponse = BookingCancellationResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        return Right(cancellationResponse);
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to cancel booking';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, BookingCancellationResponse>> cancelAssistanceBooking({
    required String bookingId,
    required String cancellationReason,
  }) async {
    try {
      final body = {'cancellationReason': cancellationReason};

      final response = await _apiClient.post(
        '${ApiRoutes.assistanceBaseURL}/bookings/$bookingId/cancel',
        data: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parse response using the model
        final cancellationResponse = BookingCancellationResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        return Right(cancellationResponse);
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to cancel booking';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  Future<Either<String, UserCouponBalance>> getUserCouponBalance() async {
    try {
      final response = await _apiClient.get('/referrals/guest/points-balance/');

      if (response.statusCode == 200) {
        final data = UserCouponBalance.fromJson(response.data);
        return Right(data);
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to fetch coupon balance';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  @override
  Future<Either<String, UserCouponListResponseModel>> getUserCoupons({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await _apiClient.get('/referrals/my-coupons/');

      if (response.statusCode == 200) {
        final model = UserCouponListResponseModel.fromJson(response.data);
        return Right(model);
      } else {
        return Left(response.data['message'] ?? 'Failed to fetch coupons');
      }
    } catch (e) {
      return Left('Error: $e');
    }
  }

  @override
  Future<Either<String, CouponClaimResponseModel>>
  claimGuestReferralCoupon() async {
    try {
      final response = await _apiClient.post(
        '/referrals/guest/claim-coupon/',
        data: {}, // Empty payload
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = CouponClaimResponseModel.fromJson(response.data);
        return Right(model);
      } else {
        return Left(response.data['message'] ?? 'Failed to claim coupon');
      }
    } catch (e) {
      return Left('Error: $e');
    }
  }

  @override
  Future<Either<String, CouponResponse>> applyReferralCoupon({
    required String code,
    required String orderTotal,
  }) async {
    try {
      final response = await _apiClient.post(
        '/bookings/user/validate-coupon/',
        data: {"code": code, "order_total": orderTotal},
      );

      if (response.statusCode == 200) {
        final model = CouponResponse.fromJson(response.data);
        return Right(model);
      } else {
        return Left(response.data['message'] ?? 'Failed to apply coupon');
      }
    } catch (e) {
      return Left('Error: $e');
    }
  }

  @override
  Future<Either<Failure, BookAndGo>> getInstantBookings({
    required String status,
    int page = 1,
  }) async {
    try {
      final response = await _apiClient.get(
        "/bookings/user/reservations/instant-booking/",
        queryParameters: {
          "status": status, // dynamic status
          "page": page,
          "page_size": 20,
        },
      );

      // Check if response data is not null
      if (response.statusCode == 200 && response.data != null) {
        try {
          final bookAndGo = BookAndGo.fromJson(
            response.data as Map<String, dynamic>,
          );
          return Right(bookAndGo);
        } catch (e, stackTrace) {
          // JSON parsing error
          return Left(ServerFailure(message: 'Failed to parse booking data'));
        }
      } else {
        return Left(ServerFailure(message: 'Failed to load instant bookings'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e, stackTrace) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

 @override
Future<Either<Failure, BookingResponse>> getHostInstantBookings({
  required String status,
  int page = 1,
}) async {
  try {
    final response = await _apiClient.get(
      "/bookings/host/reservations/instant-booking/",
      queryParameters: {
        "status": status,
        "page": page,
        "page_size": 20,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      try {
        final rawData = response.data as Map<String, dynamic>;
        final dataList = rawData['data'] as List<dynamic>? ?? [];

        for (int i = 0; i < dataList.length; i++) {
          try {
            BookingData2.fromJson(dataList[i] as Map<String, dynamic>);
            print('✅ Item $i parsed OK');
          } catch (e) {
            print('❌ Item $i FAILED: $e');
            print('❌ Item $i DATA: ${dataList[i]}');
            break;
          }
        }

        final bookingResponse = BookingResponse.fromJson(rawData);
        return Right(bookingResponse);
      } catch (e, stackTrace) {
        print('❌ PARSE ERROR: $e');
        print('❌ STACK: $stackTrace');
        return Left(ServerFailure(message: 'Failed to parse booking data: $e'));
      }
    } else {
      return Left(ServerFailure(message: 'Failed to load host instant bookings'));
    }
  } on DioException catch (e) {
    return Left(ServerFailure.fromDioError(e));
  } catch (e, stackTrace) {
    print('❌ OUTER ERROR: $e');
    print('❌ OUTER STACK: $stackTrace');
    return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
  }
}

  @override
  Future<Either<Failure, AssistanceReservationListResponse>>
  getAssistanceInstantBookings({required String status, int page = 1}) async {
    try {
      final response = await _apiClient.get(
        "${ApiRoutes.assistanceBaseURL}/host/bookings/instance-bookings?",
        queryParameters: {
          "status": status, // dynamic status
          "page": page,
          "page_size": 20,
        },
      );

      // Check if response data is not null
      if (response.statusCode == 200 && response.data != null) {
        try {
          final bookingResponse = AssistanceReservationListResponse.fromJson(
            response.data as Map<String, dynamic>,
          );
          return Right(bookingResponse);
        } catch (e, stackTrace) {
            print('❌ ASSISTANCE PARSE ERROR: $e');
            print('❌ STACK: $stackTrace');
            print('❌ RAW DATA: ${response.data}');
          // JSON parsing error
          return Left(ServerFailure(message: 'Failed to parse booking data'));
        }
      } else {
        return Left(
          ServerFailure(message: 'Failed to load host instant bookings'),
        );
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e, stackTrace) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AssistanceGuestResponse>>
  getAssistanceGuestInstantBookings({
    required String status,
    int page = 1,
  }) async {
    try {
      final response = await _apiClient.get(
        "${ApiRoutes.assistanceBaseURL}/bookings/instance-bookings?",
        queryParameters: {
          "status": status, // dynamic status
          "page": page,
          "page_size": 20,
        },
      );

      // Check if response data is not null
      if (response.statusCode == 200 && response.data != null) {
        try {
          final bookingResponse = AssistanceGuestResponse.fromJson(
            response.data as Map<String, dynamic>,
          );
          return Right(bookingResponse);
        } catch (e, stackTrace) {
            print('❌ ASSISTANCE PARSE ERROR: $e');
            print('❌ STACK: $stackTrace');
            print('❌ RAW DATA: ${response.data}');
          // JSON parsing error
          return Left(ServerFailure(message: 'Failed to parse booking data'));
        }
      } else {
        return Left(
          ServerFailure(message: 'Failed to load host instant bookings'),
        );
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e, stackTrace) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, PostBookingResponse>> acceptBooking(
    String bookingId,
  ) async {
    try {
      final response = await _apiClient.post(
        "/bookings/host/reservations/$bookingId/accept/",
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Parse response body if exists, otherwise return default success
        final data =
            response.data != null
                ? PostBookingResponse.fromJson(response.data)
                : PostBookingResponse(
                  success: true,
                  statusCode: response.statusCode ?? 200,
                  message: 'Booking accepted successfully',
                );
        return Right(data);
      } else {
        final data =
            response.data != null
                ? PostBookingResponse.fromJson(response.data)
                : null;
        return Left(
          ServerFailure(
            message:
                data?.message ??
                'Failed to accept booking. Status: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, PostBookingResponse>> acceptBookingAssistance(
    String bookingId,
  ) async {
    try {
      final response = await _apiClient.post(
        "${ApiRoutes.assistanceBaseURL}/host/bookings/$bookingId/accept",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse response body if exists, otherwise return default success
        final data =
            response.data != null
                ? PostBookingResponse.fromJson(response.data)
                : PostBookingResponse(
                  success: true,
                  statusCode: response.statusCode ?? 200,
                  message: 'Booking accepted successfully',
                );
        return Right(data);
      } else {
        final data =
            response.data != null
                ? PostBookingResponse.fromJson(response.data)
                : null;
        return Left(
          ServerFailure(
            message:
                data?.message ??
                'Failed to accept booking. Status: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> declineBooking({
    required String bookingId,
    required String reason,
  }) async {
    try {
      final response = await _apiClient.post(
        "/bookings/host/reservations/$bookingId/decline/",
        data: {"reason": reason},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(null);
      } else {
        final message =
            response.data?['message'] ??
            'Failed to decline booking. Status: ${response.statusCode}';
        return Left(ServerFailure(message: message));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> declineBookingAssistance({
    required String bookingId,
    required String reason,
  }) async {
    try {
      final response = await _apiClient.post(
        "${ApiRoutes.assistanceBaseURL}/host/bookings/$bookingId/decline",
        data: {"reason": reason},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      } else {
        final message =
            response.data?['message'] ??
            'Failed to decline booking. Status: ${response.statusCode}';
        return Left(ServerFailure(message: message));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<AssistanceBookingModel?> postBooking(
    Map<String, dynamic> bookingData,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiRoutes.postAssistanceBookings,
        data: bookingData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AssistanceBookingModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PostAssistancePaymentModel?> postPayment(
    Map<String, dynamic> payment,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiRoutes.postAssistancePaymentsInitiateSslcommerz,
        data: payment,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PostAssistancePaymentModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}

// Hello I am Tamim