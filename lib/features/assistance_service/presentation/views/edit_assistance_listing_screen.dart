import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';
import '../../../../../widgets/edit_listing_item_widget.dart';
import '../../../../../widgets/own_title_app_bar.dart';
import '../../controllers/assistance_service_controller.dart';
import '../../controllers/assistance_service_edit_controller.dart';
import 'package:stayverz_flutter_app/features/listing/models/map_suggestions_response_model.dart';
import '../../models/assistance_cancellation_polices_response.dart';
import '../widgets/location_suggestor_text_field_widget.dart';


class EditAssistanceListingScreen extends GetView<AssistanceServiceEditController> {

   EditAssistanceListingScreen({super.key});

  final AssistanceServiceController listingController = Get.find<AssistanceServiceController>();
   String formatStatus(String status) {
     // Replace underscores with spaces and capitalize each word
     return status.split('_').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ');
   }


String _stripHtml(String? input) {
  if (input == null || input.trim().isEmpty) return '';

  print("🔍 RAW: $input");

  String result = input;

  // Remove all tags including attributes
  result = result.replaceAll(RegExp(r'<[^>]*>', caseSensitive: false), ' ');

  // Decode entities
  result = result
      .replaceAll('&amp;', '&')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'");

  result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

  print("✅ CLEANED: $result");
  return result;
}

