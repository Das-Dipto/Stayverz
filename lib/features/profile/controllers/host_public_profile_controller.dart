import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/profile/models/host_listing_item_model.dart';
import 'package:stayverz_flutter_app/features/profile/models/profile_model.dart';
import 'package:stayverz_flutter_app/features/profile/repositories/host_public_profile_repository.dart';

class HostPublicProfileController extends GetxController {
  final HostPublicProfileRepository _repository;
  HostPublicProfileController(this._repository);

  final Rx<ProfileModel?> hostProfile = Rx<ProfileModel?>(null);
  final RxList<HostListingItemModel> verifiedListings = <HostListingItemModel>[].obs;

  final RxBool isLoadingProfile = false.obs;
  final RxBool isLoadingListings = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> loadHostProfile(String hostId) async {
    try {
      isLoadingProfile.value = true;
      hasError.value = false;
      hostProfile.value = await _repository.getHostProfile(hostId: hostId);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> loadHostListings() async {
    try {
      isLoadingListings.value = true;
      final listings = await _repository.getHostVerifiedListings();
      verifiedListings.assignAll(listings);
    } catch (e) {
      verifiedListings.clear();
    } finally {
      isLoadingListings.value = false;
    }
  }
}