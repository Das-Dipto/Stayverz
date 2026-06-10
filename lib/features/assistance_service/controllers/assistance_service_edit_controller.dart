import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/features/listing/models/host_listing_configuration_model.dart';
import '../models/assistance_cancellation_polices_response.dart';
import '../models/assistance_categories_response.dart';
import '../models/co_host_listing_response_model.dart';
import '../models/listing_model.dart';
import '../models/map_suggestions_response_model.dart';
import '../models/single_assistance_listing_response_model.dart';
import '../../listing/models/map_suggestions_response_model.dart' as lstMap;
import '../repositories/assistance_service_repository_interface.dart';

class AssistanceServiceEditController extends GetxController {

  final AssistanceServiceRepositoryInterface _repository;
  AssistanceServiceEditController(this._repository);

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
  lstMap.PlaceSuggestion?  selectedEditAssistanceCoveringArea;
  lstMap.PlaceSuggestion?  selectedEditAssistanceCurrentLocation;
  Rx<lstMap.PlaceSuggestion?>  selectedPlace = Rx<lstMap.PlaceSuggestion?>(null);
  // Rx<PlaceSuggestion?> selectedPlace = Rx<PlaceSuggestion?>(null);
  Rx<AssistanceSingleData?> listingDetails = Rx<AssistanceSingleData?>(null);
  RxList<AssistanceCategory> assistanceCategoryList = RxList<AssistanceCategory>();
  RxList<AssistanceCancellationPolices> assistanceCancellationPolicesList = RxList<AssistanceCancellationPolices>();
  // Rx<Category?> selectedCategory = Rx<Category?>(null);
  Rx<PlaceType?> selectedPlaceType = Rx<PlaceType?>(null);
  RxInt? selectedCategoryId = RxInt(0);
  String createdListingId = '';
  RxList<int> selectedAmenities = RxList<int>();
  TextEditingController suggestionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController describeAssistanceController = TextEditingController();
  TextEditingController currentLocationController = TextEditingController();
  TextEditingController coverageAreaController = TextEditingController();
  TextEditingController aboutYouController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController maxPersonController = TextEditingController();
  TextEditingController extraServicesController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  RxDouble basePriceValue = RxDouble(0.0);
  RxDouble guestGatewayFeeValue = RxDouble(0.0);
  RxDouble totalGuestPriceValue = RxDouble(0.0);
  RxDouble youEarnPriceValue = RxDouble(0.0);
  RxInt onHostCoHostChangeValue = RxInt(0);
  final selectedPlaceTypeId = ''.obs;
  final Rx<Marker?> selectedMarker = Rx<Marker?>(null);
  final ListingController ac = Get.find<ListingController>();

