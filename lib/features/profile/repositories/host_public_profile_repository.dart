import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/profile/models/host_listing_item_model.dart';
import 'package:stayverz_flutter_app/features/profile/models/profile_model.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';

abstract class HostPublicProfileRepository {
  Future<ProfileModel> getHostProfile({required String hostId});
  Future<List<HostListingItemModel>> getHostListings({required String hostId});
}

class HostPublicProfileRepositoryImpl implements HostPublicProfileRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<ProfileModel> getHostProfile({required String hostId}) async {
    try {
      final response = await _apiClient.get(
        'https://apix.stayverz.com/api/v1/accounts/public/profile/$hostId',
      );
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
  Future<List<HostListingItemModel>> getHostListings({required String hostId}) async {
    try {
      // Public endpoint — no auth required.
      final response = await _apiClient.get(
        'https://node-api.stayverz.com/api/v2/listings/host/$hostId',
      );

      final responseData = response.data;
      if (responseData == null || responseData['data'] == null) {
        return [];
      }

      final List rawList = responseData['data'];
      return rawList
          .map((e) => HostListingItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}