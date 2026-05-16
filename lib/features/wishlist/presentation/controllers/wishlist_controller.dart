import 'package:get/get.dart';
import '../../../../services/network/error_display_manager.dart';
import '../../../../controllers/main_controller.dart';
import '../../../public_listings/data/models/wish_list_model.dart';
import '../../domain/repositories/wishlist_repository.dart';

class WishlistController extends GetxController {
  final WishlistRepository repository;
  final _errorDisplay = Get.find<ErrorDisplayManager>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<int, bool> inWishlistMap = <int, bool>{}.obs;

  WishlistController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    
    // Only fetch wishlist data for guests, not hosts
    final mainController = Get.find<MainController>();
    if (mainController.uType.value == 'guest') {
      fetchWishlistItems();
    }
    
    // Listen for user type changes
    ever(mainController.uType, (String userType) {
      if (userType == 'guest') {
        // User switched to guest - load wishlist data
        fetchWishlistItems();
      } else if (userType == 'host') {
        // User switched to host - clear wishlist data
        wishlistItems.clear();
        inWishlistMap.clear();
      }
    });
  }

  // Fetch all wishlist items
  final RxList<WishlistItem> wishlistItems = <WishlistItem>[].obs;


  Future<void> fetchWishlistItems() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await repository.getWishlistItems();

    result.fold(
          (failure) {
        errorMessage.value = failure.message;
      },
          (items) {
        wishlistItems.value = items;

        // Clear previous map entries
        inWishlistMap.clear();

        // Update the wishlist status map safely
        for (var item in items) {
          final listingId = item.listing?.id;
          if (listingId != null) {
            inWishlistMap[listingId] = true;
          }
        }
      },
    );

    isLoading.value = false;
  }


  // Add my_listing to wishlist
  Future<void> addToWishlist(int listingId) async {
    if (inWishlistMap[listingId] == true) {
      // Already in wishlist
      return;
    }

    isLoading.value = true;

    final result = await repository.addToWishlist(listingId);

    result.fold(
      (failure) {
        _errorDisplay.showError(failure.message);
      },
      (_) {
        _errorDisplay.showSuccess('Added to wishlist');
        inWishlistMap[listingId] = true;
        fetchWishlistItems(); // Refresh the list
      },
    );

    isLoading.value = false;
  }

  // Remove my_listing from wishlist
  Future<void> removeFromWishlist(int listingId) async {
    isLoading.value = true;

    final result = await repository.removeFromWishlist(listingId);

    await result.fold(
      (failure) async {
        _errorDisplay.showError(failure.message);
        isLoading.value = false;
      },
      (_) async {
        _errorDisplay.showSuccess('Removed from wishlist');
        inWishlistMap[listingId] = false;
        // Fetch latest wishlist items to update the state
        await fetchWishlistItems();
      },
    );
  }

  // Check if my_listing is in wishlist
  Future<bool> isInWishlist(int listingId) async {
    if (inWishlistMap.containsKey(listingId)) {
      return inWishlistMap[listingId] ?? false;
    }

    final result = await repository.isListingInWishlist(listingId);
    inWishlistMap[listingId] = result;
    return result;
  }

  // Toggle wishlist status
  Future<void> toggleWishlist(int listingId) async {
    final isInList = await isInWishlist(listingId);

    if (isInList) {
      // Find the wishlist item ID for this my_listing
      final wishlistItem = wishlistItems.firstWhere(
        (item) => item.listing?.id == listingId,
        orElse: () => throw Exception('Item not found in wishlist'),
      );

      await removeFromWishlist(listingId);
    } else {
      await addToWishlist(listingId);
    }
  }
}

// Hello I am Tamim