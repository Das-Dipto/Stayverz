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
  final RxSet<String> selectedPropertyTypes = <String>{}.obs;


  // ── Beds and Bathrooms ───────────────────────────────────
  // 0 = "Any"
  final RxInt bedrooms = 0.obs;
  final RxInt bathrooms = 0.obs;
  final RxInt beds = 0.obs;

  // ── Amenities — REAL numeric IDs from /listings/amenities ─
  final RxSet<int> selectedAmenityIds = <int>{}.obs;

void togglePropertyType(String type) {
  if (selectedPropertyTypes.contains(type)) {
    selectedPropertyTypes.remove(type);
  } else {
    selectedPropertyTypes.add(type);
  }
}

  void toggleAmenity(int amenityId) {
    if (selectedAmenityIds.contains(amenityId)) {
      selectedAmenityIds.remove(amenityId);
    } else {
      selectedAmenityIds.add(amenityId);
    }
  }

 void updateMinPrice(String value) {
  final parsed = double.tryParse(value) ?? 0;
  minPrice.value = parsed.clamp(0, maxPrice.value);
}

void updateMaxPrice(String value) {
  final parsed = double.tryParse(value) ?? 99999;
  maxPrice.value = parsed.clamp(minPrice.value, 99999);
}

void clearAll() {
    minPrice.value = 0;
    maxPrice.value = 99999;
    minPriceCtrl.text = '0';
    maxPriceCtrl.text = '99999';
    selectedPropertyTypes.clear();
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
      if (selectedPropertyTypes.isNotEmpty)
            'property_type': selectedPropertyTypes.join(','),
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