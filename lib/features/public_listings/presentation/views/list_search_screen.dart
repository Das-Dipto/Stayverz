import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/public_listing_details_view.dart';
import '../../../../generated/assets.dart';
import '../../../listing/controllers/listing_controller.dart';
import '../../../listing/models/map_suggestions_response_model.dart';
import '../../../wishlist/presentation/controllers/wishlist_controller.dart';
import '../controllers/public_listings_controller.dart';

class ListSearchScreen extends StatefulWidget {
  const ListSearchScreen({super.key});

  @override
  State<ListSearchScreen> createState() => _ListSearchScreenState();
}

class _ListSearchScreenState extends State<ListSearchScreen> {

  final controller = Get.find<PublicListingsController>();

  final ListingController controllerLocation = Get.find<ListingController>();

  void _share(BuildContext context, String link) {
    Share.share(link);
  }

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  DateTime? _startDate;
  DateTime? _endDate;
  String _formattedStartDate = '';
  String _formattedEndDate = '';

  String formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: Colors.red,

        firstDate: DateTime.now().add(
          const Duration(days: 1),
        ), // Disable today and before
        lastDate: DateTime(2100),
      ),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
      value:
          _startDate != null && _endDate != null
              ? [_startDate!, _endDate!]
              : [],
    );

    if (results != null &&
        results.length == 2 &&
        results[0] != null &&
        results[1] != null) {
      setState(() {
        _startDate = results[0]!;
        _endDate = results[1]!;
        _formattedStartDate = formatDate(_startDate!);
        _formattedEndDate = formatDate(_endDate!);
      });
    } else {
      Get.snackbar(
        "Invalid Selection",
        "Please select both start and end dates.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          physics: NeverScrollableScrollPhysics(),
          children: [
            TypeAheadField<PlaceSuggestion>(
              controller: controllerLocation.suggestionController,
              builder: (context, textController, focusNode) => TextField(
                controller: textController,
                focusNode: focusNode,
                autofocus: false,
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
              ),
              decorationBuilder: (context, child) => Material(
                type: MaterialType.card,
                elevation: 6,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                child: child,
              ),
              itemBuilder: (context, suggestion) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        suggestion.address ?? '',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              onSelected: onSuggestionSelected,
              suggestionsCallback: suggestionsCallback,
              itemSeparatorBuilder: (context, index) => Divider(
                color: Colors.grey[300],
                height: 1,
              ),
              listBuilder: gridLayoutBuilder,
            ),

            Gap(10),
            GestureDetector(
              onTap: () => _selectDateRange(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF15925),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    (_formattedStartDate.isNotEmpty && _formattedEndDate.isNotEmpty)
                        ? "From $_formattedStartDate to $_formattedEndDate"
                        : "Select Date Range",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Gap(12),
            // Guest Button
            GestureDetector(
              onTap: () async {
                final result = await showDialog<Map<String, int>>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      insetPadding: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Obx(
                              () => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Close Button
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(Icons.close, size: 18),
                                ),
                              ),

                              const SizedBox(height: 4),

                              // Title
                              Align(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Guests",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Adults Stepper
                              _buildStepper(
                                "Adults",
                                "Ages 13+",
                                controller.adults.value,
                                controller.incrementAdults,
                                controller.decrementAdults,
                                controller.isAdultsIncrementDisabled,
                              ),

                              const SizedBox(height: 8),

                              // Children Stepper
                              _buildStepper(
                                "Children",
                                "Ages 2–12",
                                controller.children.value,
                                controller.incrementChildren,
                                controller.decrementChildren,
                                controller.isAdultsIncrementDisabled,
                              ),

                              const SizedBox(height: 8),

                              // Infants Stepper
                              _buildStepper(
                                "Infants",
                                "Under 2",
                                controller.infants.value,
                                controller.incrementInfants,
                                controller.decrementInfants,
                                controller.isAdultsIncrementDisabled,
                              ),

                              const SizedBox(height: 12),

                              // Save Button
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                    context,
                                    {
                                      'adults': controller.adults.value,
                                      'children': controller.children.value,
                                      'infants': controller.infants.value,
                                    },
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF15925),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

                if (result != null) {
                  controller.adults.value = result['adults'] ?? 0;
                  controller.children.value = result['children'] ?? 0;
                  controller.infants.value = result['infants'] ?? 0;
                }
              },
              child: Obx(() {
                int totalGuests =
                    controller.adults.value +
                        controller.children.value +
                        controller.infants.value;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF15925),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      totalGuests > 0
                          ? "Add Guest ($totalGuests)"
                          : "Add Guest",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ),
            Gap(12),
            // Search Button
            GestureDetector(
              onTap: () async {
                // final districtData = controller.districtData.value;
                final selectedPlace = controllerLocation.selectedPlace.value;
                if (controllerLocation.selectedPlace.value == null) {
                  Fluttertoast.showToast(msg:  'Please type your location');
                  return;
                }
                final Map<String, dynamic> params = {
                  'reset': true,
                  'searchType': 'anywhere',
                };
                // Only add latitude and longitude if available
                if (selectedPlace?.latitude != null) {
                  //   params['latitude'] = districtData!.center.latitude;
                  params['latitude'] =double.tryParse(selectedPlace!.latitude ?? '');
                }
                if (selectedPlace?.longitude!= null) {
                  //  debugPrint(controller.selectedSubDistrict.value?.longitude);
                  params['longitude'] = double.tryParse(selectedPlace!.longitude ?? '');
                }

                if ((selectedPlace?.address ?? '')
                    .isNotEmpty) {
                  params['address'] = selectedPlace!.address;
                }

                final guestsCount =
                    controller.adults.value + controller.children.value;
                if (guestsCount > 0) {
                  params['guests'] = guestsCount;
                }

                if (_formattedStartDate.isNotEmpty) {
                  params['checkIn'] = _formattedStartDate;
                }

                // Now call fetchListings with only non-null params:
                await controller.fetchListings(
                  reset: params['reset'],
                  searchType: params['searchType'],
                  address: params['address'],
                  latitude: params['latitude'],
                  longitude: params['longitude'],
                  guests: params['guests'],
                  checkIn: params['checkIn'],
                    isSearch:"True"
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF15925),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.search, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(16),
            Container(
              margin: EdgeInsets.only(top: 2),
              height: MediaQuery.of(context).size.height * .70,
              child: Obx(() {
                if (controller.isLoading.value && controller.listings.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.hasError.value) {
                  return _buildErrorWidget();
                }
                if (controller.listings.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildListingsGrid();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingsGrid() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            !controller.isLoading.value &&
            controller.hasMoreData.value) {
          controller.fetchListings(); // 👈 loads next page
        }
        return false;
      },
      child: ListView.separated(
        // padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemCount:
            controller.listings.length + (controller.isLoading.value ? 1 : 0),
        separatorBuilder: (context, index) => const Gap(16),
        itemBuilder: (context, index) {
          if (index == controller.listings.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final listing = controller.listings[index];
          return GestureDetector(
            onTap: () {
              // Navigate to my_listing details page
              // This would be implemented in a future update
              Get.to(
                PublicListingDetailsView(),
                arguments: {'id': listing.uniqueId},
              );
            },
            child: Container(
              height: 500,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Image.network(
                      listing.coverPhoto,
                      height: 290,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 290,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.assetsDefaultImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 230,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFF0F1F5) /* Grey-10 */,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            topRight: Radius.circular(18),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(10),
                                  Text(
                                    listing.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF004E70) /* Info */,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Gap(6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                      Gap(5),
                                      Expanded(
                                        child: Text(
                                          listing.address,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(
                                              0xFF33496C,
                                            ) /* Text */,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 1.50,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  Gap(8),
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating: listing.avgRating,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20,
                                        ignoreGestures: true,
                                        itemBuilder:
                                            (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      const Gap(5),
                                      Text(
                                        '(${listing.totalRatingCount})',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(15),
                                  Container(
                                    height: 42,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: const Color(
                                            0xFFE6E8EE,
                                          ) /* Stroke */,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x0C101828),
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'Price: ${listing.price}/- TK',
                                      style: TextStyle(
                                        color: Colors.black /* Black */,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 1.50,
                                      ),
                                    ),
                                  ),
                                  Gap(35),
                                  Container(
                                    width: 44,
                                    height: 40,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF2F2F2) /* BG */,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        final listingId = listing.id;
                                        if (listingId != null) {
                                          Get.find<WishlistController>()
                                              .toggleWishlist(listingId);
                                        }
                                      },
                                      child: Obx(() {
                                        final listingId = listing.id;
                                        final isInWishlist =
                                            listingId != null &&
                                            (Get.find<WishlistController>()
                                                    .inWishlistMap[listingId] ??
                                                false);

                                        return Opacity(
                                          opacity: 0.72,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFFF2F2F2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(9999),
                                              ),
                                            ),
                                            child: Icon(
                                              isInWishlist
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color:
                                                  isInWishlist
                                                      ? const Color(0xFFF15925)
                                                      : Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Gap(10),
                          Container(
                            width: 54,
                            height: 230,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFDCDEE3) /* Grey-30 */,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Gap(10),
                                Icon(
                                  Icons.person_outline_outlined,
                                  color: const Color(0xFF33496C),
                                  size: 16,
                                ),
                                Text(
                                  '${listing.guestCount} person',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF33496C) /* Text */,
                                    fontSize: 9,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Gap(5),
                                Icon(
                                  Icons.roofing_rounded,
                                  color: const Color(0xFF33496C),
                                  size: 16,
                                ),
                                Text(
                                  '${listing.bedroomCount}\n Bedrooms',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF33496C) /* Text */,
                                    fontSize: 9,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Gap(5),
                                Icon(
                                  Icons.bed,
                                  color: const Color(0xFF33496C),
                                  size: 16,
                                ),
                                Text(
                                  '${listing.bedCount} Bed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF33496C) /* Text */,
                                    fontSize: 9,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Gap(5),
                                Icon(
                                  Icons.bathtub_outlined,
                                  color: const Color(0xFF33496C),
                                  size: 16,
                                ),
                                Text(
                                  '${listing.bathroomCount} Baths',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF33496C) /* Text */,
                                    fontSize: 9,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Gap(0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Positioned(
                  //   right: 0,
                  //   bottom: 16,
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width * .68,
                  //     height: 40,
                  //     padding: EdgeInsets.only(left: 70, right: 30),
                  //
                  //     decoration: ShapeDecoration(
                  //       color: const Color(0xFFF15925) /* Brand-color */,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(8),
                  //           bottomLeft: Radius.circular(8),
                  //         ),
                  //       ),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         Text(
                  //           'View Details',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 16,
                  //             fontFamily: 'Inter',
                  //             fontWeight: FontWeight.w600,
                  //             height: 1.50,
                  //           ),
                  //         ),
                  //         Spacer(),
                  //         SizedBox(
                  //           width: 12,
                  //           height: 20,
                  //           child: FittedBox(
                  //             fit: BoxFit.fill,
                  //
                  //             child: Icon(
                  //               Icons.arrow_forward_ios_outlined,
                  //               size: 19,
                  //               color: Colors.white.withOpacity(0.7),
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: 14,
                  //           height: 20,
                  //           child: FittedBox(
                  //             fit: BoxFit.fill,
                  //             child: Icon(
                  //               Icons.arrow_forward_ios_outlined,
                  //               size: 19,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    right: 0,
                    bottom: 16,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .68,
                      height: 40,
                      padding: EdgeInsets.only(left: 70, right: 30),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF15925) /* Brand-color */,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'View Details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 12,
                            height: 20,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 19,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 14,
                            height: 20,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 19,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _share(
                            context,
                            'https://stayverz.com/rooms/${listing.uniqueId}',
                          );
                        },
                        child: Opacity(
                          opacity: 1,
                          child: Container(
                            width: 30,
                            height: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F2F2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                            child: const Icon(
                              Icons.share,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // if (listing.host.currentSuperhostTier != null)
                  //   Positioned(
                  //     left: 10,
                  //     top: 10,
                  //     child: Container(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 10,
                  //         vertical: 4,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(20),
                  //         gradient: LinearGradient(
                  //           colors: [Colors.white, Colors.white],
                  //           begin: Alignment.topLeft,
                  //           end: Alignment.bottomRight,
                  //         ),
                  //         border: Border.all(color: Colors.white, width: 1),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.black.withOpacity(0.2),
                  //             blurRadius: 6,
                  //             offset: const Offset(0, 3),
                  //           ),
                  //         ],
                  //       ),
                  //       child: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           // If you want to show the silver_host icon, uncomment the below line:
                  //           // Image.asset('assets/silver_host.png', height: 18, width: 18),
                  //           // const SizedBox(width: 6),
                  //           Text(
                  //             "${listing.host.currentSuperhostTier}",
                  //             style: const TextStyle(
                  //               color: Colors.black,
                  //               fontWeight: FontWeight.w300,
                  //               fontSize: 12.5,
                  //               shadows: [
                  //                 Shadow(
                  //                   color: Colors.black45,
                  //                   offset: Offset(0.5, 0.5),
                  //                   blurRadius: 1,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const Gap(16),
          Text(
            'No listings found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const Gap(8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const Gap(24),
          // ElevatedButton(
          //   onPressed: () => controller.refreshListings(),
          //   child: const Text('Refresh'),
          // ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const Gap(16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const Gap(24),
          ElevatedButton(
            onPressed: () => controller.refreshListings(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      ),
    );
  }





  Widget itemSeparatorBuilder(BuildContext context, int index) =>
      const Gap(2);

  Future<List<PlaceSuggestion>> suggestionsCallback(String pattern) async =>
      controllerLocation.onPlaceSearchChange(pattern);
  void onSuggestionSelected(PlaceSuggestion suggestion) async {
    controllerLocation.selectedPlace.value = suggestion;
    controllerLocation.suggestionController.text = suggestion.address ?? '';


  }
  Widget gridLayoutBuilder(BuildContext context, List<Widget> items) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      children: items,
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

}

// Hello I am Tamim