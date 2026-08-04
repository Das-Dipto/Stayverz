import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/profile/models/host_listing_item_model.dart';
import 'package:stayverz_flutter_app/features/profile/repositories/host_public_profile_repository.dart';

class HostPublicProfileController extends GetxController {
  final HostPublicProfileRepository _repository;
  HostPublicProfileController(this._repository);

  // Host info comes directly from the listing details already fetched
  // upstream (in PublicListingDetailsView) — no network call needed here.
  final RxString hostFullName = ''.obs;
  final RxString hostImage = ''.obs;
  final RxString hostBio = ''.obs;
  final RxString hostAddress = ''.obs;
  final RxList<String> hostLanguages = <String>[].obs;
  final RxString hostDateJoined = ''.obs;
  final RxInt hostReviewCount = 0.obs;

  final RxList<HostListingItemModel> hostListings = <HostListingItemModel>[].obs;
  final RxBool isLoadingListings = false.obs;

  void setHostInfo({
    required String fullName,
    required String image,
    required String bio,
    required String address,
    required List<String> languages,
    required String dateJoined,
    required int reviewCount,
  }) {
    hostFullName.value = fullName;
    hostImage.value = image;
    hostBio.value = bio;
    hostAddress.value = address;
    hostLanguages.assignAll(languages);
    hostDateJoined.value = dateJoined;
    hostReviewCount.value = reviewCount;
  }

  Future<void> loadHostListings(String hostId) async {
    try {
      isLoadingListings.value = true;
      final listings = await _repository.getHostListings(hostId: hostId);
      hostListings.assignAll(listings);
    } catch (e) {
      hostListings.clear();
    } finally {
      isLoadingListings.value = false;
    }
  }
}