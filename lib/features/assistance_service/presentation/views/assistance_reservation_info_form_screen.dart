import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stayverz_flutter_app/generated/assets.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';

import '../../../booking/data/models/assistance_booking_arguments.dart';
import '../../../../widgets/own_title_app_bar.dart';
import '../../../booking/presentation/views/assistance/public_assistance_payment_screen.dart';
import '../../../public_listings/presentation/views/image_vew_screen.dart';
import '../../controllers/public_assistance_service_controller.dart';
import '../../models/single_assistance_listing_response_model.dart';
import '../../models/single_public_assistance_listing_response_model.dart';
import '../widgets/curve_gellary_widget.dart';
import '../widgets/location_suggestor_text_field_widget.dart';
import 'public_assistance_all_review_screen.dart';

class AssistanceReservationInfoFormScreen extends GetView<PublicAssistanceServiceController> {
  static const String route = '/assistance_reservation_info_form';
  const AssistanceReservationInfoFormScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (canPop, value) {
        controller.extraGuestCount.value = 0;
        if(controller.bookingLocationController.text.isNotEmpty){
          controller.bookingLocationController.clear();
        }
        if(controller.bookingContactController.text.isNotEmpty){
          controller.bookingContactController.clear();
        }
      },
      child: Scaffold(
        appBar: OwnTitleAppBar(
          appBarText: "Booking Details",
          onPressed: () => Get.back(),
          buttonIconColor: Colors.black,
          backgroundColor: Colors.white,
          fontColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Participation',
                        style: TextStyle(
                          color: Colors.black /* Black */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                      ),
                      Text(
                        'The booking allows a maximum of ${controller.publicListingDetails.value?.maxPerson} guests. An additional charge of BDT ${controller.publicListingDetails.value?.extraChargePerPerson ?? 0} per person will apply for each extra guest.',
                        style: TextStyle(
                          color: const Color(0xFF67666B) /* Grey-70 */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      const Gap(24),
                      Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Extra guest", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: controller.extraGuestCount.value > 0 ? controller.decrementGuestCount : null,
                                    icon: Icon(Icons.remove_circle_outline),
                                  ),
                                  Text('${controller.extraGuestCount.value}', style: TextStyle(fontSize: 16)),
                                  IconButton(
                                    onPressed: controller.incrementGuestCount,
                                    icon: Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      ),
                      const Gap(8),
                      Text(
                        'Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.07,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                      const Gap(8),
                      CustomInputText(
                        controller: controller.bookingLocationController,
                      ),
                      // LocationSuggesterTextFieldWidget(
                      //   controller: controller.bookingLocationController,
                      //   hintText: 'Enter area',
                      //   onSuggestionSelected: (suggestion) async {
                      //     controller.selectedBookingLocation = suggestion;
                      //     controller.bookingLocationController.text = suggestion.address ?? '';
                      //   },
                      // ),
                      const Gap(18),
                      Text(
                        'Contact Number',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.07,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                      const Gap(8),
                      CustomInputText(
                        controller: controller.bookingContactController,
                        helperText: '01XXXXXXXXX',
                        keyboardType: TextInputType.phone,
                      ),
                      const Gap(24)
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(width: 1, color: Colors.deepOrange)
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 3,
                      offset: Offset(0, 0),
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 4,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            '৳${controller.publicListingDetails.value?.price}/',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            'per day',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {

                            if(controller.bookingLocationController.text.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please enter the booking location",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                              );
                              return;
                            }

                            if(controller.bookingContactController.text.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please enter the booking contact number",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                              );
                              return;
                            }

                            Get.toNamed(
                              PublicAssistancePaymentScreen.route,
                              arguments: AssistanceBookingArguments(
                                assistanceData: controller.publicListingDetails.value,
                                nightCount: controller.selectedDateCount.value,
                                checkIn: controller.selectedDates.first,
                                checkOut: controller.selectedDates.last,
                                extraGuestCount: controller.extraGuestCount.value,
                                phoneNumber: controller.bookingContactController.text,
                                location: controller.bookingLocationController.text,
                              ).toJson()
                            );

                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 48),
                              backgroundColor: Colors.deepOrange
                          ),
                          child: Text(
                            'Next',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                            ),
                          )
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Hello I am Tamim