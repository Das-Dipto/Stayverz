import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/reservation/models/review_model.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../../../core/constants/api_routes.dart';
import '../../../core/error/failures.dart';
import '../../assistance_service/models/assiatance_review_model.dart';
import '../../assistance_service/models/assistance_book_model.dart';
import '../../assistance_service/models/assistance_reservation_model.dart';
import '../../booking/data/models/assistance_guest_data.dart';
import '../models/host_reservation_model.dart';
import '../models/reservation_by_id_moel.dart';
import '../models/reservation_stats_model.dart';
import 'reservation_repository_interface.dart';

class ReservationRepositoryImpl implements ReservationRepositoryInterface {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<HostReservationModel> getHostReservation({
    required String type,
  }) async {
    try {
      final response = await _apiClient.get(
        '/bookings/host/reservations/', // Added leading slash to ensure proper URL construction
        queryParameters: {'event_type': type, 'page': 1, 'page_size': 0},
      );

      return HostReservationModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AssistanceBookingResponse> getAssistanceReservation({
    required String type,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiRoutes.assistanceBaseURL}/host/bookings?', // Added leading slash to ensure proper URL construction
        queryParameters: {'eventType': type},
      );

      return AssistanceBookingResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReservationStatsModel> getReservationStats({
    required String type,
  }) async {
    try {
      final response = await _apiClient.get(
        '/bookings/host/reservation-stats', // Added leading slash to ensure proper URL construction
        queryParameters: {'event_type': type},
      );

      return ReservationStatsModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RoomReservation> getReservationById({required String id}) async {
    try {
      final response = await _apiClient.get('/bookings/host/reservations/$id/');
      final data = response.data['data']; // Make sure to extract 'data'
      if (data == null) throw Exception('No reservation data found');
      return RoomReservation.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AssistanceGuestDataNew> getAssistanceGuestReservationById({
    required String id,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiRoutes.assistanceBaseURL}/bookings/$id',
      );
      final data = response.data['data']; // Make sure to extract 'data'
      if (data == null) throw Exception('No reservation data found');
      return AssistanceGuestDataNew.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AssistanceBookingModel> getAssistanceReservationById({
    required String id,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiRoutes.assistanceBaseURL}/host/bookings/get/$id',
      );
      final data = response.data['data']; // Make sure to extract 'data'
      if (data == null) throw Exception('No reservation data found');
      return AssistanceBookingModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReviewResponse> submitBookingReviewWithModel({
    required ReviewRequest request,
    required String person,
    required String bisbook,
  }) async {
    try {
      final response = await _apiClient.post(
        '/bookings/host/reservations/${request.id}/reviews/',
        data: request.toJson(),
      );

      return ReviewResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AssistanceReviewResponse> submitAssistanceBookingReviewWithModel({
    required AssistanceReviewRequest request,
    required String invId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiRoutes.assistanceBaseURL}/reviews/host/booking/$invId',
        data: request.toJson(),
      );

      return AssistanceReviewResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, void>> cancelBookingAssistance({
    required String bookingId,
    required String reason,
  }) async {
    try {
      final response = await _apiClient.post(
        "${ApiRoutes.assistanceBaseURL}/host/bookings/$bookingId/cancel-after-booked",
        data: {"cancellationReason": reason},
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
}

// Hello I am Tamim