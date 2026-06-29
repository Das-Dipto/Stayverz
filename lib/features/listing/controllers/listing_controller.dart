import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../../services/network/error_display_manager.dart';
import 'package:stayverz_flutter_app/features/listing/models/host_listing_configuration_model.dart';
import '../../../../core/utils/enums/product_listing_enums.dart';
import '../../assistance_service/models/assistance_listing_response_model.dart';
import '../../public_listings/data/models/listing_details_model.dart';
import '../../../features/listing/models/booking_data_responce_model.dart'
    as booking_model;
import '../../public_listings/data/models/search_view_modle.dart';
import '../models/address_responce_model.dart';
import '../models/aminities_new_model.dart';
import '../models/area_new_model.dart';
import '../models/booking_post_model.dart';
import '../models/calendar/calender_responce_model.dart';
import '../models/calendar/division_thana_model.dart';
import '../models/calendar/price_update_model.dart';
import '../models/calendar/responce_model.dart';
import '../models/co_host_listing_response_model.dart';
import '../models/listing_model.dart';
import '../models/map_suggestions_response_model.dart';
import '../models/payment_post_model.dart';
import '../models/payment_responce_model.dart';
import '../models/single_host_listing_response_model.dart';
import '../presentation/views/my_listing/my_listing_screen.dart';
import '../repositories/listing_repository_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

class ListingController extends GetxController {
  final _errorDisplay = Get.find<ErrorDisplayManager>();
  final ListingRepositoryInterface _repository;

  ListingController(this._repository);

  RxList<DateTime> selectedDates = <DateTime>[].obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime> firstDay = DateTime(2025, 1, 1).obs;
  Rx<DateTime> lastDay = DateTime(2025, 12, 31).obs;
  Rx<int> selectedReportType = Rx<int>(0);
  Rx<CalendarResponse?> calendarResponse = Rx<CalendarResponse?>(null);
  ScrollController calenderViewController = ScrollController();
  // RxSet<DateTime> selectedDates = <DateTime>{}.obs;
  // State variables
  RxList<SectionModel> suggestionsNew = <SectionModel>[].obs;
  final RxBool isHostListingLoading = false.obs;
  // ADD THIS
  final RxBool isSectionSearchLoading = false.obs;
  final RxBool isCoHostListingLoading = false.obs;
  final RxBool isAssistanceListingLoading = false.obs;
  final RxBool isLoadingg = false.obs;
  final RxList<ListingModel> listings = <ListingModel>[].obs;
  final RxList<CoHostListingData> coHostListings = <CoHostListingData>[].obs;
  final RxList<AssistanceListingData> assistanceListings =
      <AssistanceListingData>[].obs;
  final Rx<ListingDetailsModel> listingDetails = ListingDetailsModel().obs;
  final RxBool isCalendarLoading = false.obs;
  final RxString calendarError = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt coHostCurrentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt coHostTotalPages = 1.obs;
  final RxBool hasError = false.obs;
  final RxBool hasErrorg = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString errorMessageg = ''.obs;
  final RxBool isGridView = false.obs;
  // final Rx<Marker?> selectedMarker = Rx<Marker?>(null);
  final Rx<gmap.Marker?> selectedMarker = Rx<gmap.Marker?>(null);

  //final calendarResponse = Rxn<CalendarResponse>();

  Rx<CurrentState> currentState = Rx<CurrentState>(CurrentState.FIRST);
  RxInt personsCount = RxInt(0),
      bedroomsCount = RxInt(0),
      bedsCount = RxInt(0),
      bathroomsCount = RxInt(0);

  // For property photos
  RxList<String> uploadedPhotoUrls = <String>[].obs;
  RxBool isUploadingPhotos = false.obs;
  RxList<int> selectedAmenityKeys = <int>[].obs;

  RxList<PlaceSuggestion> suggestions = RxList<PlaceSuggestion>();
  TextEditingController suggestionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  Rx<PlaceSuggestion?> selectedPlace = Rx<PlaceSuggestion?>(null);
  Rx<SingleListingData?> createdListing = Rx<SingleListingData?>(null);
  Rx<ConfigurationData?> listingConfiguration = Rx<ConfigurationData?>(null);
  Rx<Category?> selectedCategory = Rx<Category?>(null);
  Rx<PlaceType?> selectedPlaceType = Rx<PlaceType?>(null);
  Rx<SectionModel?> selectedSection = Rx<SectionModel?>(null);
  String? createdListingId;
  RxList<int> selectedAmenities = RxList<int>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final myListingScrollController = ScrollController();
  RxDouble basePriceValue = RxDouble(0.0);
  RxDouble guestGatewayFeeValue = RxDouble(0.0);
  RxDouble totalGuestPriceValue = RxDouble(0.0);
  RxDouble youEarnPriceValue = RxDouble(0.0);
  RxInt onHostMyListingTabViewChangeValue = RxInt(0);
  RxInt onHostCalendarTabViewChangeValue = RxInt(0);
  RxBool isInitialCalendarLoad = true.obs; // Track initial load state

  // Pagination settings
  final int pageSize = 10;
  
  // Dedicated variables for HostCalendarTabView
  RxInt calendarCurrentPage = 1.obs;
  RxInt calendarTotalPages = 1.obs;
  RxBool isCalendarTabLoading = false.obs;
  RxList<ListingModel> calendarListings = <ListingModel>[].obs;
  ScrollController calendarScrollController = ScrollController();

  bool isDateSelectable(DateTime day) {
    final now = DateTime.now();
    final isPast = day.isBefore(now) || day.isAtSameMomentAs(now);
    final calendarData = calendarResponse.value?.data.calendarData;
    if (calendarData != null) {
      final dayKey = day.toIso8601String().split('T')[0];
      final dayData = calendarData[dayKey];
      return !isPast &&
          (dayData?.isBlocked ?? false) == false &&
          (dayData?.isBooked ?? false) == false;
    }
    return !isPast;
  }

  void onDaySelected(DateTime day, DateTime focusedDay) {
    if (isDateSelectable(day)) {
      if (selectedDates.contains(day)) {
        selectedDates.remove(day);
      } else if (selectedDates.length < 2) {
        // Limit to a range of 2 dates
        selectedDates.add(day);
        selectedDates.sort((a, b) => a.compareTo(b));
      }
      this.focusedDay.value = focusedDay;
    }
  }

  String getPriceForDay(DateTime day) {
    final calendarData = calendarResponse.value?.data.calendarData;
    if (calendarData != null) {
      final dayKey = day.toIso8601String().split('T')[0];
      final dayData = calendarData[dayKey];
      return dayData != null
          ? 'b${dayData.price!.toInt()}'
          : 'b7500'; // Default price if no data
    }
    return 'b7500';
  }

  @override
  void onInit() {
    super.onInit();
    fetchListings(); // Load all listings initially for other screens
    fetchAmenities();
    fetchHostListingConfigurations();
    
    // Initialize calendar tab with published listings using dedicated method
    fetchCalendarOnlyListings(isRefresh: true);
    
    myListingScrollController.addListener(() {
      if (myListingScrollController.position.maxScrollExtent ==
          myListingScrollController.offset) {
        loadNextPage();
      }
    });
    
    // Add scroll listener for calendar pagination
    calendarScrollController.addListener(() {
      if (calendarScrollController.position.maxScrollExtent ==
          calendarScrollController.offset) {
        loadNextCalendarPage();
      }
    });
    priceController.addListener(() {
      basePriceValue.value = double.parse(
        priceController.text.isEmpty ? '0' : priceController.text,
      );
      if (createdListing.value != null) {
        guestGatewayFeeValue.value =
            basePriceValue.value *
            createdListing.value!.guestServiceCharge!.toDouble();
        youEarnPriceValue.value =
            basePriceValue.value -
            (basePriceValue.value *
                createdListing.value!.hostServiceCharge!.toDouble());
        totalGuestPriceValue.value =
            basePriceValue.value + guestGatewayFeeValue.value;
      }
    });
  }

