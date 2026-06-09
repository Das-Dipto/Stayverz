// Using a prefix to avoid conflict with MetaData
import 'package:flutter/material.dart' as material;
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/public_listings/data/models/listing_details_model.dart';
import 'package:stayverz_flutter_app/features/public_listings/data/models/listing_filter_config_model.dart';
import 'package:stayverz_flutter_app/features/public_listings/data/models/public_listing_model.dart';
import 'package:stayverz_flutter_app/features/public_listings/domain/repositories/listing_filter_config_repository.dart';
import 'package:stayverz_flutter_app/features/public_listings/data/repositories/public_listings_repository.dart';

import '../../../assistance_service/models/assistance_categories_response.dart';
import '../../../assistance_service/repositories/assistance_service_repository_interface.dart';
import '../../../listing/models/aminities_new_model.dart';
import '../../data/models/category_listing.dart';
import '../../data/models/district_wise_model.dart';
import '../../data/models/lat_long_get_model.dart';
import '../../data/models/message_id_get_modeldata.dart';
import '../../data/models/new_search_modle.dart';

// Alias to avoid conflict with Flutter's MetaData
typedef ListingMetaData = MetaData;

class PublicListingsController extends GetxController {
  final PublicListingsRepository _repository;
  final ListingFilterConfigRepository _filterConfigRepository;
  final Rxn<DistrictWideLatLong> selectedSubDistrict = Rxn<DistrictWideLatLong>();
  Rx<int> selectedReportType = Rx<int>(0);
  RxList<AssistanceCategory> assistanceCategories = RxList<AssistanceCategory>();
  Rx<AssistanceCategory?> selectedAssistanceCategory = Rx<AssistanceCategory?>(null);
  final RxBool isCategoryLoading = false.obs;
  final RxString errorMessageg = ''.obs;
  RxBool showAllAmenities = false.obs;
  // Constructor with dependency injection
  PublicListingsController(this._repository, this._filterConfigRepository);
  final adults = 0.obs;
  final children = 0.obs;
  final infants = 0.obs;

  /// MAX constraints
  final int maxGuests = 50;
  final int maxInfants = 10; // optional (set if you want to limit infants)

  int get totalGuests => adults.value + children.value;

  /// --- Adults ---
  bool get isAdultsIncrementDisabled => adults.value >= maxGuests;

  Future<void> fetchAssistanceCategory() async {
    isCategoryLoading.value = true;
    hasErrorg.value = false;
    errorMessageg.value = '';

    try {
      AssistanceServiceRepositoryInterface assistanceRepo = Get.find<AssistanceServiceRepositoryInterface>();
      AssistanceCategoriesResponse response = await assistanceRepo.getAssistanceCategory();
      assistanceCategories.value = response.data ?? [];
    } catch (e) {
      hasErrorg.value = true;
      errorMessageg.value = e.toString();
    } finally {
      isCategoryLoading.value = false;
    }
  }

  void incrementAdults() {
    if (!isAdultsIncrementDisabled) {
      adults.value++;
    }
  }

  void decrementAdults() {
    if (adults.value > 0) {
      adults.value--;
    }
  }

  /// --- Children ---
  bool get isChildrenIncrementDisabled => totalGuests >= maxGuests;

  void incrementChildren() {
    if (!isChildrenIncrementDisabled) {
      children.value++;
    }
  }

  void decrementChildren() {
    if (children.value > 0) {
      children.value--;
    }
  }

  /// --- Infants ---
  bool get isInfantsIncrementDisabled => infants.value >= maxInfants;

  void incrementInfants() {
    if (!isInfantsIncrementDisabled) {
      infants.value++;
    }
  }

  void decrementInfants() {
    if (infants.value > 0) {
      infants.value--;
    }
  }

