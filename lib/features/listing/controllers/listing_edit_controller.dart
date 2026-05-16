import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/models/host_listing_configuration_model.dart';
import '../models/co_host_listing_response_model.dart';
import '../models/listing_model.dart';
import '../models/map_suggestions_response_model.dart';
import '../models/single_host_listing_response_model.dart';
import '../repositories/listing_repository_interface.dart';

class ListingEditController extends GetxController {

  final ListingRepositoryInterface _repository;
  ListingEditController(this._repository);

  //final RxBool isUploadingPhotos = false.obs;
  final RxList<String> uploadedPhotoUrlss = <String>[].obs;

  // State variables
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxList<ListingModel> listings = <ListingModel>[].obs;
  final RxList<CoHostListingData> coHostListings = <CoHostListingData>[].obs;
  final RxBool isCalendarLoading = false.obs;
  final RxString calendarError = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isGridView = false.obs;
  final RxBool isInstantBook = false.obs;
  RxInt personsCount = RxInt(0), bedroomsCount = RxInt(0), bedsCount = RxInt(0), bathroomsCount = RxInt(0);
  final RxList<String> finalUploadedImages = <String>[].obs;

  // For property photos
  RxList<String> uploadedPhotoUrls = <String>[].obs;
  RxBool isUploadingPhotos = false.obs;
  final RxString coverImageUrl = ''.obs;

  RxList<PlaceSuggestion>  suggestions = RxList<PlaceSuggestion>();
  Rx<PlaceSuggestion?> selectedPlace = Rx<PlaceSuggestion?>(null);
  Rx<SingleListingData?> listingDetails = Rx<SingleListingData?>(null);
  Rx<ConfigurationData?> listingConfiguration = Rx<ConfigurationData?>(null);
  Rx<Category?> selectedCategory = Rx<Category?>(null);
  Rx<PlaceType?> selectedPlaceType = Rx<PlaceType?>(null);
  RxInt? selectedCategoryId = RxInt(0);
  String createdListingId = '';
  RxList<int> selectedAmenities = RxList<int>();
  TextEditingController suggestionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  RxDouble basePriceValue = RxDouble(0.0);
  RxDouble guestGatewayFeeValue = RxDouble(0.0);
  RxDouble totalGuestPriceValue = RxDouble(0.0);
  RxDouble youEarnPriceValue = RxDouble(0.0);
  RxInt onHostCoHostChangeValue = RxInt(0);
  final selectedPlaceTypeId = ''.obs;



