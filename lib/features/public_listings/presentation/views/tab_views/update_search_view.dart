import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../listing/controllers/listing_controller.dart';
import '../../../data/models/search_view_modle.dart';
import '../../controllers/update_controller.dart';
import '../new_search_view_screen.dart';

class UpdateSearchView extends StatefulWidget {
  const UpdateSearchView({super.key});

  @override
  State<UpdateSearchView> createState() => _UpdateSearchViewState();
}

class _UpdateSearchViewState extends State<UpdateSearchView> {
  final ListingController controllerLocation = Get.find<ListingController>();
  final whenController = Get.put(WhenController());
  List<DateTime?> selectedRange = [];
  final adults = 0.obs;
  final children = 0.obs;
  final infants = 0.obs;
  final pets = 0.obs;
  final storage = GetStorage();
  /// MAX constraints
  final int maxGuests = 20;
  final int maxInfants = 10;
  final int maxPets = 2;
  int get totalGuests => adults.value + children.value;

  /// --- Adults ---
  bool get isAdultsIncrementDisabled => adults.value >= maxGuests;

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

  bool get isPetIncrementDisabled => pets.value >= maxPets;

  void incrementPets() {
    if (!isPetIncrementDisabled) {
      pets.value++;
    }
  }

  void decrementPets() {
    if (pets.value > 0) {
      pets.value--;
    }
  }

  final DateTime todayOnly = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  // 🔥 Clear All Function
  void clearAllFilters() {
    // Clear location
    controllerLocation.selectedSection.value = null;
    controllerLocation.suggestionController.clear();

    // Clear date range
    whenController.clearAll();

    // Clear guest counts
    adults.value = 0;
    children.value = 0;
    infants.value = 0;
    pets.value = 0;
  }

