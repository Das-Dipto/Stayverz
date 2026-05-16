import 'package:dartz/dartz.dart';
import 'package:stayverz_flutter_app/features/assistance_service/models/assistance_listing_response_model.dart';
import 'package:stayverz_flutter_app/features/listing/models/host_listing_configuration_model.dart';
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
import '../models/create_host_listing_response_model.dart';
import '../models/document_upload_response_model.dart';
import '../models/listing_model.dart';
import '../models/payment_post_model.dart';
import '../models/map_suggestions_response_model.dart';
import '../models/single_host_listing_response_model.dart';

abstract class ListingRepositoryInterface {
  Future<ListingResponseModel> getListings({required int page, required int pageSize, String? search, String? status});

  Future<CoHostListingResponseModel> getCoHostListings({required int page, required int pageSize, String? listingStatus});


  Future<AssistanceListingResponseModel> getAssistanceListings({required int page, required int pageSize, String? listingStatus});

  Future<SingleListingData?> getSingleListingDetails({required String id});

  Future<AddressData?> getListingAddress({
    required String listingId,
  });

  Future<ApiResponse<CreatedListing>> updateListing({required String id, required Map<String, dynamic> body});

  Future<ApiResponse<CreatedListing>> updateListingImageUpload({required String id, required Map<String, dynamic> body});

  Future<Either<String, BookingResponseModel>> postBooking(BookingPostModel bookingData);

  Future<Either<String, Map<String, dynamic>>> postPayment(PaymentPostModel payment);

  Future<MapsSuggestionsResponseModel> getMapSuggestions({required String place});

  Future<SectionResponse> getSectionSuggestions({
    required String query,
  });

  Future<HostListingConfigurationModel> getHostListingConfiguration();

  Future<AmenitiesResponseModel> getAmenities();

  Future<AreaResponseModel> searchAreas(String searchText);
  Future<DivisionDistrictThanaResponse> searchDivisionThana();

  Future<void> updateListingAmenities({
    required String listingId,
    required List<int> amenityIds,
  });

  Future<ApiResponse<CreatedListing>> updateListingLocation({
    required String listingId,
    required Map<String, dynamic> body,
  });

  Future<ApiResponse<CreatedListing>> createHostListing({required Map<String, dynamic> body});

  /// Uploads a document to the server
  ///
  /// [filePath] The path to the file to upload
  /// [folder] The destination folder on the server
  /// Returns a [DocumentUploadResponseModel] containing the uploaded file URL
  Future<DocumentUploadResponseModel> uploadDocument({
    required String filePath,
    required String folder,
  });

  Future<CalendarResponse> getListingCalendar({
    required int listingId,
    required String fromDate,
    required String toDate,
  });
  Future<DocumentUploadResponseModel> uploadMultipleDocuments({
    required List<String> filePaths,
    required String folder,
  });

  Future<Either<String, Map<String, dynamic>>> postListingCalendar({
    required int listingId,
    required List<BookingPayload> payload,
  });


}

// Hello I am Tamim