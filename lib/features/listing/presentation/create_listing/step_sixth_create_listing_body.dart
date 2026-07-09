import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';

class StepSixthCreateListingBody extends GetView<ListingController> {
  StepSixthCreateListingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share some basics about your place',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(12),
        Text(
        'You\'ll add more details later, like bed types',
          style: TextStyle(
            color: const Color(0xFF33496C) /* Text */,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        const Gap(30),
        Obx(() {
            return IncrementCard(
              icon: OwnIcons.guests_icon,
              title: 'Persons',
              value: controller.personsCount.value.toString(),
              onDecrement: () {
                if(controller.personsCount.value <= 0) return;
                controller.personsCount.value = controller.personsCount.value - 1;
              },
              onIncrement: () => controller.personsCount.value = controller.personsCount.value + 1,
            );
          }
        ),
        const Gap(10),
        Obx(() {
            return IncrementCard(
              icon: OwnIcons.bedrooms_icon,
              title: 'Bedrooms',
              value: controller.bedroomsCount.value.toString(),
              onDecrement: () {
                if(controller.bedroomsCount.value <= 0) return;
                controller.bedroomsCount.value = controller.bedroomsCount.value - 1;
              },
              onIncrement: () => controller.bedroomsCount.value = controller.bedroomsCount.value + 1,
            );
          }
        ),
        const Gap(10),
        Obx(() {
            return IncrementCard(
              icon: OwnIcons.beds_icon,
              title: 'Beds',
              value: controller.bedsCount.value.toString(),
              onDecrement: () {
                if(controller.bedsCount.value <= 0) return;
                controller.bedsCount.value = controller.bedsCount.value - 1;
              },
              onIncrement: () => controller.bedsCount.value = controller.bedsCount.value + 1,
            );
          }
        ),
        const Gap(10),
        Obx(() {
            return IncrementCard(
              icon: OwnIcons.bathrooms_icon,
              title: 'Bathrooms',
              value: controller.bathroomsCount.value.toString(),
              onDecrement: () {
                if(controller.bathroomsCount.value <= 0) return;
                controller.bathroomsCount.value = controller.bathroomsCount.value - 1;
              },
              onIncrement: () => controller.bathroomsCount.value = controller.bathroomsCount.value + 1,
            );
          }
        ),
        const Gap(20)
      ],
    );
  }
}

class IncrementCard extends StatelessWidget {

  final String title, value;
  final IconData? icon;
  final void Function()? onIncrement, onDecrement;

  const IncrementCard({super.key, required this.value, required this.title, this.icon, this.onIncrement, this.onDecrement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: Colors.white /* white */,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFF0F1F5) /* Grey-10 */,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Icon(icon),
            VerticalDivider(width: 40,),
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
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton.outlined(
                onPressed: onDecrement,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.remove),
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
              ),
            ),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton.outlined(
                onPressed: onIncrement,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ThirdStepContent {
  String? asset, title, subtitle;
  ThirdStepContent({this.asset, this.title, this.subtitle});
}

// Hello I am Tamim







// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../controllers/listing_controller.dart';
// import '../../models/aminities_new_model.dart';

// class StepSixthCreateListingBody extends GetView<ListingController> {
//   StepSixthCreateListingBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Call fetchAmenities when widget is built (if not already loaded)
//     if (controller.amenitiesList.isEmpty) {
//       controller.fetchAmenities();
//     }

//     return Obx(() {
//       // Show loading state
//       if (controller.isLoadingg.value) {
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       }

//       // Show error state
//       if (controller.hasErrorg.value) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error_outline, size: 48, color: Colors.red),
//               Gap(16),
//               Text(
//                 'Failed to load amenities',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Gap(8),
//               Text(
//                 controller.errorMessageg.value,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//               Gap(16),
//               ElevatedButton(
//                 onPressed: () => controller.fetchAmenities(),
//                 child: Text('Retry'),
//               ),
//             ],
//           ),
//         );
//       }

//       final List<AmenitiesCategoryModel> amenitiesList =
//           controller.amenitiesList.value;