  // @override
  // void dispose() {
  //   myListingScrollController.dispose();
  //   super.dispose();
  // }

  @override
  void onClose() {
    // Cancel timer first
    _debounce?.cancel();

    // Scroll controllers
    myListingScrollController.dispose();
    calenderViewController.dispose();
    calendarScrollController.dispose();

    // Text editing controller
    propertyCtrl.dispose();
    flatCtrl.dispose();
    areaSearchCtrl.dispose();   // only once
    divisionCtrl.dispose();
    districtCtrl.dispose();
    subDistrictCtrl.dispose();
    zipCtrl.dispose();
    suggestionController.dispose();
    searchController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();

    super.onClose(); // always last
  }

  void clearAllStates() {
    suggestions.value = [];
    suggestionController.clear();
    selectedPlace.value = null;
    createdListing.value = null;
    listingConfiguration.value = null;
    selectedCategory.value = null;
    selectedPlaceType.value = null;
    createdListingId = null;
    selectedAmenities.value = [];
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    basePriceValue.value = 0;
    guestGatewayFeeValue.value = 0;
    totalGuestPriceValue.value = 0;
    youEarnPriceValue.value = 0;
  }

  void toggleViewMode() {
    isGridView.toggle();
  }

  Future<void> fetchCalendarOnlyListings({bool isRefresh = false}) async {
    if (isRefresh) {
      calendarCurrentPage.value = 1;
      calendarListings.clear();
    }
    
    isCalendarTabLoading.value = true;
    try {
      final response = await _repository.getListings(
        page: calendarCurrentPage.value,
        pageSize: pageSize,
        status: "published", // Always published for calendar tab
      );

      if (calendarCurrentPage.value == 1) {
        calendarListings.value = response.data;
      } else {
        calendarListings.addAll(response.data);
      }

      // Calculate total pages based on meta_data
      if (response.meta_data.containsKey('total')) {
        final total = response.meta_data['total'] as int;
        calendarTotalPages.value = (total / pageSize).ceil();
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isCalendarTabLoading.value = false;
    }
  }

  Future<void> fetchCalendarListings({bool isRefresh = false}) async {
    if (isRefresh) {
      calendarCurrentPage.value = 1;
      calendarListings.clear();
    }
    
    isCalendarTabLoading.value = true;
    try {
      final response = await _repository.getListings(
        page: calendarCurrentPage.value,
        pageSize: pageSize,
        status: "published",
      );

      if (calendarCurrentPage.value == 1) {
        calendarListings.value = response.data;
      } else {
        calendarListings.addAll(response.data);
      }

      // Calculate total pages based on meta_data
      if (response.meta_data.containsKey('total')) {
        final total = response.meta_data['total'] as int;
        calendarTotalPages.value = (total / pageSize).ceil();
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isCalendarTabLoading.value = false;
    }
  }

  void loadNextCalendarPage() {
    if (calendarCurrentPage.value < calendarTotalPages.value) {
      calendarCurrentPage.value++;
      fetchCalendarOnlyListings();
    }
  }

  void refreshCalendarListings() {
    fetchCalendarOnlyListings(isRefresh: true);
  }

  Future<void> fetchListings({String? search, String? status}) async {
    isSectionSearchLoading.value = true;  // ✅ CHANGE TO THIS
    hasError.value = false;
    errorMessage.value = '';

    if ((search ?? '').isNotEmpty || (status ?? '').isNotEmpty) {
      currentPage.value = 1;
    }
    try {
      final response = await _repository.getListings(
        page: currentPage.value,
        pageSize: pageSize,
        search: search,
        status: status,
      );


      if (currentPage.value == 1) {
        listings.clear();
        listings.value = response.data;
      } else {
        listings.addAll(response.data);
      }

      // Calculate total pages based on meta_data
      if (response.meta_data.containsKey('total')) {
        final total = response.meta_data['total'] as int;
        totalPages.value = (total / pageSize).ceil();
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
       isSectionSearchLoading.value = false;  // ✅
    }
  }

  Future<void> fetchCoHostListings({String? listingStatus}) async {
    isCoHostListingLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _repository.getCoHostListings(
        page: coHostCurrentPage.value,
        pageSize: pageSize,
        listingStatus: listingStatus,
      );

      if (coHostCurrentPage.value == 1) {
        coHostListings.clear();
        coHostListings.value = response.data ?? [];
      } else {
        coHostListings.addAll(response.data ?? []);
      }

      // Calculate total pages based on meta_data
      final total = (response.metaData?.total ?? 0);
      coHostTotalPages.value = (total / pageSize).ceil();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isCoHostListingLoading.value = false;
    }
  }

  Future<void> fetchAssistanceListings({String? listingStatus}) async {
    isAssistanceListingLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _repository.getAssistanceListings(
        page: coHostCurrentPage.value,
        pageSize: pageSize,
        listingStatus: listingStatus,
      );

      if (coHostCurrentPage.value == 1) {
        assistanceListings.clear();
        assistanceListings.value = response.data ?? [];
      } else {
        assistanceListings.addAll(response.data ?? []);
      }

      // Calculate total pages based on meta_data
      // final total = (response.metaData?.total ?? 0);
      // coHostTotalPages.value = (total / pageSize).ceil();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isAssistanceListingLoading.value = false;
    }
  }

  void onHostCalendarTabBarChange(int value) {
    onHostCalendarTabViewChangeValue.value = value;
    
    switch (value) {
      case 0:
        // For the very first time Host tab is accessed, don't re-fetch since it's already loaded in onInit
        if (isInitialCalendarLoad.value) {
          isInitialCalendarLoad.value = false; // Mark initial load as complete
          return;
        }
        fetchCalendarOnlyListings(isRefresh: true);
        break;
      case 1:
        isInitialCalendarLoad.value = false; // Mark initial load as complete
        fetchCoHostListings(listingStatus: "published");
        break;
      case 2:
        isInitialCalendarLoad.value = false; // Mark initial load as complete
        fetchAssistanceListings(listingStatus: "published");
        break;
    }
  }

  void onHostCoHostChangeMyList(int value) {
    onHostMyListingTabViewChangeValue.value = value;

    switch (value) {
      case 0:
        fetchListings();
        break;
      case 1:
        fetchCoHostListings();
        break;
      case 2:
        fetchAssistanceListings();
        break;
    }
  }

  Future<void> fetchCreatedListing() async {
    isHostListingLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      createdListing.value = await _repository.getSingleListingDetails(
        id: createdListingId ?? '',
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isHostListingLoading.value = false;
    }
  }

  Future<void> fetchHostListingConfigurations() async {
    isLoadingg.value = true;
    hasErrorg.value = false;
    errorMessageg.value = '';

    try {
      HostListingConfigurationModel response =
          await _repository.getHostListingConfiguration();
      listingConfiguration.value = response.data;
    } catch (e) {
      hasErrorg.value = true;
      errorMessageg.value = e.toString();
    } finally {
      isLoadingg.value = false;
    }
  }


  final RxList<AmenitiesCategoryModel> amenitiesList =
      <AmenitiesCategoryModel>[].obs;

  Future<void> fetchAmenities() async {
    isLoadingg.value = true;
    hasErrorg.value = false;
    errorMessageg.value = '';

    try {
      AmenitiesResponseModel response =
      await _repository.getAmenities();

      amenitiesList.value = response.data ?? [];
    } catch (e) {
      hasErrorg.value = true;
      errorMessageg.value = e.toString();
    } finally {
      isLoadingg.value = false;
    }
  }


  final RxBool isUpdatingAmenities = false.obs;

  Future<void> updateAmenities({
    required String listingId,
    required List<int> amenityIds,
  }) async {
    try {
      isUpdatingAmenities.value = true;

      await _repository.updateListingAmenities(
        listingId: listingId,
        amenityIds: amenityIds,
      );

      Fluttertoast.showToast(
        msg: 'Amenities updated successfully',
        gravity: ToastGravity.TOP,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to update amenities',
        gravity: ToastGravity.TOP,
      );
      rethrow;
    } finally {
      isUpdatingAmenities.value = false;
    }
  }

  void loadNextPage() {
    if (onHostMyListingTabViewChangeValue.value == 0) {
      if (currentPage.value < totalPages.value) {
        currentPage.value++;
        fetchListings();
      }
    } else {
      if (coHostCurrentPage.value < coHostTotalPages.value) {
        coHostCurrentPage.value++;
        fetchCoHostListings();
      }
    }
  }

  void loadPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchListings();
    }
  }

  void refreshListings() {
    currentPage.value = 1;
    coHostCurrentPage.value = 1;
    fetchListings();
  }

  void searchListings(String query) {
    // In a real implementation, you might want to add a search parameter to your API call
    // For now, we'll just refresh the listings
    if (query.isEmpty) {
      fetchListings();
    } else {
      fetchListings(search: query);
    }
  }

  var areas = <AreaModel>[].obs;
  var isLoading = false.obs;
  /// 🔹 Search API call


  /// Optional: Clear search
  void clearSearch() {
    areas.clear();
  }


  final RxMap<String, List<String>> categorizedImages = <String, List<String>>{
    'images': [], // General images category
    'living_room_images': [],
    'kitchen_images': [],
    'bathroom_images': [],
    'bedroom_images': [],
    'washroom_images': [],
  }.obs;
  List<String> getCategoryImages(String category) {
    return categorizedImages[category] ?? [];
  }

  void addImageToCategory(String category, String imageUrl) {
    if (categorizedImages.containsKey(category)) {
      categorizedImages[category]!.add(imageUrl);
      categorizedImages.refresh(); // important for UI update
    }
  }

  void clearCategory(String category) {
    categorizedImages[category]?.clear();
    categorizedImages.refresh();
  }


  void removeImageFromCategory(String category, String imageUrl) {
    categorizedImages[category]?.remove(imageUrl);
    categorizedImages.refresh();
  }
  final RxString coverImageCategory = ''.obs;
  final RxString coverImageUrl = ''.obs;
  List<String> getAllImages() {
    Set<String> allImagesSet = {};

    // Add all categorized images
    categorizedImages.forEach((key, value) {
      allImagesSet.addAll(value);
    });

    return allImagesSet.toList();
  }


  Future<void> goNextAfterUploadedPhotosData() async {

    List<String> allImages = getAllImages();

    var result = await _repository.updateListingImageUpload(
      id: createdListingId ?? '',
      body: {
        "cover_photo": coverImageUrl.value,
        "images": allImages,
        "living_room_images": categorizedImages['living_room_images'] ?? [],
        "kitchen_images": categorizedImages['kitchen_images'] ?? [],
        "bathroom_images": categorizedImages['bathroom_images'] ?? [],
        "bedroom_images": categorizedImages['bedroom_images'] ?? [],
        "washroom_images": categorizedImages['washroom_images'] ?? [],
      },
    );

    // if (!result.isSuccess) {
    //   Fluttertoast.showToast(
    //     msg: "Failed to update images",
    //     gravity: ToastGravity.TOP,
    //   );
    //   return;
    // }

    Fluttertoast.showToast(
      msg: "Images Uploaded Successfully",
      gravity: ToastGravity.TOP,
    );

    //await fetchListingDetails();
  }


  String getCurrentStep(CurrentState value) {
    switch (value) {
      case CurrentState.FIRST:
        return "0";
      case CurrentState.SECOND:
        return "1";
      case CurrentState.THIRD:
        return "2";
      case CurrentState.FOURTH:
        return "3";
      case CurrentState.FIFTH:
        return "4";
      case CurrentState.SIXTH:
        return "5";
      case CurrentState.SEVENTH:
        return "6";
      case CurrentState.EIGHTH:
        return "7";
      case CurrentState.NINTH:
        return "8";
      case CurrentState.TENTH:
        return "9";
      case CurrentState.ELEVENTH:
        return "10";
    }
  }

  void goBack() {
    switch (currentState.value) {
      case CurrentState.FIRST:
        Get.back();
        break;
      case CurrentState.SECOND:
        currentState.value = CurrentState.FIRST;
        break;
      case CurrentState.THIRD:
        currentState.value = CurrentState.SECOND;
        break;
      case CurrentState.FOURTH:
        currentState.value = CurrentState.THIRD;
        break;
      case CurrentState.FIFTH:
        currentState.value = CurrentState.FOURTH;
        break;
      case CurrentState.SIXTH:
        currentState.value = CurrentState.FIFTH;
        break;
      case CurrentState.SEVENTH:
        currentState.value = CurrentState.SIXTH;
        break;
      case CurrentState.EIGHTH:
        currentState.value = CurrentState.SEVENTH;
        break;
      case CurrentState.NINTH:
        currentState.value = CurrentState.EIGHTH;
        break;
      case CurrentState.TENTH:
        currentState.value = CurrentState.NINTH;
        break;
      case CurrentState.ELEVENTH:
        currentState.value = CurrentState.TENTH;
        break;
    }
  }

  var isLoadingNext = false.obs;

  Future<void> goNext() async {
    isLoadingNext.value = true;

    try {
      print('DEBUG goNext called, state: ${currentState.value}');
      bool canProceed = true;
      switch (currentState.value) {
        case CurrentState.FIRST:
          initListing();
          break;
        case CurrentState.SECOND:
          goNextAfterSelectingCategory();
          break;
        case CurrentState.THIRD:
          goNextAfterSelectingPlaceType();
          break;
        case CurrentState.FOURTH:
          goNextAfterSelectingPlace();
          break;
        case CurrentState.FIFTH:
          goNextAfterSelectingBasics();
          break;
        case CurrentState.SIXTH:
          goNextAfterSelectingAmenities();
          break;
        case CurrentState.SEVENTH:
          goNextAfterUploadedPhotos();
          break;
        case CurrentState.EIGHTH:
          canProceed = await goNextAfterEnteredTitle(); // 👈 Validate here
          break;
        case CurrentState.NINTH:
          goNextAfterEnteredDescription();
          break;
        case CurrentState.TENTH:
          goNextAfterEnteredPrice();
          break;
        case CurrentState.ELEVENTH:
          throw UnimplementedError();
      }

      // ✅ Move only if previous step was valid
      if (canProceed && currentState.value != CurrentState.ELEVENTH) {
        currentState.value = CurrentState.values[currentState.value.index + 1];
      }
    }catch (e, stack) {
    print('DEBUG goNext EXCEPTION: $e');
    print('DEBUG stack: $stack');
  } 
    
     finally {
      isLoadingNext.value = false;
    }
  }

  Future<void> initListing() async {
  try {
    print('DEBUG initListing called');
    var result = await _repository.createHostListing(body: {
      "title": "Untitled Listing",
    });
    print('DEBUG result: ${result.isSuccess}');
    
    // if (!result.isSuccess) {
    //   Fluttertoast.showToast(msg: "Failed to create listing");
    //   return;
    // }
    createdListingId = result.data?.uniqueId;
    await fetchCreatedListing();
    await fetchHostListingConfigurations();
    currentState(CurrentState.SECOND);
  } catch (e, stack) {
    print('DEBUG initListing EXCEPTION: $e');
    print('DEBUG stack: $stack');
  }
}

  void goNextAfterSelectingCategory() async {
    if (selectedCategory.value == null) {
      Fluttertoast.showToast(
        msg: "Please select a category",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    var result = await _repository.updateListing(
      id: createdListingId ?? '',
      body: {
        "id": createdListingId,
        "category": selectedCategory.value?.id ?? 0,
      },
    );
    if (!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update category of my_listing",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchCreatedListing();
    currentState(CurrentState.THIRD);
  }

  void goNextAfterSelectingPlaceType() async {
    if (selectedPlaceType.value == null) {
      Fluttertoast.showToast(
        msg: "Please select a place type",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    var result = await _repository.updateListing(
      id: createdListingId ?? '',
      body: {
        "id": createdListingId,
        "place_type": selectedPlaceType.value?.id ?? 0,
      },
    );
    if (!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to place type of my_listing",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchCreatedListing();
    currentState(CurrentState.FOURTH);
  }

  void goNextAfterSelectingPlace() async {
    // if (selectedPlace.value == null) {
    //   Fluttertoast.showToast(
    //     msg: "Please select a place",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //   );
    //   return;
    // }
    // var result = await _repository.updateListing(
    //   id: createdListingId ?? '',
    //   body: {
    //     "id": createdListingId,
    //     "address": selectedPlace.value?.address ?? '',
    //     "latitude": selectedPlace.value?.latitude ?? '',
    //     "longitude": selectedPlace.value?.longitude ?? '',
    //   },
    // );

   await submitLocationData(createdListingId);
   await submitLocationDataMAp(createdListingId);

    await fetchCreatedListing();
    currentState(CurrentState.FIFTH);
  }

  void goNextAfterSelectingBasics() async {
    if (selectedPlace.value == null) {
      Fluttertoast.showToast(
        msg: "Please select a place",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    var result = await _repository.updateListing(
      id: createdListingId ?? '',
      body: {
        "id": createdListingId,
        'bathroom_count': bathroomsCount.value,
        'bed_count': bedsCount.value,
        'bedroom_count': bedroomsCount.value,
        'guest_count': personsCount.value,
      },
    );
    if (!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update place location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchCreatedListing();
    currentState(CurrentState.SIXTH);
  }

  void goNextAfterSelectingAmenities() async {
    if (selectedPlace.value == null) {
      Fluttertoast.showToast(
        msg: "Please select a place",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }


    var result =   await _repository.updateListingAmenities(
      listingId: "$createdListingId",
      amenityIds: selectedAmenities,
    );

    Fluttertoast.showToast(
      msg: 'Amenities updated successfully',
      gravity: ToastGravity.TOP,
    );
    await fetchCreatedListing();
    currentState(CurrentState.SEVENTH);
  }

  void goNextAfterUploadedPhotos() async {
    if (uploadedPhotoUrls.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please upload at least one photo",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    var result = await _repository.updateListing(
      id: createdListingId ?? '',
      body: {
        "id": createdListingId,
        "cover_photo": uploadedPhotoUrls.first,
        "images": uploadedPhotoUrls.toList(),
      },
    );
    if (!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update listing photos",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchCreatedListing();
    currentState(CurrentState.EIGHTH);
  }

  Future<bool> goNextAfterEnteredTitle() async {
    if (titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter title",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return false;
    } else if (titleController.text.trim().length < 10) {
      Fluttertoast.showToast(
        msg: "Title must be at least 10 characters long",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    var result = await _repository.updateListing(
      id: createdListingId ?? '',
      body: {"id": createdListingId, "title": titleController.text.trim()},
    );

    if (!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update title",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    await fetchCreatedListing();
    return true; // ✅ success
  }

  void goNextAfterEnteredDescription() async {
    if (descriptionController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter description",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    var result = await _repository.updateListing(
      id: createdListingId ?? '',
      body: {"id": createdListingId, "description": descriptionController.text},
    );
    if (!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update description",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchCreatedListing();
    currentState(CurrentState.TENTH);
  }

  void goNextAfterEnteredPrice() async {
    if (priceController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter price",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    var result = await _repository.updateListing(
      id: createdListingId ?? '',
      body: {"id": createdListingId, "price": priceController.text},
    );
    if (!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update price",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchCreatedListing();
    currentState(CurrentState.ELEVENTH);
  }

  void onPublishClick() async {
    var result = await _repository.updateListing(
      id: createdListingId ?? '',
      body: {
        "id": createdListingId,
        "price": priceController.text,
        'status': 'published',
      },
    );
    if (!result.isSuccess) {
      Fluttertoast.showToast(
        msg: "Failed to update price",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    await fetchCreatedListing();
    Get.off(MyListingScreen());
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

      final List<String> uploadedUrls =
      List<String>.from(result.data?.urls ?? []);

      categorizedImages.update(
        category,
            (existing) => [...existing, ...uploadedUrls],
        ifAbsent: () => uploadedUrls,
      );

      categorizedImages.refresh();
      return uploadedUrls;
    } finally {
      isUploadingPhotos.value = false;
    }
  }


  /// Uploads multiple photos to the server and updates the uploadedPhotoUrls list
  /// Returns the list of uploaded photo URLs if successful, empty list otherwise
  Future<List<String>> uploadMultiplePhotos(List<String> filePaths) async {
    if (filePaths.isEmpty) return [];

    isUploadingPhotos.value = true;
    try {
      final result = await _repository.uploadMultipleDocuments(
        filePaths: filePaths,
        folder:
            'property_photos', // Using a specific folder for property photos
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

  void setCoverImage(String imageUrl, String category) {
    coverImageUrl.value = imageUrl;
    coverImageCategory.value = category;
  }
  void setCategoryImages(String category, List<String> urls) {
    categorizedImages[category] = urls;
    categorizedImages.refresh();
  }
  /// Removes a photo from the uploadedPhotoUrls list at the specified index
  void removePhoto(int index) {
    if (index >= 0 && index < uploadedPhotoUrls.length) {
      uploadedPhotoUrls.removeAt(index);
    }
  }

  // Optional: example method to post a booking (requires your repo to have this)

  Future<booking_model.BookingData?> createBooking(
    BookingPostModel booking,
  ) async {
    final result = await _repository.postBooking(booking);

    return result.fold(
      (error) {
        Get.snackbar("Booking Failed", error);
        return null;
      },
      (booking_model.BookingResponseModel responseModel) {
        return responseModel.data;
      },
    );
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

  Future<List<PlaceSuggestion>> onPlaceSearchChange(String query) async {
    isHostListingLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    if (query.isEmpty) {
      return [];
    }

    // try {
    final response = await _repository.getMapSuggestions(place: query);

    // listings.value = response.data;

    suggestions.value = response.data is List ? response.data ?? [] : [];

    return suggestions.toList();
  }

  Future<List<SectionModel>> onSectionSearchChange(String query) async {
    isHostListingLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    if (query.isEmpty) {
      suggestionsNew.clear();
      return [];
    }

    try {
      final SectionResponse response =
      await _repository.getSectionSuggestions(query: query);

      print("Okay this is keyword search response ${response.data}");
      
      suggestionsNew.value = response.data;

      return response.data;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      return [];
    } finally {
      isHostListingLoading.value = false;
    }
  }



  final isInitialLoad = true.obs;

  Future<CalendarResponse?> getListingCalendar({
    required int listingId,
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
        calendarResponse.value = response;
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
  if (calenderViewController.hasClients) {
    calenderViewController.animateTo(
      DateTime.now().month *
          (calenderViewController.position.maxScrollExtent / 12),
      duration: Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }
});
    }
  }

  Future<CalendarPostResponse?> submitListingCalendar({
    required int listingId,
    required List<BookingPayload> bookingList,
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
        final responseModel = CalendarPostResponse.fromJson(data);
        // Get.snackbar("Success", responseModel.message);
        return responseModel;
      },
    );
  }

  RxList<int> selectedAmenityIds = <int>[].obs;

  //RxList<int> selectedAmenityIds = <int>[].obs;

  void toggleAmenity(int id) {
    if (selectedAmenityIds.contains(id)) {
      selectedAmenityIds.remove(id);
    } else {
      selectedAmenityIds.add(id);
    }
  }



  var lat = 0.0.obs;
  var long = 0.0.obs;

  // Get current location
  var isFetchingLocation = false.obs;

  Future<void> getCurrentLocation() async {
    isFetchingLocation.value = true; // Start loader

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) {
      //   Get.snackbar(
      //     "GPS is Turned Off",
      //     "Please turn on your location services to continue",
      //     icon: const Icon(Icons.location_off, color: Colors.white),
      //     backgroundColor: const Color(0xFFF15927), // Your brand orange color
      //     colorText: Colors.white,
      //     snackPosition: SnackPosition.BOTTOM,
      //     duration: const Duration(seconds: 4),
      //     margin: const EdgeInsets.all(16),
      //     borderRadius: 12,
      //     isDismissible: true,
      //     forwardAnimationCurve: Curves.easeOut,
      //     reverseAnimationCurve: Curves.easeIn,
      //   );
      //   return;
      // }

      if (!serviceEnabled) {
        Get.snackbar(
          "Location Services Disabled",
          "Please enable GPS / Location to use this feature",
          icon: const Icon(Icons.location_off_rounded, color: Colors.white, size: 28),
          backgroundColor: const Color(0xFFF15927),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          borderRadius: 12,
          mainButton: TextButton(
            onPressed: () async {
              Get.back(); // close snackbar
              await Geolocator.openLocationSettings();
            },
            child: const Text(
              "Open Settings",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorDisplay.showError('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorDisplay.showError('Location permission permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      lat.value = position.latitude;
      long.value = position.longitude;

      String locationName = 'Current Location';
      try {
        List<Placemark> placemarks =
        await placemarkFromCoordinates(lat.value, long.value);
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          locationName =
              '${placemark.name ?? ''}, ${placemark.locality ?? ''}'.trim();
        }
      } catch (e) {
      }

      selectedSection.value = SectionModel(
        displayName: locationName,
        lat: lat.value,
        long: long.value,
      );
    } finally {
      isFetchingLocation.value = false; // Stop loader
    }
  }

  final propertyCtrl = TextEditingController();
  final flatCtrl = TextEditingController();
  final divisionCtrl = TextEditingController();
  final districtCtrl = TextEditingController();
  final areaSearchCtrl = TextEditingController();
  final subDistrictCtrl = TextEditingController();
  final zipCtrl = TextEditingController();

  final selectedCountry = ''.obs;

  final latitude = ''.obs;
  final longitude = ''.obs;
  final address = ''.obs;

  /// Map Location Methods

  void setMapLocation({
    required String lat,
    required String lng,
    required String addressText,
  }) {
    latitude.value = lat;
    longitude.value = lng;
    address.value = addressText;
  }

  bool get hasMapLocation =>
      latitude.value.isNotEmpty && longitude.value.isNotEmpty;

  bool validateForm() {
    return
        propertyCtrl.text.isNotEmpty &&
        selectedCountry.value.isNotEmpty &&
        flatCtrl.text.isNotEmpty &&
        areaSearchCtrl.text.isNotEmpty &&
        divisionCtrl.text.isNotEmpty &&
        districtCtrl.text.isNotEmpty &&
        subDistrictCtrl.text.isNotEmpty &&
        zipCtrl.text.isNotEmpty;
  }


  Timer? _debounce;

  /// COUNTRY LIST
  final countries = <String>[
    'Bangladesh',
    'India',
    'USA',
    'UK',
    'Canada',
    'Australia',
    'Germany',
    'France'
  ].obs;

  void onAreaSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (value.trim().length >= 2) {
        searchAreas(value);
      } else {
        areas.clear();
      }
    });
  }

  Future<void> searchAreas(String searchText) async {
    isLoading.value = true;
    try {
      final response = await _repository.searchAreas(searchText);
      areas.value = response.data ?? [];
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void selectArea(AreaModel area) {
    areaSearchCtrl.text = area.area ?? '';
    // When selecting from area search, also update the dropdown selections if valid
    if (area.division != null && bangladeshLocationData.containsKey(area.division)) {
      onDivisionChanged(area.division);
      if (area.district != null && 
          bangladeshLocationData[area.division]?.containsKey(area.district) == true) {
        onDistrictChanged(area.district);
        if (area.thana != null && 
            bangladeshLocationData[area.division]?[area.district]?.contains(area.thana) == true) {
          onSubDistrictChanged(area.thana);
        }
      }
    } else {
      divisionCtrl.text = area.division ?? '';
      districtCtrl.text = area.district ?? '';
      subDistrictCtrl.text = area.thana ?? '';
    }
    areas.clear();
  }


  Map<String, dynamic> buildLocationJson() {
      final json = {
    "apartment_name": propertyCtrl.text.trim(),
    // "property_name": propertyCtrl.text.trim(),
    "property_name": "",
    "country": selectedCountry.value,
    "apartment_no": flatCtrl.text.trim(),
    "division": selectedDivision.value.isNotEmpty ? selectedDivision.value : divisionCtrl.text.trim(),
    "district": selectedDistrict.value.isNotEmpty ? selectedDistrict.value : districtCtrl.text.trim(),
    "thana": selectedSubDistrict.value.isNotEmpty ? selectedSubDistrict.value : subDistrictCtrl.text.trim(),
    "area": areaSearchCtrl.text.trim(),
  };

  print("📦 buildLocationJson: $json"); // 👈 ADD HERE

  return json;
  }
  RxBool isSubmittingLocation = false.obs;
  Future<bool> submitLocationData(String? uniqId) async {
  if (isSubmittingLocation.value) return false;

  try {
    isSubmittingLocation.value = true;

      // ✅ Add these prints
    print('DEBUG submitLocationData latitude: ${latitude.value}');
    print('DEBUG submitLocationData longitude: ${longitude.value}');
    print('DEBUG submitLocationData address: ${address.value}');
    print('DEBUG submitLocationData area: ${areaSearchCtrl.text.trim()}');

    // ✅ Use updateListing instead of updateListingLocation
    final result = await _repository.updateListing(
      id: uniqId ?? createdListingId ?? '',
      body: {
        "apartment_name": propertyCtrl.text.trim(),
        "property_name": "",
        "country": selectedCountry.value,
        "apartment_no": flatCtrl.text.trim(),
        "division": selectedDivision.value.isNotEmpty ? selectedDivision.value : divisionCtrl.text.trim(),
        "district": selectedDistrict.value.isNotEmpty ? selectedDistrict.value : districtCtrl.text.trim(),
        "thana": selectedSubDistrict.value.isNotEmpty ? selectedSubDistrict.value : subDistrictCtrl.text.trim(),
        "area": areaSearchCtrl.text.trim(),
        "address": areaSearchCtrl.text.trim(), // ✅ address = area
        "latitude": latitude.value,   // ✅ added
        "longitude": longitude.value, // ✅ added
      },
    );

    print('DEBUG submitLocationData success: ${result.isSuccess}');

    if (result.isSuccess) {
      return true;
    } else {
      Fluttertoast.showToast(
        msg: "Failed to update location",
        gravity: ToastGravity.TOP,
      );
      return false;
    }
  } catch (e) {
    print('DEBUG submitLocationData ERROR: $e');
    return false;
  } finally {
    isSubmittingLocation.value = false;
  }
}
//  Future<bool> submitLocationData(String? uniqId) async {
//   if (isSubmittingLocation.value) return false;

//   try {
//     isSubmittingLocation.value = true;

//     final result = await _repository.updateListingLocation(
//       listingId: uniqId ?? createdListingId ?? '',
//       body: buildLocationJson(),
//     );

//     if (result.isSuccess) {
      
//       // 👇 ADD THIS — override address with just area value
//       await _repository.updateListing(
//         id: uniqId ?? createdListingId ?? '',
//         body: {
//           "address": areaSearchCtrl.text.trim(),
//         },
//       );
      
//       print("✅ Address overridden with area: ${areaSearchCtrl.text.trim()}");
      
//       return true;
//     } else {
//       Fluttertoast.showToast(
//         msg: "Failed to update location",
//         gravity: ToastGravity.TOP,
//       );
//       return false;
//     }
//   } finally {
//     isSubmittingLocation.value = false;
//   }
// }


  Map<String, dynamic> buildLocationJsonForMAp() {
    return {
      "longitude": longitude.value,
      "latitude": latitude.value,
      "address": address.value,
    };
  }

  RxBool isLocationSubmitting = false.obs;
 Future<bool> submitLocationDataMAp(String? uniqId) async {
  if (isLocationSubmitting.value) return false;

  try {
    isLocationSubmitting.value = true;

    final result = await _repository.updateListing(
      id: uniqId ?? createdListingId ?? '',
      body: {
        "address": address.value,
        "latitude": latitude.value,
        "longitude": longitude.value,
      },
    );

    print('DEBUG submitLocationDataMAp success: ${result.isSuccess}');
    return result.isSuccess;
  } catch (e) {
    print('DEBUG submitLocationDataMAp ERROR: $e');
    return false;
  } finally {
    isLocationSubmitting.value = false;
  }
}


  final isLoadingAddress = false.obs;
  final Rxn<AddressData> listingAddress = Rxn<AddressData>();

  Future<void> fetchListingAddress(String listingId) async {
    isLoadingAddress.value = true;

    try {
      final addressData = await _repository.getListingAddress(
        listingId: listingId,
      );

      listingAddress.value = addressData;

      // ✅ Replace with this
print("📍 RAW Address Data: $addressData");// 👈 ADD HERE

      // 👇 IMPORTANT
      applyFetchedAddressToForm();

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoadingAddress.value = false;
    }
  }
  void applyFetchedAddressToForm() {
    final data = listingAddress.value;
    if (data == null) return;

  print("🏠 Applying Address to Form:");       // 👈 ADD HERE
  print("   apartmentName : ${data.apartmentName}");
  print("   propertyName  : ${data.propertyName}");
  print("   apartmentNo   : ${data.apartmentNo}");
  print("   area          : ${data.area}");
  print("   division      : ${data.division}");
  print("   district      : ${data.district}");
  print("   thana         : ${data.thana}");
  print("   zipCode       : ${data.zipCode}");
  print("   country       : ${data.country}");
  print("   address       : ${data.address}");


    // Text fields
    propertyCtrl.text = data.apartmentName ?? '';
    propertyCtrl.text = data.propertyName ?? '';
    flatCtrl.text = data.apartmentNo ?? '';
    areaSearchCtrl.text = data.area;
    zipCtrl.text = data.zipCode ?? '';
    selectedCountry.value = data.country ?? '';
    
    // Set dropdown values for Bangladesh locations
    if (data.division != null && bangladeshLocationData.containsKey(data.division)) {
      selectedDivision.value = data.division!;
      divisionCtrl.text = data.division!;
      
      if (data.district != null && 
          bangladeshLocationData[data.division]?.containsKey(data.district) == true) {
        selectedDistrict.value = data.district!;
        districtCtrl.text = data.district!;
        
        if (data.thana != null && 
            bangladeshLocationData[data.division]?[data.district]?.contains(data.thana) == true) {
          selectedSubDistrict.value = data.thana!;
          subDistrictCtrl.text = data.thana!;
        } else {
          selectedSubDistrict.value = '';
          subDistrictCtrl.text = data.thana ?? '';
        }
      } else {
        selectedDistrict.value = '';
        selectedSubDistrict.value = '';
        districtCtrl.text = data.district ?? '';
        subDistrictCtrl.text = data.thana ?? '';
      }
    } else {
      // Non-Bangladesh data or unknown division
      selectedDivision.value = '';
      selectedDistrict.value = '';
      selectedSubDistrict.value = '';
      divisionCtrl.text = data.division;
      districtCtrl.text = data.district;
      subDistrictCtrl.text = data.thana;
    }
    
    // Address string
    address.value = data.address;

    // Lat / Long

  }

  /// API-based location data (replaces local data)
  final apiDivisions = <DivisionModel>[].obs;
  final isDivisionThanaLoading = false.obs;
  final isDivisionThanaError = false.obs;
  final hasFetchedDivisionData = false.obs;

  /// BANGLADESH LOCATION DATA - Divisions, Districts, and Sub-districts (Thana)
  final bangladeshLocationData = <String, Map<String, List<String>>> {
    'Dhaka': {
      'Dhaka': ['Dhanmondi', 'Gulshan', 'Mohammadpur', 'Mirpur', 'Uttara', 'Tejgaon', 'Motijheel', 'Paltan', 'Savar', 'Dohar', 'Keraniganj', 'Nawabganj', 'Kadamtali', 'Kamrangirchar', 'Lalbagh', 'Shah Ali', 'Turag', 'Badda', 'Cantonment', 'Demra', 'Gendaria', 'Hazaribagh', 'Jatrabari', 'Khilgaon', 'Khilkhet', 'Mohakhali', 'New Market', 'Ramna', 'Sabujbagh', 'Shahbagh', 'Sher-e-Bangla Nagar', 'Sutrapur', 'Wari'],
      'Gazipur': ['Gazipur Sadar', 'Kaliakair', 'Kapasia', 'Sreepur', 'Kaliganj', 'Tongi'],
      'Narayanganj': ['Narayanganj Sadar', 'Bandar', 'Araihazar', 'Sonargaon', 'Rupganj', 'Siddhirganj'],
      'Tangail': ['Tangail Sadar', 'Sakhipur', 'Basail', 'Kalihati', 'Ghatail', 'Madhupur', 'Mirzapur', 'Dhanbari', 'Nagarpur', 'Delduar'],
      'Faridpur': ['Faridpur Sadar', 'Boalmari', 'Alfadanga', 'Charbhadrasan', 'Madhukhali', 'Bhanga', 'Nagarkanda', 'Sadarpur', 'Shaltha'],
      'Gopalganj': ['Gopalganj Sadar', 'Kashiani', 'Kotalipara', 'Muksudpur', 'Tungipara'],
      'Kishoreganj': ['Kishoreganj Sadar', 'Karimganj', 'Tarail', 'Hossainpur', 'Pakundia', 'Katiadi', 'Bajitpur', 'Bhairab', 'Itna', 'Mithamain', 'Ashtagram', 'Nikli', 'Kuliarchar'],
      'Madaripur': ['Madaripur Sadar', 'Kalkini', 'Rajoir', 'Shibchar'],
      'Manikganj': ['Manikganj Sadar', 'Singair', 'Shivalaya', 'Saturia', 'Harirampur', 'Ghior', 'Daulatpur'],
      'Munshiganj': ['Munshiganj Sadar', 'Sreenagar', 'Sirajdikhan', 'Lohajang', 'Gazaria', 'Tongibari'],
      'Rajbari': ['Rajbari Sadar', 'Baliakandi', 'Goalanda', 'Pangsha', 'Kalukhali'],
      'Shariatpur': ['Shariatpur Sadar', 'Zanjira', 'Naria', 'Gosairhat', 'Bhedarganj', 'Damudya'],
      'Narsingdi': ['Narsingdi Sadar', 'Belabo', 'Monohardi', 'Palash', 'Raipura', 'Shibpur'],
    },
    'Chattogram': {
      'Chattogram': ['Chattogram Sadar', 'Anwara', 'Banshkhali', 'Boalkhali', 'Chandanaish', 'Fatikchhari', 'Hathazari', 'Lohagara', 'Mirsharai', 'Patiya', 'Rangunia', 'Raozan', 'Sandwip', 'Satkania', 'Sitakunda', 'Bhatiari', 'Halishahar', 'Pahartali', 'Panchlaish', 'Khulshi', 'Akbarshah', 'Bakolia', 'Bayazid', 'Chandgaon', 'Double Mooring', 'EPZ', 'Kotwali'],
      'Bandarban': ['Bandarban Sadar', 'Thanchi', 'Ruma', 'Rowangchhari', 'Lama', 'Naikhongchhari', 'Ali Kadam'],
      'Brahmanbaria': ['Brahmanbaria Sadar', 'Ashuganj', 'Bancharampur', 'Bijoynagar', 'Kasba', 'Nabinagar', 'Nasirnagar', 'Sarail', 'Akhaura'],
      'Chandpur': ['Chandpur Sadar', 'Haimchar', 'Haziganj', 'Kachua', 'Matlab North', 'Matlab South', 'Shahrasti', 'Faridganj'],
      "Cox's Bazar": ["Cox's Bazar Sadar", 'Chakaria', 'Kutubdia', 'Maheshkhali', 'Pekua', 'Ramu', 'Teknaf', 'Ukhia', 'Eidgaon'],
      'Cumilla': ['Cumilla Sadar', 'Barura', 'Brahmanpara', 'Burichang', 'Chandina', 'Chauddagram', 'Daudkandi', 'Debidwar', 'Homna', 'Laksam', 'Lalmai', 'Muradnagar', 'Nangalkot', 'Titas', 'Monohorganj', 'Meghna'],
      'Feni': ['Feni Sadar', 'Chhagalnaiya', 'Daganbhuiyan', 'Parshuram', 'Sonagazi', 'Fulgazi'],
      'Khagrachhari': ['Khagrachhari Sadar', 'Dighinala', 'Lakshmichhari', 'Mahalchhari', 'Manikchhari', 'Matiranga', 'Panchhari', 'Ramgarh', 'Guimara'],
      'Lakshmipur': ['Lakshmipur Sadar', 'Raipur', 'Ramganj', 'Ramgati', 'Kamalnagar'],
      'Noakhali': ['Noakhali Sadar', 'Begumganj', 'Chatkhil', 'Companiganj', 'Hatiya', 'Senbagh', 'Sonaimuri', 'Subarnachar', 'Kabirhat'],
      'Rangamati': ['Rangamati Sadar', 'Baghaichhari', 'Barkal', 'Belaichhari', 'Juraichhari', 'Kaptai', 'Kawkhali', 'Langadu', 'Naniarchar', 'Rajasthali'],
    },
    'Rajshahi': {
      'Rajshahi': ['Rajshahi Sadar', 'Bagha', 'Bagmara', 'Charghat', 'Durgapur', 'Godagari', 'Mohanpur', 'Paba', 'Puthia', 'Tanore', 'Boalia', 'Rajpara', 'Shah Makhdum'],
      'Bogra': ['Bogra Sadar', 'Adamdighi', 'Dhunat', 'Dupchanchia', 'Gabtali', 'Kahaloo', 'Nandigram', 'Sariakandi', 'Shajahanpur', 'Sherpur', 'Shibganj', 'Sonatola'],
      'Chapainawabganj': ['Chapainawabganj Sadar', 'Bholahat', 'Gomastapur', 'Nachole', 'Shibganj'],
      'Joypurhat': ['Joypurhat Sadar', 'Akkelpur', 'Kalai', 'Khetlal', 'Panchbibi'],
      'Naogaon': ['Naogaon Sadar', 'Atrai', 'Badalgachi', 'Dhamoirhat', 'Manda', 'Mohadevpur', 'Niamatpur', 'Patnitala', 'Porsha', 'Raninagar', 'Sapahar'],
      'Natore': ['Natore Sadar', 'Bagatipara', 'Baraigram', 'Gurudaspur', 'Lalpur', 'Singra', 'Naldanga'],
      'Pabna': ['Pabna Sadar', 'Atgharia', 'Bera', 'Bhangura', 'Chatmohar', 'Faridpur', 'Ishwardi', 'Santhia', 'Sujanagar'],
      'Sirajganj': ['Sirajganj Sadar', 'Belkuchi', 'Chauhali', 'Kamarkhanda', 'Kazipur', 'Raiganj', 'Shahjadpur', 'Tarash', 'Ullahpara'],
    },
    'Khulna': {
      'Khulna': ['Khulna Sadar', 'Batiaghata', 'Dacope', 'Dumuria', 'Dighalia', 'Koyra', 'Paikgacha', 'Phultala', 'Rupsa', 'Terokhada', 'Sonadanga', 'Khalishpur', 'Daulatpur', 'Harintana', 'Labanchara', 'Boyra'],
      'Bagerhat': ['Bagerhat Sadar', 'Chitalmari', 'Fakirhat', 'Kachua', 'Mollahat', 'Mongla', 'Morrelganj', 'Rampal', 'Sarankhola'],
      'Chuadanga': ['Chuadanga Sadar', 'Alamdanga', 'Damurhuda', 'Jibannagar'],
      'Jessore': ['Jessore Sadar', 'Abhaynagar', 'Bagherpara', 'Chaugachha', 'Jhikargacha', 'Keshabpur', 'Manirampur', 'Sharsha'],
      'Jhenaidah': ['Jhenaidah Sadar', 'Harinakunda', 'Kaliganj', 'Kotchandpur', 'Maheshpur', 'Shailkupa'],
      'Kushtia': ['Kushtia Sadar', 'Bheramara', 'Daulatpur', 'Khoksa', 'Kumarkhali', 'Mirpur'],
      'Magura': ['Magura Sadar', 'Mohammadpur', 'Shalikha', 'Sreepur'],
      'Meherpur': ['Meherpur Sadar', 'Gangni', 'Mujibnagar'],
      'Narail': ['Narail Sadar', 'Kalia', 'Lohagara'],
      'Satkhira': ['Satkhira Sadar', 'Assasuni', 'Debhata', 'Kalaroa', 'Kaliganj', 'Shyamnagar', 'Tala'],
    },
    'Barishal': {
      'Barishal': ['Barishal Sadar', 'Agailjhara', 'Babuganj', 'Bakerganj', 'Banaripara', 'Gaurnadi', 'Hizla', 'Mehendiganj', 'Muladi', 'Wazirpur', 'Airport', 'Kawnia', 'Charmonai'],
      'Barguna': ['Barguna Sadar', 'Amtali', 'Bamna', 'Betagi', 'Patharghata', 'Taltali'],
      'Bhola': ['Bhola Sadar', 'Burhanuddin', 'Char Fasson', 'Daulatkhan', 'Lalmohan', 'Manpura', 'Tazumuddin'],
      'Jhalokati': ['Jhalokati Sadar', 'Kathalia', 'Nalchity', 'Rajapur'],
      'Patuakhali': ['Patuakhali Sadar', 'Bauphal', 'Dashmina', 'Dumki', 'Galachipa', 'Kalapara', 'Mirzaganj', 'Rangabali'],
      'Pirojpur': ['Pirojpur Sadar', 'Bhandaria', 'Kawkhali', 'Mathbaria', 'Nazirpur', 'Nesarabad', 'Indurkani'],
    },
    'Sylhet': {
      'Sylhet': ['Sylhet Sadar', 'Beanibazar', 'Bishwanath', 'Companiganj', 'Fenchuganj', 'Golapganj', 'Gowainghat', 'Jaintiapur', 'Kanaighat', 'Osmaninagar', 'Zakiganj', 'Moglabazar', 'Shahporan', 'Jalalabad'],
      'Habiganj': ['Habiganj Sadar', 'Ajmiriganj', 'Bahubal', 'Baniachang', 'Chunarughat', 'Lakhai', 'Madhabpur', 'Nabiganj', 'Shaistaganj'],
      'Moulvibazar': ['Moulvibazar Sadar', 'Barlekha', 'Juri', 'Kamalganj', 'Kulaura', 'Rajnagar', 'Sreemangal'],
      'Sunamganj': ['Sunamganj Sadar', 'Bishwambarpur', 'Chhatak', 'Derai', 'Dharamapasha', 'Dowarabazar', 'Jamalganj', 'Jagannathpur', 'Sullah', 'Tahirpur', 'South Sunamganj', 'Shantiganj'],
    },
    'Rangpur': {
      'Rangpur': ['Rangpur Sadar', 'Badarganj', 'Gangachara', 'Kaunia', 'Mithapukur', 'Pirgachha', 'Pirganj', 'Taraganj', 'Haragachh', 'Mahiganj'],
      'Dinajpur': ['Dinajpur Sadar', 'Birampur', 'Birganj', 'Bochaganj', 'Chirirbandar', 'Fulbari', 'Ghoraghat', 'Hakimpur', 'Kaharole', 'Khansama', 'Nawabganj', 'Parbatipur'],
      'Gaibandha': ['Gaibandha Sadar', 'Fulchhari', 'Gobindaganj', 'Palashbari', 'Sadullapur', 'Saghata', 'Sundarganj'],
      'Kurigram': ['Kurigram Sadar', 'Bhurungamari', 'Char Rajibpur', 'Chilmari', 'Phulbari', 'Nageshwari', 'Rajarhat', 'Raumari', 'Ulipur'],
      'Lalmonirhat': ['Lalmonirhat Sadar', 'Aditmari', 'Hatibandha', 'Kaliganj', 'Patgram'],
      'Nilphamari': ['Nilphamari Sadar', 'Dimla', 'Domar', 'Jaldhaka', 'Kishoreganj', 'Saidpur'],
      'Panchagarh': ['Panchagarh Sadar', 'Atwari', 'Boda', 'Debiganj', 'Tetulia'],
      'Thakurgaon': ['Thakurgaon Sadar', 'Baliadangi', 'Haripur', 'Pirganj', 'Ranisankail'],
    },
    'Mymensingh': {
      'Mymensingh': ['Mymensingh Sadar', 'Trishal', 'Bhaluka', 'Muktagacha', 'Phulpur', 'Fulbaria', 'Gaffargaon', 'Gauripur', 'Haluaghat', 'Ishwarganj', 'Nandail', 'Dhobaura', 'Boruadanga', 'Kewatkhali', 'Akua', 'Biddyaganj'],
      'Jamalpur': ['Jamalpur Sadar', 'Dewanganj', 'Baksiganj', 'Islampur', 'Madarganj', 'Melandaha', 'Sarishabari'],
      'Netrokona': ['Netrokona Sadar', 'Barhatta', 'Atpara', 'Khaliajuri', 'Kalmakanda', 'Durgapur', 'Purbadhala', 'Mohanganj', 'Madan'],
      'Sherpur': ['Sherpur Sadar', 'Nalitabari', 'Sreebardi', 'Jhenaigati', 'Nakla'],
    },
  };

  /// Observable variables for cascading location dropdowns
  final selectedDivision = ''.obs;
  final selectedDistrict = ''.obs;
  final selectedSubDistrict = ''.obs;

  /// Get available districts based on selected division
  List<String> get availableDistricts {
    if (selectedDivision.value.isEmpty) return [];
    return bangladeshLocationData[selectedDivision.value]?.keys.toList() ?? [];
  }

  /// Get available sub-districts (thanas) based on selected division and district
  List<String> get availableSubDistricts {
    if (selectedDivision.value.isEmpty || selectedDistrict.value.isEmpty) return [];
    return bangladeshLocationData[selectedDivision.value]?[selectedDistrict.value] ?? [];
  }

  /// Get list of all divisions
  List<String> get allDivisions => bangladeshLocationData.keys.toList();

  /// API-BASED GETTERS - Use these for dropdowns when using API data

  /// Get all division names from API data
  List<String> get apiAllDivisions {
    return apiDivisions.map((d) => d.divisionName).toSet().toList();
  }

  /// Get available districts from API based on selected division
  List<String> get apiAvailableDistricts {
    if (selectedDivision.value.isEmpty) return [];
    final division = apiDivisions.firstWhereOrNull(
      (d) => d.divisionName == selectedDivision.value,
    );
    return division?.districts.map((d) => d.districtName).toSet().toList() ?? [];
  }

  /// Get available sub-districts (thanas) from API based on selected division and district
  List<String> get apiAvailableSubDistricts {
    if (selectedDivision.value.isEmpty || selectedDistrict.value.isEmpty) return [];
    final division = apiDivisions.firstWhereOrNull(
      (d) => d.divisionName == selectedDivision.value,
    );
    final district = division?.districts.firstWhereOrNull(
      (d) => d.districtName == selectedDistrict.value,
    );
    return district?.thanas.map((t) => t.thanaName).toSet().toList() ?? [];
  }

  /// Reset cascading selections when division changes
  void onDivisionChanged(String? division) {
    selectedDivision.value = division ?? '';
    selectedDistrict.value = '';
    selectedSubDistrict.value = '';
    divisionCtrl.text = division ?? '';
    districtCtrl.text = '';
    subDistrictCtrl.text = '';
  }

  /// Reset sub-district when district changes
  void onDistrictChanged(String? district) {
    selectedDistrict.value = district ?? '';
    selectedSubDistrict.value = '';
    districtCtrl.text = district ?? '';
    subDistrictCtrl.text = '';
  }

  /// Set sub-district when changed
  void onSubDistrictChanged(String? subDistrict) {
    selectedSubDistrict.value = subDistrict ?? '';
    subDistrictCtrl.text = subDistrict ?? '';
  }

  /// Fetch division/district/thana data from API
  /// Call this when AddManualLocationScreen loads - uses cached data if available
  Future<void> fetchDivisionThanaData() async {
    // Return cached data if already fetched
    if (hasFetchedDivisionData.value && apiDivisions.isNotEmpty) {
      return;
    }

    isDivisionThanaLoading.value = true;
    isDivisionThanaError.value = false;
    try {
      final response = await _repository.searchDivisionThana();
      apiDivisions.value = response.data;
      hasFetchedDivisionData.value = true;
    } catch (_) {
      isDivisionThanaError.value = true;
    } finally {
      isDivisionThanaLoading.value = false;
    }
  }

  /// Legacy method - kept for backward compatibility
  Future<void> searchDivisionThana(String searchText) async {
    await fetchDivisionThanaData();
  }

  Future<bool> updateMapLocation(String? uniqId) async {
  if (latitude.value.isEmpty || longitude.value.isEmpty) return false;

  print('DEBUG updateMapLocation called');
  print('DEBUG lat: ${latitude.value}, lng: ${longitude.value}, address: ${address.value}');

  final result = await _repository.updateListing(
    id: uniqId ?? createdListingId ?? '',
    body: {
      "address": address.value,
      "latitude": latitude.value,
      "longitude": longitude.value,
    },
  );

  print('DEBUG updateMapLocation success: ${result.isSuccess}');
  return result.isSuccess;
}


}