  // 🔥 Handle Search with Data
  void handleSearch() {
    // Clear previous search
    storage.remove('lastSearch');

    final int? locationId = controllerLocation.selectedSection.value?.id;
    final Map<String, dynamic> currentSearch = {
      'location': controllerLocation.selectedSection.value,
      'locationName': controllerLocation.selectedSection.value?.displayName ?? '',
      // Convert DateTime list safely
      'dateRange': whenController.selectedRange.value
          .map((d) => d is DateTime ? d.toIso8601String() : d?.toString())
          .toList(),
      'dateText': whenController.whenText.value,
      'adults': adults.value,
      'children': children.value,
      'infants': infants.value,
      'pets': pets.value,
      'totalGuests': totalGuests,
      'start_date': whenController.startDate.value, // already String
      'end_date': whenController.endDate.value,     // already String
      if (locationId != null) 'locationId': locationId,
      if (locationId == null) ...{
        'lat': controllerLocation.lat.value ?? 0.0,
        'long': controllerLocation.long.value ?? 0.0,
      },
    };

    // Save new search safely
    storage.write('lastSearch', currentSearch);

    // Navigate with updated data
    Get.to(() => NewSearchViewScreen(), arguments: currentSearch);
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Gap(45),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8), // similar to your Figma padding
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFFD8DCE0), // border color from Figma
                    ),
                    borderRadius: BorderRadius.circular(24), // rounded corners
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Get.back();
                  },
                  child: Transform.scale(
                    scale: 1.8, // makes icon bigger/thicker
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Stays',
                    style: TextStyle(
                      color: const Color(0xFFF15B25),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                // adjust this to increase the gap
                  Gap(2),
                  Container(
                    height: 2, // underline thickness
                    width: 45, // underline width, adjust if needed
                    color: const Color(0xFFF15B25), // underline color same as text
                  ),
                ],
              ),
              Gap(60),
            ],
          ),
          Gap(34),
          Obx(() {
            final selected = controllerLocation.selectedSection.value;

            // 🔹 AFTER selection → show compact view
            if (selected != null) {
              // Determine what text to show
              final displayText = (selected.displayName != null && selected.displayName!.isNotEmpty)
                  ? selected.displayName
                  : (selected.subText != null && selected.subText!.isNotEmpty)
                  ? selected.subText
                  : 'Unknown location';

              return GestureDetector(
                onTap: () {
                  // Allow user to change selection
                  controllerLocation.selectedSection.value = null;
                },
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFE4E9EC),
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Where     ',
                        style: TextStyle(
                          color: Color(0xFF989B9D),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Text(
                          displayText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF3D3F40),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // 🔹 BEFORE selection → show search UI
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFE4E9EC),
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),
                  const Text(
                    'Where to?',
                    style: TextStyle(
                      color: Color(0xFF090909),
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(10),
                  TypeAheadField<SectionModel>(
                    controller: controllerLocation.suggestionController,
                    suggestionsCallback: suggestionsCallback,
                    onSelected: onSuggestionSelected,
                    builder: (context, textController, focusNode) => TextField(
                      controller: textController,
                      focusNode: focusNode,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF3D3F40),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search location...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF9E9E9E),
                          size: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF6F7F9),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    itemBuilder: (context, SectionModel suggestion) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.21),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0x33787878),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.16),
                              ),
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.black,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${suggestion.displayName}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF4E4E4E),
                                    fontSize: 18.2,
                                    fontFamily: 'Kumbh Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 1.29,
                                  ),
                                ),
                                if (suggestion.subText!.isNotEmpty)
                                  Text(
                                    "${suggestion.subText}",
                                    style: const TextStyle(
                                      color: Color(0xFF717375),
                                      fontSize: 12.4,
                                      fontFamily: 'Kumbh Sans',
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    listBuilder: gridLayoutBuilder,
                  ),
                  const Gap(15),
                  Obx(() {
                    final isLoading = controllerLocation.isFetchingLocation.value;
                    return GestureDetector(
                      onTap: () {
                        controllerLocation.getCurrentLocation();
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFFF1DC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFF15927),
                              ),
                            )
                                : const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFFF15927),
                            ),
                          ),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLoading ? 'Locating...' : 'Nearby',
                                style: const TextStyle(
                                  color: Color(0xFF4E4E4E),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.29,
                                ),
                              ),
                              const Text(
                                'Find what’s around you',
                                style: TextStyle(
                                  color: Color(0xFF717375),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
          Gap(20),
          Obx(
            () =>
                !whenController.showCalendar.value
                    ? GestureDetector(
                      onTap: whenController.openCalendar,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFE4E9EC),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'When',
                              style: TextStyle(
                                color: Color(0xFF989B9D),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Obx(
                              () => Text(
                                whenController.whenText.value,
                                style: TextStyle(
                                  color: const Color(0xFF3D3F40),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.29,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : const SizedBox(),
          ),

          /// CALENDAR CONTAINER
          Obx(
            () =>
                whenController.showCalendar.value
                    ? Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFE4E9EC),
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'When\'s your trip?',
                            style: TextStyle(
                              color: Color(0xFF090909),
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CalendarDatePicker2WithActionButtons(
                            config: CalendarDatePicker2WithActionButtonsConfig(
                              calendarType: CalendarDatePicker2Type.range,
                              selectedDayHighlightColor: Colors.red,
                              gapBetweenCalendarAndButtons: 4,
                              buttonPadding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              cancelButton: const Text("Cancel"),
                              okButton: const Text("Ok"),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            ),
                            value: whenController.selectedRange,
                            onValueChanged: (dates) {
                              whenController.selectedRange.value = dates;
                            },
                            onCancelTapped: whenController.cancelCalendar,
                            onOkTapped: whenController.confirmRange,
                          ),
                        ],
                      ),
                    )
                    : const SizedBox(),
          ),
          Gap(16),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child:
                  whenController.isOpen.value
                      ? _expandedGuestCard()
                      : _collapsedGuestCard(),
            ),
          ),
          Gap(20),
          Row(
            children: [
              // 🔥 Clear All Button
              InkWell(
                onTap: clearAllFilters,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Clear all',
                      style: TextStyle(
                        color: const Color(0xFF090909),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // const SizedBox(height: 1), // adjust this to increase the gap
                    Container(
                      height: 1, // underline thickness
                      width: 60,   // underline width, adjust if needed
                      color: const Color(0xFF090909), // same as text color
                    ),
                  ],
                )
              ),
              Spacer(),
              // 🔥 Search Button
              InkWell(
                onTap: handleSearch,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF15927),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(Icons.search,color: Colors.white,),
                      Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gap(40),
        ],
      ),
    );
  }

  Widget _buildStepper(
    String title,
    String subtitle,
    int value,
    VoidCallback onIncrement,
    VoidCallback onDecrement,
    bool isIncrementDisabled,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: Icon(Icons.remove_circle_outline),
            ),
            Text(value.toString(), style: TextStyle(fontSize: 16)),
            IconButton(
              onPressed: isIncrementDisabled ? null : onIncrement,
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }



  void onSuggestionSelected(SectionModel suggestion) {
    controllerLocation.selectedSection.value = suggestion;
    controllerLocation.suggestionController.text = "${suggestion.displayName}";
  }

  Future<List<SectionModel>> suggestionsCallback(String pattern) async =>
      controllerLocation.onSectionSearchChange(pattern);

  Widget gridLayoutBuilder(BuildContext context, List<Widget> items) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      children: items,
    );
  }

  Widget _collapsedGuestCard() {
    return GestureDetector(
      key: const ValueKey('collapsed'),
      onTap: whenController.openGuest,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFFE4E9EC)),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          children: const [
            Text(
              'Who',
              style: TextStyle(
                color: Color(0xFF989B9D),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              'Add guests',
              style: TextStyle(
                color: const Color(0xFF3D3F40),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.29,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expandedGuestCard() {
    return Container(
      key: const ValueKey('expanded'),
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFFE4E9EC)),
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Who's coming?",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          _buildStepper(
            "Adults",
            "Ages 13+",
            adults.value,
            incrementAdults,
            decrementAdults,
            isAdultsIncrementDisabled,
          ),
          const SizedBox(height: 16),
          _buildStepper(
            "Children",
            "Ages 2–12",
            children.value,
            incrementChildren,
            decrementChildren,
            isChildrenIncrementDisabled,
          ),
          const SizedBox(height: 16),
          _buildStepper(
            "Infants",
            "Under 2",
            infants.value,
            incrementInfants,
            decrementInfants,
            isInfantsIncrementDisabled,
          ),
          const SizedBox(height: 16),
          _buildStepper(
            "Pets",
            "Service animal?",
            pets.value,
            incrementPets,
            decrementPets,
            isPetIncrementDisabled,
          ),
        ],
      ),
    );
  }
}

