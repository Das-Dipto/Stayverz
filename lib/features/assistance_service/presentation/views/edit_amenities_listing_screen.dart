// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import '../../../../widgets/own_title_app_bar.dart';
// import '../../../public_listings/data/models/listing_filter_config_model.dart';
// import '../../controllers/assistance_service_controller.dart';
// import '../../controllers/assistance_service_edit_controller.dart';
//
// class EditAmenitiesListingScreen extends StatefulWidget {
//   final dynamic lsit;
//   const EditAmenitiesListingScreen({super.key, required this.lsit});
//
//   @override
//   State<EditAmenitiesListingScreen> createState() => _EditAmenitiesListingScreenState();
// }
//
// class _EditAmenitiesListingScreenState extends State<EditAmenitiesListingScreen> {
//   final AssistanceServiceController controller = Get.find<AssistanceServiceController>();
//   final AssistanceServiceEditController listingEditController = Get.find<AssistanceServiceEditController>();
//
//   @override
//   void initState() {
//     super.initState();
//     controller.fetchHostListingConfigurations();
//   }
//
//   List<Amenity> _parseAmenitiesList(String key) {
//     final amenitiesMap = controller.listingConfiguration.value?.amenities;
//     if (amenitiesMap == null || amenitiesMap[key] == null) return [];
//
//     final list = amenitiesMap[key];
//
//     return List<Amenity>.from(
//       list!.map((item) => Amenity.fromJson(item.toJson())),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: OwnTitleAppBar(
//         appBarText: 'Edit your Listing',
//         fontColor: Colors.black,
//         backgroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: Obx(() {
//         if (controller.isLoadingg.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.hasErrorg.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Error: ${controller.errorMessageg.value}'),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: controller.refreshListings,
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         final safetyAmenities = _parseAmenitiesList('safety');
//         final standOutAmenities = _parseAmenitiesList('stand_out');
//         final entirePlaceAmenities = _parseAmenitiesList('entire_place');
//
//         final allAmenities = [
//           ...safetyAmenities,
//           ...standOutAmenities,
//           ...entirePlaceAmenities,
//         ];
//
//         safetyAmenities.removeWhere((e) {
//           return e.status == true;
//         });
//
//         standOutAmenities.removeWhere((e) {
//           return e.status == true;
//         });
//
//         entirePlaceAmenities.removeWhere((e) {
//           return e.status == true;
//         });
//
//         // Initialize selected amenities from my_listing details
//         if (listingEditController.selectedAmenities.isEmpty && widget.lsit != null) {
//           final amenitiesList = widget.lsit;
//           final selectedIds = amenitiesList
//               .map((item) => item.amenity.id)
//               .whereType<int>()
//               .toList();
//           listingEditController.selectedAmenities.value = selectedIds;
//           controller.selectedAmenityIds.value = selectedIds;
//         }
//
//         return ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           children: [
//             const Gap(10),
//             const Text('Select Amenities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const Divider(color: Colors.black),
//
//             _buildSection("Any Extraordinary amenities?", standOutAmenities),
//             _buildSection("Do you have any entire place amenities?", entirePlaceAmenities),
//             _buildSection("Safety items?", safetyAmenities),
//
//             const Gap(20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 40,
//                   width: 90,
//                   child: OutlinedButton(
//                     onPressed: () {
//                       if (controller.selectedAmenityIds.isEmpty) {
//                         Fluttertoast.showToast(
//                           msg: "Please select a place",
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.TOP,
//                         );
//                         return;
//                       }
//
//                       listingEditController.goUpdateAfterSelectingAmenities(
//                         selectList: controller.selectedAmenityIds.toList(),
//                       );
//                       controller.selectedAmenityIds.clear();
//                       Get.back();
//                     },
//                     style: OutlinedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     child: const Text(
//                       'Save',
//                       style: TextStyle(
//                         color: Color(0xFF19191A),
//                         fontSize: 16,
//                         fontFamily: 'Inter',
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Gap(20),
//           ],
//         );
//       }),
//     );
//   }
//
//   Widget _buildSection(String title, List<Amenity> amenities) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Gap(20),
//         Text(
//           title,
//           style: const TextStyle(
//             color: Color(0xFF33496C),
//             fontSize: 15.22,
//             fontFamily: 'Inter',
//             fontWeight: FontWeight.w600,
//             height: 1.50,
//           ),
//         ),
//         const Gap(10),
//         if (amenities.isNotEmpty)
//           ...amenities.map((amenity) => Obx(() => _AmenityCard(
//             amenity: amenity,
//             isSelected: controller.selectedAmenityIds.contains(amenity.id),
//             onTap: () => controller.toggleAmenity(amenity.id!),
//           ))),
//       ],
//     );
//   }
// }
//
// class _AmenityCard extends StatelessWidget {
//   final Amenity amenity;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const _AmenityCard({
//     required this.amenity,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Stack(
//         children: [
//           Card(
//             margin: const EdgeInsets.symmetric(vertical: 6),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 0,
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: ShapeDecoration(
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(
//                     width: 0.95,
//                     color: Color(0xFFF0F1F5),
//                   ),
//                   borderRadius: BorderRadius.circular(7.61),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   const Gap(5),
//                   Expanded(
//                     child: Text(
//                       amenity.name ?? '',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   const Gap(5),
//                   _buildAmenityIcon(amenity.iconMobile),
//                 ],
//               ),
//             ),
//           ),
//           if (isSelected)
//             Positioned(
//               top: 9,
//               left: 3,
//               child: Container(
//                 width: 18,
//                 height: 18,
//                 decoration: const BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check, size: 12, color: Colors.white),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAmenityIcon(String? url) {
//     if (url == null || url.isEmpty) return const SizedBox.shrink();
//     if (url.toLowerCase().endsWith('.svg')) {
//       return SvgPicture.network(
//         url,
//         width: 56,
//         height: 56,
//         placeholderBuilder: (context) => const SizedBox(
//           width: 30,
//           height: 30,
//           child: CircularProgressIndicator(strokeWidth: 1),
//         ),
//       );
//     } else {
//       return Image.network(
//         url,
//         width: 56,
//         height: 56,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) => const Icon(Icons.error_outline),
//       );
//     }
//   }
// }

// Hello I am Tamim