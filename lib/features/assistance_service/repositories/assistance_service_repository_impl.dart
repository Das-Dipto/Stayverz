import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:stayverz_flutter_app/core/constants/api_routes.dart';
import 'package:stayverz_flutter_app/features/assistance_service/models/assistance_cancellation_polices_response.dart';
import 'package:stayverz_flutter_app/features/assistance_service/models/document_upload_response_model.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../../../services/network/api_response.dart';
import '../../listing/models/calendar/assistance_calender_responce_model.dart';
import '../../public_listings/data/models/message_id_get_modeldata.dart';
import '../models/assistance_categories_response.dart';
import '../models/assistance_listing_response_model.dart';
import '../models/assistance_price_update_model.dart';
import '../models/booking_data_responce_model.dart';
import '../models/booking_post_model.dart';
import '../models/create_assistance_response_model.dart';
import '../models/map_suggestions_response_model.dart';
import '../models/payment_post_model.dart';
import '../models/single_assistance_listing_response_model.dart';
import '../models/single_public_assistance_listing_response_model.dart';
import 'assistance_service_repository_interface.dart';

class AssistanceServiceRepositoryImpl implements AssistanceServiceRepositoryInterface {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
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
  }) async {
    try {
      final response = await _apiClient.get(
        ApiRoutes.assistanceSearch, // Added leading slash to ensure proper URL construction
        queryParameters: {
          'page': page,
          'limit': limit,
          if(categoryIn != null)...{'category_in': categoryIn},
          if((maxPersonGet ?? '').isNotEmpty)...{'max_person_gte': maxPersonGet},
          if((priceMin ?? '').isNotEmpty)...{'price_min': priceMin},
          if((priceMax ?? '').isNotEmpty)...{'price_max': priceMax},
          if((checkIn ?? '').isNotEmpty)...{'check_in': checkIn},
          if((checkOut ?? '').isNotEmpty)...{'check_out': checkOut},
          if((latitude ?? '').isNotEmpty)...{'latitude': latitude},
          if((longitude ?? '').isNotEmpty)...{'longitude': longitude},
          if((radius ?? '').isNotEmpty)...{'radius': radius},
        },
      );

      return AssistanceListingResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<String, BookingResponseModel>> postBooking(
    BookingPostModel bookingData,
  ) async {
    try {
      final response = await _apiClient.post(
        '/bookings/user/bookings/',
        data: bookingData.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Right(BookingResponseModel.fromJson(response.data));
      } else {


        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to create booking';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> postPayment(
    PaymentPostModel payment,
  ) async {
    try {
      final response = await _apiClient.post(
        'https://api-assistance.stayverz.com/payments/initiate/sslcommerz',
        data: payment.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Right(response.data as Map<String, dynamic>);
      } else {
        final errorMessage =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
                : 'Failed to make payment';
        return Left(errorMessage);
      }
    } on FormatException catch (e) {
      return Left('Data parsing error: $e');
    } catch (e) {
      return Left('Network error: $e');
    }
  }

  @override
  Future<MapsSuggestionsResponseModel> getMapSuggestions({
    required String place,
  }) async {
    try {
      final response = await _apiClient.get(
        '/maps/suggestions/', // Added leading slash to ensure proper URL construction
        queryParameters: {'place': place},
      );

      return MapsSuggestionsResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AssistanceCategoriesResponse> getAssistanceCategory() async {
    try {
      final response = await _apiClient.get(
        ApiRoutes.getAssistanceCategory, // Added leading slash to ensure proper URL construction
      );
      return AssistanceCategoriesResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AssistanceCancellationPolicesResponse> getAssistanceCancellationPolices() async {
    try {
      final response = await _apiClient.get(
        ApiRoutes.getAssistanceCancellationPolices, // Added leading slash to ensure proper URL construction
      );
      return AssistanceCancellationPolicesResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<CreatedAssistanceData>> createAssistanceListing({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiClient.post(
      ApiRoutes.postAssistanceCreateAssistance,
      data: body,
    );
    CreateAssistanceResponseModel data = CreateAssistanceResponseModel.fromJson(response.data);
    if (data.status == 200 && data.data != null) {
      return ApiResponse.success(data.data);
    } else {
      String errorMessage = data.message?.toString() ?? 'Login failed';
      // Handle field errors if present
      if (response.data['errors'] != null && response.data['errors'] is Map) {
        final fieldErrors = response.data['errors'];
        if (fieldErrors.isNotEmpty) {
          errorMessage = '$errorMessage (${fieldErrors.toString()})';
        }
      }
      return ApiResponse.error(errorMessage);
    }
  }

  @override
  Future<AssistanceSingleData?> getAssistanceSingleListingDetails({required String id}) async {
    try {
      final response = await _apiClient.get(
        ApiRoutes.getAssistanceDetailsById(id),
      );

      return SingleAssistanceListingResponseModel.fromJson(response.data).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PublicAssistanceData?> getPublicAssistanceSingleListingDetails({required String id}) async {
    try {
      final response = await _apiClient.get(
        ApiRoutes.getAssistancePublicDetailsById(id),
      );

      return SinglePublicAssistanceListingResponseModel.fromJson(response.data).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<CreatedAssistanceData>> updateAssistanceListing({required String id, required Map<String, dynamic> body}) async {
    final response = await _apiClient.patch(
      ApiRoutes.pathAssistanceListingDetailsById(id),
      data: body,
    );
    CreateAssistanceResponseModel data = CreateAssistanceResponseModel.fromJson(response.data);
    if (data.status == 200 && data.data != null) {
      return ApiResponse.success(data.data);
    } else {
      String errorMessage = data.message?.toString() ?? 'Login failed';
      // Handle field errors if present
      if (response.data['errors'] != null && response.data['errors'] is Map) {
        final fieldErrors = response.data['errors'];
        if (fieldErrors.isNotEmpty) {
          errorMessage = '$errorMessage (${fieldErrors.toString()})';
        }
      }
      return ApiResponse.error(errorMessage);
    }
  }

  // @override
  // Future<DocumentUploadResponseModel> uploadDocument({
  //   required String filePath,
  //   required String folder,
  // }) async {
  //   try {
  //     // Create form data using Dio's FormData
  //     final formData = dio.FormData.fromMap({
  //       'document': await dio.MultipartFile.fromFile(
  //         filePath,
  //         filename: filePath.split('/').last,
  //       ),
  //       'folder': folder,
  //     });
  //
  //     // Make the request with multipart content type
  //     final response = await _apiClient.post<Map<String, dynamic>>(
  //       '/document-upload/',
  //       data: formData,
  //       options: dio.Options(
  //         headers: {
  //         'Content-Type': 'multipart/form-data',
  //       },
  //     ));
  //
  //     // Parse and return the response
  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       return DocumentUploadResponseModel.fromJson(response.data!);
  //     } else {
  //       throw Exception('Failed to upload document: ${response.statusMessage}');
  //     }
  //   } catch (e) {
  //     // Log the error and rethrow
  //     Get.log('Document upload error: $e');
  //     rethrow;
  //   }
  // }

  @override
  Future<DocumentUploadResponseModel> uploadMultipleDocuments({
    required List<String> filePaths,
    required String folder,
  }) async {
    try {
      // Create form data with multiple files
      final formData = dio.FormData();

      // Add each file to the form data with the same field name 'document'
      for (String path in filePaths) {
        formData.files.add(
          MapEntry(
            'document',
            await dio.MultipartFile.fromFile(
              path,
              filename: path.split('/').last,
            ),
          ),
        );
      }

      // Add the folder parameter
      formData.fields.add(MapEntry('folder', folder));

      // Make the request with multipart content type
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/document-upload/',
        data: formData,
        options: dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // Parse and return the response
      if (response.statusCode == 201 || response.statusCode == 200) {
        return DocumentUploadResponseModel.fromJson(response.data!);
      } else {
        throw Exception('Failed to upload documents: ${response.statusMessage}');
      }
    } catch (e) {
      // Log the error and rethrow
      Get.log('Multiple document upload error: $e');
      rethrow;
    }
  }


  @override
  Future<AssistanceCalendarResponse> getListingCalendar({
    required String listingId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiRoutes.getAssistanceListingCalendarById(listingId),
        queryParameters: {
          'fromDate': fromDate,
          'toDate': toDate,
        },
      );
      return AssistanceCalendarResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> postListingCalendar({
    required String listingId,
    required List<AssistancePriceUpdatePayload> payload,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiRoutes.assistanceBaseURL}/assistance/listing-calendars/$listingId/',
        data: {
          "data": payload.map((e) => e.toJson()).toList(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data as Map<String, dynamic>);
      } else {
        final errorMessage =
        response.data is Map && response.data['message'] != null
            ? response.data['message']
            : 'Failed to submit calendar';
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Error: $e');
    }
  }

  @override
  Future<MessageBookingResponse> startUserChat({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiRoutes.assistanceBaseURL}/chat/inquiry', // Base path without domain since _apiClient already includes the baseUrl
        data: body,
      );

      if (response.statusCode == 201 && response.data != null) {
        return MessageBookingResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to start user chat.');
      }
    } on dio.DioException catch (e) {
      final errorData = e.response?.data;
      if (errorData != null) {
        return MessageBookingResponse.fromJson(errorData);
      }
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

// Hello I am Tamim