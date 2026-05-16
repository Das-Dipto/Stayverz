import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/utils/main_utils.dart';
import '../../listing/models/calendar/assistance_calender_responce_model.dart';
import '../../listing/models/map_suggestions_response_model.dart';
import '../../public_listings/data/models/listing_details_model.dart';
import '../models/assistance_categories_response.dart';
import '../models/assistance_price_update_model.dart';
import '../models/co_host_listing_response_model.dart';
import '../models/payment_post_model.dart';
import '../models/payment_responce_model.dart';
import '../models/update_calendar_response_model.dart';
import '../repositories/assistance_service_repository_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

class AssistanceServiceController extends GetxController {
  final AssistanceServiceRepositoryInterface _repository;

  AssistanceServiceController(this._repository);

  var isLoadingNext = false.obs;

  // State variables
  final RxBool isLoading = false.obs;
  final RxBool isCategoryLoading = false.obs;
  final RxBool isCalendarLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxBool hasErrorg = false.obs;
  RxBool isPublishing = false.obs;
  RxBool isCreatingAssistance = false.obs;
  final isInitialLoad = true.obs;
  final RxBool isGridView = false.obs;
  final RxBool enableMultipleDateSelection = false.obs;


  final RxList<CoHostListingData> coHostListings = <CoHostListingData>[].obs;
  final Rx<ListingDetailsModel> listingDetails = ListingDetailsModel().obs;
  final RxString calendarError = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt coHostCurrentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt coHostTotalPages = 1.obs;

  final RxString errorMessage = ''.obs;

  final RxString errorMessageg = ''.obs;
  RxString imageUrl = ''.obs;
  final Rx<gmap.Marker?> selectedMarker = Rx<gmap.Marker?>(null);

  RxInt currentState = RxInt(0);
  RxList<String> uploadedPhotoUrls = <String>[].obs;

  RxList<File> selectedAssistanceFiles = <File>[].obs;

  PlaceSuggestion? selectedAssistanceCurrentLocation;
  PlaceSuggestion? selectedAssistanceCoveringArea;
  PlaceSuggestion? selectedAssistanceMeetupPoint;

  RxList<PlaceSuggestion> suggestions = RxList<PlaceSuggestion>();
  Rx<PlaceSuggestion?> selectedPlace = Rx<PlaceSuggestion?>(null);
  RxList<AssistanceCategory> assistanceCategories = RxList<AssistanceCategory>();
  Rx<AssistanceCategory?> selectedCategory = Rx<AssistanceCategory?>(null);
  Rx<AssistanceCategory?> selectedExperiences = Rx<AssistanceCategory?>(null);
  String? createdListingId;
  RxList<int> selectedAmenities = RxList<int>();

  TextEditingController meetupPointSuggestionController = TextEditingController();
  TextEditingController aboutYouController = TextEditingController();
  TextEditingController currentLocationSuggesterController = TextEditingController();
  TextEditingController coveringAreaSuggesterController = TextEditingController();
  TextEditingController describeYourAssistanceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController maxParticipationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController extraServicesController = TextEditingController();

  final myListingScrollController = ScrollController();
  RxInt onHostCoHostChangeValue = RxInt(0);
  RxList<int> selectedAmenityIds = <int>[].obs;
  final int pageSize = 100;

