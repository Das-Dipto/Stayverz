import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../listing/models/aminities_new_model.dart';
import '../controllers/all_filters_controller.dart';
import '../controllers/public_listings_controller.dart';

class AllFiltersDialog extends GetView<AllFiltersController> {
  const AllFiltersDialog({super.key});

  static const _borderColor = Color(0xFFE4E9EC);
  static const _orange = Color(0xFFF15927);
  static const _dark = Color(0xFF090909);
  static const _grey = Color(0xFF989B9D);

  @override
  Widget build(BuildContext context) {
    Get.put(AllFiltersController());
    final publicListingsController = Get.find<PublicListingsController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _header(),
              
              const Divider(height: 1),
Expanded(
  child: Obx(() {
    // Ensure amenities are actually fetched (safe no-op if already loaded/loading)
    if (publicListingsController.amenitiesList.isEmpty &&
        !publicListingsController.isLoadingg.value) {
      publicListingsController.fetchAmenities();
    }

    if (publicListingsController.amenitiesList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Flatten every category's items into ONE list, then split strictly by a_type
    final List<AmenityModel> allAmenities = publicListingsController
        .amenitiesList
        .expand((cat) => cat.data ?? <AmenityModel>[])
        .toList();

    final entirePlace = allAmenities
        .where((a) => (a.aType ?? '').trim() == 'entire_place')
        .toList();
    final standOut = allAmenities
        .where((a) => (a.aType ?? '').trim() == 'stand_out')
        .toList();
    final safety = allAmenities
        .where((a) => (a.aType ?? '').trim() == 'safety')
        .toList();

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      children: [
        _priceRangeSection(),
        const Gap(20),
        const Divider(),
        const Gap(20),
        _propertyTypeSection(),
        const Gap(20),
        const Divider(),
        const Gap(20),
        _bedsAndBathsSection(),
        const Gap(20),
        const Divider(),
        const Gap(20),
        if (entirePlace.isNotEmpty)
          _amenitiesGroup('Amenities', 'Entire Place', entirePlace),
        if (standOut.isNotEmpty) ...[
          const Gap(24),
          _amenitiesGroup(null, 'Stand Out', standOut),
        ],
        if (safety.isNotEmpty) ...[
          const Gap(24),
          _amenitiesGroup(null, 'Safety', safety),
        ],
      ],
    );
  }),
),
              const Divider(height: 1),
              _bottomBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.close, color: _dark),
          ),
          const Expanded(
            child: Text(
              'Filters',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _dark,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _priceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price Range',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _dark)),
        const Gap(16),
        Obx(
          () => RangeSlider(
            values: RangeValues(
              controller.minPrice.value.clamp(0, 99999),
              controller.maxPrice.value.clamp(0, 99999),
            ),
            min: 0,
            max: 99999,
            activeColor: _orange,
            inactiveColor: const Color(0xFFE0E0E0),
            onChanged: (range) {
              controller.minPrice.value = range.start;
              controller.maxPrice.value = range.end;
              controller.minPriceCtrl.text = range.start.toInt().toString();
              controller.maxPriceCtrl.text = range.end.toInt().toString();
            },
          ),
        ),
        Row(
          children: [
            Expanded(child: _priceField('Min Price', controller.minPriceCtrl, controller.updateMinPrice)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('—'),
            ),
            Expanded(child: _priceField('Max Price', controller.maxPriceCtrl, controller.updateMaxPrice)),
          ],
        ),
      ],
    );
  }

  Widget _priceField(String label, TextEditingController ctrl, ValueChanged<String> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: _orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: _grey)),
          Row(
            children: [
              const Text('৳ ', style: TextStyle(color: _dark)),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: _dark, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _propertyTypeSection() {
    // NOTE: values match `place_type__in` on web exactly.
    final types = [
      {'key': 'entire_place', 'label': 'Entire Places', 'icon': Icons.home_outlined},
      {'key': 'single_room', 'label': 'Single Rooms', 'icon': Icons.meeting_room_outlined},
      {'key': 'shared_room', 'label': 'Shared Rooms', 'icon': Icons.people_outline},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Property Type',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _dark)),
        const Gap(14),
        Obx(
          () => Row(
            children: types.map((t) {
             final isSelected = controller.selectedPropertyTypes.contains(t['key']);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => controller.togglePropertyType(t['key'] as String),
                  
child: Container(
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
  decoration: BoxDecoration(
    color: isSelected ? _orange.withOpacity(0.08) : Colors.white,
    border: Border.all(
      color: isSelected ? _orange : _borderColor,
      width: isSelected ? 1.5 : 1,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    children: [
      Icon(t['icon'] as IconData, color: isSelected ? _orange : _dark),
      const Gap(10),
      Text(
        t['label'] as String,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? _orange : _dark,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    ],
  ),
),              
                  
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _bedsAndBathsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Beds and bathrooms',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _dark)),
        const Gap(12),
        _BedBathCounter(label: 'Bedrooms', onChanged: (val) => controller.bedrooms.value = val),
        const Gap(16),
        _BedBathCounter(label: 'Bathrooms', onChanged: (val) => controller.bathrooms.value = val),
        const Gap(16),
        _BedBathCounter(label: 'Beds', onChanged: (val) => controller.beds.value = val),
      ],
    );
  }

  Widget _amenitiesGroup(String? sectionTitle, String categoryLabel, List<AmenityModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitle != null) ...[
          Text(sectionTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _dark)),
          const Gap(10),
        ],
        Text(categoryLabel,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _dark)),
        const Gap(10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4.2,
          ),
          itemBuilder: (context, index) => _amenityCheckbox(items[index]),
        ),
      ],
    );
  }

  Widget _amenityCheckbox(AmenityModel amenity) {
    final id = amenity.id;
    final name = amenity.name ?? '';
    if (id == null) return const SizedBox.shrink();

    return Obx(() {
      final isChecked = controller.selectedAmenityIds.contains(id);
      return InkWell(
        onTap: () => controller.toggleAmenity(id),
        child: Row(
          children: [
            Checkbox(
              value: isChecked,
              activeColor: _orange,
              onChanged: (_) => controller.toggleAmenity(id),
            ),
            Expanded(
              child: Text(
                name.trim(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: _dark),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: controller.clearAll,
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: _dark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              final filterParams = controller.buildFilterParams();
              Get.back(result: filterParams);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                color: _orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Show places',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BedBathCounter extends StatefulWidget {
  final String label;
  final ValueChanged<int>? onChanged; // 0 = Any, 8 = "8+"

  const _BedBathCounter({required this.label, this.onChanged});

  @override
  State<_BedBathCounter> createState() => _BedBathCounterState();
}

class _BedBathCounterState extends State<_BedBathCounter> {
  static const _borderColor = Color(0xFFE4E9EC);
  static const _orange = Color(0xFFF15927);
  static const _dark = Color(0xFF090909);

  static const List<String> options = ['Any', '1', '2', '3', '4', '5', '6', '7', '8+'];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontSize: 14, color: _dark)),
        const Gap(8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            separatorBuilder: (_, __) => const Gap(8),
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              return InkWell(
                onTap: () {
                  setState(() => selectedIndex = index);
                  final numericValue =
                      index == 0 ? 0 : (index == options.length - 1 ? 8 : index);
                  widget.onChanged?.call(numericValue);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? _orange : Colors.white,
                    border: Border.all(color: isSelected ? _orange : _borderColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    options[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : _dark,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}