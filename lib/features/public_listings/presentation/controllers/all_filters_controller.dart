import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllFiltersController extends GetxController {
  // ── Price Range ──────────────────────────────────────────
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 99999.0.obs;
  final TextEditingController minPriceCtrl =
      TextEditingController(text: '0');
  final TextEditingController maxPriceCtrl =
      TextEditingController(text: '99999');

  // ── Property Type ────────────────────────────────────────
  // 'entire_place' | 'single_room' | 'shared_room' | null
  final RxnString selectedPropertyType = RxnString();

  // ── Beds and Bathrooms ───────────────────────────────────
  // 0 = "Any"
  final RxInt bedrooms = 0.obs;
  final RxInt bathrooms = 0.obs;
  final RxInt beds = 0.obs;

  // ── Amenities — REAL numeric IDs from /listings/amenities ─
  final RxSet<int> selectedAmenityIds = <int>{}.obs;

  void togglePropertyType(String type) {
    selectedPropertyType.value =
        selectedPropertyType.value == type ? null : type;
  }

  void toggleAmenity(int amenityId) {
    if (selectedAmenityIds.contains(amenityId)) {
      selectedAmenityIds.remove(amenityId);
    } else {
      selectedAmenityIds.add(amenityId);
    }
  }

  void updateMinPrice(String value) {
    minPrice.value = double.tryParse(value) ?? 0;
  }

  void updateMaxPrice(String value) {
    maxPrice.value = double.tryParse(value) ?? 99999;
  }

  void clearAll() {
    minPrice.value = 0;
    maxPrice.value = 99999;
    minPriceCtrl.text = '0';
    maxPriceCtrl.text = '99999';
    selectedPropertyType.value = null;
    bedrooms.value = 0;
    bathrooms.value = 0;
    beds.value = 0;
    selectedAmenityIds.clear();
  }

  /// Params matching web's query string exactly:
  /// price_min, price_max, place_type__in, bedroom_count,
  /// bathroom_count, bed_count, listing_amenity__in
  Map<String, dynamic> buildFilterParams() {
    return {
      'min_price': minPrice.value,
      'max_price': maxPrice.value,
      if (selectedPropertyType.value != null)
        'property_type': selectedPropertyType.value,
      if (bedrooms.value > 0) 'bedrooms': bedrooms.value,
      if (bathrooms.value > 0) 'bathrooms': bathrooms.value,
      if (beds.value > 0) 'beds': beds.value,
      if (selectedAmenityIds.isNotEmpty)
        'amenities': selectedAmenityIds.toList(),
    };
  }

  @override
  void onClose() {
    minPriceCtrl.dispose();
    maxPriceCtrl.dispose();
    super.onClose();
  }
}