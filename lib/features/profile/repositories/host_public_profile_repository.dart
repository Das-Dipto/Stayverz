import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/constants/api_routes.dart';
import 'package:stayverz_flutter_app/features/profile/models/profile_model.dart';
import 'package:stayverz_flutter_app/features/profile/models/host_listing_item_model.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';

abstract class HostPublicProfileRepository {
  Future<ProfileModel> getHostProfile({required String hostId});
  Future<List<HostListingItemModel>> getHostVerifiedListings();
}

class HostPublicProfileRepositoryImpl implements HostPublicProfileRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<ProfileModel> getHostProfile({required String hostId}) async {
    try {
      final response = await _apiClient.get(ApiRoutes.getSingleUser(hostId));
      final data = response.data['data'] ?? response.data;
      if (data == null) {
        throw Exception('No host profile data found');
      }
      return ProfileModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HostListingItemModel>> getHostVerifiedListings() async {
    try {
      // NOTE: This endpoint currently returns listings scoped to whichever
      // token is attached to the request (i.e. "my own listings"), not an
      // arbitrary host's listings. Swap this path once a host-id-aware
      // public endpoint is confirmed with backend.
      final response = await _apiClient.get(
        '/listings/host/listings/',
        queryParameters: {'page': 1, 'page_size': 10},
      );

      final responseData = response.data;
      if (responseData == null || responseData['data'] == null) {
        return [];
      }

      final List rawList = responseData['data'];
      final allListings = rawList
          .map((e) => HostListingItemModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Only show verified listings in the grid
      return allListings
          .where((l) => l.verificationStatus == 'verified')
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}