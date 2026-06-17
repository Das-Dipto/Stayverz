import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../../../listing/models/aminities_new_model.dart';
import '../models/category_listing.dart';
import '../models/district_wise_model.dart';
import '../models/lat_long_get_model.dart';
import '../models/listing_details_model.dart';
import '../models/message_id_get_modeldata.dart';
import '../models/new_search_modle.dart';
import '../models/public_listing_model.dart';
import 'public_listings_repository.dart';

class PublicListingsRepositoryImpl implements PublicListingsRepository {
  final ApiClient _apiClient;

  // Constructor that gets ApiClient from GetX dependency injection
  PublicListingsRepositoryImpl() : _apiClient = Get.find<ApiClient>();

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
  Future<PublicListingsResponse> getPublicListings({
    int? page,
    int? pageSize,
    String? checkIn,
    String? chekOut,
    int? guests,
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
    String? isSearch,
  }) async {
    try {
      // Build query parameters
      final Map<String, dynamic> queryParams = {};
      // Add all non-null parameters to the query
      if (page != null) queryParams['page'] = page.toString();
      if (pageSize != null) queryParams['page_size'] = pageSize.toString();
      if (checkIn != null) queryParams['check_in'] = checkIn;
      if (chekOut != null) queryParams['check_out'] = chekOut;
      if (guests != null) queryParams['guests'] = guests.toString();
      if (searchType != null) queryParams['searchType'] = searchType;
      if (priceMin != null) queryParams['price_min'] = priceMin.toString();
      if (priceMax != null) queryParams['price_max'] = priceMax.toString();
      if (radius != null) queryParams['radius'] = radius.toString();
       if (address != null) queryParams['address'] = address;
      // if (isSearch != null) queryParams['isSearch'] = isSearch;
      if (latitude != null) queryParams['latitude'] = latitude.toString();
      if (longitude != null) queryParams['longitude'] = longitude.toString();
      // Handle place_type filter with proper formatting
      if (placeType != null) queryParams['place_type__in'] = placeType;
      // Add room details if specified
      if (bedroomCount != null)
        queryParams['bedroom_count'] = bedroomCount.toString();
      if (bathroomCount != null)
        queryParams['bathroom_count'] = bathroomCount.toString();
      if (bedCount != null) queryParams['bed_count'] = bedCount.toString();

      // Process categories and amenities as list values
      if (categories != null && categories.isNotEmpty) {
        queryParams['category__in'] = categories.join(',');
      }

      if (amenities != null && amenities.isNotEmpty) {
        queryParams['listing_amenity__in'] = amenities.join(',');
      }

      //Make the API request
      final response = await _apiClient.get(
        (isSearch== "True")
            ? '/listings/public/listings/'
            : '/listings/public/listings/random/',
        queryParameters: queryParams,
      );

      // final response = await _apiClient.get( '/listings/public/listings/random/', queryParameters: queryParams, );
      // Parse the response
      if (response.statusCode == 200) {
        return PublicListingsResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch public listings: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
Future<ListingDetailsModel> getListingDetails({String id = ''}) async {
  try {
    final response = await _apiClient.get('https://api-sub.stayverz.com/listings/details/$id');
    
    // ADD THIS LINE
    print("RAW RESPONSE DATA: ${response.data}");
    
    return ListingDetailsModel.fromJson((response.data?['data'] ?? {}));
  } catch (e) {
    print("ERROR IN getListingDetails: $e"); // ADD THIS TOO
    rethrow;
  }
}

@override
Future<void> postAvgResponseTime({
  required int listingId,
  required int hostId,
  required int guestId,
  required int avgResponseTimeSeconds,
  required int totalResponses,
}) async {
  try {
    await _apiClient.post(
      'https://node-api.stayverz.com/api/v2/response/first-message',
      data: {
        'listing_id': listingId,
        'host_id': hostId,
        'guest_id': guestId,
        // 'avg_response_time_seconds': avgResponseTimeSeconds,
        // 'total_responses': totalResponses,
      },
    );
  } catch (e) {
    // silently fail — don't block chat flow
  }
}



  @override
  Future<LocationResponse> getDistrictPoints({String query = ''}) async {
    try {
      final response = await _apiClient.get(
        '/maps/get-district-points/',
        queryParameters: {'q': query},
      );
      return LocationResponse.fromJson(response.data ?? {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HomeResponse> getHomeLayout({required String tab}) async {
    try {
      final response = await _apiClient.get(
        'https://api-sub.stayverz.com/listings/home-layout',
        queryParameters: {
          'tab': tab,     // dynamic
          'size': 10,     // fixed
        },
      );

      return HomeResponse.fromJson(response.data ?? {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DistrictWideLatLongResponse> getSubDistrictPointsLocation({
    required String districtName,
  }) async {
    try {
      final response = await _apiClient.get(
        '/maps/api/sub-districts-by-district/',
        queryParameters: {'district_name': districtName},
      );
      return DistrictWideLatLongResponse.fromJson(response.data ?? {});
    } catch (e) {
      rethrow;
    }
  }

  @override
Future<Map<String, dynamic>> getHostAvgResponseTime({required int hostId}) async {
  try {
    final response = await _apiClient.get(
      'https://node-api.stayverz.com/api/v2/response/avg-time/host/$hostId',
    );
    print('✅ avgResponseTime response: ${response.data}');
    return response.data ?? {};
  } catch (e) {
    print('❌ avgResponseTime error: $e');
    return {};
  }
}




  @override
  Future<MessageBookingResponse> startUserChat({
    required MessageBookingRequest messageRequest,
  }) async {
    try {
      final response = await _apiClient.post(
        '/chat/user/start/', // Base path without domain since _apiClient already includes the baseUrl
        data: messageRequest.toJson(),
      );

     if (response.statusCode == 201 && response.data != null) {
      final result = MessageBookingResponse.fromJson(response.data);

      return result;
    }  else {
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

  @override
@override
Future<PropertyListResponse> getUpdatedPublicListings({
  int page = 1,
  int? id,
  double? latitude,
  double? longitude,
  int? radius,
  int? guests,
  String? checkIn,
  String? checkOut,
}) async {
  try {
    final bool hasLocationFilter = id != null || 
                                  (latitude != null && longitude != null);

    final Map<String, dynamic> queryParams = {'page': page};

    if (guests != null) queryParams['guests'] = guests;
    if (checkIn != null) queryParams['check_in'] = checkIn;
    if (checkOut != null) queryParams['check_out'] = checkOut;

    String endpoint;
    Map<String, dynamic> finalParams = Map.from(queryParams);

    if (hasLocationFilter) {
      // 🔵 Location-based search
      endpoint = 'https://api-sub.stayverz.com/search/results';
      if (id != null) finalParams['id'] = id;
      if (latitude != null) finalParams['latitude'] = latitude;
      if (longitude != null) finalParams['longitude'] = longitude;
      if (radius != null) finalParams['radius'] = radius;
    } else {
      // 🔴 General search (no location)
      endpoint = 'https://apix.stayverz.com/api/v1/listings/public/listings/';
      finalParams['page_size'] = 10;
    }

    print("🔍 Using endpoint: $endpoint");
    print("📊 Params: $finalParams");

    final response = await _apiClient.get(
      endpoint,
      queryParameters: finalParams,
    );

    final Map<String, dynamic> json = response.data ?? {};

    if (hasLocationFilter) {
      return PropertyListResponse.fromJson(json);
    } else {
      return _parseGeneralResponse(json, page);
    }
  } catch (e) {
    print("❌ Error in getUpdatedPublicListings: $e");
    rethrow;
  }
}

// ADD THIS NEW HELPER METHOD at the bottom of the class (inside the class, before the last })
PropertyListResponse _parseGeneralResponse(Map<String, dynamic> json, int currentPage) {
  final metaData = json['meta_data'] ?? {};

  return PropertyListResponse(
    statusCode: json['status_code'] ?? json['statusCode'] ?? 200,
    data: (json['data'] as List<dynamic>?)
            ?.map((e) => NewPropertyItem.fromJson(e))
            .toList() ??
        [],
    meta: NewMeta.fromJson({
      'total': metaData['total'] ?? 0,
      'page': currentPage,
      'pageSize': metaData['page_size'],
      'last_page': metaData['next'] != null ? currentPage + 1 : currentPage,
    }),
  );
}

  @override
  Future<PropertyListResponse> getSectionViewListings({
    required String title,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'title': title,
        'page': page,
        'pageSize': pageSize,
      };

      final response = await _apiClient.get(
        'https://api-sub.stayverz.com/listings/section-view',
        queryParameters: queryParams,
      );

      return PropertyListResponse.fromJson(response.data ?? {});
    } catch (e) {
      rethrow;
    }
  }
}

// Hello I am Tamim