enum ImageLayoutType { type1, type2 }
Widget imageGalleryView({
  required String title,
  required ImageLayoutType layoutType,
  required List<String> images,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      const gap = 10.0;

      Widget imageBox({
        required double width,
        required double height,
        required String asset,
      }) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(asset),
              fit: BoxFit.cover,
            ),
          ),
        );
      }

      final unitWidth = (width - gap) / 3;
      final rightImageHeight = (unitWidth * 3 - gap) / 2;

      Widget buildType1() {
        return Column(
          children: [
            imageBox(width: width, height: 200, asset: images[0]),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: imageBox(
                    width: double.infinity,
                    height: 120,
                    asset: images[1],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: imageBox(
                    width: double.infinity,
                    height: 120,
                    asset: images[2],
                  ),
                ),
              ],
            ),
          ],
        );
      }

      Widget buildType2() {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageBox(
              width: unitWidth * 2,
              height: unitWidth * 3,
              asset: images[0],
            ),
            const SizedBox(width: gap),
            Column(
              children: [
                imageBox(
                  width: unitWidth,
                  height: rightImageHeight,
                  asset: images[1],
                ),
                const SizedBox(height: gap),
                imageBox(
                  width: unitWidth,
                  height: rightImageHeight,
                  asset: images[2],
                ),
              ],
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF3D3F40),
              fontSize: 17.25,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          layoutType == ImageLayoutType.type1 ? buildType1() : buildType2(),
        ],
      );
    },
  );
}
// Hello I am Tamim