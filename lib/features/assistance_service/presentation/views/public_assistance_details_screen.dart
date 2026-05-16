import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stayverz_flutter_app/generated/assets.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../main.dart';
import '../../../../widgets/own_title_app_bar.dart';
import '../../../public_listings/presentation/views/image_vew_screen.dart';
import '../../controllers/public_assistance_service_controller.dart';

import '../../models/single_public_assistance_listing_response_model.dart';
import '../widgets/curve_gellary_widget.dart';
import 'assistance_schedule_booking_screen.dart';
import 'public_assistance_all_review_screen.dart';



class PublicAssistanceDetailsScreen
    extends GetView<PublicAssistanceServiceController> {
  static const String route = '/public_assistance_details';
  const PublicAssistanceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: "Assistance Details",
        onPressed: () {
          Get.back();
        },
        buttonIconColor: Colors.black,
        backgroundColor: Colors.white,
        fontColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoadingPublicAssistance.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        PublicAssistanceData? data = controller.publicListingDetails.value;
        return SingleChildScrollView(
          padding: EdgeInsets.only(left: 16, right: 16,top: 10,bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((data?.images ?? []).isNotEmpty) ...[
                Text(
                  'Specialties',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
                CurvedGallery(
                  containerColors: data?.images ?? [],
                  onImageClick: (index) {
                    Get.to(
                      () => ImageGalleryScreen(
                        imageUrls: controller.publicListingDetails.value?.images ?? [],
                        initialIndex: index,
                      ),
                    );
                  },
                  onSeeAllTab: () {
                    Get.to(
                      () => ImageGalleryScreen(
                        imageUrls:
                            controller.publicListingDetails.value?.images ?? [],
                        initialIndex: 0,
                      ),
                    );
                  },
                ),
                const Gap(38),
              ],
              if ((data?.title ?? '').isNotEmpty) ...[
                Text(
                  data?.title ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(16),
              ],
              if ((data?.aboutYou ?? '').isNotEmpty) ...[
                Text(
                  data?.aboutYou ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                const Gap(26),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 4,
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 20),
                      Text(
                        '${data?.avgRating ?? 0} . ${data?.totalRatingCount ?? 0} Reviews',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black /* Black */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if((data?.reviews ?? []).isNotEmpty)SizedBox(
                    height: 25,
                    child: TextButton.icon(
                      onPressed: () {
                        Get.toNamed(PublicAssistanceAllReviewScreen.route);
                      },
                      icon: Icon(Icons.arrow_forward),
                      iconAlignment: IconAlignment.end,
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        foregroundColor: const Color(0xFFF15925),
                        padding: EdgeInsets.zero,
                        iconSize: 14,
                      ),
                      label: Text("View All"),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              if((data?.reviews ?? []).isNotEmpty)...[SizedBox(
                height: 124,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    var review = data?.reviews?[index];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            spacing: 6,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ...List.generate(
                                    review?.rating ?? 0,
                                    (i) => Icon(Icons.star_sharp, size: 16),
                                  ),
                                  Text(
                                    '. 1 week ago',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black /* Black */,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                review?.review ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  color: Colors.deepOrangeAccent,
                                ),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    review?.reviewBy?.image ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, data, stack) => Image.asset(
                                          Assets.assetsDefaultImage,
                                          fit: BoxFit.fill,
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  review?.reviewBy?.name ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black /* Black */,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const Gap(16),
                  itemCount: data?.reviews?.length ?? 0,
                ),
              ),
              const Gap(40)],
              if (controller.publicListingDetails.value?.meetupPoint !=
                  null) ...[
                Text(
                  "I'll meet you at your location.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(20),
                Text(
                  "Currently serving clients in ${controller.publicListingDetails.value?.meetupPointName ?? ''}. For bookings outside these areas, please contact me directly.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                const Gap(16),
                MeetUpLocationMapView(
                  lat: (controller.publicListingDetails.value?.meetupPoint?.coordinates ?? []).last,
                  lng: (controller.publicListingDetails.value?.meetupPoint?.coordinates ?? []).first,
                ),
              ],
              const Gap(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text(
                    'Key Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  Row(
                    spacing: 14,
                    children: [
                      SvgPicture.asset(Assets.assetsGuestRequirementsIcon),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Guest requirements\n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Service includes ${controller.publicListingDetails.value?.maxPerson ?? 0} people. ৳${controller.publicListingDetails.value?.extraChargePerPerson ?? 0} fee for every extra person.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 14,
                    children: [
                      SvgPicture.asset(Assets.assetsGuestRequirementsIcon),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Cancellation Policy\n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text:
                                  controller
                                      .publicListingDetails
                                      .value
                                      ?.cancellationPolicy
                                      ?.description ??
                                  '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(48),
              Container(
                padding: EdgeInsets.all(4),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(width: 1, color: Colors.deepOrange),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 3,
                      offset: Offset(0, 0),
                      spreadRadius: 2,
                    ),
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
                            '৳${data?.price}/',
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!mainControl.isLogin.value) {
                            Get.toNamed(AppRoute.login);
                            return;
                          }

                          Get.toNamed(AssistanceScheduleBookingScreen.route);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 48),
                          backgroundColor: Colors.deepOrange,
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
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Gap(20),
            ],
          ),
        );
      }),
    );
  }

  String formatToDayMonthYear(String input) {
    try {
      DateTime dateTime = DateTime.parse(input);
      return DateFormat('d MMM yyyy').format(dateTime); // e.g. 4 Jun 2025
    } catch (e) {
      return 'Invalid date';
    }
  }

}

class MeetUpLocationMapView extends GetView<PublicAssistanceServiceController> {
  final double lat, lng;
  MeetUpLocationMapView({super.key, required this.lat, required this.lng});

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late final Set<Marker> _markers = {
    Marker(markerId: MarkerId('marker_1'), position: LatLng(lat, lng)),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 194,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: 14.4746,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController mapController) {
          _controller.complete(mapController);
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(lat, lng),
                zoom: 16.0,
              ),
            ),
          );
        },
        onTap: (location) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

// Hello I am Tamim