  RxString selectedDivision = ''.obs;
  RxString selectedDistrict = ''.obs;
  RxList<String> districts = <String>[].obs;
  Map<String, List<String>> divisionDistrictMap = {
    'Dhaka': [
      'Dhaka',
      'Gazipur',
      'Kishoreganj',
      'Manikganj',
      'Munshiganj',
      'Narayanganj',
      'Narsingdi',
      'Tangail',
    ],
    'Chattogram': [
      'Chattogram',
      'Coxs Bazar',
      'Cumilla',
      'Feni',
      'Khagrachari',
      'Lakshmipur',
      'Noakhali',
      'Rangamati',
    ],
    'Rajshahi': [
      'Bogura',
      'Joypurhat',
      'Naogaon',
      'Natore',
      'Chapainawabganj',
      'Pabna',
      'Rajshahi',
      'Sirajganj',
    ],
    'Khulna': [
      'Bagerhat',
      'Chuadanga',
      'Jashore',
      'Jhenaidah',
      'Khulna',
      'Kushtia',
      'Magura',
      'Meherpur',
      'Narail',
      'Satkhira',
    ],
    'Barishal': [
      'Barguna',
      'Barishal',
      'Bhola',
      'Jhalokathi',
      'Patuakhali',
      'Pirojpur',
    ],
    'Sylhet': ['Habiganj', 'Moulvibazar', 'Sunamganj', 'Sylhet'],
    'Rangpur': [
      'Dinajpur',
      'Gaibandha',
      'Kurigram',
      'Lalmonirhat',
      'Nilphamari',
      'Panchagarh',
      'Rangpur',
      'Thakurgaon',
    ],
    'Mymensingh': ['Jamalpur', 'Mymensingh', 'Netrokona', 'Sherpur'],
  };

  void setDivision(String division) {
    selectedDivision.value = division;
    selectedDistrict.value = '';
    districts.value = divisionDistrictMap[division] ?? [];
  }

  void setDistrict(String district) {
    selectedDistrict.value = district;
  }

  // Observable states
  final isLoading = false.obs;
  final isLoadingg = false.obs;
  final isLoadinggc = false.obs;
  final isLoadingFilters = false.obs;
  final hasError = false.obs;
  final hasListingDetailsError = false.obs;
  final hasErrore = false.obs;
  final hasErrorec = false.obs;
  final hasErrorg = false.obs;
  final hasErrorgc = false.obs;
  final errorMessage = ''.obs;
  final errorMessagec = ''.obs;
  final errorMessagee = ''.obs;
  final errorMessageec = ''.obs;
  final listings = <PublicListingModel>[].obs;
  final listingDetails = ListingDetailsModel().obs;
  final metaData = Rx<ListingMetaData?>(null);
  final RxDouble totalSelectedDatePrice = RxDouble(0);
  final currentImageIndex = 0.obs;

  // Filter states
  final selectedCategory = RxString('All');
  final page = 1.obs;
  final pageSize = 10.obs;

  // Filter configurations
  final filterConfig = Rx<ListingFilterConfigResponse?>(null);

  final selectedCategories = <int>[].obs;
  final selectedAmenities = <int>[].obs;
  final selectedCategoryId = Rx<int?>(null);

  // Price range filter (min, max)
  final Rx<material.RangeValues> priceRange =
      material.RangeValues(800, 99999).obs;
  final maxPrice = 99999.0.obs;

  // Selected dates for booking
  final selectedDates = <DateTime?>[].obs;
  void resetDateSelection() {
    selectedDates.value = [];
    selectedDateCount.value = 0;
  }


  final roomDetailsList =
      [
        {"title": " Persons", "icon": material.Icons.person_outline},
        {"title": " bedrooms", "icon": material.Icons.roofing},
        {"title": " bed", "icon": material.Icons.bed},
        {"title": " baths", "icon": material.Icons.bathtub_outlined},
      ].obs;

  final galleryImages =
      [
        'assets/demopic.jpg',
        'assets/demopic.jpg',
        'assets/demopic.jpg',
        'assets/demopic.jpg',
      ].obs;
  final selectedDateCount = 0.obs;
  //final selectedDates = <DateTime?>[].obs;

  // Update selected dates
  void updateSelectedDates(List<DateTime?> dates) {
    selectedDates.value = dates;
    totalSelectedDatePrice.value = 0.0;

    if (selectedDates.length > 1 &&
        selectedDates[0] != null &&
        selectedDates[1] != null) {
      // Normalize dates to midnight to ensure accurate date-only comparison.
      DateTime startDate =
          DateTime(selectedDates[0]!.year, selectedDates[0]!.month, selectedDates[0]!.day);
      DateTime endDate =
          DateTime(selectedDates[1]!.year, selectedDates[1]!.month, selectedDates[1]!.day);

      listingDetails.value.calendarData?.forEach((key, value) {
        try {
          // Convert the string key to a DateTime object.
          final DateTime date = DateTime.parse(key);

          // Check if the date from the calendar data is within the selected range (inclusive).
          if (!date.isBefore(startDate) && !date.isAfter(endDate.subtract(Duration(days: 1)))) {
            totalSelectedDatePrice.value += value.price;
          }
        } catch (e) {
          // Log an error if the date key is not in the expected 'yyyy-MM-dd' format.
        }
      });
    }

  }

