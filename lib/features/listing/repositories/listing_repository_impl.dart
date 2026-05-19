import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:stayverz_flutter_app/core/constants/api_routes.dart';
import 'package:stayverz_flutter_app/features/assistance_service/models/assistance_listing_response_model.dart';
import 'package:stayverz_flutter_app/features/listing/models/create_host_listing_response_model.dart';
import 'package:stayverz_flutter_app/features/listing/models/document_upload_response_model.dart';
import 'package:stayverz_flutter_app/features/listing/models/host_listing_configuration_model.dart';
import 'package:stayverz_flutter_app/features/listing/models/single_host_listing_response_model.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../../../services/network/api_response.dart';
import '../../public_listings/data/models/search_view_modle.dart';
import '../models/address_responce_model.dart';
import '../models/aminities_new_model.dart';
import '../models/area_new_model.dart';
import '../models/booking_data_responce_model.dart';
import '../models/booking_post_model.dart';
import '../models/calendar/calender_responce_model.dart';
import '../models/calendar/division_thana_model.dart';
import '../models/calendar/price_update_model.dart';
import '../models/co_host_listing_response_model.dart';
import '../models/listing_model.dart';
import '../models/map_suggestions_response_model.dart';
import '../models/payment_post_model.dart';
import 'listing_repository_interface.dart';

