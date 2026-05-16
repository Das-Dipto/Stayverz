// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
//
// import '../../../widgets/own_app_bar.dart';
//
// class SpecialRequestScreen extends StatefulWidget {
//   const SpecialRequestScreen({super.key});
//
//   @override
//   State<SpecialRequestScreen> createState() => _SpecialRequestScreenState();
// }
//
// class _SpecialRequestScreenState extends State<SpecialRequestScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     Get.put(BedController());
//   }
//   RxBool checkBead = false.obs;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: OwnAppBar(
//         appHeight: 60,
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(16),
//           bottomRight: Radius.circular(16),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               height: 35,
//               width: 35,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey.withOpacity(0.1),
//               ),
//               child: IconButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 icon: const Icon(Icons.arrow_back_ios, size: 20,),
//                 color: Colors.black,
//               ),
//             ),
//             Text(
//               'Special Request',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Gap(30)
//           ],
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         children: [
//           Gap(20),
//           Text(
//             'Booking Details',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Gap(10),
//           Column(
//             children: [
//               BedOptionTile(bedType: BedType.twin, label: 'Twin Bed'),
//               Gap(10),
//               BedOptionTile(bedType: BedType.double, label: 'Double Bed'),
//               Gap(10),
//               BedOptionTile(bedType: BedType.queen, label: 'Queen Bed'),
//             ],
//           ),
//           Gap(20),
//           Text(
//             'Smoking preference',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Gap(10),
//           Obx(
//                 () => InkWell(
//               borderRadius: BorderRadius.circular(8),
//               onTap: (){
//                 checkBead.value = !checkBead.value;
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
//                 decoration: ShapeDecoration(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       width: 0.50,
//                       color: const Color(0xFFDCDEE3),
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Twin Bed',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                         fontFamily: 'Inter',
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Icon(checkBead.value==true?Icons.circle:Icons.circle_outlined,color:checkBead.value!=true?Colors.grey :Colors.green,size: 20,)
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Gap(20),
//           Text(
//             'Others Request',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Obx(
//                 () => InkWell(
//               borderRadius: BorderRadius.circular(8),
//               onTap: (){
//                 checkBead.value = !checkBead.value;
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
//                 decoration: ShapeDecoration(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       width: 0.50,
//                       color: const Color(0xFFDCDEE3),
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Check In Early',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 14,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           'Earliest check-in at 01:00 pm',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 8,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Icon(checkBead.value==true?Icons.circle:Icons.circle_outlined,color:checkBead.value!=true?Colors.grey :Colors.green,size: 20,)
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Gap(10),
//           Obx(
//                 () => InkWell(
//               borderRadius: BorderRadius.circular(8),
//               onTap: (){
//                 checkBead.value = !checkBead.value;
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
//                 decoration: ShapeDecoration(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       width: 0.50,
//                       color: const Color(0xFFDCDEE3),
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Connected Room',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 14,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           'Gat a room with connecting door',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 8,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Icon(checkBead.value==true?Icons.circle:Icons.circle_outlined,color:checkBead.value!=true?Colors.grey :Colors.green,size: 20,)
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Gap(10),
//           Obx(
//                 () => InkWell(
//               borderRadius: BorderRadius.circular(8),
//               onTap: (){
//                 checkBead.value = !checkBead.value;
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
//                 decoration: ShapeDecoration(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       width: 0.50,
//                       color: const Color(0xFFDCDEE3),
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'High Floor',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 14,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           'Gat a room on the high floor',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 8,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Icon(checkBead.value==true?Icons.circle:Icons.circle_outlined,color:checkBead.value!=true?Colors.grey :Colors.green,size: 20,)
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Gap(10),
//           Obx(
//                 () => InkWell(
//               borderRadius: BorderRadius.circular(8),
//               onTap: (){
//                 checkBead.value = !checkBead.value;
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
//                 decoration: ShapeDecoration(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       width: 0.50,
//                       color: const Color(0xFFDCDEE3),
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Others Request',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 14,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           'Write another request here',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 8,
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Icon(checkBead.value==true?Icons.circle:Icons.circle_outlined,color:checkBead.value!=true?Colors.grey :Colors.green,size: 20,)
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Gap(10),
//           TextField(
//             minLines: 5,
//             maxLines: null,
//             decoration: InputDecoration(
//               hintText: 'Enter your message...',
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: Colors.grey,  // Gray border color
//                   width: 1.0,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: Colors.grey.shade700, // Slightly darker gray when focused
//                   width: 1.5,
//                 ),
//               ),
//             ),
//           ),
//           Gap(20),
//           Center(
//             child: Container(
//
//               height: 44,
//               width: 160,
//               alignment: Alignment.center,
//               decoration: ShapeDecoration(
//                 color: Colors.white /* white */,
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(
//                     width: 1,
//                     color: const Color(0xFFDCDEE3) /* Grey-30 */,
//                   ),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 shadows: [
//                   BoxShadow(
//                     color: Color(0x26000000),
//                     blurRadius: 10,
//                     offset: Offset(0, 0),
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Text(
//                 'Request',
//                 style: TextStyle(
//                   color: Colors.black /* Black */,
//                   fontSize: 16,
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//           Gap(20),
//
//
//
//         ],
//
//       ),
//     );
//   }
// }
//
// enum BedType { none, twin, double, queen }
//
// class BedController extends GetxController {
//   Rx<BedType> selectedBed = BedType.none.obs;
// }
// class BedOptionTile extends StatelessWidget {
//   final BedType bedType;
//   final String label;
//   final BedController controller = Get.find();
//
//   BedOptionTile({required this.bedType, required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//           () => InkWell(
//         borderRadius: BorderRadius.circular(8),
//         onTap: () {
//           controller.selectedBed.value = bedType;
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           decoration: ShapeDecoration(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               side: BorderSide(
//                 width: 0.50,
//                 color: const Color(0xFFDCDEE3),
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Icon(
//                 controller.selectedBed.value == bedType
//                     ? Icons.circle
//                     : Icons.circle_outlined,
//                 color: controller.selectedBed.value == bedType
//                     ? Colors.green
//                     : Colors.grey,
//                 size: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// Hello I am Tamim