  @override
  void onInit() {
    super.onInit();
    // Clear previously selected dates
    fetchAmenities();
    fetchListings();
    fetchHomeLayout(tab: "ALL");
    fetchAssistanceCategory();
    loadFilterConfigurations();
    updateSelectedDates([]);
    selectedDateCount.value = 0;
  }



  final categories = <Category>[].obs;
  // Load filter configurations
  Future<void> loadFilterConfigurations() async {
    isLoadingFilters.value = true;
    final result = await _filterConfigRepository.getFilterConfigurations();

    result.fold(
      (failure) {
      },
      (config) {
        try {
          filterConfig.value = config;
          categories.clear();
          categories.assignAll(config.categories);
        } catch (e) {
        }
        isLoadingFilters.value = false;
      },
    );
  }

  // Toggle amenity selection
  void toggleAmenity(int amenityId) {
    if (selectedAmenities.contains(amenityId)) {
      selectedAmenities.remove(amenityId);
    } else {
      selectedAmenities.add(amenityId);
    }
  }

  // Toggle category selection
  void toggleCategory(int categoryId) {
    if (selectedCategories.contains(categoryId)) {
      selectedCategories.remove(categoryId);
    } else {
      selectedCategories.add(categoryId);
    }
  }

  // Set selected category
  void setCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    fetchListings(
      reset: true,
      categories: categoryId != null ? [categoryId] : null,
    );
  }

  // Update price range filter
  void updatePriceRange(material.RangeValues range) {
    priceRange.value = range;
  }

  // Reset all filters to default values
  void resetFilters() {
    selectedCategories.clear();
    selectedAmenities.clear();
    selectedRoomTypes.value = {};
    selectedCategoryId.value = null;
    selectedGuestOption.value = "Any";
    selectedBatroomOption.value = 'Any';
    selectedBatOption.value = 'Any';

    // Reset price range to min and max from filter config
    final minPrice =
        filterConfig.value?.amenities.entirePlace.isNotEmpty == true
            ? 0.0
            : 0.0;
    final maxPrice =
        filterConfig.value?.amenities.entirePlace.isNotEmpty == true
            ? 99999.0
            : 99999.0;
    priceRange.value = material.RangeValues(minPrice, maxPrice);
  }

  // Apply filters and refresh listings
  void applyFilters() {
    final filters = <String, dynamic>{};

    // Add filters only if not empty/null
    if (selectedRoomTypes.isNotEmpty) {
      filters['placeType'] = selectedRoomTypes.join(',');
    }
    if (selectedCategories.isNotEmpty) {
      filters['categories'] = selectedCategories.toList();
    }
    if (selectedAmenities.isNotEmpty) {
      filters['amenities'] = selectedAmenities.toList();
    }

    filters['priceMin'] = priceRange.value.start;
    filters['priceMax'] = priceRange.value.end;

    if (selectedGuestOption.value != 'Any') {
      filters['bedroomCount'] =
          selectedGuestOption.value == '8+'
              ? 9
              : int.parse(selectedGuestOption.value);
    }
    if (selectedBatroomOption.value != 'Any') {
      filters['bathroomCount'] =
          selectedBatroomOption.value == '8+'
              ? 9
              : int.parse(selectedBatroomOption.value);
    }
    if (selectedBatOption.value != 'Any') {
      filters['bedCount'] =
          selectedBatOption.value == '8+'
              ? 9
              : int.parse(selectedBatOption.value);
    }

    // If at least one filter is applied, call fetchListings
    if (filters.isNotEmpty) {
      fetchListings(
        reset: true,
        placeType: filters['placeType'],
        categories: filters['categories'],
        amenities: filters['amenities'],
        priceMin: filters['priceMin'],
        priceMax: filters['priceMax'],
        bedroomCount: filters['bedroomCount'],
        bathroomCount: filters['bathroomCount'],
        bedCount: filters['bedCount'],
      );
    } else {
      // Optionally show a message: No filters selected
    }
  }

  // var listings = <PublicListingModel>[].obs;
  var allListings = <PublicListingModel>[];

  final searchText = ''.obs;
  // final TextEditingController searchController = TextEditingController();

  void filterListings(String keyword) {
    searchText.value = keyword;
    if (keyword.isEmpty) {
      listings.value = allListings;
    } else {
      listings.value =
          allListings.where((listing) {
            return listing.title.toLowerCase().contains(
                  keyword.toLowerCase(),
                ) ||
                listing.address.toLowerCase().contains(keyword.toLowerCase());
          }).toList();
    }
  }

  final RxBool hasMoreData = true.obs;
  // Method to fetch listings with optional filters