   @override
    Widget build(BuildContext context) {

      controller.fetchAssistanceSingleListingDetails();
      controller.fetchAssistanceCategory();
      controller.fetchAssistanceCancellationPolices();

      return Scaffold(
        appBar: OwnTitleAppBar(
          appBarText: 'Listing details',
          fontColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Obx(() {
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
                    title: 'Title of Assistance',
                    value: controller.listingDetails.value?.title ?? '',
                    onPress: () {
                      _showTitleModalBottomSheet();
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'About you',
                    value: controller.listingDetails.value?.aboutYou ?? '',
                    onPress: () {
                      _showAboutYouModalBottomSheet();
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Current location',
                    value: controller.listingDetails.value?.currentLocationName ?? '',
                    onPress: () {
                      _showCurrentLocationModalBottomSheet();
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Coverage Area',
                    value: controller.listingDetails.value?.coverageAreaName ?? '',
                    onPress: () {
                      _showCoverageAreaModalBottomSheet();
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Describe your Assistance',
                    value: controller.listingDetails.value?.assistanceDescription ?? '',
                    onPress: () {
                      _showDescribeAssistanceModalBottomSheet();
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Details',
                    value: controller.listingDetails.value?.details ?? '',
                    onPress: () {
                      _showDescriptionModalBottomSheet();
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Meetup point',
                    value: controller.listingDetails.value?.meetupPointName ?? '',
                    onPress: _showModalBottomShowForWhereILive,
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Max participation',
                    value: "${controller.listingDetails.value?.maxPerson ?? 0}",
                    onPress: () {
                      _showMaxPersonModalBottomSheet();
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Booking Price',
                    value: "৳ ${controller.listingDetails.value?.price ?? 0}",
                    onPress: () {
                      _showPriceModalBottomSheet();
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Extra services',
                    value: "Per Guest extra charge ৳ ${controller.listingDetails.value?.extraChargePerPerson ?? 0}",
                    onPress: () {
                      _showExtraServicesModalBottomSheet();
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Status',
                    value:(controller.listingDetails.value?.status != "in_progress" &&
                        controller.listingDetails.value?.status != "unpublished")
                        ? "Published"
                        : "Unpublished",
                    onPress: () {
                      _showStatusModalBottomSheet(controller.listingDetails.value?.status ?? '');
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Photos',
                    value: 'Your photos are a guest’s first impression of your listing',
                    onPress: () {
                      openPhotoUploadBottomSheet(
                          context,controller,
                          controller.listingDetails.value!.images??[],
                          coverImage: controller.listingDetails.value?.coverPhoto
                      );

                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Instant Book',
                    value: 'Turned ${controller.listingDetails.value?.instantBookingAllowed != true ?'off: Manually Accept or decline booking request.' : 'on'}',
                    onPress: () {
                      final RxBool isInstantBookEnabled = RxBool(controller.listingDetails.value?.instantBookingAllowed ?? false);
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
                    title: 'Multiple date selection',
                    value: 'Turned ${controller.listingDetails.value?.isEnableMultipleDateSelection != true ?'off: User can\'t book if it\'s already booked.' : 'on'}',
                    onPress: () {
                      final RxBool isEnableMultipleDateSelection = RxBool(controller.listingDetails.value?.isEnableMultipleDateSelection ?? false);
                      showMultipleDateSelectionBookBottomSheet(
                        context: context,
                        isInstantBookEnabled: isEnableMultipleDateSelection,
                        onChanged: (newValue) {
                          // Optional: call API here or handle logic
                          controller.goUpdateMultipleDateSelectionEnable(newValue);
                          // yourController.updateInstantBook(newValue);
                        },
                      );
                    },
                  ),
                  Divider(height: 30, thickness: 0.6),
                  EditListingItem(
                    title: 'Cancellation Policy',
                    value: '${controller.listingDetails.value?.cancellationPolicy?.policyName}',
                    onPress: () {

                      showCancellationPolicyBottomSheet(
                        context: context,
                        policies: controller.assistanceCancellationPolicesList.value,
                        selectedPolicyId: controller.listingDetails.value?.cancellationPolicy?.id,
                        controller: controller
                      );

                    },
                  ),
                ],
              ),
            );
          })
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
           padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
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
               Obx(() => GestureDetector(
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
                     color: isInstantBookEnabled.value
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
                         alignment: isInstantBookEnabled.value
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
               )),
             ],
           ),
         );
       },
     );
   }

   void showMultipleDateSelectionBookBottomSheet({
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
           padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               // Header
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(
                     "Edit multiple date selection",
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
                   "Use Multiple date selection",
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
               Obx(() => GestureDetector(
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
                     color: isInstantBookEnabled.value
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
                         alignment: isInstantBookEnabled.value
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
               )),
             ],
           ),
         );
       },
     );
   }

  void _showTitleModalBottomSheet() {
    controller.titleController.text = controller.listingDetails.value?.title ?? '';
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
        }
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
    );
  }

   void _showAboutYouModalBottomSheet() {
   final raw = controller.listingDetails.value?.aboutYou ?? '';
    print("📌 About You Raw: $raw");
    controller.aboutYouController.text = _stripHtml(raw);
     Get.bottomSheet(
         Obx(() {
           return EditBottomSheet(
             title: 'Edit about you',
             isLoading: controller.isUpdating.value,
             onSave: controller.goNextAfterEnteredAboutYou,
             onCancel: () {
               Get.back();
             },
             child: SingleFieldBottomSheetBody(
               description: 'Write Some awesome about you',
               label: 'About you',
               hitText: 'Enter about you',
               textControl: controller.aboutYouController,
             ),
           );
         }
         ),
         backgroundColor: Colors.white,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
     );
   }

  void _showDescriptionModalBottomSheet() {
    final raw = controller.listingDetails.value?.details ?? '';
      print("📌 Details Raw: $raw");                    // ← This is the one in your screenshot
      controller.descriptionController.text = _stripHtml(raw);
    Get.bottomSheet(
        Obx(() {
            return EditBottomSheet(
              title: 'Edit you Listing',
              isLoading: controller.isUpdating.value,
              onSave: controller.goNextAfterEnteredDetails,
              onCancel: () {
                Get.back();
              },
              child: SingleFieldBottomSheetBody(
                description: 'Write Some awesome Descriptions',
                label: 'Add Descriptionnnn',
                hitText: 'Enter description',
                textControl: controller.descriptionController,
              ),
            );
          }
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
    );
  }

  void _showDescribeAssistanceModalBottomSheet() {
    final raw = controller.listingDetails.value?.assistanceDescription ?? '';
      print("📌 Assistance Description Raw: $raw");
      controller.describeAssistanceController.text = _stripHtml(raw);
    Get.bottomSheet(
        Obx(() {
            return EditBottomSheet(
              title: 'Edit describe assistance',
              isLoading: controller.isUpdating.value,
              onSave: controller.goNextAfterEnteredDescribeAssistance,
              onCancel: () {
                Get.back();
              },
              child: SingleFieldBottomSheetBody(
                description: 'Enter description about you assistance ',
                label: 'Assistance description',
                hitText: 'Describe assistance',
                textControl: controller.describeAssistanceController,
              ),
            );
          }
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
    );
  }

  void _showCoverageAreaModalBottomSheet() {
    controller.coverageAreaController.text = controller.listingDetails.value?.coverageAreaName ?? '';
    Get.bottomSheet(
        Obx(() {
            return EditBottomSheet(
              title: 'Edit you coverage area',
              isLoading: controller.isUpdating.value,
              onSave: controller.goNextAfterEnteredCoverageArea,
              onCancel: () {
                Get.back();
              },
              isMax: true,
              child: SingleFieldBottomSheetBody(
                description: 'Enter and select the coverage area',
                label: 'Add coverage area',
                hitText: 'Enter coverage area',
                textControl: controller.coverageAreaController,
                onSuggestionSelected: (suggestion) async {
                  controller.selectedEditAssistanceCoveringArea = suggestion;
                  controller.coverageAreaController.text = suggestion.address ?? '';
                },
                showLocationSuggestion: true,
              ),
            );
          }
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

   void _showCurrentLocationModalBottomSheet() {
     controller.currentLocationController.text = controller.listingDetails.value?.currentLocationName ?? '';
     Get.bottomSheet(
       Obx(() {
         return EditBottomSheet(
           title: 'Edit current location',
           isLoading: controller.isUpdating.value,
           onSave: controller.goNextAfterEnteredCurrentLocation,
           onCancel: () {
             Get.back();
           },
           isMax: true,
           child: SingleFieldBottomSheetBody(
             description: 'Enter and select the current location',
             label: 'Current location',
             hitText: 'Enter current location',
             textControl: controller.currentLocationController,
             onSuggestionSelected: (suggestion) async {
               controller.selectedEditAssistanceCurrentLocation = suggestion;
               controller.currentLocationController.text = suggestion.address ?? '';
             },
             showLocationSuggestion: true,
           ),
         );
       }
       ),
       backgroundColor: Colors.white,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
     );
   }

   void _showStatusModalBottomSheet(String status) {
     String selectedStatus = status.isNotEmpty
         ? status
         : 'unpublished'; // default to 'unpublished'

     Get.bottomSheet(
       EditBottomSheet(
         title: 'Edit status',
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                       final title = controller.listingDetails.value?.title ?? '';
                       final price = controller.listingDetails.value?.price ?? 0;
                       final maxPerson = controller.listingDetails.value?.maxPerson;
                       final coverageAreaName = controller.listingDetails.value?.coverageAreaName ?? '';

                       if (price <= 0.0) {
                         Fluttertoast.showToast(
                           msg: "You cannot publish with price 0.00 or less",
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

                       if (maxPerson == null || maxPerson == 0) {
                         Fluttertoast.showToast(
                           msg: "Please update the max price before publish",
                           toastLength: Toast.LENGTH_SHORT,
                           gravity: ToastGravity.BOTTOM,
                         );
                         return;
                       }

                       if (coverageAreaName.isEmpty) {
                         Fluttertoast.showToast(
                           msg: "Please update coverage area before publish",
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
     );
   }

   void _showPriceModalBottomSheet() {
     controller.priceController.text = "${controller.listingDetails.value?.price ?? 0}";

     // final enableLengthDiscount = controller.listingDetails.value?.enableLengthOfStayDiscount ?? false;
     // final enableLengthDiscount = false;

     // final selectedDiscountsRaw = controller.listingDetails.value?.lengthOfStayDiscounts;

     Map<String, dynamic> selectedDiscounts = {};
     // if (selectedDiscountsRaw != null && selectedDiscountsRaw.toJson() is Map<String, dynamic>) {
     //   selectedDiscounts = selectedDiscountsRaw.toJson() as Map<String, dynamic>;
     //   print("v\selectedDiscountsRaw -- ${selectedDiscountsRaw.toJson() as Map<String, dynamic>}");
     //
     // }

     // RxBool enableDiscounted = RxBool(enableLengthDiscount);
     // RxInt daysSelected = RxInt(0);
     // TextEditingController adjustedPricing = TextEditingController();
     //
     // // Pre-select one of the existing discounts (3 > 7 > 30)
     // if (enableLengthDiscount && selectedDiscounts.isNotEmpty) {
     //   for (final key in ["3", "7", "30"]) {
     //     if (selectedDiscounts.containsKey(key)) {
     //       daysSelected.value = int.parse(key);
     //       adjustedPricing.text = selectedDiscounts[key].toString();
     //       break; // stop after first match
     //     }
     //   }
     // }

     Get.bottomSheet(
       Obx(() {
         return EditBottomSheet(
           title: 'Edit pricing',
           isLoading: controller.isUpdating.value,
           onSave: () => controller.goNextAfterEnteredPrice({
             // "enable_length_of_stay_discount": enableDiscounted.value,
             // if (enableDiscounted.value && daysSelected.value > 0)
             //   "length_of_stay_discounts": {
             //     "${daysSelected.value}": int.tryParse(adjustedPricing.text.trim()) ?? 0
             //   }
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
               /*Padding(
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
                         children: [3, 7, 30].map((day) {
                           return Obx(() {
                             final isSelected = daysSelected.value == day;
                             final discountValue = selectedDiscounts["$day"]?.toString() ?? '';

                             // Update adjustedPricing.text only if this checkbox got selected
                             if (isSelected && adjustedPricing.text != discountValue) {
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
                             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                 ),*/
               Gap(15),
             ],
           ),
         );
       }),
       enableDrag: true,
       isScrollControlled: true,
       backgroundColor: Colors.white,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
     );
   }

   void _showMaxPersonModalBottomSheet() {
     controller.maxPersonController.text = "${controller.listingDetails.value?.maxPerson ?? 0}";

     Get.bottomSheet(
       Obx(() {
         return EditBottomSheet(
           title: 'Edit max person',
           isLoading: controller.isUpdating.value,
           onSave: () => controller.goNextAfterEnteredMaxPerson(),
           onCancel: () => Get.back(),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SingleFieldBottomSheetBody(
                 description: 'Write max person',
                 label: 'Max person',
                 hitText: '৳ 0.0',
                 textControl: controller.maxPersonController,
                 keyboardType: TextInputType.number,
               ),
               Gap(15),
             ],
           ),
         );
       }),
       enableDrag: true,
       isScrollControlled: true,
       backgroundColor: Colors.white,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
     );
   }

   void _showExtraServicesModalBottomSheet() {
     controller.extraServicesController.text = "${controller.listingDetails.value?.extraChargePerPerson ?? 0}";

     Get.bottomSheet(
       Obx(() {
         return EditBottomSheet(
           title: 'Edit extra services',
           isLoading: controller.isUpdating.value,
           onSave: () => controller.goNextAfterEnteredExtraServicesPrice(),
           onCancel: () => Get.back(),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SingleFieldBottomSheetBody(
                 description: 'Write your extra services price',
                 label: 'Extra Services',
                 hitText: '৳ 0.0',
                 textControl: controller.extraServicesController,
                 keyboardType: TextInputType.number,
               ),
               Gap(15),
             ],
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
     controller.suggestionController.text = controller.listingDetails.value?.meetupPointName ?? '';
    Get.bottomSheet(
      WhereILiveBottomSheet(),
      enableDrag: false,
      elevation: 6,
      isDismissible: false,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
    );
  }

   void openPhotoUploadBottomSheet(
       BuildContext context,
       AssistanceServiceEditController controller,
       List<String> uploadedPhotoUrlss, {
         String? coverImage, // ✅ Pass this when calling
   }) {
     final RxList<XFile> selectedNewImages = <XFile>[].obs;
     final RxList<String> existingUrls = uploadedPhotoUrlss.obs;
     final RxString coverImageUrl = ''.obs;
     final RxInt coverImageIndex = (-1).obs;
     final RxBool isCoverFromExisting = true.obs;

     // ✅ Pre-select if coverImage matches an existing URL
     if (coverImage != null && uploadedPhotoUrlss.contains(coverImage)) {
       coverImageUrl.value = coverImage;
       coverImageIndex.value = uploadedPhotoUrlss.indexOf(coverImage);
       isCoverFromExisting.value = true;
     }

     final ImagePicker picker = ImagePicker();

     showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
       ),
       builder: (_) {
         return SingleChildScrollView(
           padding: const EdgeInsets.all(16.0),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               // Top Bar
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text("Upload Photos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                   IconButton(
                     icon: Icon(Icons.close),
                     onPressed: () => Navigator.pop(context),
                   ),
                 ],
               ),
               SizedBox(height: 10),

               // Select New Images
               ElevatedButton.icon(
                 onPressed: () async {
                   final images = await picker.pickMultiImage();
                   if (images.isNotEmpty) {
                     selectedNewImages.addAll(images);
                   }
                 },
                 icon: Icon(Icons.add_photo_alternate_outlined, color: Colors.black87),
                 label: Text(
                   "Select Images",
                   style: TextStyle(
                     color: Colors.black87,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.white, // white background
                   foregroundColor: Colors.orange, // for ripple effect
                   side: BorderSide(color: Colors.grey), // grey border
                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(12),
                   ),
                   elevation: 2,
                   shadowColor: Colors.grey.withOpacity(0.2),
                 ),
               ),

               SizedBox(height: 16),

               // Existing Uploaded Images
               Obx(() {
                 if (existingUrls.isEmpty) return SizedBox();
                 return Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Previously Uploaded", style: TextStyle(fontWeight: FontWeight.bold)),
                     SizedBox(height: 8),
                     GridView.builder(
                       shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),
                       itemCount: existingUrls.length,
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                 errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
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
                                   child: Icon(Icons.close, color: Colors.white, size: 16),
                                 ),
                               ),
                             ),
                             Positioned(
                               top: 4,
                               left: 4,
                               child: GestureDetector(
                                 onTap: () {
                                   coverImageUrl.value = existingUrls[index];
                                   coverImageIndex.value = index;
                                   isCoverFromExisting.value = true;
                                 },
                                 child: Obx(() => Container(
                                   decoration: BoxDecoration(
                                     color: coverImageUrl.value == existingUrls[index]
                                         ? Colors.green
                                         : Colors.black.withOpacity(0.5),
                                     borderRadius: BorderRadius.circular(8),
                                   ),
                                   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                   child: Row(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       Icon(Icons.star, color: Colors.white, size: 14),
                                       SizedBox(width: 4),
                                       Text(
                                         "Cover",
                                         style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
                                       ),
                                     ],
                                   ),
                                 )),
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

               // New Selected Images
               Obx(() {
                 if (selectedNewImages.isEmpty) return SizedBox();
                 return Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("New Selected", style: TextStyle(fontWeight: FontWeight.bold)),
                     SizedBox(height: 8),
                     GridView.builder(
                       shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),
                       itemCount: selectedNewImages.length,
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                 onTap: () => selectedNewImages.removeAt(index),
                                 child: Container(
                                   decoration: BoxDecoration(
                                     color: Colors.black.withOpacity(0.5),
                                     shape: BoxShape.circle,
                                   ),
                                   padding: EdgeInsets.all(4),
                                   child: Icon(Icons.close, color: Colors.white, size: 16),
                                 ),
                               ),
                             ),
                             Positioned(
                               top: 4,
                               left: 4,
                               child: GestureDetector(
                                 onTap: () {
                                   coverImageUrl.value = selectedNewImages[index].path;
                                   coverImageIndex.value = index;
                                   isCoverFromExisting.value = false;
                                 },
                                 child: Obx(() => Container(
                                   decoration: BoxDecoration(
                                     color: coverImageUrl.value == selectedNewImages[index].path
                                         ? Colors.green
                                         : Colors.black.withOpacity(0.5),
                                     borderRadius: BorderRadius.circular(8),
                                   ),
                                   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                   child: Row(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       Icon(Icons.star, color: Colors.white, size: 14),
                                       SizedBox(width: 3),
                                       Text(
                                         "Is Cover",
                                         style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
                                       ),
                                     ],
                                   ),
                                 )),
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

               // Submit Button
               Obx(() {
                 return controller.isUploadingPhotos.value
                     ? CircularProgressIndicator()
                     :  GestureDetector(
                       onTap: () async {
                         final newPaths = selectedNewImages.map((img) => img.path).toList();
                         List<String> newUploadedUrls = [];

                         if (newPaths.isNotEmpty) {
                           newUploadedUrls = await controller.uploadMultiplePhotos(newPaths);
                         }

                         final combinedImageUrls = [...existingUrls, ...newUploadedUrls];
                         controller.finalUploadedImages.assignAll(combinedImageUrls);

                         // Set final cover image URL
                         if (coverImageUrl.value.isNotEmpty) {
                           if (isCoverFromExisting.value) {
                             controller.coverImageUrl.value = coverImageUrl.value;
                           } else {
                             final index = coverImageIndex.value;
                             if (index >= 0 && index < newUploadedUrls.length) {
                               controller.coverImageUrl.value = newUploadedUrls[index];
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
                 );



               }),

               SizedBox(height: 24),
             ],
           ),
         );
       },
     );
   }


   void showCancellationPolicyBottomSheet({
     required BuildContext context,
     required List<AssistanceCancellationPolices> policies,
     required int? selectedPolicyId,
     required AssistanceServiceEditController controller,
   }) {
     final RxInt selectedIndex = (policies.indexWhere((p) => p.id == selectedPolicyId)).obs;

     showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
       ),
       builder: (_) {
         return Padding(
           padding: const EdgeInsets.all(16.0),
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
                                 color: isSelected
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
                   if (selectedIndex.value >= 0 && selectedIndex.value < policies.length) {
                     final selectedPolicy = policies[selectedIndex.value];
                     controller.goUpdatePolicy(
                       id: selectedPolicy.id!
                     );
                   } else {
                   }
                   Get.back();
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.orangeAccent,
                   padding:
                   const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
}

class EditBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isLoading, isMax;
  final Function()? onSave, onCancel;

  const EditBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.onSave,
    this.onCancel,
    this.isLoading = false,
    this.isMax = false
  });

@override

  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom > 0 ? 20.0 : 16.0;

    return SafeArea(
      bottom: true,
      child: Column(
        mainAxisSize: isMax ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
              bottom: 12.0,
              right: 18,
              left: 18,
            ),
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
                          alignment: Alignment.center
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
                      )),
                ),
                const Gap(12),
                SizedBox(
                  height: 20,
                  child: TextButton.icon(
                      onPressed: isLoading ? null : onSave,
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero
                      ),
                      iconAlignment: IconAlignment.end,
                      icon: isLoading 
                          ? const SizedBox(
                              height: 16, 
                              width: 16, 
                              child: CircularProgressIndicator(strokeWidth: 0.6),
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
                      )),
                )
              ],
            ),
          ),
          Divider(height: 30),
          
          // Content area
          if (isMax)
            Expanded(child: child)
          else
            child,

          // Bottom safe padding for Cancel/Save buttons
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}

class SingleFieldBottomSheetBody extends GetView<AssistanceServiceEditController> {
  final String description, label, hitText;
  final TextEditingController textControl;
  final TextInputType? keyboardType;
  final bool showLocationSuggestion;
  final Future<void> Function(PlaceSuggestion)? onSuggestionSelected;
  const SingleFieldBottomSheetBody({
    super.key,
    required this.description,
    required this.label,
    required this.hitText,
    required this.textControl,
    this.keyboardType,
    this.showLocationSuggestion = false,
    this.onSuggestionSelected
  });

  @override
  Widget build(BuildContext context) {
    print("🎯 SingleFieldBottomSheetBody - Setting text: ${textControl.text}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:  18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          // Text(
          //   label,
          //   style: TextStyle(
          //     color: Colors.black,
          //     fontSize: 8,
          //     fontFamily: 'Inter',
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          // const Gap(8),
          if(showLocationSuggestion)LocationSuggesterTextFieldWidget(
            controller: textControl,
            hintText: 'Enter area',
            onSuggestionSelected: onSuggestionSelected,
          ),
          if(!showLocationSuggestion)CustomInputText(
            controller: textControl,
            helperText: hitText,
            keyboardType: keyboardType,
          ),
          const Gap(18)
        ],
      ),
    );
  }
}

