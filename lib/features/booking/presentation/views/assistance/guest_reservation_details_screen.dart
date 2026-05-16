import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';
import 'package:stayverz_flutter_app/widgets/own_title_app_bar.dart';
import 'package:stayverz_flutter_app/widgets/profile_avatar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../generated/assets.dart';
import '../../../../messaging/presentation/views/message_conversation_page.dart';
import '../../../../reservation/controllers/reservation_controller.dart';
import '../../../data/models/assistance_guest_data.dart';

class ReservationGuetsDetailsScreen extends StatefulWidget {
  final String bookId;
  final String title;
  final bool isShowPhone;
  const ReservationGuetsDetailsScreen({
    super.key,
    required this.bookId,
    required this.title,
    this.isShowPhone = false,
  });

  @override
  State<ReservationGuetsDetailsScreen> createState() =>
      _ReservationGuetsDetailsScreenState();
}

class _ReservationGuetsDetailsScreenState
    extends State<ReservationGuetsDetailsScreen> {
  final ReservationController controller = Get.find<ReservationController>();
  @override
  void initState() {
    // TODO: implement initState
    controller.fetchGuestReservationById(id: widget.bookId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: "Assistance Reservation Details",
        backgroundColor: Colors.white,
        fontColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Obx(() {
            if (controller.isGuestReservationLoading.value) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 1),
              );
            }

            if (controller.reservationGuestHasError.value) {
              return Center(
                child: Text(
                  controller.reservationGuestErrorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final reservation = controller.selectedGuestReservation.value;

            if (reservation == null) {
              return const Center(child: Text("No reservation selected"));
            }
            String formatToDate(String dateTimeString) {
              try {
                DateTime parsed = DateTime.parse(dateTimeString);
                // Format: yyyy-MM-dd
                return "${parsed.year.toString().padLeft(4, '0')}-"
                    "${parsed.month.toString().padLeft(2, '0')}-"
                    "${parsed.day.toString().padLeft(2, '0')}";
              } catch (e) {
                return dateTimeString; // fallback if parsing fails
              }
            }

            return Column(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child:
                      (controller
                                      .selectedGuestReservation
                                      .value
                                      ?.listing
                                      ?.coverPhoto ??
                                  '')
                              .isEmpty
                          ? Image.asset(
                            'assets/default_image.jpg',
                            fit: BoxFit.cover,
                          )
                          : Image.network(
                            "${controller.selectedGuestReservation.value?.listing?.coverPhoto}",
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
                                    image: AssetImage(
                                      Assets.assetsDefaultImage,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${controller.selectedGuestReservation.value!.guest?.firstName}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                          ProfileAvatarWidget(
                            url:
                                "${controller.selectedGuestReservation.value!.guest!.image}",
                            radius: 25,
                          ),
                        ],
                      ),
                      Divider(height: 40, thickness: 0.7),
                      Text(
                        '${controller.selectedGuestReservation.value?.listing?.title}',
                        style: TextStyle(
                          color: const Color(0xFF67666B) /* Grey-70 */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        //'Apr 2 - Apr 3 (1 Night)',
                        '${controller.selectedGuestReservation.value?.checkIn} - ${controller.selectedGuestReservation.value?.checkOut} (${controller.selectedGuestReservation.value?.nightCount} Night)',
                        style: TextStyle(
                          color: const Color(0xFF67666B) /* Grey-70 */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        '${controller.selectedGuestReservation.value?.guestCount} Guests',
                        style: TextStyle(
                          color: const Color(0xFF67666B) /* Grey-70 */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                      const Gap(30),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFDCDEE3) /* Grey-30 */,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 6,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About ${controller.selectedGuestReservation.value?.guest?.firstName}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            const Gap(14),
                            Row(
                              children: [
                                Text(
                                  "ID Verification : ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      (controller
                                                  .selectedGuestReservation
                                                  .value
                                                  ?.guest
                                                  ?.identityVerificationStatus ??
                                              "")
                                          .replaceAll('_', ' ')
                                          .split(' ')
                                          .map(
                                            (word) =>
                                                word.isNotEmpty
                                                    ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                                                    : '',
                                          )
                                          .join(' '),
                                      style: const TextStyle(
                                        color: Color(0xFF67666B),
                                        /* Grey-70 */
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 1.50,
                                      ),
                                    ),
                                    const Gap(8),
                                    Icon(
                                      (() {
                                        final status =
                                            controller
                                                .selectedGuestReservation
                                                .value
                                                ?.guest
                                                ?.identityVerificationStatus ??
                                            "";
                                        if (status.contains('not_verified')) {
                                          return Icons.close;
                                        } else if (status.contains('pending')) {
                                          return Icons
                                              .check_circle; // ⏳ pending icon
                                        } else {
                                          return Icons.check_circle;
                                        }
                                      })(),
                                      color:
                                          (() {
                                            final status =
                                                controller
                                                    .selectedGuestReservation
                                                    .value
                                                    ?.guest
                                                    ?.identityVerificationStatus ??
                                                "";
                                            if (status.contains(
                                              'not_verified',
                                            )) {
                                              return Colors.red;
                                            } else if (status.contains(
                                              'pending',
                                            )) {
                                              return Colors
                                                  .grey; // pending color
                                            } else {
                                              return Colors.green;
                                            }
                                          })(),
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Gap(10),
                            Row(
                              children: [
                                Text(
                                  "Account Type : ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),

                                Row(
                                  children: [
                                    Text(
                                      (() {
                                        final status =
                                            controller
                                                .selectedGuestReservation
                                                .value
                                                ?.guest
                                                ?.identityVerificationStatus ??
                                            "N/A";
                                        return status.isNotEmpty
                                            ? status[0].toUpperCase() +
                                                status
                                                    .substring(1)
                                                    .toLowerCase()
                                            : status;
                                      })(),
                                      style: TextStyle(
                                        color:
                                            controller
                                                        .selectedGuestReservation
                                                        .value
                                                        ?.guest
                                                        ?.identityVerificationStatus ==
                                                    "active"
                                                ? Colors.green
                                                : Color(0xFF67666B),
                                        /* Grey-70 */
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 1.50,
                                      ),
                                    ),
                                    const Gap(8),
                                    Icon(
                                      (controller
                                                          .selectedGuestReservation
                                                          .value
                                                          ?.guest
                                                          ?.identityVerificationStatus ??
                                                      "")
                                                  .toLowerCase() ==
                                              "active"
                                          ? Icons.check_circle
                                          : Icons.close,
                                      color:
                                          (controller
                                                              .selectedGuestReservation
                                                              .value
                                                              ?.guest
                                                              ?.identityVerificationStatus ??
                                                          "")
                                                      .toLowerCase() ==
                                                  "active"
                                              ? Colors.green
                                              : Colors.red,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (widget.isShowPhone == false) Gap(14),
                            if (widget.isShowPhone == false)
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        var phoneNumber =
                                            controller
                                                .selectedGuestReservation
                                                .value
                                                ?.guest
                                                ?.phoneNumber;
                                        final Uri launchUri = Uri(
                                          scheme: 'tel',
                                          path: phoneNumber,
                                        );

                                        if (await canLaunchUrl(launchUri)) {
                                          await launchUrl(launchUri);
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Could not open dialer",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        elevation: 0,
                                        backgroundColor: Colors.black12,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            OwnIcons.call_icon,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                          const Gap(8),
                                          Text(
                                            'Call',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black /* Black */,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if ((controller
                                              .selectedGuestReservation
                                              .value
                                              ?.chatRoomId ??
                                          '')
                                      .isNotEmpty)
                                    Gap(10),
                                  if ((controller
                                              .selectedGuestReservation
                                              .value
                                              ?.chatRoomId ??
                                          '')
                                      .isNotEmpty)
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.toNamed(
                                            MessageConversationScreen.routeName,
                                            arguments: {
                                              'conversationId':
                                                  controller
                                                      .selectedGuestReservation
                                                      .value
                                                      ?.chatRoomId,
                                              'participantId':
                                                  controller
                                                      .selectedGuestReservation
                                                      .value
                                                      ?.guest
                                                      ?.id, // Fallback to room.id if toUser.id is null
                                              'participantName':
                                                  controller
                                                      .selectedGuestReservation
                                                      .value
                                                      ?.guest
                                                      ?.firstName,
                                              'participantAvatar':
                                                  controller
                                                      .selectedGuestReservation
                                                      .value
                                                      ?.guest
                                                      ?.image,
                                              'isOnline': false,
                                              // 'receiver': User(
                                              //   id:
                                              //       "${controller.selectedGuestReservation.value!.guest?.id}",
                                              //   name:
                                              //       controller
                                              //           .selectedGuestReservation
                                              //           .value!
                                              //           .guest
                                              //           ?.firstName ??
                                              //       '',
                                              //   avatar:
                                              //       controller
                                              //           .selectedGuestReservation
                                              //           .value!
                                              //           .guest
                                              //           ?.image ??
                                              //       '',
                                              //   email: '',
                                              // ),
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          elevation: 0,
                                          backgroundColor: Colors.black12,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              OwnIcons.message_icon,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                            const Gap(8),
                                            Text(
                                              'Message',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black /* Black */,
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const Gap(30),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white /* white */,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking Details',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            const Gap(14),
                            Text(
                              'Guests',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              '${controller.selectedGuestReservation.value?.guestCount} guest',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            Divider(height: 15),
                            Text(
                              'Extra guests',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              '${controller.selectedGuestReservation.value?.extraGuestCount} guest',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            Divider(height: 15),
                            Text(
                              'Check-In',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              '${controller.selectedGuestReservation.value?.checkIn}',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            Divider(height: 15),
                            Text(
                              'Checkout',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              '${controller.selectedGuestReservation.value?.checkOut}',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            Divider(height: 15),
                            Text(
                              'Booking date',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              formatToDate(
                                "${controller.selectedGuestReservation.value!.createdAt}",
                              ),
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            Divider(height: 15),
                            Text(
                              'Confirmation Code',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            if(controller.selectedGuestReservation.value?.reservationCode!=null)Text(
                              controller.selectedGuestReservation.value?.reservationCode ?? '',
                              style: TextStyle(
                                color: const Color(0xFF282C35) /* Black-80 */,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(30),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFDCDEE3) /* Grey-30 */,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 6,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Guest Payment',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            const Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '৳${controller.selectedGuestReservation.value?.priceInfo?.entries.first.value.price} x ${controller.selectedGuestReservation.value?.nightCount} nights',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                                Text(
                                  '৳${(((controller.selectedGuestReservation.value?.priceInfo?.entries.first.value.price ?? 0) * (controller.selectedGuestReservation.value?.nightCount ?? 0))).toStringAsFixed(2)}',

                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                            if(controller.selectedGuestReservation.value?.extraGuestCharge != null)Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Extra guest fee',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Text(
                                  '৳${controller.selectedGuestReservation.value?.extraGuestCharge ?? 0}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                            if(controller.selectedGuestReservation.value?.discountAmountApplied != null)Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount amount',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Text(
                                  '৳${controller.selectedGuestReservation.value?.discountAmountApplied ?? 0}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gateway Fee',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Text(
                                  '৳${controller.selectedGuestReservation.value?.guestServiceCharge ?? 0}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Price',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF424141,
                                    ) /* Grey-70 */,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                                Text(
                                  '৳${controller.selectedGuestReservation.value?.totalPrice ?? 0}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF424141,
                                    ) /* Grey-70 */,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                            // const Gap(20),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Host Service Fee',
                            //       style: TextStyle(
                            //         color: const Color(
                            //           0xFF67666B,
                            //         ) /* Grey-70 */,
                            //         fontSize: 16,
                            //         fontFamily: 'Inter',
                            //         fontWeight: FontWeight.w500,
                            //         height: 1.50,
                            //       ),
                            //     ),
                            //     Text(
                            //       '৳${controller.selectedGuestReservation.value?.hostServiceCharge}',
                            //       textAlign: TextAlign.right,
                            //       style: TextStyle(
                            //         color: const Color(
                            //           0xFF67666B,
                            //         ) /* Grey-70 */,
                            //         fontSize: 16,
                            //         fontFamily: 'Inter',
                            //         fontWeight: FontWeight.w500,
                            //         height: 1.50,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      if (controller.selectedGuestReservation.value?.status ==
                              'confirmed' ||
                          controller.selectedGuestReservation.value?.status ==
                              'cancelled')
                        const Gap(30),
                      if (controller.selectedGuestReservation.value?.status ==
                              'confirmed' ||
                          controller.selectedGuestReservation.value?.status ==
                              'cancelled')
                        Align(
                          alignment: Alignment.center,
                          child: OutlinedButton(
                            onPressed: () {
                              if (controller.selectedGuestReservation.value !=
                                  null) {
                                _generateInvoicePdf(
                                  controller.selectedGuestReservation.value!,
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              side: BorderSide(width: 0.7),
                            ),
                            child: Text(
                              'Download Invoice',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      const Gap(30),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFDCDEE3) /* Grey-30 */,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 6,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(),
                            Text(
                              'Cancellation Policy',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              'Non-refundable',
                              style: TextStyle(
                                color: Colors.black /* Black */,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              'You will not receive a refund if you cancel\nyour reservation.',
                              style: TextStyle(
                                color: const Color(0xFF67666B) /* Grey-70 */,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(30),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> _generateInvoicePdf(AssistanceGuestDataNew invoiceData) async {
    final fontData = await rootBundle.load('assets/fonts/NotoSansBengali.ttf');
    final ttf = pw.Font.ttf(fontData);
    final pdf = pw.Document();
    final Uint8List logoBytes = await rootBundle
        .load('assets/stayverz_logo.png')
        .then((data) => data.buffer.asUint8List());
    final image = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              pw.Header(
                level: 0,
                child: pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 10),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Invoice', style: pw.TextStyle(fontSize: 24)),
                          pw.Text(
                            "${invoiceData.invoiceNo}",
                            style: pw.TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                      pw.Container(
                        height: 40,
                        width: 80,
                        child: pw.Image(image, fit: pw.BoxFit.fill),
                      ),
                    ],
                  ),
                ),
              ),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Text(
                  'Mark',
                  style: pw.TextStyle(
                    color: PdfColors.black, // ✅ use PdfColors
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold, // ✅ use pw.FontWeight
                    height: 1.5,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Text(
                  "${invoiceData.listing?.coverageAreaName}",
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.normal,
                    height: 1.5,
                    // font: yourCustomFont, // Optional: if you're using a custom font like 'Inter'
                  ),
                ),
              ),

              pw.Divider(color: PdfColors.black),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Reservation code:',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if you're using the Inter font
                      ),
                    ),

                    pw.Text(
                      "${invoiceData.reservationCode}",
                      textAlign: pw.TextAlign.right, // ✅ Use pdf's TextAlign
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if using Inter font
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(color: PdfColors.black),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Text(
                  'Property:',
                  style: pw.TextStyle(
                    color: PdfColors.black, // ✅ use PdfColors
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold, // ✅ use pw.FontWeight
                    height: 1.5,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Text(
                  "${invoiceData.listing?.title}",
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.normal,
                    height: 1.5,
                    // font: yourCustomFont, // Optional: if you're using a custom font like 'Inter'
                  ),
                ),
              ),

              pw.Divider(color: PdfColors.black),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Text(
                  'Booking Details:',
                  style: pw.TextStyle(
                    color: PdfColors.black, // ✅ use PdfColors
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold, // ✅ use pw.FontWeight
                    height: 1.5,
                  ),
                ),
              ),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Check in date',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if you're using the Inter font
                      ),
                    ),

                    pw.Text(
                      "${invoiceData.checkIn}",
                      textAlign: pw.TextAlign.right, // ✅ Use pdf's TextAlign
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if using Inter font
                      ),
                    ),
                  ],
                ),
              ),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Checkout Date',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if you're using the Inter font
                      ),
                    ),

                    pw.Text(
                      "${invoiceData.checkOut}",
                      textAlign: pw.TextAlign.right, // ✅ Use pdf's TextAlign
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if using Inter font
                      ),
                    ),
                  ],
                ),
              ),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Person (Adults)',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if you're using the Inter font
                      ),
                    ),

                    pw.Text(
                      "${invoiceData.guestCount}",
                      textAlign: pw.TextAlign.right, // ✅ Use pdf's TextAlign
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if using Inter font
                      ),
                    ),
                  ],
                ),
              ),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Person (Childs)',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if you're using the Inter font
                      ),
                    ),

                    pw.Text(
                      "${0}",
                      textAlign: pw.TextAlign.right, // ✅ Use pdf's TextAlign
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if using Inter font
                      ),
                    ),
                  ],
                ),
              ),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total nights',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if you're using the Inter font
                      ),
                    ),

                    pw.Text(
                      "${invoiceData.nightCount}",
                      textAlign: pw.TextAlign.right, // ✅ Use pdf's TextAlign
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if using Inter font
                      ),
                    ),
                  ],
                ),
              ),

              pw.Divider(color: PdfColors.black),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Text(
                  'Mark',
                  style: pw.TextStyle(
                    color: PdfColors.black, // ✅ use PdfColors
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold, // ✅ use pw.FontWeight
                    height: 1.5,
                  ),
                ),
              ),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '৳ ${invoiceData.price}x${invoiceData.nightCount} nights',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        font: ttf,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if you're using the Inter font
                      ),
                    ),

                    pw.Text(
                      '৳ ${invoiceData.totalPrice}',
                      textAlign: pw.TextAlign.right, // ✅ Use pdf's TextAlign
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        font: ttf,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if using Inter font
                      ),
                    ),
                  ],
                ),
              ),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Service fee',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if you're using the Inter font
                      ),
                    ),

                    pw.Text(
                      '৳ ${invoiceData.guestServiceCharge}',
                      textAlign: pw.TextAlign.right, // ✅ Use pdf's TextAlign
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if using Inter font
                      ),
                    ),
                  ],
                ),
              ),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Discount Amount',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if you're using the Inter font
                      ),
                    ),

                    pw.Text(
                      '৳ ${invoiceData.discountAmountApplied}',
                      textAlign: pw.TextAlign.right, // ✅ Use pdf's TextAlign
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.black,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if using Inter font
                      ),
                    ),
                  ],
                ),
              ),

              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Paid amount',
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.black,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if you're using the Inter font
                      ),
                    ),

                    pw.Text(
                      '৳ ${invoiceData.paidAmount}',
                      textAlign: pw.TextAlign.right, // ✅ Use pdf's TextAlign
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.black,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.normal,
                        height: 1.5,
                        // font: interFont, // Uncomment if using Inter font
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(color: PdfColors.black),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Text(
                  'PLEASE BE AWARE THAT OUR INVOICES ARE BASED ON DEPARTURE DATE AND NOT ON ARRIVAL DATE',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    height: 1.5,
                    // font: interFont, // Uncomment this if you're using the Inter font
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Text(
                  'For finance_report and invoice related questions, please visit our help desk www.stayverz.com/support',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.normal,
                    height: 1.5,
                    // font: interFont, // Uncomment if using Inter font
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
            ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}

// Hello I am Tamim