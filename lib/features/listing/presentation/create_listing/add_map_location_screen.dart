import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/features/listing/models/map_suggestions_response_model.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../widgets/own_app_bar.dart';

class AddMapLocationScreen extends GetView<ListingController> {
  final String? uniqId;
  AddMapLocationScreen({super.key, this.uniqId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 90,
        child: Row(
          children: [
            InkWell(
              onTap: Get.back,
              child: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF7F7F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Add Map Location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF090909),
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.27,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Where\'s your place located?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                ),
              ),
              const Gap(12),
              const Text(
                'Your address is only shared with guests after they\'ve made a reservation.',
                style: TextStyle(
                  color: Color(0xFF33496C),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              const Gap(30),
              WhereILiveBottomSheet(),
              const Gap(20),
              Obx(() => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.isLocationSubmitting.value
                      ? null
                      : () async {
                    final success =
                    await controller.submitLocationDataMAp(uniqId);
                    if (success) {
                      _showSuccessPopup(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF15A24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isLocationSubmitting.value
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Add Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              )),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== Success Popup =====================

  void _showSuccessPopup(BuildContext context) {
    // Pull address data from controller
    final address = controller.suggestionController.text.trim();

    // Split address into title + subtitle by first comma
    final commaIndex = address.indexOf(',');
    final title =
    commaIndex != -1 ? address.substring(0, commaIndex).trim() : address;
    final subtitle =
    commaIndex != -1 ? address.substring(commaIndex + 1).trim() : '';

    // Detail rows using MapEntry — no helper class needed
    final fields = <MapEntry<String, String>>[
      if (address.isNotEmpty) MapEntry('Full Address', address),
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Success icon ──────────────────────────────
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF15A24).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFFF15A24),
                      size: 40,
                    ),
                  ),
                ),
                const Gap(14),

                // ── "Location Added Successfully!" ────────────
                const Center(
                  child: Text(
                    'Location Added Successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D1D1D),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const Gap(8),

                // ── Big address title ─────────────────────────
                if (title.isNotEmpty)
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D1D1D),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                const Gap(4),

                // ── Subtitle address line ─────────────────────
                if (subtitle.isNotEmpty)
                  Center(
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B6B6B),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                const Gap(20),
                const Divider(color: Color(0xFFEEEEEE), thickness: 1),
                const Gap(24),
                // ── Go Back button ────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Close dialog using its own context — 100% safe
                      Navigator.of(dialogContext, rootNavigator: true).pop();
                      // Then go back to previous screen
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF15A24),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== Detail Row =====================

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B6B6B),
                fontFamily: 'Inter',
              ),
            ),
          ),
          const Text(
            ':  ',
            style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 12),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1D1D),
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSuggestionSelected(PlaceSuggestion suggestion) {
    controller.selectedPlace.value = suggestion;
    controller.suggestionController.text = suggestion.address ?? '';
  }

  Future<List<PlaceSuggestion>> suggestionsCallback(String pattern) async =>
      controller.onPlaceSearchChange(pattern);
}

// ===================== Map Widget =====================

class WhereILiveBottomSheet extends StatelessWidget {
  WhereILiveBottomSheet({super.key});

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final ListingController controller = Get.find<ListingController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Obx(
                () => GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: _kGooglePlex,
              markers: controller.selectedMarker.value != null
                  ? {controller.selectedMarker.value!}
                  : {},
              onMapCreated: (GoogleMapController mapController) {
                _controller.complete(mapController);
              },
              onTap: (location) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: TypeAheadField<PlaceSuggestion>(
            controller: controller.suggestionController,
            builder: (context, textController, focusNode) => TextField(
              controller: textController,
              focusNode: focusNode,
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search...',
                isDense: true,
                isCollapsed: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
            decorationBuilder: (context, child) => Material(
              type: MaterialType.card,
              elevation: 4,
              borderRadius: BorderRadius.circular(6),
              child: child,
            ),
            itemBuilder: (context, suggestion) => Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  const Gap(6),
                  Expanded(child: Text(suggestion.address ?? '')),
                ],
              ),
            ),
            onSelected: onSuggestionSelected,
            suggestionsCallback: suggestionsCallback,
            itemSeparatorBuilder: itemSeparatorBuilder,
            listBuilder: gridLayoutBuilder,
          ),
        ),
      ],
    );
  }

  void onSuggestionSelected(PlaceSuggestion suggestion) async {
    controller.selectedPlace.value = suggestion;
    controller.suggestionController.text = suggestion.address ?? '';

    final lat = suggestion.latitude;
    final lng = suggestion.longitude;

    if (lat != null && lng != null) {
      controller.setMapLocation(
        lat: lat,
        lng: lng,
        addressText: suggestion.address ?? '',
      );

      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(double.parse(lat), double.parse(lng)),
          16,
        ),
      );

      controller.selectedMarker.value = Marker(
        markerId: const MarkerId('selected-location'),
        position: LatLng(double.parse(lat), double.parse(lng)),
      );
    }
  }

  Widget itemSeparatorBuilder(BuildContext context, int index) => const Gap(2);

  Widget gridLayoutBuilder(BuildContext context, List<Widget> items) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      children: items,
    );
  }

  Future<List<PlaceSuggestion>> suggestionsCallback(String pattern) async =>
      controller.onPlaceSearchChange(pattern);
}
// Hello I am Tamim