  Rx<AssistanceCalendarResponse?> assistanceCalendarResponse = Rx<AssistanceCalendarResponse?>(null);
  ScrollController calenderViewController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchAssistanceCategory();
    myListingScrollController.addListener(() {
      if (myListingScrollController.position.maxScrollExtent == myListingScrollController.offset) {

      }
    });
  }

  @override
  void dispose() {
    myListingScrollController.dispose();
    super.dispose();
  }

  void clearAllStates() {
    suggestions.value = [];
    meetupPointSuggestionController.clear();
    selectedPlace.value = null;
    assistanceCategories.clear();
    selectedCategory.value = null;
    createdListingId = null;
    selectedAmenities.value = [];
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
  }

  void toggleViewMode() {
    isGridView.toggle();
  }


  void onHostCoHostChange(int value) {
    onHostCoHostChangeValue(value);
    switch (value) {
      case 0:
        onHostCoHostChangeValue.value = 0;
      case 1:
        onHostCoHostChangeValue.value = 1;
        // fetchCoHostListings();
    }
  }

  Future<void> fetchCreatedListing() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // createdListing.value = await _repository.getSingleListingDetails(
      //   id: createdListingId ?? '',
      // );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAssistanceCategory() async {
    isCategoryLoading.value = true;
    hasErrorg.value = false;
    errorMessageg.value = '';

    try {
    AssistanceCategoriesResponse response = await _repository.getAssistanceCategory();

      assistanceCategories.value = response.data ?? [];
    } catch (e) {
      hasErrorg.value = true;
      errorMessageg.value = e.toString();
    } finally {
      isCategoryLoading.value = false;
    }
  }


  void loadPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  void refreshListings() {
    currentPage.value = 1;
    // fetchCoHostListings();
  }


  void goBack() {
    switch (currentState.value) {
      case 0:
        Get.back();
        break;
      case 1:
        currentState.value = 0;
        break;
      case 2:
        currentState.value = 1;
        break;
      case 3:
        currentState.value = 2;
        break;
      case 4:
        currentState.value = 3;
        break;
      default:
        break;
    }
  }


  void goNextAfterSelectingCategory() async {
    if(selectedCategory.value == null) {
      MainUtils.showErrorSnackBar('Please a select category');
      return;
    }
    currentState(1);
  }

  void goNextAfterSelectingSubcategory() async {
    if(selectedExperiences.value == null) {
      MainUtils.showErrorSnackBar('Please select your assistance subcategory');
      return;
    }
    currentState(2);
  }

  void goNextAfterCreateListing() async {
    // try {
      isCreatingAssistance.value = true;
      var result = await _repository.createAssistanceListing(body: {
        "category_id": selectedCategory.value?.id,
        "a_sub_category_id": selectedExperiences.value?.id
      });
      if (!result.isSuccess) {
        MainUtils.showErrorSnackBar(
          "Failed to create: ${result.message}",
        );
        return;
      }
      createdListingId = result.data?.uniqueId ?? '';
      currentState(3);
    // } catch(e) {
    //   MainUtils.showErrorSnackBar(
    //     "Failed to create assistance my_listing",
    //   );
    // } finally {
      isCreatingAssistance.value = false;
    // }
  }

  void goNextAfterSharingQualifications() async {
    try {

      isPublishing.value = true;

      if (maxParticipationController.text.isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter max participation number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        return;
      }

      if (priceController.text.isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter the service price",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        return;
      }

      if (coveringAreaSuggesterController.text.isEmpty || selectedAssistanceCoveringArea == null) {
        Fluttertoast.showToast(
          msg: "Please enter the covering area",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        return;
      }

      List<String> uploadedPathList = [];

      if(selectedAssistanceFiles.isNotEmpty) {
        final result = await _repository.uploadMultipleDocuments(
            filePaths: selectedAssistanceFiles.map((e) => e.path).toList(),
            folder: 'property_photos'
        );
        uploadedPathList = result.data.urls;
      }

      var payload = {
        "title": titleController.text,
        "about_you": aboutYouController.text,
        "details": descriptionController.text,
        "assistance_description": describeYourAssistanceController.text,
        "max_person": maxParticipationController.text,
        "price": priceController.text,
        "extra_charge_per_person": extraServicesController.text,
        if(uploadedPathList.isNotEmpty)...{"cover_photo": uploadedPathList.first},
        "status": "published",
        if(uploadedPathList.isNotEmpty)...{"images": uploadedPathList},
        "is_enable_multiple_date_selection": enableMultipleDateSelection.value,
        "latitude_coverage_area": selectedAssistanceCoveringArea?.latitude,
        "longitude_coverage_area": selectedAssistanceCoveringArea?.longitude,
        "coverage_area_name": selectedAssistanceCoveringArea?.address,
        "latitude_current_location": selectedAssistanceCurrentLocation?.latitude,
        "longitude_current_location": selectedAssistanceCurrentLocation?.longitude,
        "current_location_name": selectedAssistanceCurrentLocation?.address,
        if(selectedAssistanceMeetupPoint != null)...{
          "latitude_meetup_point": selectedAssistanceMeetupPoint?.latitude,
          "longitude_meetup_point": selectedAssistanceMeetupPoint?.longitude,
          "meetup_point_name": meetupPointSuggestionController.text
        }
      };


      var result = await _repository.updateAssistanceListing(
        id: createdListingId ?? '',
        body: payload,
      );
      if (!result.isSuccess) {
        Fluttertoast.showToast(
          msg: "Failed to update place location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        return;
      }
      currentState(4);
    } catch(e) {
    } finally {
      isPublishing.value = false;
    }
  }

  Future<PaymentData?> createPayment(String bookingCode) async {
    final result = await _repository.postPayment(
      PaymentPostModel(booking: bookingCode),
    );

    return result.fold(
      (error) {
        Get.snackbar("Payment Failed", error);
        return null;
      },
      (data) {
        final responseModel = PaymentResponseModel.fromJson(data);
        return responseModel.data;
      },
    );
  }

  Future<UpdateCalendarResponseModel?> submitListingCalendar({
    required String listingId,
    required List<AssistancePriceUpdatePayload> bookingList,
  }) async {
    final result = await _repository.postListingCalendar(
      listingId: listingId,
      payload: bookingList,
    );

    return result.fold(
      (error) {
        Get.snackbar("Calendar Submission Failed", error);
        return null;
      },
      (data) {
        final responseModel = UpdateCalendarResponseModel.fromJson(data);
        // Get.snackbar("Success", responseModel.message);
        return responseModel;
      },
    );
  }

  void toggleAmenity(int id) {
    if (selectedAmenityIds.contains(id)) {
      selectedAmenityIds.remove(id);
    } else {
      selectedAmenityIds.add(id);
    }
  }

  Future<AssistanceCalendarResponse?> getListingCalendar({
    required String listingId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      if (isInitialLoad.value) {
        isCalendarLoading.value =
        true; // Only set this true during initial load
      }

      calendarError.value = '';

      final response = await _repository.getListingCalendar(
        listingId: listingId,
        fromDate: fromDate,
        toDate: toDate,
      );

      if (response != null) {
        assistanceCalendarResponse.value = response;
      } else {
        calendarError.value = 'No calendar data received.';
        Get.snackbar('Calendar Error', calendarError.value);
      }

      return response;
    } catch (e) {
      calendarError.value = e.toString();
      Get.snackbar('Calendar Error', calendarError.value);
      return null;
    } finally {
      isCalendarLoading.value = false;
      isInitialLoad.value = false; // Set to false after the first API call
      Future.delayed(Duration(seconds: 1), () {
        calenderViewController.animateTo(DateTime.now().month*(calenderViewController.position.maxScrollExtent/12), duration: Duration(seconds: 1), curve: Curves.easeIn);
      });
    }
  }

}

// Hello I am Tamim