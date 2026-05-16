import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../../assistance_service/models/public_assistance_params.dart';
import '../../../../generated/assets.dart';
import '../../../assistance_service/controllers/public_assistance_service_controller.dart';
import '../../../assistance_service/models/assistance_listing_response_model.dart';
import '../../../assistance_service/presentation/views/public_assistance_details_screen.dart';
import '../../../assistance_service/presentation/widgets/location_suggestor_text_field_widget.dart';

class AssistanceListSearchScreen extends StatefulWidget {
  const AssistanceListSearchScreen({super.key});

  @override
  State<AssistanceListSearchScreen> createState() => _AssistanceListSearchScreenState();
}

class _AssistanceListSearchScreenState extends State<AssistanceListSearchScreen> {
  final controller = Get.find<PublicAssistanceServiceController>();
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
            LocationSuggesterTextFieldWidget(
              controller: controller.searchController,
              hintText: 'Search location...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              isDense: false,
              isCollapsed: false,
              onSuggestionSelected: (suggestion) async {
                controller.selectedSearchLocation.value = suggestion;
                controller.searchController.text = suggestion.address ?? '';
              },
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
            Obx(() {
                return _buildStepper(
                  "Max guest",
                  controller.children.value,
                  controller.incrementChildren,
                  controller.decrementChildren,
                );
              }
            ),
            Gap(12),
            // Search Button
            GestureDetector(
              onTap: () async {
                // final districtData = controller.districtData.value;
                final selectedPlace = controller.selectedSearchLocation.value;
                if (controller.selectedSearchLocation.value == null) {
                  Fluttertoast.showToast(msg:  'Please type your location');
                  return;
                }

                // Now call fetchListings with only non-null params:
                await controller.fetchListings(
                  latitude: selectedPlace?.latitude,
                  longitude: selectedPlace?.longitude,
                  checkIn: _formattedStartDate,
                  checkOut:_formattedEndDate,
                  maxPersonGet: "${controller.children.value}"
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
                if (controller.isSearchingPublicAssistance.value && controller.listings.isEmpty) {
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
            !controller.isSearchingPublicAssistance.value) {
          controller.fetchListings(); // 👈 loads next page
        }
        return false;
      },
      child: GridView.builder(
        // padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.86, // Square items
        ),
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: controller.listings.length,
        itemBuilder: (context, index) {
          AssistanceListingData item = controller.listings[index];
          return InkWell(
            onTap: () {
              Get.toNamed(
                PublicAssistanceDetailsScreen.route,
                arguments: PublicAssistanceParams(
                  categoryId: controller.params?.categoryId,
                  subcategoryId: controller.params?.subcategoryId,
                  assistanceId: item.uniqueId ?? '',
                ).toJson(),
              );
              controller.fetchAssistanceSingleListingDetails();
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.22),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x15000000),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ✅ Fixed: constrained image with AspectRatio
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        item.coverPhoto ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, data, track) {
                          return Image.asset(
                            Assets.assetsDefaultImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // ✅ Fixed: wrapped in Flexible to prevent overflow
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? '',
                        style: const TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.currentLocationName ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Price ৳${item.price}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
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
              controller.searchErrorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const Gap(24),
          ElevatedButton(
            // onPressed: () => controller.refreshListings(),
            onPressed: () {

            },
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


  Widget _buildStepper(
    String title,
    int value,
    VoidCallback onIncrement,
    VoidCallback onDecrement,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              onPressed: value < 0 ? null : onDecrement,
              icon: Icon(Icons.remove_circle_outline),
            ),
            Text(value.toString(), style: TextStyle(fontSize: 16)),
            IconButton(
              onPressed: onIncrement,
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}

// Hello I am Tamim