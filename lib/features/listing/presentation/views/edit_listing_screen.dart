// ignore_for_file: unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_edit_controller.dart';
import 'package:stayverz_flutter_app/features/listing/models/host_listing_configuration_model.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';
import '../../../../../widgets/edit_listing_item_widget.dart';
import '../../../../../widgets/listing_card_widget.dart';
import '../../../../../widgets/own_title_app_bar.dart';
import '../../../../../features/listing/presentation/views/edit_amenities_listing_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../widgets/compress_file.dart';
import '../../controllers/listing_controller.dart';
import '../../models/map_suggestions_response_model.dart';
import '../create_listing/add_manual_location_screen.dart';

class EditListingScreen extends GetView<ListingEditController> {
  EditListingScreen({super.key});

  final ListingController listingController = Get.find<ListingController>();
  String formatStatus(String status) {
    // Replace underscores with spaces and capitalize each word
    return status
        .split('_')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchListingDetails();
    controller.fetchHostListingConfigurations();

    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Listing details',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.listings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${controller.errorMessage.value}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.refreshListings,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              children: [
                EditListingItem(
                  title: 'Title',
                  value: controller.listingDetails.value?.title ?? '',
                  onPress: () {
                    _showTitleModalBottomSheet();
                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Description',
                  value: controller.listingDetails.value?.description ?? '',
                  onPress: () {
                    _showDescriptionModalBottomSheet();
                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Amenities',
                  value: '',
                  onPress: () {
                    Get.to(
                          () => EditAmenitiesListingScreen(
                        lsit: controller.listingDetails.value?.amenities,
                        uniqueId: controller.listingDetails.value!.uniqueId!,
                      ),
                    )?.then((_) {
                      controller.fetchListingDetails();
                    });

                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Status',
                  value:
                      (controller.listingDetails.value?.status !=
                                  "in_progress" &&
                              controller.listingDetails.value?.status !=
                                  "unpublished")
                          ? "Published"
                          : "Unpublished",
                  onPress: () {
                    _showStatusModalBottomSheet(
                      controller.listingDetails.value?.price ?? 0.0,
                    );
                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Price',
                  value: "৳ ${controller.listingDetails.value?.price}",
                  onPress: () {
                    _showPriceModalBottomSheet(context);
                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Location',
                  value: controller.listingDetails.value?.address ?? '',
                    onPress: () {
                      Get.to(() => AddManualLocationScreen(uniqId: controller.listingDetails.value?.uniqueId,))?.then((_) {
                        controller.fetchListingDetails();
                      });
                    }
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Structure',
                  value: "${controller.listingDetails.value?.categoryName}",
                  onPress: () {
                    structureSelectBottomSheet(context, controller);
                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Place type',
                  value:
                      (controller.listingDetails.value?.placeType ?? '')
                          .replaceAll('_', ' ')
                          .capitalizeFirst ??
                      '',
                  onPress: () {
                    placeTypeSelectBottomSheet(context, controller);
                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Floor Plan',
                  value:
                      'Bedrooms: ${controller.listingDetails.value?.bedroomCount},'
                      ' Beds: ${controller.listingDetails.value?.bedCount}, '
                      'Bathrooms: ${controller.listingDetails.value?.bathroomCount},'
                      ' Guests: ${controller.listingDetails.value?.guestCount}',
                  onPress: () {
                    showFloorPlanBottomSheet(
                      context: context,
                      initialPersons:
                          controller.listingDetails.value!.guestCount!,
                      initialBedrooms:
                          controller.listingDetails.value!.bedroomCount!,
                      initialBeds: controller.listingDetails.value!.bedCount!,
                      initialBathrooms:
                          controller.listingDetails.value!.bathroomCount!,
                      onSave: ({
                        required int persons,
                        required int bedrooms,
                        required int beds,
                        required int bathrooms,
                      }) {
                        controller.goUpdateFloorData(
                          bath: bathrooms,
                          bed: beds,
                          bedroom: bedrooms,
                          guest: persons,
                        );

                        // controller.updateFloorPlan(...) if needed
                      },
                    );
                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Photos',
                  value:
                      'Your photos are a guest’s first impression of your my_listing',
                  onPress: () {
                    if (controller.listingDetails.value == null) {
                      Fluttertoast.showToast(
                        msg: "Please load listing details first",
                        gravity: ToastGravity.TOP,
                      );
                      return;
                    }

                    // Initialize images from listing
                    controller.initializeCategoryImagesFromListing();

                    // Open the management screen
                    Get.to(() => CategoryImageManagementScreen(controller: controller));

                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Instant Book',
                  value:
                      'Turned ${controller.listingDetails.value?.instantBookingAllowed != true ? 'off: Manually Accept or decline booking request.' : 'on'}',
                  onPress: () {
                    final RxBool isInstantBookEnabled = RxBool(
                      controller.listingDetails.value?.instantBookingAllowed ??
                          false,
                    );
                    showInstantBookBottomSheet(
                      context: context,
                      isInstantBookEnabled: isInstantBookEnabled,
                      onChanged: (newValue) {
                        // Optional: call API here or handle logic
                        controller.goUpdateInstantBooking(newValue);
                        // yourController.updateInstantBook(newValue);
                      },
                    );
                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Cancellation Policy',
                  value:
                      '${controller.listingDetails.value?.cancellationPolicy?.policyName}',
                  onPress: () {
                    showCancellationPolicyBottomSheet(
                      context: context,
                      policies:
                          controller
                              .listingConfiguration
                              .value
                              ?.cancellationPolicy ??
                          [],
                      selectedPolicyId:
                          controller
                              .listingDetails
                              .value
                              ?.cancellationPolicy
                              ?.id,
                      controller: controller,
                    );
                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'Trip Duration',
                  value:
                      'Minimum Nights: ${controller.listingDetails.value?.minimumNights}, Maximum Nights: ${controller.listingDetails.value?.maximumNights}',
                  onPress: () {
                    showTripDurationBottomSheet(
                      context: context,
                      initialMinNights:
                          controller.listingDetails.value?.minimumNights,
                      initialMaxNights:
                          controller.listingDetails.value?.maximumNights,
                      onSave: (min, max) {
                        // controller.updateTripDuration(min, max);
                        controller.goUpdateMinMaxNight(
                          maxday: max,
                          minday: min,
                        );
                        //  Get.back();
                      },
                    );
                  },
                ),
                Divider(height: 30, thickness: 0.6),
                EditListingItem(
                  title: 'House rules',
                  value:
                      'Check-in: ${controller.listingDetails.value?.checkIn}, Checkout: ${controller.listingDetails.value?.checkOut}',
                  onPress: () {
                    showHouseRulesBottomSheet(
                      context: context,
                      noSmoking:
                          controller.listingDetails.value!.smokingAllowed!,
                      noPets: controller.listingDetails.value!.petAllowed!,
                      noOutsideGuests:
                          controller
                              .listingDetails
                              .value!
                              .unmarriedCouplesAllowed!,
                      noParties: controller.listingDetails.value!.mediaAllowed!,
                      quietHours:
                          controller.listingDetails.value!.eventAllowed!,
                      initialCheckIn: parseTimeOfDayFrom24Format(
                        controller.listingDetails.value!.checkIn!,
                      ), // e.g. "14:00:00"
                      initialCheckOut: parseTimeOfDayFrom24Format(
                        controller.listingDetails.value!.checkOut!,
                      ), // e.g. "11:00:00"
                      onSave: ({
                        required bool noSmoking,
                        required bool noPets,
                        required bool noParties,
                        required bool quietHours,
                        required bool noOutsideGuests,
                        required TimeOfDay checkInTime,
                        required TimeOfDay checkOutTime,
                      }) {
                        final checkInString = formatTimeOfDayTo24(checkInTime);
                        final checkOutString = formatTimeOfDayTo24(
                          checkOutTime,
                        );
                        controller.goUpdateHouseRule(
                          unmaried: noOutsideGuests,
                          checkIn: checkInString,
                          checkOut: checkOutString,
                          event: quietHours,
                          media: noParties,
                          pet: noPets,
                          smoking: noSmoking,
                        );
                      },
                    );
                  },
                ),
                Divider(height: 30, thickness: 0.6),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showTitleModalBottomSheet() {
    controller.titleController.text =
        controller.listingDetails.value?.title ?? '';
    Get.bottomSheet(
      Obx(() {
        return EditBottomSheet(
          title: 'Edit you Listing',
          isLoading: controller.isUpdating.value,
          onSave: controller.goNextAfterEnteredTitle,
          onCancel: () {
            Get.back();
          },
          child: SingleFieldBottomSheetBody(
            description: 'Write your awesome title',
            label: 'Add Title',
            hitText: 'Enter title',
            textControl: controller.titleController,
          ),
        );
      }),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      isScrollControlled: true,
    );
  }

  void _showDescriptionModalBottomSheet() {
    controller.descriptionController.text =
        controller.listingDetails.value?.description ?? '';
    Get.bottomSheet(
      Obx(() {
        return EditBottomSheet(
          title: 'Edit you Listing',
          isLoading: controller.isUpdating.value,
          onSave: controller.goNextAfterEnteredDescription,
          onCancel: () {
            Get.back();
          },
          child: SingleFieldBottomSheetBody(
            description: 'Write Some awesome Descriptions',
            label: 'Add Description',
            hitText: 'Enter description',
            textControl: controller.descriptionController,
            isTextArea: true,
            keyboardType: TextInputType.multiline,
          ),
        );
      }),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      isScrollControlled: true,
    );
  }

  // void _showStatusModalBottomSheet(double price) {
  //   String selectedStatus = controller.statusController.text.isNotEmpty
  //       ? controller.statusController.text
  //       : 'Unpublished'; // Default to 'Unpublished'
  //
  //   Get.bottomSheet(
  //     EditBottomSheet(
  //       title: 'Edit status',
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //         child: StatefulBuilder(
  //           builder: (context, setState) {
  //             return Column(
  //               children: [
  //                 RadioListTile<String>(
  //                   title: Text(
  //                     'Unpublished',
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 14,
  //                       fontFamily: 'Inter',
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                   value: 'unpublished',
  //                   groupValue: selectedStatus,
  //                   onChanged: (value) {
  //                     setState(() {
  //                       selectedStatus = value!;
  //                       controller.statusController.text = value;
  //                     });
  //                   },
  //                 ),
  //                 RadioListTile<String>(
  //                   title: Text(
  //                     'Published',
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 14,
  //                       fontFamily: 'Inter',
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                   value: 'published',
  //                   groupValue: selectedStatus,
  //                   onChanged: (value) {
  //                     setState(() {
  //                       selectedStatus = value!;
  //                       controller.statusController.text = value;
  //                     });
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       ),
  //       onSave: () {
  //         controller.onPublishClick();
  //         Get.back();// Reads from controller.statusController.text
  //       },
  //       onCancel: () {
  //         Get.back();
  //       },
  //     ),
  //     backgroundColor: Colors.white,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //   );
  // }

  void _showStatusModalBottomSheet(double price) {
    String selectedStatus =
        controller.statusController.text.isNotEmpty
            ? controller.statusController.text
            : 'unpublished'; // default to 'unpublished'

    Get.bottomSheet(
      EditBottomSheet(
        title: 'Edit status',
        child: Builder(
          builder:
              (context) => Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        // Unpublished option
                        RadioListTile<String>(
                          title: const Text(
                            'Unpublished',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          value: 'unpublished',
                          groupValue: selectedStatus,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value!;
                              controller.statusController.text = value;
                            });
                          },
                        ),

                        // Published option
                        // Published option
                        RadioListTile<String>(
                          title: const Text(
                            'Published',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          value: 'published',
                          groupValue: selectedStatus,
                          onChanged: (value) {
                            final title =
                                controller.listingDetails.value?.title ?? '';
                            final amenities =
                                controller.listingDetails.value?.amenities ??
                                [];
                            final description =
                                controller.listingDetails.value?.description ??
                                '';

                            if (price <= 0.0) {
                              Fluttertoast.showToast(
                                msg:
                                    "You cannot publish with price 0.00 or less",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                              return;
                            }

                            if (title.trim().isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Title cannot be empty to publish",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                              return;
                            }

                            if (amenities.isEmpty) {
                              Fluttertoast.showToast(
                                msg:
                                    "At least one amenity is required to publish",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                              return;
                            }

                            if (description.trim().isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Description cannot be empty to publish",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                              return;
                            }

                            // ✅ If all validations pass
                            setState(() {
                              selectedStatus = value!;
                              controller.statusController.text = value;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
        ),
        onSave: () {
          controller.onPublishClick();
          Get.back(); // Reads from controller.statusController.text
        },
        onCancel: () {
          Get.back();
        },
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      isScrollControlled: true,
    );
  }

  void _showPriceModalBottomSheet(BuildContext context) {
    controller.priceController.text =
        "${controller.listingDetails.value?.price ?? 0}";

    final enableLengthDiscount =
        controller.listingDetails.value?.enableLengthOfStayDiscount ?? false;

    final selectedDiscountsRaw =
        controller.listingDetails.value?.lengthOfStayDiscounts;

    Map<String, dynamic> selectedDiscounts = {};
    if (selectedDiscountsRaw != null &&
        selectedDiscountsRaw.toJson() is Map<String, dynamic>) {
      selectedDiscounts = selectedDiscountsRaw.toJson() as Map<String, dynamic>;
    }

    RxBool enableDiscounted = RxBool(enableLengthDiscount);
    RxInt daysSelected = RxInt(0);
    TextEditingController adjustedPricing = TextEditingController();

    // Pre-select one of the existing discounts (3 > 7 > 30)
    if (enableLengthDiscount && selectedDiscounts.isNotEmpty) {
      for (final key in ["3", "7", "30"]) {
        if (selectedDiscounts.containsKey(key)) {
          daysSelected.value = int.parse(key);
          adjustedPricing.text = selectedDiscounts[key].toString();
          break; // stop after first match
        }
      }
    }

    Get.bottomSheet(
      Obx(() {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 30),
          child: EditBottomSheet(
            title: 'Edit pricing',
            isLoading: controller.isUpdating.value,
            onSave:
                () => controller.goNextAfterEnteredPrice({
                  "enable_length_of_stay_discount": enableDiscounted.value,
                  if (enableDiscounted.value && daysSelected.value > 0)
                    "length_of_stay_discounts": {
                      "${daysSelected.value}":
                          int.tryParse(adjustedPricing.text.trim()) ?? 0,
                    },
                }),
            onCancel: () => Get.back(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleFieldBottomSheetBody(
                  description: 'Write Listing Price',
                  label: 'Add Price',
                  hitText: '৳ 00.00',
                  textControl: controller.priceController,
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enable discount option ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      Switch(
                        value: enableDiscounted.value,
                        onChanged: (value) {
                          enableDiscounted.value = value;
                          if (!value) {
                            daysSelected.value = 0;
                            adjustedPricing.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (enableDiscounted.value)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Adjust your pricing to attract more guests.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                if (enableDiscounted.value)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8),
                    child: Row(
                      children: [
                        // Checkbox list for 3,7,30 days wrapped with Obx
                        Row(
                          children:
                              [3, 7, 30].map((day) {
                                return Obx(() {
                                  final isSelected = daysSelected.value == day;
                                  final discountValue =
                                      selectedDiscounts["$day"]?.toString() ?? '';

                                  // Update adjustedPricing.text only if this checkbox got selected
                                  if (isSelected &&
                                      adjustedPricing.text != discountValue) {
                                    adjustedPricing.text = discountValue;
                                  }

                                  return Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (value) {
                                          if (value == true) {
                                            daysSelected.value = day;
                                            adjustedPricing.text = discountValue;
                                          } else {
                                            daysSelected.value = 0;
                                            adjustedPricing.clear();
                                          }
                                        },
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      Text(
                                        '$day Days',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  );
                                });
                              }).toList(),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 65,
                          child: TextField(
                            controller: adjustedPricing,
                            enabled: daysSelected.value != 0,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                              _DiscountMaxValueInputFormatter(max: 100),
                            ],
                            decoration: InputDecoration(
                              hintText: '0%',
                              suffix: Text('%'),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              isDense: true,
                              isCollapsed: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Gap(15),
              ],
            ),
          ),
        );
      }),
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  _showModalBottomShowForWhereILive() {
    Get.bottomSheet(
      WhereILiveBottomSheet(),
      enableDrag: false,
      elevation: 6,
      isDismissible: false,
      backgroundColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
    );
  }

  void structureSelectBottomSheet(
    BuildContext context,
    ListingEditController controller,
  ) {
    final categories = controller.listingConfiguration.value?.categories ?? [];

    // Initialize selected category if not already set
    if (controller.selectedCategoryId!.value == 0 &&
        controller.listingDetails.value?.category != null) {
      controller.selectedCategoryId!.value =
          controller.listingDetails.value!.category!;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16,16, MediaQuery.of(context).viewInsets.bottom + 55),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Choose Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),

              /// Category List
              Obx(() {
                return Column(
                  children:
                      categories.map((category) {
                        final isSelected =
                            controller.selectedCategoryId!.value == category.id;

                        return GestureDetector(
                          onTap: () {
                            controller.selectedCategoryId!.value = category.id!;
                          },
                          child: Stack(
                            children: [
                              Card(
                                margin: EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      /// Category name
                                      Expanded(
                                        child: Text(
                                          category.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),

                                      /// Category Icon (right side)
                                      _buildAmenityIcon(
                                        category.iconMobile ?? '',
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// Checkmark in top-right if selected
                              if (isSelected)
                                Positioned(
                                  top: 9,
                                  left: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF34C759),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.check,
                                      color: const Color(0xFF34C759),
                                      size: 13,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                );
              }),
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  controller.goUpdateAfterSelectingCategory();
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        width: 1,
                        color: Color(0xFFA9A9B0), // Grey-50
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x26000000), // Black with opacity
                        blurRadius: 10,
                        offset: Offset(0, 0),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmenityIcon(String url) {
    if (url.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        url,
        width: 56,
        height: 56,
        placeholderBuilder:
            (context) => const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
      );
    } else {
      return Image.network(
        url,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.error_outline),
      );
    }
  }

  void placeTypeSelectBottomSheet(
    BuildContext context,
    ListingEditController controller,
  ) {
    final placeTypes = controller.listingConfiguration.value?.placeTypes ?? [];

    // Initialize selected value if not already set
    if (controller.selectedPlaceTypeId!.value.isEmpty &&
        controller.listingDetails.value?.placeType != null) {
      controller.selectedPlaceTypeId!.value =
          controller.listingDetails.value!.placeType!;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.0,16,16, MediaQuery.of(context).viewInsets.bottom + 55),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Choose Place Type",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),

              /// PlaceType List
              Obx(() {
                return Column(
                  children:
                      placeTypes
                          .where(
                            (place) => place.name != "Shared Room",
                          ) // ✅ filter here
                          .map((place) {
                            final isSelected =
                                controller.selectedPlaceTypeId!.value ==
                                place.id;

                            return GestureDetector(
                              onTap: () {
                                controller.selectedPlaceTypeId!.value =
                                    place.id!;
                              },
                              child: Container(
                                height: 95,
                                margin: EdgeInsets.only(bottom: 10),
                                width: MediaQuery.of(context).size.width - 40,
                                child: Stack(
                                  children: [
                                    // Card
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: 75,
                                        width:
                                            MediaQuery.of(context).size.width -
                                            40,
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 0.97,
                                              color: const Color(0xFFF0F1F5),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              7.73,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Gap(80),
                                            Container(
                                              width: 3.86,
                                              height: 55.06,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFFF15925),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        9659.23,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Gap(8),
                                            SizedBox(
                                              height: 75,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width -
                                                  180,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Gap(10),
                                                  Text(
                                                    place.name ?? '',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      place.shortDescription ??
                                                          '',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11.59,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.50,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Check icon
                                    if (isSelected)
                                      Positioned(
                                        top: 23,
                                        right: 4,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF34C759),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(3),
                                          child: Icon(
                                            Icons.check,
                                            color: const Color(0xFF34C759),
                                            size: 9,
                                          ),
                                        ),
                                      ),

                                    // Icon
                                    Positioned(
                                      left: 10,
                                      top: 0,
                                      child: Container(
                                        width: 61.15,
                                        height: 61.15,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.63,
                                          vertical: 14.49,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 0.97,
                                              color: const Color(0xFFDCDEE3),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              7.73,
                                            ),
                                          ),
                                        ),
                                        child: _buildAmenityIcon(
                                          place.iconMobile ?? '',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                          .toList(),
                );
              }),

              SizedBox(height: 24),

              GestureDetector(
                onTap: () {
                  controller.goUpdateAfterSelectingPlaceType();
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        width: 1,
                        color: Color(0xFFA9A9B0), // Grey-50
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x26000000), // Black with opacity
                        blurRadius: 10,
                        offset: Offset(0, 0),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void openPhotoUploadBottomSheet(
      BuildContext context,
      ListingEditController controller,
      List<String> uploadedPhotoUrlss, {
        String? coverImage,
      }) {
    final RxList<XFile> selectedNewImages = <XFile>[].obs;
    final RxList<String> existingUrls = uploadedPhotoUrlss.obs;
    final RxString coverImageUrl = ''.obs;
    final RxInt coverImageIndex = (-1).obs;
    final RxBool isCoverFromExisting = true.obs;
    final RxBool isCompressing = false.obs; // ✅ Add compression state

    if (coverImage != null && uploadedPhotoUrlss.contains(coverImage)) {
      coverImageUrl.value = coverImage;
      coverImageIndex.value = uploadedPhotoUrlss.indexOf(coverImage);
      isCoverFromExisting.value = true;
    }

    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16.0,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upload Photos Image",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // ✅ Show compression status
              Obx(() => isCompressing.value
                  ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Compressing images...",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              )
                  : SizedBox()),

              // Select New Images
              SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final images = await picker.pickMultiImage();
                    if (images.isNotEmpty) {
                      isCompressing.value = true;

                      // ✅ Compress each image before adding
                      List<XFile> compressedImages = [];
                      for (var image in images) {
                        final compressed = await compressImage(image);
                        if (compressed != null) {
                          compressedImages.add(compressed);
                        } else {
                          // If compression fails, use original
                          compressedImages.add(image);
                        }
                      }

                      selectedNewImages.addAll(compressedImages);
                      isCompressing.value = false;

                      Fluttertoast.showToast(
                        msg: "Added ${compressedImages.length} image(s)",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                  },
                  icon: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Colors.black87,
                  ),
                  label: Text(
                    "Select Images",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                    side: BorderSide(color: Colors.grey),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),

              SizedBox(height: 16),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // New Selected Images
                      Obx(() {
                        if (selectedNewImages.isEmpty) return SizedBox();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Selected",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: selectedNewImages.length,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(selectedNewImages[index].path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () =>
                                            selectedNewImages.removeAt(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      left: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          coverImageUrl.value =
                                              selectedNewImages[index].path;
                                          coverImageIndex.value = index;
                                          isCoverFromExisting.value = false;
                                        },
                                        child: Obx(
                                              () => Container(
                                            decoration: BoxDecoration(
                                              color: coverImageUrl.value ==
                                                  selectedNewImages[index].path
                                                  ? Colors.green
                                                  : Colors.black.withOpacity(0.5),
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 4,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 3),
                                                Text(
                                                  "Is Cover",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      }),

                      // Existing Uploaded Images (same as before)
                      Obx(() {
                        if (existingUrls.isEmpty) return SizedBox();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Previously Uploaded",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: existingUrls.length,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        existingUrls[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (_, __, ___) =>
                                            Icon(Icons.broken_image),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => existingUrls.removeAt(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      left: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          coverImageUrl.value =
                                          existingUrls[index];
                                          coverImageIndex.value = index;
                                          isCoverFromExisting.value = true;
                                        },
                                        child: Obx(
                                              () => Container(
                                            decoration: BoxDecoration(
                                              color: coverImageUrl.value ==
                                                  existingUrls[index]
                                                  ? Colors.green
                                                  : Colors.black.withOpacity(0.5),
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 4,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  "Cover",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const Gap(16),
              // Submit Button
              Obx(
                    () => GestureDetector(
                  onTap: controller.isUploadingPhotos.value || isCompressing.value
                      ? null
                      : () async {
                    final newPaths =
                    selectedNewImages.map((img) => img.path).toList();
                    List<String> newUploadedUrls = [];

                    // ✅ File size check is now less critical since images are compressed
                    // But you can still keep it as a safeguard
                    int totalBytes = 0;

                    for (final path in newPaths) {
                      final file = File(path);
                      if (await file.exists()) {
                        totalBytes += await file.length();
                      }
                    }

                    const maxSizeInBytes = 20 * 1024 * 1024; // 20 MB

                    if (totalBytes > maxSizeInBytes) {
                      Fluttertoast.showToast(
                        msg:
                        "Total file size exceeds 20 MB. Please select fewer images.",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                      );
                      return;
                    }

                    // Proceed with upload
                    if (newPaths.isNotEmpty) {
                      newUploadedUrls =
                      await controller.uploadMultiplePhotos(newPaths);
                    }

                    final combinedImageUrls = [
                      ...existingUrls,
                      ...newUploadedUrls,
                    ];
                    controller.finalUploadedImages
                        .assignAll(combinedImageUrls);

                    // Set final cover image URL
                    if (coverImageUrl.value.isNotEmpty) {
                      if (isCoverFromExisting.value) {
                        controller.coverImageUrl.value =
                            coverImageUrl.value;
                      } else {
                        final index = coverImageIndex.value;
                        if (index >= 0 && index < newUploadedUrls.length) {
                          controller.coverImageUrl.value =
                          newUploadedUrls[index];
                        }
                      }
                    }

                    controller.goNextAfterUploadedPhotos();

                    Fluttertoast.showToast(
                      msg:
                      "Uploaded ${newUploadedUrls.length} new image(s)\nCover image set.",
                    );
                    Get.back();
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 8,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            width: 1,
                            color: Color(0xFFA9A9B0),
                          ),
                        ),
                      ),
                      child: controller.isUploadingPhotos.value || isCompressing.value
                          ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(),
                      )
                          : Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void openPhotoUploadBottomSheet1(
      BuildContext context,
      ListingEditController controller,
      String imageCategory,
      ) {
    final RxList<XFile> selectedNewImages = <XFile>[].obs;

    // Load existing images for this category
    final RxList<String> existingUrls =
        List<String>.from(controller.getCategoryImages(imageCategory)).obs;

    final RxString coverImageUrl = ''.obs;
    final RxInt coverImageIndex = (-1).obs;
    final RxBool isCoverFromExisting = true.obs;
    final RxBool isCompressing = false.obs;

    final Map<String, String> categoryNames = {
      'images': 'General Images',
      'living_room_images': 'Living Room',
      'kitchen_images': 'Kitchen',
      'bathroom_images': 'Bathroom',
      'bedroom_images': 'Bedroom',
      'washroom_images': 'Washroom',
    };

    // Pre-select cover image if it exists in this category
    if (controller.coverImageUrl.value.isNotEmpty &&
        existingUrls.contains(controller.coverImageUrl.value)) {
      coverImageUrl.value = controller.coverImageUrl.value;
      coverImageIndex.value = existingUrls.indexOf(controller.coverImageUrl.value);
      isCoverFromExisting.value = true;
    }

    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return WillPopScope(
          onWillPop: () async {
            if (isCompressing.value || controller.isUploadingPhotos.value) {
              Fluttertoast.showToast(
                msg: "Please wait for the process to complete",
                gravity: ToastGravity.TOP,
              );
              return false;
            }
            return true;
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16.0,
              16,
              16,
              MediaQuery.of(context).viewInsets.bottom + 50,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Bar with Category Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Photos",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          categoryNames[imageCategory] ?? imageCategory,
                          style: TextStyle(
                            fontSize: 14,
                            color: imageCategory == 'images'
                                ? Colors.blue
                                : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        if (!isCompressing.value &&
                            !controller.isUploadingPhotos.value) {
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please wait for the process to complete",
                            gravity: ToastGravity.TOP,
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Compression Status
                Obx(() => isCompressing.value
                    ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Compressing images...",
                        style: TextStyle(
                          color: imageCategory == 'images'
                              ? Colors.blue
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                )
                    : SizedBox()),

                // Select New Images Button
                SizedBox(
                  height: 40,
                  width: 150,
                  child: ElevatedButton.icon(
                    onPressed: isCompressing.value ||
                        controller.isUploadingPhotos.value
                        ? null
                        : () async {
                      final images = await picker.pickMultiImage();
                      if (images.isNotEmpty) {
                        isCompressing.value = true;

                        List<XFile> compressedImages = [];
                        for (var image in images) {
                          final compressed = await compressImage(image);
                          if (compressed != null) {
                            compressedImages.add(compressed);
                          } else {
                            compressedImages.add(image);
                          }
                        }

                        selectedNewImages.addAll(compressedImages);
                        isCompressing.value = false;

                        Fluttertoast.showToast(
                          msg: "Added ${compressedImages.length} image(s)",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.black87,
                    ),
                    label: Text(
                      "Select Images",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: imageCategory == 'images'
                          ? Colors.blue
                          : Colors.orange,
                      side: BorderSide(color: Colors.grey),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                      shadowColor: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Images Display Area
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Existing Images Section (Show First)
                        Obx(() {
                          if (existingUrls.isEmpty) return SizedBox();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Previously Uploaded (${existingUrls.length})",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (controller.coverImageUrl.value.isNotEmpty &&
                                      existingUrls.contains(controller.coverImageUrl.value))
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.green),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "Has Cover",
                                            style: TextStyle(
                                              color: Colors.green.shade800,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 8),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: existingUrls.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) {
                                  final imageUrl = existingUrls[index];
                                  final isCurrentCover =
                                      controller.coverImageUrl.value == imageUrl;

                                  return Stack(
                                    children: [
                                      // Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          loadingBuilder: (context, child, progress) {
                                            if (progress == null) return child;
                                            return Container(
                                              color: Colors.grey.shade200,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  value: progress.expectedTotalBytes != null
                                                      ? progress.cumulativeBytesLoaded /
                                                      progress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder: (_, __, ___) => Container(
                                            color: Colors.grey.shade300,
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 40,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Remove Button
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Remove Image"),
                                                  content: const Text(
                                                    "Are you sure you want to remove this image?",
                                                  ),
                                                  actions: [
                                                    // ❌ Cancel button
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: const Text("Cancel"),
                                                    ),

                                                    // 🗑 Remove button
                                                    TextButton(
                                                      onPressed: () {
                                                        existingUrls.removeAt(index);

                                                        // Close dialog
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Remove",
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(0.8),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Cover Image Selector
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (isCurrentCover) {
                                              coverImageUrl.value = '';
                                              coverImageIndex.value = -1;
                                            } else {
                                              coverImageUrl.value = imageUrl;
                                              coverImageIndex.value = index;
                                              isCoverFromExisting.value = true;
                                            }
                                          },
                                          child: Obx(
                                                () => Container(
                                              decoration: BoxDecoration(
                                                color: coverImageUrl.value == imageUrl
                                                    ? Colors.green
                                                    : Colors.black.withOpacity(0.6),
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 4,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    coverImageUrl.value == imageUrl
                                                        ? "Cover"
                                                        : "Set Cover",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Main Cover Badge
                                      if (isCurrentCover)
                                        Positioned(
                                          bottom: 4,
                                          right: 4,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "MAIN COVER",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: 16),
                            ],
                          );
                        }),

                        // New Selected Images Section
                        Obx(() {
                          if (selectedNewImages.isEmpty) return SizedBox();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "New Selected (${selectedNewImages.length})",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 8),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: selectedNewImages.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(selectedNewImages[index].path),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),

                                      // Remove Button
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () =>
                                              selectedNewImages.removeAt(index),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(0.8),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Cover Image Selector
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            coverImageUrl.value =
                                                selectedNewImages[index].path;
                                            coverImageIndex.value = index;
                                            isCoverFromExisting.value = false;
                                          },
                                          child: Obx(
                                                () => Container(
                                              decoration: BoxDecoration(
                                                color: coverImageUrl.value ==
                                                    selectedNewImages[index]
                                                        .path
                                                    ? Colors.green
                                                    : Colors.black
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 4,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    "Cover",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: 16),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                const Gap(16),

                // Save Button
                Obx(
                      () => GestureDetector(
                    onTap: controller.isUploadingPhotos.value ||
                        isCompressing.value
                        ? null
                        : () async {
                      final newPaths = selectedNewImages
                          .map((img) => img.path)
                          .toList();
                      List<String> newUploadedUrls = [];

                      // Size check
                      int totalBytes = 0;
                      for (final path in newPaths) {
                        final file = File(path);
                        if (await file.exists()) {
                          totalBytes += await file.length();
                        }
                      }

                      const maxSizeInBytes = 20 * 1024 * 1024;

                      if (totalBytes > maxSizeInBytes) {
                        Fluttertoast.showToast(
                          msg:
                          "Total file size exceeds 20 MB. Please select fewer images.",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }

                      // Upload new images
                      if (newPaths.isNotEmpty) {
                        newUploadedUrls = await controller
                            .uploadCategoryPhotos(newPaths, imageCategory);
                      }

                      // Combine URLs
                      final combinedImageUrls = [
                        ...existingUrls,
                        ...newUploadedUrls,
                      ];

                      // Update category
                      controller.setCategoryImages(
                        imageCategory,
                        combinedImageUrls,
                      );

                      // Set cover image
                      if (coverImageUrl.value.isNotEmpty) {
                        if (isCoverFromExisting.value) {
                          controller.setCoverImage(
                            coverImageUrl.value,
                            imageCategory,
                          );
                        } else {
                          final index = coverImageIndex.value;
                          if (index >= 0 &&
                              index < newUploadedUrls.length) {
                            controller.setCoverImage(
                              newUploadedUrls[index],
                              imageCategory,
                            );
                          }
                        }
                      }

                      // Update backend
                      await controller.goNextAfterUploadedPhotos();

                      Fluttertoast.showToast(
                        msg: newUploadedUrls.isEmpty
                            ? "Updated ${categoryNames[imageCategory]} images"
                            : "Uploaded ${newUploadedUrls.length} new image(s) to ${categoryNames[imageCategory]}",
                      );
                      Get.back();
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 8,
                        ),
                        decoration: ShapeDecoration(
                          color: controller.isUploadingPhotos.value ||
                              isCompressing.value
                              ? Colors.grey.shade300
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              width: 1,
                              color: Color(0xFFA9A9B0),
                            ),
                          ),
                        ),
                        child: controller.isUploadingPhotos.value ||
                            isCompressing.value
                            ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void showInstantBookBottomSheet({
    required BuildContext context,
    required RxBool isInstantBookEnabled,
    required void Function(bool newValue) onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit your Listing",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Use Instant Book",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 12),

              // Description
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Turn on to automatically accept bookings. Turn off to manually accept or decline booking requests.",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 20),

              // Custom Toggle with Arrow Icon
              Obx(
                () => GestureDetector(
                  onTap: () {
                    isInstantBookEnabled.toggle();
                    onChanged(isInstantBookEnabled.value);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 70,
                    height: 34,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color:
                          isInstantBookEnabled.value
                              ? Colors.orange
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedAlign(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          alignment:
                              isInstantBookEnabled.value
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isInstantBookEnabled.value
                                  ? Icons.arrow_forward_ios
                                  : Icons.arrow_back_ios_new,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showCancellationPolicyBottomSheet({
    required BuildContext context,
    required List<CancellationPolicy> policies,
    required int? selectedPolicyId,
    required ListingEditController controller,
  }) {
    final RxInt selectedIndex =
        (policies.indexWhere((p) => p.id == selectedPolicyId)).obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Cancellation Policy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: policies.length,
                itemBuilder: (context, index) {
                  final policy = policies[index];
                  return Obx(() {
                    final isSelected = selectedIndex.value == index;
                    return GestureDetector(
                      onTap: () => selectedIndex.value = index,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.orangeAccent
                                        : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  policy.policyName ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  policy.description ?? '',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.orangeAccent,
                                size: 24,
                              ),
                            ),
                        ],
                      ),
                    );
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedIndex.value >= 0 &&
                      selectedIndex.value < policies.length) {
                    final selectedPolicy = policies[selectedIndex.value];
                    controller.goUpdatePolicy(
                      id: selectedPolicy.id!,
                      day: selectedPolicy.cancellationDeadline!,
                      des: selectedPolicy.description!,
                      name: selectedPolicy.policyName!,
                      percent: selectedPolicy.refundPercentage!,
                    );
                  } else {
                  }
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showTripDurationBottomSheet({
    required BuildContext context,
    required void Function(int minNights, int maxNights) onSave,
    int? initialMinNights,
    int? initialMaxNights,
  }) {
    final minNightsController = TextEditingController(
      text: initialMinNights?.toString() ?? '',
    );
    final maxNightsController = TextEditingController(
      text: initialMaxNights?.toString() ?? '',
    );

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 60,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Trip Duration",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Min Nights Field
                TextFormField(
                  controller: minNightsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Min Nights",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final number = int.tryParse(value ?? '');
                    if (number == null || number < 1) {
                      return 'Min nights must be at least 1';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Max Nights Field
                TextFormField(
                  controller: maxNightsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Max Nights",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final min = int.tryParse(minNightsController.text);
                    final max = int.tryParse(value ?? '');
                    if (max == null || min == null) {
                      return 'Please enter a valid number';
                    }
                    if (max < min) {
                      return 'Max nights must be ≥ Min nights';
                    }
                    if (max < 1) {
                      return 'Max nights must be at least 1';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final min = int.parse(minNightsController.text);
                      final max = int.parse(maxNightsController.text);
                      onSave(min, max);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void showHouseRulesBottomSheet({
    required BuildContext context,
    required void Function({
      required bool noSmoking,
      required bool noPets,
      required bool noParties,
      required bool quietHours,
      required bool noOutsideGuests,
      required TimeOfDay checkInTime,
      required TimeOfDay checkOutTime,
    })
    onSave,
    bool noSmoking = false,
    bool noPets = false,
    bool noParties = false,
    bool quietHours = false,
    bool noOutsideGuests = false,
    TimeOfDay? initialCheckIn,
    TimeOfDay? initialCheckOut,
  }) {
    final RxBool rxNoSmoking = noSmoking.obs;
    final RxBool rxNoPets = noPets.obs;
    final RxBool rxNoParties = noParties.obs;
    final RxBool rxQuietHours = quietHours.obs;
    final RxBool rxNoOutsideGuests = noOutsideGuests.obs;

    final Rx<TimeOfDay> checkInTime = Rx<TimeOfDay>(
      initialCheckIn ?? const TimeOfDay(hour: 14, minute: 0),
    );
    final Rx<TimeOfDay> checkOutTime = Rx<TimeOfDay>(
      initialCheckOut ?? const TimeOfDay(hour: 11, minute: 0),
    );

    Future<void> pickTime(Rx<TimeOfDay> target) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: target.value,
      );
      if (picked != null) target.value = picked;
    }

    String formatTime(TimeOfDay time) {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? "AM" : "PM";
      return "$hour:$minute $period";
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "House Rules",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => CheckboxListTile(
                      title: const Text("Smoking Allowed"),
                      value: rxNoSmoking.value,
                      onChanged: (val) => rxNoSmoking.value = val ?? false,
                    ),
                  ),
                  Obx(
                    () => CheckboxListTile(
                      title: const Text("Pets Allowed"),
                      value: rxNoPets.value,
                      onChanged: (val) => rxNoPets.value = val ?? false,
                    ),
                  ),
                  Obx(
                    () => CheckboxListTile(
                      title: const Text("Media Allowed"),
                      value: rxNoParties.value,
                      onChanged: (val) => rxNoParties.value = val ?? false,
                    ),
                  ),
                  Obx(
                    () => CheckboxListTile(
                      title: const Text("Event Allowed"),
                      value: rxQuietHours.value,
                      onChanged: (val) => rxQuietHours.value = val ?? false,
                    ),
                  ),
                  Obx(
                    () => CheckboxListTile(
                      title: const Text("Unmarried Couples Allowed"),
                      value: rxNoOutsideGuests.value,
                      onChanged:
                          (val) => rxNoOutsideGuests.value = val ?? false,
                    ),
                  ),

                  const Divider(height: 30),

                  Obx(
                    () => ListTile(
                      onTap: () => pickTime(checkInTime),

                      title: const Text("Check-In Time"),
                      trailing: Text(formatTime(checkInTime.value)),
                    ),
                  ),
                  Obx(
                    () => ListTile(
                      onTap: () => pickTime(checkOutTime),
                      title: const Text("Check-Out Time"),
                      trailing: Text(formatTime(checkOutTime.value)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      onSave(
                        noSmoking: rxNoSmoking.value,
                        noPets: rxNoPets.value,
                        noParties: rxNoParties.value,
                        quietHours: rxQuietHours.value,
                        noOutsideGuests: rxNoOutsideGuests.value,
                        checkInTime: checkInTime.value,
                        checkOutTime: checkOutTime.value,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Save"),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TimeOfDay parseTimeOfDayFrom24Format(String timeString) {
    final parts = timeString.split(':');
    if (parts.length < 2) {
      throw FormatException("Invalid time format: $timeString");
    }

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  String formatTimeOfDayTo24(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  void showFloorPlanBottomSheet({
    required BuildContext context,
    int initialPersons = 0,
    int initialBedrooms = 0,
    int initialBeds = 0,
    int initialBathrooms = 0,
    required void Function({
      required int persons,
      required int bedrooms,
      required int beds,
      required int bathrooms,
    })
    onSave,
  }) {
    final RxInt persons = initialPersons.obs;
    final RxInt bedrooms = initialBedrooms.obs;
    final RxInt beds = initialBeds.obs;
    final RxInt bathrooms = initialBathrooms.obs;

    Widget buildCounter(String label, Icon iconAsset, RxInt value) {
      return Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              iconAsset,
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 16)),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (value.value > 0) value.value--;
                    },
                  ),
                  Container(
                    width: 28,
                    alignment: Alignment.center,
                    child: Text(
                      value.value.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      value.value++;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Floor Plan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              buildCounter(
                "Persons",
                Icon(Icons.person_outline_outlined),
                persons,
              ),
              buildCounter("Bedrooms", Icon(Icons.roofing), bedrooms),
              buildCounter("Beds", Icon(Icons.bed), beds),
              buildCounter("Bathrooms", Icon(Icons.bathtub), bathrooms),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  onSave(
                    persons: persons.value,
                    bedrooms: bedrooms.value,
                    beds: beds.value,
                    bathrooms: bathrooms.value,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Save"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class EditBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isLoading;
  final Function()? onSave, onCancel;

  const EditBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.onSave,
    this.onCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: true,
      minimum: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: bottomInset > 0 ? 20 : 0,
        ),
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 18, left: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                      ),
                      const Gap(12),
                      SizedBox(
                        height: 20,
                        child: TextButton.icon(
                          onPressed: onCancel,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                          ),
                          iconAlignment: IconAlignment.end,
                          icon: Icon(Icons.close),
                          label: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ),
                      ),
                      const Gap(12),
                      SizedBox(
                        height: 20,
                        child: TextButton.icon(
                          onPressed: isLoading ? null : onSave,
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          iconAlignment: IconAlignment.end,
                          icon:
                              isLoading
                                  ? SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 0.6,
                                    ),
                                  )
                                  : Icon(Icons.check),
                          label: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 30),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SingleFieldBottomSheetBody extends GetView<ListingEditController> {
  final String description, label, hitText;
  final TextEditingController textControl;
  final TextInputType? keyboardType;
  final bool isTextArea;
  const SingleFieldBottomSheetBody({
    super.key,
    required this.description,
    required this.label,
    required this.hitText,
    required this.textControl,
    this.keyboardType,
    this.isTextArea = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            description,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          const Gap(12),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          const Gap(8),
           Builder(
            builder: (context) {
              final rawText = textControl.text;
              if (rawText.contains('<') && rawText.contains('>')) {
                final stripped = rawText
                    .replaceAll(RegExp(r'<[^>]*>'), '')
                    .replaceAll('&nbsp;', ' ')
                    .replaceAll('&amp;', '&')
                    .replaceAll('&lt;', '<')
                    .replaceAll('&gt;', '>')
                    .replaceAll('&quot;', '"')
                    .trim();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (textControl.text != stripped) {
                    textControl.text = stripped;
                    textControl.selection = TextSelection.collapsed(
                      offset: stripped.length,
                    );
                  }
                });
              }
              return CustomInputText(
                controller: textControl,
                helperText: hitText,
                keyboardType: keyboardType,
                maxLines: isTextArea ? null : 1,
              );
            },
          ),
          const Gap(18),
        ],
      ),
    );
  }
}

class WhereILiveBottomSheet extends StatelessWidget {
  WhereILiveBottomSheet({super.key});

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final ListingController controller = Get.find<ListingController>();
  final ListingEditController editController =
      Get.find<ListingEditController>();

  @override
  Widget build(BuildContext context) {
    // Check if there's existing location data and show marker
    _showExistingLocationMarker();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 50),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: Obx(
              () => GoogleMap(
                mapType: MapType.terrain,
                initialCameraPosition: _kGooglePlex,
                markers:
                    controller.selectedMarker.value != null
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
            child: Row(
              children: [
                Expanded(
                  child: TypeAheadField<PlaceSuggestion>(
                    controller: controller.suggestionController,
                    builder:
                        (context, textController, focusNode) => TextField(
                          controller: textController,
                          focusNode: focusNode,
                          autofocus: false,
                          style: DefaultTextStyle.of(
                            context,
                          ).style.copyWith(fontStyle: FontStyle.italic),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search...',
                            isDense: true,
                            isCollapsed: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                    decorationBuilder:
                        (context, child) => Material(
                          type: MaterialType.card,
                          elevation: 4,
                          borderRadius: BorderRadius.circular(6),
                          child: child,
                        ),
                    itemBuilder:
                        (context, suggestion) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6,
                          ),
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
                const Gap(8),
                IconButton.filled(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 6,
                  ),
                  icon: const Icon(Icons.close, color: Colors.black),
                ),
                // IconButton.filled(
                //   onPressed: () {
                //     // Save or confirm action
                //     Get.back();
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: AppColors.primaryColor,
                //     elevation: 6,
                //   ),
                //   icon: const Icon(Icons.check, color: Colors.black),
                // ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: () async {
                final selectedPlace = controller.selectedPlace.value;

                if (selectedPlace != null) {
                  final lat = double.tryParse(selectedPlace.latitude ?? '');
                  final lng = double.tryParse(selectedPlace.longitude ?? '');
                  final address = selectedPlace.address ?? '';

                  editController.onUpdateLocation(
                    long: lng!,
                    lat: lat!,
                    location: address,
                  );

                  Get.back();
                } else {
                  Get.snackbar(
                    'Warning',
                    'Please select a location from search.',
                  );
                }
              },
              child: Container(
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSuggestionSelected(PlaceSuggestion suggestion) async {
    controller.selectedPlace.value = suggestion;
    controller.suggestionController.text = suggestion.address ?? '';

    final double? lat = double.tryParse(suggestion.latitude ?? '');
    final double? lng = double.tryParse(suggestion.longitude ?? '');

    if (lat != null && lng != null) {
      final GoogleMapController mapController = await _controller.future;

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
        ),
      );

      controller.selectedMarker.value = Marker(
        markerId: const MarkerId('selected-location'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: suggestion.address),
      );
    } else {
    }
  }

  void _showExistingLocationMarker() {
    final listingDetails = editController.listingDetails.value;

    // Check if latitude and longitude are not empty/null
    if (listingDetails?.latitude != null &&
        listingDetails?.longitude != null &&
        listingDetails!.latitude != 0.0 &&
        listingDetails!.longitude != 0.0) {
      // Create marker for existing address
      final existingMarker = Marker(
        markerId: const MarkerId('existing-location'),
        position: LatLng(listingDetails.latitude!, listingDetails.longitude!),
        draggable: true,
        infoWindow: InfoWindow(
          title: listingDetails.title ?? 'Current Location',
          snippet: listingDetails.address ?? '',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor
              .hueRed, // Different color to distinguish from new selection
        ),
      );

      // Set the marker and update camera position
      controller.selectedMarker.value = existingMarker;

      // Move camera to existing location
      _controller.future.then((mapController) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                listingDetails.latitude!,
                listingDetails.longitude!,
              ),
              zoom: 16.0,
            ),
          ),
        );
      });

      // Pre-fill the search field with existing address
      controller.suggestionController.text = listingDetails.address ?? '';
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

class _DiscountMaxValueInputFormatter extends TextInputFormatter {
  final int max;

  _DiscountMaxValueInputFormatter({required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    try {
      final int? value = int.tryParse(newValue.text);
      if (value == null || value > max) {
        return oldValue;
      }
      return newValue;
    } catch (_) {
      return oldValue;
    }
  }
}

class CategoryImageUploadWidget extends StatelessWidget {
  final ListingEditController controller;

  const CategoryImageUploadWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxString selectedCategory = 'images'.obs;

    final Map<String, IconData> categoryIcons = {
      'images': Icons.photo_library,
      'living_room_images': Icons.weekend,
      'kitchen_images': Icons.kitchen,
      'bathroom_images': Icons.bathtub,
      'bedroom_images': Icons.bed,
      'washroom_images': Icons.wc,
    };

    final Map<String, String> categoryNames = {
      'images': 'General Images',
      'living_room_images': 'Living Room',
      'kitchen_images': 'Kitchen',
      'bathroom_images': 'Bathroom',
      'bedroom_images': 'Bedroom',
      'washroom_images': 'Washroom',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Property Images",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(() {
              final total = controller.getTotalImageCount();
              return total > 0
                  ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: Text(
                  "$total Total Images",
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
                  : SizedBox();
            }),
          ],
        ),
        SizedBox(height: 12),

        // Cover Image Display
        Obx(() {
          if (controller.coverImageUrl.value.isEmpty) return SizedBox();

          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200, width: 2),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    controller.coverImageUrl.value,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.broken_image),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.green.shade700,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Main Cover Image",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      if (controller.coverImageCategory.value.isNotEmpty)
                        Text(
                          "From: ${categoryNames[controller.coverImageCategory.value] ?? controller.coverImageCategory.value}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    controller.coverImageUrl.value = '';
                    controller.coverImageCategory.value = '';
                  },
                  tooltip: "Remove cover image",
                ),
              ],
            ),
          );
        }),

        // Category Dropdown
        Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButton<String>(
            value: selectedCategory.value,
            isExpanded: true,
            underline: SizedBox(),
            icon: Icon(Icons.arrow_drop_down),
            items: categoryNames.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Row(
                  children: [
                    Icon(
                      categoryIcons[entry.key],
                      size: 20,
                      color: entry.key == 'images'
                          ? Colors.blue
                          : Colors.orange,
                    ),
                    SizedBox(width: 12),
                    Text(
                      entry.value,
                      style: TextStyle(
                        fontWeight: entry.key == 'images'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                    Obx(() {
                      final count =
                          controller.getCategoryImages(entry.key).length;
                      return count > 0
                          ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: entry.key == 'images'
                              ? Colors.blue
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : SizedBox();
                    }),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                selectedCategory.value = value;
              }
            },
          ),
        )),

        SizedBox(height: 16),

        // Upload Button
        Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              openPhotoUploadBottomSheet(
                context,
                controller,
                selectedCategory.value,
              );
            },
            icon: Icon(Icons.cloud_upload),
            label: Text(
              "Upload ${categoryNames[selectedCategory.value]} Photos",
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedCategory.value == 'images'
                  ? Colors.blue
                  : Colors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        )),

        SizedBox(height: 16),

        // Preview Grid
        Obx(() {
          final images = controller.getCategoryImages(selectedCategory.value);

          if (images.isEmpty) {
            return Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      categoryIcons[selectedCategory.value],
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "No images uploaded for ${categoryNames[selectedCategory.value]}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Tap the button above to add images",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${categoryNames[selectedCategory.value]} (${images.length})",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final imageUrl = images[index];
                  final isMainCover = controller.isCoverImage(imageUrl);

                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey.shade200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                      if (isMainCover)
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  "Cover",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        }),
      ],
    );
  }
  void openPhotoUploadBottomSheet(
      BuildContext context,
      ListingEditController controller,
      String imageCategory,
      ) {
    final RxList<XFile> selectedNewImages = <XFile>[].obs;

    // Load existing images for this category
    final RxList<String> existingUrls =
        List<String>.from(controller.getCategoryImages(imageCategory)).obs;

    final RxString coverImageUrl = ''.obs;
    final RxInt coverImageIndex = (-1).obs;
    final RxBool isCoverFromExisting = true.obs;
    final RxBool isCompressing = false.obs;

    final Map<String, String> categoryNames = {
      'images': 'General Images',
      'living_room_images': 'Living Room',
      'kitchen_images': 'Kitchen',
      'bathroom_images': 'Bathroom',
      'bedroom_images': 'Bedroom',
      'washroom_images': 'Washroom',
    };

    // Pre-select cover image if it exists in this category
    if (controller.coverImageUrl.value.isNotEmpty &&
        existingUrls.contains(controller.coverImageUrl.value)) {
      coverImageUrl.value = controller.coverImageUrl.value;
      coverImageIndex.value = existingUrls.indexOf(controller.coverImageUrl.value);
      isCoverFromExisting.value = true;
    }

    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return WillPopScope(
          onWillPop: () async {
            if (isCompressing.value || controller.isUploadingPhotos.value) {
              Fluttertoast.showToast(
                msg: "Please wait for the process to complete",
                gravity: ToastGravity.TOP,
              );
              return false;
            }
            return true;
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16.0,
              16,
              16,
              MediaQuery.of(context).viewInsets.bottom + 50,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Bar with Category Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upload Photos",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            categoryNames[imageCategory] ?? imageCategory,
                            style: TextStyle(
                              fontSize: 14,
                              color: imageCategory == 'images'
                                  ? Colors.blue
                                  : Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          if (!isCompressing.value &&
                              !controller.isUploadingPhotos.value) {
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please wait for the process to complete",
                              gravity: ToastGravity.TOP,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Compression Status
                  Obx(() => isCompressing.value
                      ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Compressing images...",
                          style: TextStyle(
                            color: imageCategory == 'images'
                                ? Colors.blue
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  )
                      : SizedBox()),

                  // Select New Images Button
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton.icon(
                      onPressed: isCompressing.value ||
                          controller.isUploadingPhotos.value
                          ? null
                          : () async {
                        final images = await picker.pickMultiImage();
                        if (images.isNotEmpty) {
                          isCompressing.value = true;

                          List<XFile> compressedImages = [];
                          for (var image in images) {
                            final compressed = await compressImage(image);
                            if (compressed != null) {
                              compressedImages.add(compressed);
                            } else {
                              compressedImages.add(image);
                            }
                          }

                          selectedNewImages.addAll(compressedImages);
                          isCompressing.value = false;

                          Fluttertoast.showToast(
                            msg: "Added ${compressedImages.length} image(s)",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        }
                      },
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.black87,
                      ),
                      label: Text(
                        "Select Images",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: imageCategory == 'images'
                            ? Colors.blue
                            : Colors.orange,
                        side: BorderSide(color: Colors.grey),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                        shadowColor: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Images Display Area
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Existing Images Section (Show First)
                          Obx(() {
                            if (existingUrls.isEmpty) return SizedBox();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Previously Uploaded (${existingUrls.length})",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (controller.coverImageUrl.value.isNotEmpty &&
                                        existingUrls.contains(controller.coverImageUrl.value))
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.green),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 12,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "Has Cover",
                                              style: TextStyle(
                                                color: Colors.green.shade800,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: existingUrls.length,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    final imageUrl = existingUrls[index];
                                    final isCurrentCover =
                                        controller.coverImageUrl.value == imageUrl;

                                    return Stack(
                                      children: [
                                        // Image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return Container(
                                                color: Colors.grey.shade200,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    value: progress.expectedTotalBytes != null
                                                        ? progress.cumulativeBytesLoaded /
                                                        progress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder: (_, __, ___) => Container(
                                              color: Colors.grey.shade300,
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 40,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Remove Button
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("Remove Image"),
                                                    content: const Text(
                                                      "Are you sure you want to remove this image?",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: const Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          existingUrls.removeAt(index);
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text(
                                                          "Remove",
                                                          style: TextStyle(color: Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.8),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Cover Image Selector
                                        Positioned(
                                          top: 4,
                                          left: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (isCurrentCover) {
                                                coverImageUrl.value = '';
                                                coverImageIndex.value = -1;
                                              } else {
                                                coverImageUrl.value = imageUrl;
                                                coverImageIndex.value = index;
                                                isCoverFromExisting.value = true;
                                              }
                                            },
                                            child: Obx(
                                                  () => Container(
                                                decoration: BoxDecoration(
                                                  color: coverImageUrl.value == imageUrl
                                                      ? Colors.green
                                                      : Colors.black.withOpacity(0.6),
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 4,
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      coverImageUrl.value == imageUrl
                                                          ? "Cover"
                                                          : "Set Cover",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Main Cover Badge
                                        if (isCurrentCover)
                                          Positioned(
                                            bottom: 4,
                                            right: 4,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "MAIN COVER",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 16),
                              ],
                            );
                          }),

                          // New Selected Images Section
                          Obx(() {
                            if (selectedNewImages.isEmpty) return SizedBox();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "New Selected (${selectedNewImages.length})",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 8),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: selectedNewImages.length,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            File(selectedNewImages[index].path),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),

                                        // Remove Button
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () =>
                                                selectedNewImages.removeAt(index),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.8),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Cover Image Selector
                                        Positioned(
                                          top: 4,
                                          left: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              coverImageUrl.value =
                                                  selectedNewImages[index].path;
                                              coverImageIndex.value = index;
                                              isCoverFromExisting.value = false;
                                            },
                                            child: Obx(
                                                  () => Container(
                                                decoration: BoxDecoration(
                                                  color: coverImageUrl.value ==
                                                      selectedNewImages[index]
                                                          .path
                                                      ? Colors.green
                                                      : Colors.black
                                                      .withOpacity(0.6),
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 4,
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      "Cover",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 16),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const Gap(16),
                  // Save Button
                  Obx(
                        () => GestureDetector(
                      onTap: controller.isUploadingPhotos.value ||
                          isCompressing.value
                          ? null
                          : () async {
                        final newPaths = selectedNewImages
                            .map((img) => img.path)
                            .toList();
                        List<String> newUploadedUrls = [];

                        // Size check
                        int totalBytes = 0;
                        for (final path in newPaths) {
                          final file = File(path);
                          if (await file.exists()) {
                            totalBytes += await file.length();
                          }
                        }

                        const maxSizeInBytes = 20 * 1024 * 1024;

                        if (totalBytes > maxSizeInBytes) {
                          Fluttertoast.showToast(
                            msg:
                            "Total file size exceeds 20 MB. Please select fewer images.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }

                        // Upload new images
                        if (newPaths.isNotEmpty) {
                          newUploadedUrls = await controller
                              .uploadCategoryPhotos(newPaths, imageCategory);
                        }

                        // Combine URLs
                        final combinedImageUrls = [
                          ...existingUrls,
                          ...newUploadedUrls,
                        ];

                        // Update category
                        controller.setCategoryImages(
                          imageCategory,
                          combinedImageUrls,
                        );

                        // Set cover image
                        if (coverImageUrl.value.isNotEmpty) {
                          if (isCoverFromExisting.value) {
                            controller.setCoverImage(
                              coverImageUrl.value,
                              imageCategory,
                            );
                          } else {
                            final index = coverImageIndex.value;
                            if (index >= 0 &&
                                index < newUploadedUrls.length) {
                              controller.setCoverImage(
                                newUploadedUrls[index],
                                imageCategory,
                              );
                            }
                          }
                        }

                        // Update backend
                        await controller.goNextAfterUploadedPhotosData();

                        Fluttertoast.showToast(
                          msg: newUploadedUrls.isEmpty
                              ? "Updated ${categoryNames[imageCategory]} images"
                              : "Uploaded ${newUploadedUrls.length} new image(s) to ${categoryNames[imageCategory]}",
                        );
                        Get.back();
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 8,
                          ),
                          decoration: ShapeDecoration(
                            color: controller.isUploadingPhotos.value ||
                                isCompressing.value
                                ? Colors.grey.shade300
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                width: 1,
                                color: Color(0xFFA9A9B0),
                              ),
                            ),
                          ),
                          child: controller.isUploadingPhotos.value ||
                              isCompressing.value
                              ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            "Saves",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategoryImageManagementScreen extends StatelessWidget {
  final ListingEditController controller;

  const CategoryImageManagementScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Property Images"),
        backgroundColor: Colors.white,
         foregroundColor: Colors.black,
        actions: [
          Obx(() {
            final hasImages = controller.getTotalImageCount() > 0;
            return SizedBox(
              height: 23,
              child: InkWell(
                onTap: hasImages
                    ? () async {
                  await controller.goNextAfterUploadedPhotos();
                  Get.back();
                }
                    : null,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 126,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check, size: 18, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        "Save All",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CategoryImageUploadWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}

// Hello I am Tamim