  // Pagination settings
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    priceController.addListener(() {
      basePriceValue.value = double.parse(priceController.text.isEmpty ? '0' : priceController.text);
      guestGatewayFeeValue.value = basePriceValue.value * listingDetails.value!.guestServiceCharge!.toDouble();
      youEarnPriceValue.value = basePriceValue.value - (basePriceValue.value * listingDetails.value!.hostServiceCharge!.toDouble());
      totalGuestPriceValue.value = guestGatewayFeeValue.value + youEarnPriceValue.value;
    });
  }

  void clearAllStates(){
    suggestions.value = [];
    suggestionController.clear();
    selectedPlace.value = null;
    listingDetails.value = null;
    listingConfiguration.value = null;
    selectedCategory.value = null;
    selectedPlaceType.value = null;
    createdListingId = '';
    selectedAmenities.value = [];
    titleController.clear();
    descriptionController.clear();
    statusController.clear();
    priceController.clear();
    basePriceValue.value = 0;
    guestGatewayFeeValue.value = 0;
    totalGuestPriceValue.value = 0;
    youEarnPriceValue.value = 0;
    finalUploadedImages.clear();
  }

  Future<void> fetchListingDetails({String? id}) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      createdListingId = createdListingId.isNotEmpty ? createdListingId : Get.arguments?['id'] ?? '';
      var res = await _repository.getSingleListingDetails(id: createdListingId);
      listingDetails.value = res;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchListingDetailsHost({String? id}) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // Determine which ID to use
      final listingIdToUse = id ?? Get.arguments?['id'] ?? '';
      if (listingIdToUse.isEmpty) {
        throw Exception("Listing ID is required");
      }

      createdListingId = createdListingId.isNotEmpty ? createdListingId : listingIdToUse;

      // Call API
      final res = await _repository.getSingleListingDetails(id: createdListingId);

      if (res == null) {
        throw Exception("You must be the primary host or an active co-host for this my_listing to perform this action.");
      }

      listingDetails.value = res;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();

      // ✅ Rethrow the exception so the caller (onPressed) can handle it
      throw e;
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchHostListingConfigurations() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      HostListingConfigurationModel response = await _repository.getHostListingConfiguration();

      listingConfiguration.value = response.data;

    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchListingDetails();
    }
  }

  void loadPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchListingDetails();
    }
  }

  void refreshListings() {
    currentPage.value = 1;
    fetchListingDetails();
  }

  void goUpdateAfterSelectingCategory() async {
    if(selectedCategoryId?.value == null) {
      Fluttertoast.showToast(
        msg: "Please select a category",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "category" : selectedCategoryId!.value
    });

    if(result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Update category of Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchListingDetails();
      return;
    }
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update category of my_listing",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

  }

  void goUpdateAfterSelectingPlaceType() async {
    if(selectedPlaceTypeId.value == '') {
      Fluttertoast.showToast(
        msg: "Please select a place type",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "place_type" : selectedPlaceTypeId.value ?? ''
    });

    if(result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Update place type Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchListingDetails();
      return;
    }
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to place type of my_listing",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

  }

  // void goNextAfterSelectingPlace() async {
  //   if(selectedPlace.value == null) {
  //     Fluttertoast.showToast(
  //       msg: "Please select a place",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.TOP,
  //     );
  //     return;
  //   }
  //   var result = await _repository.updateListing( id: createdListingId ?? '',body: {
  //     "id": createdListingId,
  //     "address" : selectedPlace.value?.address ?? '',
  //     "latitude" : selectedPlace.value?.latitude ?? '',
  //     "longitude" : selectedPlace.value?.longitude ?? '',
  //   });
  //   if(!result.isSuccess) {
  //     Fluttertoast.showToast(
  //       msg: "Failed to update place location",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.TOP,
  //     );
  //     return;
  //   }
  //   await fetchListingDetails();
  // }

  void goNextAfterSelectingBasics() async {
    if(selectedPlace.value == null) {
      Fluttertoast.showToast(
        msg: "Please select a place",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      'bathroom_count': bathroomsCount.value,
      'bed_count': bedsCount.value,
      'bedroom_count': bedroomsCount.value,
      'guest_count': personsCount.value
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update place location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchListingDetails();
  }

  void goUpdateAfterSelectingAmenities({required List selectList}) async {
    if(selectList.length == 0) {
      Fluttertoast.showToast(
        msg: "Please select a place",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "amenities": selectList
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update place location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchListingDetails();
  }



  void goUpdatePolicy({required int id,required int day, required String name,required String des,
    required int percent
  }) async {

    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "cancellation_policy": {
        "id": 3,
        "policy_name": "Moderate",
        "description": "Full refund 5 days prior to arrival",
        "refund_percentage": 100,
        "cancellation_deadline": 5
      },
    });

    if(result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Cancellation Policy Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchListingDetails();
      return;
    }
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update place location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

  }


  void goUpdateMinMaxNight({required int minday,required int maxday,
  }) async {
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "minimum_nights": minday,
      "maximum_nights": maxday,
    });

    if(result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Min Max Day Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchListingDetails();
      return;
    }
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update place location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

  }

  void goUpdateHouseRule({required String checkIn,required String checkOut,
    required bool unmaried,
    required bool smoking,
    required bool event,
    required bool media,
    required bool pet,
  }) async {
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "pet_allowed": pet,
      "media_allowed": media,
      "event_allowed": event,
      "smoking_allowed": smoking,
      "unmarried_couples_allowed": unmaried,
      "check_in": checkIn,
      "check_out": checkOut,
    });

    if(result.isSuccess) {
      Fluttertoast.showToast(
        msg: "House details updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchListingDetails();
      return;
    }
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update House details",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

  }


  void goUpdateFloorData({required int bed,required int bedroom,
    required int guest,
    required int bath,
  }) async {
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "guest_count": guest,
      "bedroom_count": bedroom,
      "bed_count": bed,
      "bathroom_count": bath,
    });

    if(result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Floor Plan Day Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchListingDetails();
      return;
    }
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update Floor Plan",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

  }



  // void goNextAfterUploadedPhotos() async {
  //
  //
  //   var result = await _repository.updateListing( id: createdListingId ?? '',body: {
  //     "id": createdListingId,
  //     "cover_photo": coverImageUrl.value,
  //     "images": finalUploadedImages.toList()
  //   });
  //
  //   if(result.isSuccess) {
  //     Fluttertoast.showToast(
  //       msg: "Image Uploaded Successfully",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.TOP,
  //     );
  //     await fetchListingDetails();
  //     return;
  //   }
  //
  //   if(!result.isSuccess) {
  //     Fluttertoast.showToast(
  //       msg: "Failed to update place location",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.TOP,
  //     );
  //     return;
  //   }
  //
  // }

  void goNextAfterEnteredTitle() async {
    isUpdating.value = true;
    if(titleController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter title",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    if(titleController.text.length <10) {
      Fluttertoast.showToast(
        msg: "Please enter minimum 100 character",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "title": titleController.text
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update title",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchListingDetails();
    isUpdating.value = false;
    Get.back();
  }

  void goNextAfterEnteredDescription() async {
    isUpdating.value = true;
    if(descriptionController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter description",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "description": descriptionController.text
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update description",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchListingDetails();
    isUpdating.value = false;
    Get.back();
  }

  void goNextAfterEnteredPrice(Map supportiveData) async {
    isUpdating.value = true;
    if(priceController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter price",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "price": priceController.text,
      ...supportiveData
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update price",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchListingDetails();
    isUpdating.value = false;
    Get.back();
  }


  void goUpdateInstantBooking(bool isBook) async {
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "instant_booking_allowed": isBook,
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update instant booking",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchListingDetails();
    isUpdating.value = false;
    Get.back();
  }

  void onPublishClick() async {
    isUpdating.value = true;
    if(statusController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter price",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      //"price": priceController.text,
      'status': statusController.text
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update Publish",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchListingDetails();
  }

  void onUpdateLocation({required String location, required double lat,required double long,}) async {
    isUpdating.value = true;
    if(location.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter lat long",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateListing( id: createdListingId ?? '',body: {
      "id": createdListingId,
      "latitude": lat,
      "longitude": long,
      "address": location,
    });
    if(result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Address Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchListingDetails();
      return;
    }
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update Address",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

  }

  /// update cetagory Data---



  /// Uploads multiple photos to the server and updates the uploadedPhotoUrls list
  /// Returns the list of uploaded photo URLs if successful, empty list otherwise
  Future<List<String>> uploadMultiplePhotos(List<String> filePaths) async {
    if (filePaths.isEmpty) return [];

    isUploadingPhotos.value = true;
    try {
      final result = await _repository.uploadMultipleDocuments(
        filePaths: filePaths,
        folder: 'property_photos', // Using a specific folder for property photos
      );

      // Add the newly uploaded URLs to our list
      uploadedPhotoUrls.addAll(result.data.urls);

      return result.data.urls;
    } catch (e) {
      Get.log('Error uploading photos: $e');
      Fluttertoast.showToast(
        msg: "Failed to upload photos. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return [];
    } finally {
      isUploadingPhotos.value = false;
    }
  }

  /// Removes a photo from the uploadedPhotoUrls list at the specified index
  void removePhoto(int index) {
    if (index >= 0 && index < uploadedPhotoUrls.length) {
      uploadedPhotoUrls.removeAt(index);
    }
  }


  Future<List<PlaceSuggestion>> onPlaceSearchChange(String query) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    // try {
    final response = await _repository.getMapSuggestions(
        place: query
    );

    // listings.value = response.data;

    suggestions.value = response.data ?? [];

    return suggestions.toList();
  }

  // Add this method to your controller

  final RxMap<String, List<String>> categorizedImages = <String, List<String>>{
    'images': [], // General images category
    'living_room_images': [],
    'kitchen_images': [],
    'bathroom_images': [],
    'bedroom_images': [],
    'washroom_images': [],
  }.obs;
  final RxString coverImageCategory = ''.obs;
  void initializeCategoryImagesFromListing() {
    if (listingDetails.value != null) {
      final listing = listingDetails.value!;


      // Initialize general images FIRST
      categorizedImages['images'] =
      listing.images != null
          ? List<String>.from(listing.images!)
          : [];

      // Initialize categorized images
      categorizedImages['living_room_images'] =
      listing.livingRoomImages != null
          ? List<String>.from(listing.livingRoomImages!)
          : [];

      categorizedImages['kitchen_images'] =
      listing.kitchenImages != null
          ? List<String>.from(listing.kitchenImages!)
          : [];

      categorizedImages['bathroom_images'] =
      listing.bathroomImages != null
          ? List<String>.from(listing.bathroomImages!)
          : [];

      categorizedImages['bedroom_images'] =
      listing.bedroomImages != null
          ? List<String>.from(listing.bedroomImages!)
          : [];

      categorizedImages['washroom_images'] =
      listing.washroomImages != null
          ? List<String>.from(listing.washroomImages!)
          : [];

      // Debug: Print loaded images

      // Set cover image
      if (listing.coverPhoto != null && listing.coverPhoto!.isNotEmpty) {
        coverImageUrl.value = listing.coverPhoto!;

        // Find which category the cover image belongs to
        categorizedImages.forEach((category, images) {
          if (images.contains(coverImageUrl.value)) {
            coverImageCategory.value = category;
          }
        });
      }

      // Backward compatibility - also set finalUploadedImages
      if (listing.images != null && listing.images!.isNotEmpty) {
        finalUploadedImages.value = List<String>.from(listing.images!);
      }

      // Force refresh
      categorizedImages.refresh();
    } else {
    }
  }

  Future<List<String>> uploadCategoryPhotos(
      List<String> filePaths,
      String category,
      ) async {
    if (filePaths.isEmpty) return [];

    isUploadingPhotos.value = true;
    try {
      final result = await _repository.uploadMultipleDocuments(
        filePaths: filePaths,
        folder: 'property_photos/$category',
      );

      // Add the newly uploaded URLs to the category
      if (categorizedImages[category] != null) {
        categorizedImages[category]!.addAll(result.data.urls);
      } else {
        categorizedImages[category] = result.data.urls;
      }

      // Trigger update
      categorizedImages.refresh();

      return result.data.urls;
    } catch (e) {
      Get.log('Error uploading photos: $e');
      Fluttertoast.showToast(
        msg: "Failed to upload photos. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return [];
    } finally {
      isUploadingPhotos.value = false;
    }
  }

  List<String> getCategoryImages(String category) {
    final images = categorizedImages[category] ?? [];
    return images;
  }

  // Set existing images for a category (when editing)
  void setCategoryImages(String category, List<String> urls) {
    categorizedImages[category] = urls;
    categorizedImages.refresh();
  }

  // Remove image from category
  void removeImageFromCategory(String category, String imageUrl) {
    if (categorizedImages[category] != null) {
      categorizedImages[category]!.remove(imageUrl);

      // If removed image was the cover, clear cover
      if (coverImageUrl.value == imageUrl) {
        coverImageUrl.value = '';
        coverImageCategory.value = '';
      }

      categorizedImages.refresh();
    }
  }

  // Get total image count across all categories
  int getTotalImageCount() {
    int total = 0;
    categorizedImages.forEach((key, value) {
      total += value.length;
    });
    return total;
  }

  // Get total images excluding general 'images' category (to avoid double counting)
  int getCategorizedImageCount() {
    int total = 0;
    categorizedImages.forEach((key, value) {
      if (key != 'images') {
        total += value.length;
      }
    });
    return total;
  }

  // Set cover image with category tracking
  void setCoverImage(String imageUrl, String category) {
    coverImageUrl.value = imageUrl;
    coverImageCategory.value = category;
  }

  // Check if an image is the cover image
  bool isCoverImage(String imageUrl) {
    return coverImageUrl.value == imageUrl;
  }

  // Get all images across all categories (excluding duplicates)
  List<String> getAllImages() {
    Set<String> allImagesSet = {};

    // Add all categorized images
    categorizedImages.forEach((key, value) {
      allImagesSet.addAll(value);
    });

    return allImagesSet.toList();
  }

  // Get only categorized images (excluding general 'images')
  Map<String, List<String>> getCategorizedImagesOnly() {
    Map<String, List<String>> categorized = {};
    categorizedImages.forEach((key, value) {
      if (key != 'images') {
        categorized[key] = value;
      }
    });
    return categorized;
  }

  Future<void> goNextAfterUploadedPhotosData() async {
    // Collect all unique images
    List<String> allImages = getAllImages();

    var result = await _repository.updateListingImageUpload(
      id: createdListingId ?? '',
      body: {
        "cover_photo": coverImageUrl.value,
        "images": allImages, // All unique images combined
        "living_room_images": categorizedImages['living_room_images'] ?? [],
        "kitchen_images": categorizedImages['kitchen_images'] ?? [],
        "bathroom_images": categorizedImages['bathroom_images'] ?? [],
        "bedroom_images": categorizedImages['bedroom_images'] ?? [],
        "washroom_images": categorizedImages['washroom_images'] ?? [],
      },
    );

    if (result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Images Uploaded Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchListingDetails();
      return;
    }

    if (!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update images",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
  }
  // Update listing with categorized images
  Future<void> goNextAfterUploadedPhotos() async {
    // Collect all unique images
    List<String> allImages = getAllImages();


    var result = await _repository.updateListing(
      id: createdListingId ?? '',
      body: {
        "id": createdListingId,
        "cover_photo": coverImageUrl.value,
        "images": allImages, // All unique images combined
        "living_room_images": categorizedImages['living_room_images'] ?? [],
        "kitchen_images": categorizedImages['kitchen_images'] ?? [],
        "bathroom_images": categorizedImages['bathroom_images'] ?? [],
        "bedroom_images": categorizedImages['bedroom_images'] ?? [],
        "washroom_images": categorizedImages['washroom_images'] ?? [],
      },
    );

    if (result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Images Uploaded Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchListingDetails();
      return;
    }

    if (!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update images",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
  }


  void clearAllData() {
    categorizedImages['images']?.clear();
    categorizedImages['living_room_images']?.clear();
    categorizedImages['kitchen_images']?.clear();
    categorizedImages['bathroom_images']?.clear();
    categorizedImages['bedroom_images']?.clear();
    categorizedImages['washroom_images']?.clear();
    coverImageUrl.value = '';
    coverImageCategory.value = '';
    finalUploadedImages.clear();
    categorizedImages.refresh();
  }

}

// Hello I am Tamim