class WhereILiveBottomSheet extends StatelessWidget {
  WhereILiveBottomSheet({super.key});

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // final AssistanceServiceController controller = Get.find<AssistanceServiceController>();
  final AssistanceServiceEditController editController = Get.find<AssistanceServiceEditController>();


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Obx(() => GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: _kGooglePlex,
            markers: editController.selectedMarker.value != null
                ? {editController.selectedMarker.value!}
                : {},
            onMapCreated: (GoogleMapController mapController) {
              _controller.complete(mapController);
            },
            onTap: (location) {
              FocusScope.of(context).unfocus();
            },
          )),
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
              // Expanded(
              //   child: TypeAheadField<PlaceSuggestion>(
              //     controller: controller.suggestionController,
              //     builder: (context, textController, focusNode) => TextField(
              //       controller: textController,
              //       focusNode: focusNode,
              //       autofocus: true,
              //       style: DefaultTextStyle.of(context).style.copyWith(fontStyle: FontStyle.italic),
              //       decoration: const InputDecoration(
              //         border: InputBorder.none,
              //         hintText: 'Search...',
              //         isDense: true,
              //         isCollapsed: true,
              //         filled: true,
              //         fillColor: Colors.white,
              //         contentPadding:
              //         EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              //       ),
              //     ),
              //     decorationBuilder: (context, child) => Material(
              //       type: MaterialType.card,
              //       elevation: 4,
              //       borderRadius: BorderRadius.circular(6),
              //       child: child,
              //     ),
              //     itemBuilder: (context, suggestion) => Padding(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 12.0, vertical: 6),
              //       child: Row(
              //         children: [
              //           const Icon(Icons.location_on_outlined),
              //           const Gap(6),
              //           Expanded(child: Text(suggestion.address ?? '')),
              //         ],
              //       ),
              //     ),
              //     onSelected: onSuggestionSelected,
              //     // suggestionsCallback: suggestionsCallback,
              //     itemSeparatorBuilder: itemSeparatorBuilder,
              //     listBuilder: gridLayoutBuilder, suggestionsCallback: (String search) {  },
              //   ),
              // ),
              Expanded(
                child: LocationSuggesterTextFieldWidget(
                  controller: editController.suggestionController,
                  hintText: 'Enter area',
                  onSuggestionSelected: (PlaceSuggestion suggestion) async {
                    editController.selectedPlace.value = suggestion;
                    editController.suggestionController.text = suggestion.address ?? '';

                    final double? lat = double.tryParse(suggestion.latitude ?? '');
                    final double? lng = double.tryParse(suggestion.longitude ?? '');

                    if (lat != null && lng != null) {
                      final GoogleMapController mapController = await _controller.future;

                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(lat, lng),
                            zoom: 16.0,
                          ),
                        ),
                      );

                      editController.selectedMarker.value = Marker(
                        markerId: const MarkerId('selected-location'),
                        position: LatLng(lat, lng),
                        infoWindow: InfoWindow(title: suggestion.address),
                      );
                    } else {
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          bottom: 10,
          child: GestureDetector(
            onTap: () async {
              final selectedPlace = editController.selectedPlace.value;

              if (selectedPlace != null) {
                final lat = double.tryParse(selectedPlace.latitude ?? '');
                final lng = double.tryParse(selectedPlace.longitude ?? '');
                final address = selectedPlace.address ?? '';

                editController.onUpdateLocation(long: lng!,lat: lat!,location: address);

                Get.back();

              } else {
                Get.snackbar('Warning', 'Please select a location from search.');
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
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget itemSeparatorBuilder(BuildContext context, int index) =>
      const Gap(2);

  Widget gridLayoutBuilder(BuildContext context, List<Widget> items) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      children: items,
    );
  }

  // Future<List<PlaceSuggestion>> suggestionsCallback(String pattern) async => controller.onPlaceSearchChange(pattern);
}

// Hello I am Tamim