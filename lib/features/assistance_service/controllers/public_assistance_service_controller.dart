import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverz_flutter_app/features/assistance_service/models/public_assistance_params.dart';
import 'package:stayverz_flutter_app/features/assistance_service/models/assistance_listing_response_model.dart';

import '../../listing/models/map_suggestions_response_model.dart';
import '../models/single_public_assistance_listing_response_model.dart';
import '../repositories/assistance_service_repository_interface.dart';

class PublicAssistanceServiceController extends GetxController {

  final AssistanceServiceRepositoryInterface _repository;

  // params data
  PublicAssistanceParams? params;

  PublicAssistanceServiceController(this._repository);

  final RxList<AssistanceListingData> assistanceListings = <AssistanceListingData>[].obs;
  final RxBool isAssistanceListingLoading = false.obs;
  final RxBool isLoadingPublicAssistance = false.obs;
  final RxBool isSearchingPublicAssistance = false.obs;
  final RxBool isStartingInquiry = false.obs;
  final RxBool hasError = false.obs;
  final RxBool hasInquiryError = false.obs;
  final RxBool hasSearchError = false.obs;
  final RxBool hasMoreAssistanceData = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString inquiryErrorMessage = ''.obs;
  final RxString searchErrorMessage = ''.obs;
  final RxInt coHostCurrentPage = 1.obs;
  final RxInt searchCurrentPage = 1.obs;
  var extraGuestCount = 0.obs;
  Rx<PublicAssistanceData?> publicListingDetails = Rx<PublicAssistanceData?>(null);
  final int pageSize = 50;
  final Rx<Marker?> selectedMarker = Rx<Marker?>(null);
  final selectedDates = <DateTime?>[].obs;
  final RxDouble totalSelectedDatePrice = RxDouble(0);
  final selectedDateCount = 0.obs;
  final searchTotalPage = 10.obs;
  final children = 0.obs;
  TextEditingController bookingLocationController = TextEditingController();
  TextEditingController bookingContactController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  PlaceSuggestion? selectedBookingLocation;

  Rx<PlaceSuggestion?> selectedSearchLocation = Rx<PlaceSuggestion?>(null);
  final RxList<AssistanceListingData> listings = <AssistanceListingData>[].obs;

  final RxString chatRoomId = ''.obs;

  @override
  void onInit() {
    params = PublicAssistanceParams.fromJson(Get.arguments);
    fetchAssistanceListings();
    super.onInit();
  }

  Future<void> fetchListings({String? latitude, String? longitude, String? checkIn, String? checkOut, String? maxPersonGet}) async {
    isSearchingPublicAssistance.value = true;
    hasSearchError.value = false;
    searchErrorMessage.value = '';

    try {
      final response = await _repository.getAssistanceSearch(
        page: searchCurrentPage.value,
        limit: pageSize,
        categoryIn: params?.categoryId,
        maxPersonGet: maxPersonGet,
        latitude: latitude,
        longitude: longitude,
        checkIn: checkIn,
        checkOut: checkOut,
        radius: "25"
      );


      if (searchCurrentPage.value == 1) {
        listings.value = response.data ?? [];
      } else {
        listings.addAll(response.data ?? []);
      }

      // Calculate total pages based on meta_data
      final total = response.totalPages as int;
      searchTotalPage.value = (total / pageSize).ceil();
    } catch (e) {
      hasSearchError.value = true;
      searchErrorMessage.value = e.toString();
    } finally {
      isSearchingPublicAssistance.value = false;
    }
  }

  Future<void> fetchAssistanceSingleListingDetails() async {
    isLoadingPublicAssistance.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      PublicAssistanceParams? arg = PublicAssistanceParams.fromJson(Get.arguments);
      var res = await _repository.getPublicAssistanceSingleListingDetails(id: arg.assistanceId ?? '');
      publicListingDetails.value = res;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoadingPublicAssistance.value = false;
    }
  }

  void incrementChildren() {
    // if (!isChildrenIncrementDisabled) {
      children.value++;
    // }
  }

  void decrementChildren() {
    if (children.value > 0) {
      children.value--;
    }
  }

  Future<void> fetchAssistanceListings() async {
    isAssistanceListingLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    if((params?.categoryId ?? '').isEmpty) {
      isAssistanceListingLoading.value = false;
      return;
    }

    try {
      final response = await _repository.getAssistanceSearch(
        page: coHostCurrentPage.value,
        limit: pageSize,
        categoryIn: params?.categoryId
      );

      if (coHostCurrentPage.value == 1) {
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

  void incrementGuestCount() {
    extraGuestCount.value++;
  }

  void decrementGuestCount() {
    if (extraGuestCount.value > 0) {
      extraGuestCount.value--;
    }
  }

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

      publicListingDetails.value?.calendarData?.forEach((key, value) {
        try {
          // Convert the string key to a DateTime object.
          final DateTime date = DateTime.parse(key);

          // Check if the date from the calendar data is within the selected range (inclusive).
          if (!date.isBefore(startDate) && !date.isAfter(endDate.subtract(Duration(days: 1)))) {
            totalSelectedDatePrice.value += (value.price ?? 0);
          }
        } catch (e) {
          // Log an error if the date key is not in the expected 'yyyy-MM-dd' format.
        }
      });
    }

  }

  Future<void> startUserChatRequest({
    required Map<String, dynamic> body,
  }) async {
    try {
      isStartingInquiry.value = true;
      hasInquiryError.value = false;

      final response = await _repository.startUserChat(body: body);


      if (response.data != null) {
        chatRoomId.value = response.data?.chatRoomId ?? '';
      } else {
        inquiryErrorMessage.value = response.message ?? 'Failed to start chat.';
        chatRoomId.value = '';
      }

      isStartingInquiry.value = false;
    } catch (e) {
      isStartingInquiry.value = false;
      hasInquiryError.value = true;
      inquiryErrorMessage.value = e.toString();
      chatRoomId.value = '';
    }
  }

}

// Hello I am Tamim