// Store last used filters

  Map<String, dynamic> _lastQuery = {};

  Future<void> fetchListings({
    bool reset = false,
    String? searchType,
    double? priceMin,
    double? priceMax,
    String? address,
    double? latitude,
    double? longitude,
    String? placeType,
    int? bedroomCount,
    int? bathroomCount,
    int? bedCount,
    int? guests,
    String? checkIn,
    String? chekOut,
    List<int>? categories,
    List<int>? amenities,
    String? isSearch,
  }) async {
    try {
      if (reset) {
        listings.clear();
        page.value = 1;
        hasMoreData.value = true;
        // Save filters only on reset
        _lastQuery = {
          'searchType': searchType,
          'priceMin': priceMin,
          'priceMax': priceMax,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          'placeType': placeType == 'All' ? null : placeType,
          'bedroomCount': bedroomCount,
          'bathroomCount': bathroomCount,
          'bedCount': bedCount,
          'guests': guests,
          'checkIn': checkIn,
          'chekOut': chekOut,
          'categories': categories,
          'amenities': amenities,
          'isSearch': isSearch,
        };
      }

      if (!hasMoreData.value || isLoading.value) return;

      isLoading.value = true;
      hasError.value = false;

      // Call repo with last filters
      final result = await _repository.getPublicListings(
        page: page.value,
        pageSize: pageSize.value,
        searchType: _lastQuery['searchType'],
        priceMin: _lastQuery['priceMin'],
        priceMax: _lastQuery['priceMax'],
        address: _lastQuery['address'],
        latitude: _lastQuery['latitude'],
        longitude: _lastQuery['longitude'],
        placeType: _lastQuery['placeType'],
        bedroomCount: _lastQuery['bedroomCount'],
        bathroomCount: _lastQuery['bathroomCount'],
        bedCount: _lastQuery['bedCount'],
        guests: _lastQuery['guests'],
        checkIn: _lastQuery['checkIn'],
        chekOut: _lastQuery['chekOut'],
        categories: _lastQuery['categories'],
        amenities: _lastQuery['amenities'],
        isSearch: _lastQuery['isSearch'],
      );

      if (reset) {
        listings.assignAll(result.data);
      } else {
        listings.addAll(result.data);
      }

      metaData.value = result.metaData;

      if (result.data.isEmpty || result.data.length < pageSize.value) {
        hasMoreData.value = false;
      } else {
        page.value++;
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  // Method to fetch listings with optional filters
  Future<void> fetchListingDetails() async {
    try {
      // Show loading state
      isLoading.value = true;
      hasListingDetailsError.value = false;

      final String listingId = Get.parameters['id'] ?? '';

      // Get listings from repository
      final result = await _repository.getListingDetails(id: listingId);

      print("The result is the following- ${result}");
      listingDetails.value = result;

      // Hide loading state
      isLoading.value = false;
    } catch (e) {
      // Update error state
      isLoading.value = false;
      hasListingDetailsError.value = true;
      errorMessage.value = e.toString();
    }
  }

  // Method to load the next page of listings
  Future<void> loadMoreListings() async {
    // Check if there's a next page available
    if (metaData.value != null && metaData.value!.next != null) {
      page.value++;
      await fetchListings();
    }
  }

  // Method to refresh listings
  Future<void> refreshListings() async {
    await fetchListings(reset: true);
  }

  // Method to filter by category
  void filterByCategory(String category) {
    selectedCategory.value = category;

    String? placeType;
    // Map category to the API's place_type parameter
    switch (category) {
      case 'All':
        placeType = null;
        break;
      case 'Hotel':
        placeType = 'hotel';
        break;
      case 'Resort':
        placeType = 'resort';
        break;
      case 'Apartment':
        placeType = 'apartment';
        break;
      case 'Home':
        placeType = 'entire_place';
        break;
      default:
        placeType = null;
    }

    fetchListings(reset: true, placeType: placeType);
  }

  // Method to filter by category ID from the API
  void filterByCategoryId(int? categoryId) {
    // Clear previous selections if All is selected (null categoryId)
    if (categoryId == null) {
      selectedCategories.clear();
      selectedCategoryId.value = null;
      fetchListings(reset: true);
      return;
    }

    // Set the selected category ID
    selectedCategoryId.value = categoryId;

    // Create a list with just this category ID
    final categories = [categoryId];

    // Fetch listings filtered by this category
    fetchListings(reset: true, categories: categories);
  }

  final Rxn<LocationData> districtData = Rxn<LocationData>();

  Future<void> fetchDistrictPoint({required String data}) async {
    try {
      isLoadingg.value = true;
      hasErrorg.value = false;

      // Get district points from repository
      final response = await _repository.getDistrictPoints(query: data);

      if (response.data.isNotEmpty) {
        districtData.value = response.data.first;
      } else {
        districtData.value = null;
        errorMessage.value = 'No district data found.';
      }

      isLoadingg.value = false;
    } catch (e) {
      isLoadingg.value = false;
      hasErrore.value = true;
      errorMessagee.value = e.toString();
    }
  }

  final RxString chatRoomId = ''.obs;
  Future<void> startUserChatRequest({
    required MessageBookingRequest request,
    required String guestId, // ADD THIS PARAM
  }) async {
    try {
      isLoadinggc.value = true;
      hasErrorgc.value = false;

  final response = await _repository.startUserChat(
    messageRequest: request,
  );


      if (response.success == true) {
        chatRoomId.value = response.data?.chatRoomId ?? '';

         try {
            await _repository.postAvgResponseTime(
              listingId: request.listing ?? 0,
              hostId: request.toUser ?? 0,
              guestId: int.tryParse(guestId) ?? 0,
              avgResponseTimeSeconds: 0,
              totalResponses: 0,
            );
            print("✅ avgTime API called successfully");
          } catch (e) {
            print("❌ avgTime API failed: $e");
          }
      } else {
        errorMessage.value = response.message ?? 'Failed to start chat.';
        chatRoomId.value = '';
      }

      isLoadinggc.value = false;
    } catch (e) {
      isLoadinggc.value = false;
      hasErrore.value = true;
      errorMessageec.value = e.toString();
      chatRoomId.value = '';
    }
  }

  //new filter option update---
  RxSet<String> selectedRoomTypes = <String>{}.obs;

  void toggleRoomType(String roomType) {
    if (selectedRoomTypes.contains(roomType)) {
      selectedRoomTypes.remove(roomType);
    } else {
      selectedRoomTypes.add(roomType);
    }
  }

  bool isSelected(String roomType) => selectedRoomTypes.contains(roomType);
  RxString selectedGuestOption = 'Any'.obs;

  void selectGuestOption(String option) {
    selectedGuestOption.value = option;
  }

  RxString selectedBatroomOption = 'Any'.obs;
  RxString selectedBatOption = 'Any'.obs;

  void selectBatroomOption(String option) {
    selectedBatroomOption.value = option;
  }

  void selectBatOption(String option) {
    selectedBatOption.value = option;
  }

  final RxList<DistrictWideLatLong> subDistrictList =
      <DistrictWideLatLong>[].obs;

  // For loading and error state
  final RxBool isSubDistrictLoading = false.obs;
  final RxBool hasSubDistrictError = false.obs;
  final RxString subDistrictErrorMessage = ''.obs;

  Future<void> fetchSubDistrictPoints({required String districtName}) async {
    try {
      isSubDistrictLoading.value = true;
      hasSubDistrictError.value = false;

      // Get sub-district points from repository
      final response = await _repository.getSubDistrictPointsLocation(
        districtName: districtName,
      );

      if (response.districtList.isNotEmpty) {
        subDistrictList.assignAll(response.districtList);
      } else {
        subDistrictList.clear();
        subDistrictErrorMessage.value = 'No sub-district data found.';
      }

      isSubDistrictLoading.value = false;
    } catch (e) {
      isSubDistrictLoading.value = false;
      hasSubDistrictError.value = true;
      subDistrictErrorMessage.value = e.toString();
    }
  }

  final isLoadingHome = false.obs;
  final hasErrorHome  = false.obs;
  final errorMessageHome  = ''.obs;

  final homeSections = <HomeSection>[].obs;

  final selectedHomeCategoryId = RxnInt();
  final selectedTabName = 'All'.obs;

  Future<void> fetchHomeLayout({required String tab}) async {
    try {
      isLoadingg.value = true;
      hasErrorg.value = false;

      final response = await _repository.getHomeLayout(tab: tab);

      homeSections.value = response.data;
      selectedTabName.value = tab;

      isLoadingg.value = false;
    } catch (e) {
      isLoadingg.value = false;
      hasErrorg.value = true;
      errorMessage.value = e.toString();
    }
  }

  /// Called from tabs
  void onCategorySelected({
    int? categoryId,
    required String tabName,
  }) {
    /// Avoid duplicate API calls
    if (selectedTabName.value == tabName &&
        selectedHomeCategoryId.value == categoryId) {
      return;
    }

    selectedHomeCategoryId.value = categoryId;
    selectedTabName.value = tabName;

    fetchHomeLayout(tab: tabName);
  }

  final isLoadingListings = false.obs;
  final hasErrorListings = false.obs;
  final errorMessageListings = ''.obs;

  // Data
  final newListings = <NewPropertyItem>[].obs;

  // Pagination
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final isLoadMore = false.obs;
  int? _lastId;
  double? _lastLat;
  double? _lastLong;
  int? _lastRadius;
  int? _lastGuests;
  String? _lastCheckIn;
  String? _lastCheckOut;
  /// Fetch listings (initial + pagination)
  Future<void> fetchUpdatedListings({
    bool loadMore = false,
    int? id,
    double? latitude,
    double? longitude,
    int? radius,
    int? guests,
    String? checkIn,
    String? checkOut,
  }) async {
    try {
      if (isLoadingListings.value) return;

      // Save last used parameters for pagination
      if (!loadMore) {
        _lastId = id;
        _lastLat = latitude;
        _lastLong = longitude;
        _lastRadius = radius;
        _lastGuests = guests;
        _lastCheckIn = checkIn;
        _lastCheckOut = checkOut;
      }

      if (loadMore) {
        if (currentPage.value >= lastPage.value) return;
        isLoadMore.value = true;
        currentPage.value += 1;

        // Use last saved parameters if not passed
        id ??= _lastId;
        latitude ??= _lastLat;
        longitude ??= _lastLong;
        radius ??= _lastRadius;
        guests ??= _lastGuests;
        checkIn ??= _lastCheckIn;
        checkOut ??= _lastCheckOut;
      } else {
        isLoadingListings.value = true;
        currentPage.value = 1;
        newListings.clear();
      }

      hasErrorListings.value = false;

      final response = await _repository.getUpdatedPublicListings(
        page: currentPage.value,
        id: id,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        guests: guests,
        checkIn: checkIn,
        checkOut: checkOut,
      );

      newListings.addAll(response.data);
      lastPage.value = response.meta.lastPage;

      isLoadingListings.value = false;
      isLoadMore.value = false;
    } catch (e) {
      isLoadingListings.value = false;
      isLoadMore.value = false;
      hasErrorListings.value = true;
      errorMessageListings.value = e.toString();
    }
  }



  /// Reset when filters change
  void resetListings() {
    currentPage.value = 1;
    lastPage.value = 1;
    newListings.clear();
  }

  String? _lastTitle;

  Future<void> fetchSectionViewListings({
    required String title,
    bool loadMore = false,
    int pageSize = 10,
  }) async {
    try {
      if (isLoadingListings.value) return;

      // Save last used parameters for pagination
      if (!loadMore) {
        _lastTitle = title;
      }

      if (loadMore) {
        if (currentPage.value >= lastPage.value) return;
        isLoadMore.value = true;
        currentPage.value += 1;

        // Use last saved title if not passed (shouldn't change during pagination)
        title = _lastTitle ?? title;
      } else {
        isLoadingListings.value = true;
        currentPage.value = 1;
        newListings.clear();
      }

      hasErrorListings.value = false;

      final response = await _repository.getSectionViewListings(
        title: title,
        page: currentPage.value,
        pageSize: pageSize,
      );

      newListings.addAll(response.data);
      lastPage.value = response.meta.lastPage;

      isLoadingListings.value = false;
      isLoadMore.value = false;
    } catch (e) {
      isLoadingListings.value = false;
      isLoadMore.value = false;
      hasErrorListings.value = true;
      errorMessageListings.value = e.toString();
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
}

// Hello I am Tamim