//       // Show empty state
//       if (amenitiesList.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
//               Gap(16),
//               Text(
//                 'No amenities available',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Tell guests what amenities you can offer',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 24,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w600,
//               height: 1.33,
//             ),
//           ),
//           Text(
//             'You can add more amenities after you publish your listing',
//             style: TextStyle(
//               color: const Color(0xFF33496C),
//               fontSize: 16,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w400,
//               height: 1.50,
//             ),
//           ),
//           const Gap(30),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               final AmenitiesCategoryModel category = amenitiesList[index];
//               final String categoryTitle = category.title ?? '';
//               final List<AmenityModel> allAmenities = category.data ?? [];

//               // Filter out amenities with status == true (don't modify original list)
//               final List<AmenityModel> availableAmenities =
//               allAmenities.where((e) => e.status != true).toList();

//               // Skip this category if no available amenities
//               if (availableAmenities.isEmpty) {
//                 return SizedBox.shrink();
//               }

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Do you have any ${categoryTitle.replaceAll('_', ' ')} amenities?',
//                     style: TextStyle(
//                       color: const Color(0xFF33496C),
//                       fontSize: 16,
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w600,
//                       height: 1.50,
//                     ),
//                   ),
//                   const Gap(12),
//                   ListView.separated(
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemBuilder: (context, index1) {
//                       final amenity = availableAmenities[index1];
//                       return Obx(() {
//                         return SelectableCard(
//                           title: amenity.name ?? '',
//                           asset: amenity.iconMobile ?? '',
//                           isSelected: controller.selectedAmenities.value
//                               .contains(amenity.id),
//                           onTap: () {
//                             var amId = amenity.id;
//                             if (amId != null) {
//                               if (controller.selectedAmenities.contains(amId)) {
//                                 controller.selectedAmenities
//                                     .removeWhere((id) => id == amId);
//                               } else {
//                                 controller.selectedAmenities.add(amId);
//                               }
//                             }
//                           },
//                         );
//                       });
//                     },
//                     separatorBuilder: (context, _) => Gap(10),
//                     itemCount: availableAmenities.length,
//                   ),
//                 ],
//               );
//             },
//             separatorBuilder: (context, index) => const Gap(20),
//             itemCount: amenitiesList.length,
//           ),
//           const Gap(50),
//         ],
//       );
//     });
//   }
// }

// class SelectableCard extends StatelessWidget {
//   final String title, asset;
//   final bool isSelected;
//   final Function()? onTap;

//   const SelectableCard({
//     super.key,
//     this.onTap,
//     required this.title,
//     required this.asset,
//     this.isSelected = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 60,
//         decoration: ShapeDecoration(
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             side: BorderSide(
//               width: 1,
//               color: isSelected ? Colors.deepOrange : const Color(0xFFF0F1F5),
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
//         child: Row(
//           children: [
//             if (isSelected)
//               Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: Icon(
//                   Icons.check_circle,
//                   color: Colors.green,
//                   size: 20,
//                 ),
//               ),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w500,

//                 ),
//               ),
//             ),
//             buildImage(asset),
//             const Gap(8)
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildImage(String? url) {
//     final imageUrl = url ?? '';

//     if (imageUrl.isEmpty) {
//       return _buildErrorIcon();
//     }

//     if (imageUrl.endsWith('.svg')) {
//       return SvgPicture.network(
//         imageUrl,
//         width: 30,
//         height: 30,
//         excludeFromSemantics: true,
//         placeholderBuilder: (context) => Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
//       );
//     } else {
//       return Image.network(
//         imageUrl,
//         width: 30,
//         height: 30,
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               width: 30,
//               height: 30,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }

//   Widget _buildErrorIcon() {
//     return Container(
//       width: 52,
//       height: 52,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Icon(Icons.image_not_supported, color: Colors.grey),
//     );
//   }
// }

// class SecondStepContent {
//   String? asset, title, subtitle;
//   SecondStepContent({this.asset, this.title, this.subtitle});
// }
// // Hello I am Tamim