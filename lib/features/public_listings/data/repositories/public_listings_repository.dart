import '../../../listing/models/aminities_new_model.dart';
import '../models/category_listing.dart';
import '../models/district_wise_model.dart';
import '../models/lat_long_get_model.dart';
import '../models/listing_details_model.dart';
import '../models/message_id_get_modeldata.dart';
import '../models/new_search_modle.dart';
import '../models/public_listing_model.dart';

abstract class PublicListingsRepository {

  Future<PublicListingsResponse> getPublicListings({
    int? page,
    int? pageSize,
    String? checkIn,
    String? chekOut,
    int? guests,
    String? isSearch,
    String? searchType,
    double? priceMin,
    double? priceMax,
    double? radius,
    String? address,
    double? latitude,
    double? longitude,
    String? placeType,
    int? bedroomCount,
    int? bathroomCount,
    int? bedCount,
    List<int>? categories,
    List<int>? amenities,

  });

  Future<ListingDetailsModel> getListingDetails({String id});

  Future<LocationResponse> getDistrictPoints({String query});

  Future<DistrictWideLatLongResponse> getSubDistrictPointsLocation({
    required String districtName,
  });
  Future<AmenitiesResponseModel> getAmenities();


  Future<MessageBookingResponse> startUserChat({
    required MessageBookingRequest messageRequest,
  });

  Future<HomeResponse> getHomeLayout({required String tab});

  Future<void> postAvgResponseTime({
  required int listingId,
  required int hostId,
  required int guestId,
  required int avgResponseTimeSeconds,
  required int totalResponses,
});


  Future<PropertyListResponse> getUpdatedPublicListings({
  int page,
  int? id,
  double? latitude,
  double? longitude,
  int? radius,
  int? guests,
  String? checkIn,
  String? checkOut,
  });

  Future<PropertyListResponse> getSectionViewListings({
    required String title,
    int page = 1,
    int pageSize = 10,
  });

}

// Hello I am Tamim