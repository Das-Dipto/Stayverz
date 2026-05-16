import 'package:dartz/dartz.dart';
import 'package:stayverz_flutter_app/features/assistance_service/models/assistance_cancellation_polices_response.dart';
import '../../../services/network/api_response.dart';
import '../../listing/models/calendar/assistance_calender_responce_model.dart';
import '../../public_listings/data/models/message_id_get_modeldata.dart';
import '../models/assistance_categories_response.dart';
import '../models/assistance_listing_response_model.dart';
import '../models/assistance_price_update_model.dart';
import '../models/booking_data_responce_model.dart';
import '../models/booking_post_model.dart';
import '../models/create_assistance_response_model.dart';
import '../models/document_upload_response_model.dart';
import '../models/payment_post_model.dart';
import '../models/map_suggestions_response_model.dart';
import '../models/single_assistance_listing_response_model.dart';
import '../models/single_public_assistance_listing_response_model.dart';

abstract class AssistanceServiceRepositoryInterface {

  Future<AssistanceSingleData?> getAssistanceSingleListingDetails({required String id});

  Future<PublicAssistanceData?> getPublicAssistanceSingleListingDetails({required String id});

  Future<ApiResponse<CreatedAssistanceData>> updateAssistanceListing({required String id, required Map<String, dynamic> body});

  Future<AssistanceListingResponseModel> getAssistanceSearch({
    required int page,
    required int limit,
    String? categoryIn,
    String? maxPersonGet,
    String? priceMin,
    String? priceMax,
    String? checkIn,
    String? checkOut,
    String? latitude,
    String? longitude,
    String? radius
  });

  Future<Either<String, BookingResponseModel>> postBooking(BookingPostModel bookingData);

  Future<Either<String, Map<String, dynamic>>> postPayment(PaymentPostModel payment);

  Future<MapsSuggestionsResponseModel> getMapSuggestions({required String place});

  Future<AssistanceCategoriesResponse> getAssistanceCategory();

  Future<AssistanceCancellationPolicesResponse> getAssistanceCancellationPolices();

  Future<ApiResponse<CreatedAssistanceData>> createAssistanceListing({required Map<String, dynamic> body});

  // Future<DocumentUploadResponseModel> uploadDocument({
  //   required String filePath,
  //   required String folder,
  // });

  Future<AssistanceCalendarResponse> getListingCalendar({
    required String listingId,
    required String fromDate,
    required String toDate,
  });
  Future<DocumentUploadResponseModel> uploadMultipleDocuments({
    required List<String> filePaths,
    required String folder,
  });

  Future<Either<String, Map<String, dynamic>>> postListingCalendar({
    required String listingId,
    required List<AssistancePriceUpdatePayload> payload,
  });

  Future<MessageBookingResponse> startUserChat({
    required Map<String, dynamic> body,
  });
}

// Hello I am Tamim