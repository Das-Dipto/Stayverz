import 'package:dartz/dartz.dart';
import 'package:stayverz_flutter_app/features/reservation/models/review_model.dart';

import '../../../core/error/failures.dart';
import '../../assistance_service/models/assiatance_review_model.dart';
import '../../assistance_service/models/assistance_book_model.dart';
import '../../assistance_service/models/assistance_reservation_model.dart';
import '../../booking/data/models/assistance_guest_data.dart';
import '../models/host_reservation_model.dart';
import '../models/reservation_by_id_moel.dart';
import '../models/reservation_stats_model.dart';

abstract class ReservationRepositoryInterface {
  Future<ReservationStatsModel> getReservationStats({required String type});
  Future<HostReservationModel> getHostReservation({required String type});
  Future<AssistanceBookingResponse> getAssistanceReservation({
    required String type,
  });

  Future<RoomReservation> getReservationById({required String id});

  Future<AssistanceGuestDataNew> getAssistanceGuestReservationById({
    required String id,
  });

  Future<AssistanceBookingModel> getAssistanceReservationById({
    required String id,
  });
  Future<ReviewResponse> submitBookingReviewWithModel({
    required ReviewRequest request,
    required String person,
    required String bisbook,
  });

  Future<AssistanceReviewResponse> submitAssistanceBookingReviewWithModel({
    required AssistanceReviewRequest request,
    required String invId,
  });

  Future<Either<Failure, void>> cancelBookingAssistance({
    required String bookingId,
    required String reason,
  });
}

// Hello I am Tamim