class ListingRepositoryImpl implements ListingRepositoryInterface {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<ListingResponseModel> getListings({
    required int page,
    required int pageSize,
    String? search,
    String? status
  }) async {
    try {
      final response = await _apiClient.get(
        '/listings/host/listings/', // Added leading slash to ensure proper URL construction
        queryParameters: {'page': page, 'page_size': pageSize, if(search!=null||status!=null)...{'search': search,'status':status}},
      );

      return ListingResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SectionResponse> getSectionSuggestions({
    required String query,
  }) async {
    try {
      // final response = await _apiClient.get(
      //   'https://api-sub.stayverz.com/search/suggestions',
      //   queryParameters: {'q': query},
      // );

      final response = await _apiClient.get(
        'https://apix.stayverz.com/api/v1/maps/suggestions/',
        queryParameters: {'place': query},
      );
      

      return SectionResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AddressData?> getListingAddress({
    required String listingId,
  }) async {
    try {
      final response = await _apiClient.get(
        'https://api-sub.stayverz.com/listings/details-for-location-page/$listingId',
      );

      return AddressResponse
          .fromJson(response.data)
          .data;

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AmenitiesResponseModel> getAmenities() async {
    try {
      final response = await _apiClient.get(
        'https://api-sub.stayverz.com/listings/amenities',
      );

      return AmenitiesResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<CoHostListingResponseModel> getCoHostListings({
    required int page,
    required int pageSize,
    String? listingStatus
  }) async {
    try {
      final response = await _apiClient.get(
        '/listings/host/my-assignments/cohosting-listings/', // Added leading slash to ensure proper URL construction
        queryParameters: {'page': page, 'page_size': pageSize, if(listingStatus!=null) ...{
          'listing__status': listingStatus
        }},
      );

      return CoHostListingResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<AssistanceListingResponseModel> getAssistanceListings({
    required int page,
    required int pageSize,
    String? listingStatus
  }) async {
    try {
      final response = await _apiClient.get(
        ApiRoutes.getAssistanceHostList, // Added leading slash to ensure proper URL construction
        queryParameters: {'page': page, 'page_size': pageSize, if(listingStatus!=null) ...{
          'status': listingStatus
        }},
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
        '/payments/user/ssl-order-payment/',
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
  Future<HostListingConfigurationModel> getHostListingConfiguration() async {
    try {
      final response = await _apiClient.get(
        '/listings/host/configurations/', // Added leading slash to ensure proper URL construction
      );

      return HostListingConfigurationModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<CreatedListing>> createHostListing({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiClient.post(
      '/listings/host/listings/',
      data: body,
    );
    CreateHostListingResponseModel data = CreateHostListingResponseModel.fromJson(response.data);
    if (data.success == true && data.data != null) {
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
  Future<SingleListingData?> getSingleListingDetails({required String id}) async {
    try {
      final response = await _apiClient.get('/listings/host/listings/$id/');
      return SingleHostListingResponseModel.fromJson(response.data).data;
    } on dio.DioException catch (e) {
      final data = e.response?.data;

      // ✅ Handle 403 error specifically
      if (e.response?.statusCode == 403) {
        final errorMessage = data?['errors']?['non_field_errors']?.first ??
            data?['message'] ??
            'Forbidden';
        throw Exception(errorMessage);
      }

      // ✅ Handle other errors gracefully
      final message = data?['message'] ?? 'Something went wrong';
      throw Exception(message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  @override
  Future<void> updateListingAmenities({
    required String listingId,
    required List<int> amenityIds,
  }) async {
    try {
      await _apiClient.patch(
        'https://api-sub.stayverz.com/listings/$listingId/amenities',
        data: {
          "amenityIds": amenityIds,
        },
      );
    } catch (e) {
      rethrow;
    }
  }



  @override
  Future<ApiResponse<CreatedListing>> updateListing({required String id, required Map<String, dynamic> body}) async {
    final response = await _apiClient.patch(
      '/listings/host/listings/$id/',
      data: body,
    );
    CreateHostListingResponseModel data = CreateHostListingResponseModel.fromJson(response.data);
    if (data.success == true && data.data != null) {
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
  Future<ApiResponse<CreatedListing>> updateListingImageUpload({required String id, required Map<String, dynamic> body}) async {
    final response = await _apiClient.patch(
      'https://api-sub.stayverz.com/listings/$id',
      data: body,
    );
    CreateHostListingResponseModel data = CreateHostListingResponseModel.fromJson(response.data);
    if (data.success == true && data.data != null) {
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
  Future<DocumentUploadResponseModel> uploadDocument({
    required String filePath,
    required String folder,
  }) async {
    try {
      // Create form data using Dio's FormData
      final formData = dio.FormData.fromMap({
        'document': await dio.MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
        'folder': folder,
      });

      // Make the request with multipart content type
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/document-upload/',
        data: formData,
        options: dio.Options(
          headers: {
          'Content-Type': 'multipart/form-data',
        },
      ));

      // Parse and return the response
      if (response.statusCode == 201 || response.statusCode == 200) {
        return DocumentUploadResponseModel.fromJson(response.data!);
      } else {
        throw Exception('Failed to upload document: ${response.statusMessage}');
      }
    } catch (e) {
      // Log the error and rethrow
      Get.log('Document upload error: $e');
      rethrow;
    }
  }

  @override
  Future<AreaResponseModel> searchAreas(String searchText) async {
    try {
      final response = await _apiClient.get(
      //  'https://test.spanexec.com/listings/locations/areas',
        'https://api-sub.stayverz.com/listings/locations/areas',
        queryParameters: {'search': searchText},
      );

      return AreaResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DivisionDistrictThanaResponse> searchDivisionThana() async {
    try {
      final response = await _apiClient.get(
        'https://api-sub.stayverz.com/listings/locations/nested',
      );

      return DivisionDistrictThanaResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

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
  Future<CalendarResponse> getListingCalendar({
    required int listingId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await _apiClient.get(
        '/listings/host/listing-calendars/$listingId/',
        queryParameters: {
          'from_date': fromDate,
          'to_date': toDate,
        },
      );
      return CalendarResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> postListingCalendar({
    required int listingId,
    required List<BookingPayload> payload,
  }) async {
    try {
      final response = await _apiClient.post(
        '/listings/host/listing-calendars/$listingId/',
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
  Future<ApiResponse<CreatedListing>> updateListingLocation({
    required String listingId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _apiClient.patch(
        'https://api-sub.stayverz.com/listings/$listingId/location',
        data: body,
      );


      if (response.statusCode == 200 && response.data['data'] != null) {
        final listing = CreatedListing.fromJson(response.data['data']);
        return ApiResponse.success(listing);
      }

      return ApiResponse.error("Location update failed");
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

}

// Hello I am Tamim