  // Pagination settings
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    priceController.addListener(() {

    });
  }

  void clearAllStates(){
    suggestions.value = [];
    suggestionController.clear();
    selectedPlace.value = null;
    listingDetails.value = null;
    assistanceCategoryList.clear();
    // selectedCategory.value = null;
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

 // ✅ AFTER
Future<void> fetchAssistanceSingleListingDetails({String? id}) async {
  isLoading.value = true;
  hasError.value = false;
  errorMessage.value = '';

  try {
    createdListingId = id ?? Get.arguments?['id'] ?? ''; // ✅ uses passed id
    if (createdListingId.isEmpty) throw Exception("Listing ID is required");
    
    var res = await _repository.getAssistanceSingleListingDetails(id: createdListingId);
    listingDetails.value = res;
  } catch (e) {
    hasError.value = true;
    errorMessage.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}

  Future<void> fetchAssistanceCategory() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      AssistanceCategoriesResponse response = await _repository.getAssistanceCategory();

      assistanceCategoryList.value = response.data ?? [];

    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAssistanceCancellationPolices() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      AssistanceCancellationPolicesResponse response = await _repository.getAssistanceCancellationPolices();

      assistanceCancellationPolicesList.value = response.data ?? [];

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
      fetchAssistanceSingleListingDetails();
    }
  }

  void loadPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchAssistanceSingleListingDetails();
    }
  }

  void refreshListings() {
    currentPage.value = 1;
    fetchAssistanceSingleListingDetails();
  }

  void goUpdateAfterSelectingCategory() async {
    // if(selectedCategoryId?.value == null) {
    //   Fluttertoast.showToast(
    //     msg: "Please select a category",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //   );
    //   return;
    // }
    // var result = await _repository.updateListing( id: createdListingId ?? '',body: {
    //   "id": createdListingId,
    //   "category" : selectedCategoryId!.value
    // });
    //
    // if(result.isSuccess) {
    //   Fluttertoast.showToast(
    //     msg: "Update category of Successfully",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //   );
    //   await fetchListingDetails();
    //   return;
    // }
    // if(!result.isSuccess) {
    //   Fluttertoast.showToast(
    //     msg: "Failed to update category of my_listing",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //   );
    //   return;
    // }

  }

  void goUpdateAfterSelectingPlaceType() async {
    // if(selectedPlaceTypeId.value == '') {
    //   Fluttertoast.showToast(
    //     msg: "Please select a place type",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //   );
    //   return;
    // }
    // var result = await _repository.updateListing( id: createdListingId ?? '',body: {
    //   "id": createdListingId,
    //   "place_type" : selectedPlaceTypeId.value ?? ''
    // });
    //
    // if(result.isSuccess) {
    //   Fluttertoast.showToast(
    //     msg: "Update place type Successfully",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //   );
    //   await fetchListingDetails();
    //   return;
    // }
    // if(!result.isSuccess) {
    //   Fluttertoast.showToast(
    //     msg: "Failed to place type of my_listing",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //   );
    //   return;
    // }

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


  void goUpdatePolicy({required int id}) async {

    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
      "cancellation_policy_id": id,
    });

    if(result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Cancellation Policy Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchAssistanceSingleListingDetails();
      ac.fetchAssistanceListings();
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
    // var result = await _repository.updateListing( id: createdListingId ?? '',body: {
    //   "id": createdListingId,
    //   "minimum_nights": minday,
    //   "maximum_nights": maxday,
    // });
    //
    // if(result.isSuccess) {
    //   Fluttertoast.showToast(
    //     msg: "Min Max Day Updated",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //   );
    //   await fetchListingDetails();
    //   return;
    // }
    // if(!result.isSuccess) {
    //   Fluttertoast.showToast(
    //     msg: "Failed to update place location",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //   );
    //   return;
    // }

  }

  void goUpdateInstantBooking(bool isBook) async {
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',
        body: {
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
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
    isUpdating.value = false;
    Get.back();
  }

  void goUpdateMultipleDateSelectionEnable(bool isBook) async {
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',
        body: {
          "is_enable_multiple_date_selection": isBook,
        });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update Multiple date selection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
    isUpdating.value = false;
    Get.back();
  }

  void goNextAfterUploadedPhotos() async {

    if(coverImageUrl.value==''||finalUploadedImages.value.isEmpty){
      Fluttertoast.showToast(
        msg: "Please select any image and cover Photo",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }

    var result = await _repository.updateAssistanceListing( id: createdListingId,body: {
      "cover_photo": coverImageUrl.value,
      "images": finalUploadedImages.toList()
    });

    if(result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Image Uploaded Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchAssistanceSingleListingDetails();
      ac.fetchAssistanceListings();
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
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
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
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
    isUpdating.value = false;
    Get.back();
  }

  void goNextAfterEnteredAboutYou() async {
    isUpdating.value = true;
    if(aboutYouController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter about you",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
      "about_you": aboutYouController.text
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update about you",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
    isUpdating.value = false;
    Get.back();
  }

  void goNextAfterEnteredDetails() async {
    isUpdating.value = true;
    if(descriptionController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter details",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
      "details": descriptionController.text
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update details",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
    isUpdating.value = false;
    Get.back();
  }

  void goNextAfterEnteredDescribeAssistance() async {
    isUpdating.value = true;
    if(describeAssistanceController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter assistance description",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
      "assistance_description": describeAssistanceController.text
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update assistance description",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
    isUpdating.value = false;
    Get.back();
  }

  void goNextAfterEnteredCoverageArea() async {
    isUpdating.value = true;
    if(coverageAreaController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter coverage area",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
      "latitude_coverage_area": selectedEditAssistanceCoveringArea?.latitude,
      "longitude_coverage_area": selectedEditAssistanceCoveringArea?.longitude,
      "coverage_area_name": coverageAreaController.text,
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update coverage area",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
    isUpdating.value = false;
    Get.back();
  }

  void goNextAfterEnteredCurrentLocation() async {
    isUpdating.value = true;
    if(currentLocationController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter current location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
      "latitude_current_location": selectedEditAssistanceCurrentLocation?.latitude,
      "longitude_current_location": selectedEditAssistanceCurrentLocation?.longitude,
      "current_location_name": currentLocationController.text,
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update current location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
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
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
      "price": priceController.text,
      // ...supportiveData
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
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
    isUpdating.value = false;
    Get.back();
  }

  void goNextAfterEnteredMaxPerson() async {
    isUpdating.value = true;
    if(maxPersonController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter max person",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
      "max_person": maxPersonController.text
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update max person",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
    isUpdating.value = false;
    Get.back();
  }

  void goNextAfterEnteredExtraServicesPrice() async {
    isUpdating.value = true;
    if(extraServicesController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter extra service price",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
      "extra_charge_per_person": extraServicesController.text,
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to extra service price",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    await fetchAssistanceSingleListingDetails();
    ac.fetchAssistanceListings();
    isUpdating.value = false;
    Get.back();
  }

  void onPublishClick() async {
    isUpdating.value = true;
    if(statusController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please select status",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      isUpdating.value = false;
      return;
    }
    var result = await _repository.updateAssistanceListing( id: createdListingId ?? '',body: {
      'status': statusController.text
    });
    if(!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update status",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchAssistanceSingleListingDetails();
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
    var result = await _repository.updateAssistanceListing( id: createdListingId,body: {
      "latitude_meetup_point": lat,
      "longitude_meetup_point": long,
      "meetup_point_name": location,
    });
    if(result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Address Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      await fetchAssistanceSingleListingDetails();
      ac.fetchAssistanceListings();
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

}

// Hello I am Tamim