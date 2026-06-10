import 'dart:math';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../views/home_root/booking/booking_screen.dart';
import '../../../listing/models/aminities_new_model.dart';
import '../../../messaging/data/models/chat_room_model.dart';
import '../../../messaging/presentation/views/message_conversation_page.dart';
import '../../data/models/listing_details_model.dart' hide User;
import '../../data/models/message_id_get_modeldata.dart';
import '../controllers/public_listings_controller.dart';
import '../../../../features/wishlist/presentation/controllers/wishlist_controller.dart';
import '../../../../features/wishlist/presentation/bindings/wishlist_binding.dart';
import 'image_vew_screen.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PublicListingDetailsView extends GetView<PublicListingsController> {
  const PublicListingDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize wishlist binding if not already done
    if (!Get.isRegistered<WishlistController>()) {
      WishlistBinding().dependencies();
    }
    final wishlistController = Get.find<WishlistController>();

    // Fetch my_listing details after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateSelectedDates([]);
      controller.selectedDateCount.value = 0;
      // Get the id from arguments
      if (Get.arguments != null && Get.arguments['id'] != null) {
        // Set the id parameter for the controller
        Get.parameters['id'] = Get.arguments['id'].toString();
        // Fetch my_listing details
       controller.fetchListingDetails().then((_) {
  final hostId = controller.listingDetails.value.host?.id;
  print('✅ hostId after fetch: $hostId');
  if (hostId != null) {
    controller.fetchHostAvgResponseTime(hostId: hostId);
  } else {
    print('⚠️ hostId is null after fetchListingDetails');
  }
});


        // Check if this my_listing is in wishlist
        final listingId = int.tryParse(Get.arguments['id'].toString());
        if (listingId != null) {
          wishlistController.isInWishlist(listingId);
        }
      }
    });

    void openImageGalleryBottomSheet(BuildContext context) {
      final details = controller.listingDetails.value;

      final Map<String, List<String>?> imageSections = {
        'All Images': details.images,
        'Living Room': details.living_room_images,
        'Kitchen': details.kitchen_images,
        'Bathroom': details.bathroom_images,
        'Bedroom': details.bedroom_images,
        'Washroom': details.washroom_images,
      };

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: imageSections.entries.map((entry) {
                  final images = entry.value;
                  final hasImages = images != null && images.isNotEmpty;

                  // Decide layout type
                  final layoutType = (entry.key == 'All Images' || entry.key == 'Living Room')
                      ? ImageLayoutType.type1
                      : ImageLayoutType.type2;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: hasImages
                        ? imageGalleryView(
                      title: entry.key,
                      layoutType: layoutType,
                      images: images,
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: const Text(
                            'No images available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    }

    Widget _statDot(Color color, String label) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.black54),
      ),
    ],
  );
}
    void _share(BuildContext context, String url) async {
      await Share.share(
        url,
        subject: 'Check this out!',
      );
    }

// In your controller class

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {

        // Show loading indicator when data is being fetched
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.deepOrangeAccent),
                SizedBox(height: 16),
                Text(
                  'Loading details...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        // Show error message if there's an error
        if (controller.hasListingDetailsError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error loading details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.fetchListingDetails(),
                  child: Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        final config = CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.range,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          selectedDayHighlightColor: Colors.red,

          // ✅ Logic for selectable days
          selectableDayPredicate: (day) {
            final key =
                "${day.year.toString().padLeft(4, '0')}-"
                "${day.month.toString().padLeft(2, '0')}-"
                "${day.day.toString().padLeft(2, '0')}";

            final data = controller.listingDetails.value.calendarData?[key];

            // 🚫 Blocked/booked logic
            if (data != null && (data.isBooked == true || data.isBlocked == true)) {
              // ✅ Check previous day
              final prevDay = day.subtract(const Duration(days: 1));
              final prevKey =
                  "${prevDay.year.toString().padLeft(4, '0')}-"
                  "${prevDay.month.toString().padLeft(2, '0')}-"
                  "${prevDay.day.toString().padLeft(2, '0')}";

              final prevData = controller.listingDetails.value.calendarData?[prevKey];

              // Allow selection if previous date is free
              if (prevData == null || (prevData.isBooked != true && prevData.isBlocked != true)) {
                return true; // ✅ selectable
              }

              return false; // ❌ otherwise block
            }

            return true; // ✅ normal free day
          },
        );
        final amenities = controller.listingDetails.value.amenities;
        // Show content when data is loaded
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 0),
          children: [

            Container(
              // padding: EdgeInsets.only(right: 20),
              // margin: EdgeInsets.all(12),
              width: MediaQuery.of(context).size.width,
              height: 295,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
               // borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  // Carousel Slider
                  Obx(() {
                    final images = controller.listingDetails.value.images;
                    final hasImages = images != null && images.isNotEmpty;
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 360,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: hasImages && images.length > 1,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        onPageChanged: (index, reason) {
                          controller.currentImageIndex.value = index;
                        },
                      ),
                      items: hasImages
                          ? images.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                              //  borderRadius: BorderRadius.all(Radius.circular(16)),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    imageUrl,
                                    maxHeight: 1200,
                                    maxWidth: 1200,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList()
                          : [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            image: DecorationImage(
                              image: AssetImage("assets/default_image.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  // Overlay Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: (controller.listingDetails.value.instantBookingAllowed ?? false)
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                        children: [
                          // Instant Booking Badge
                          if (controller.listingDetails.value.instantBookingAllowed ?? false)
                            Transform.rotate(
                              angle: -45 * math.pi / 180,
                              origin: Offset(0, 42),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.deepOrangeAccent.shade200,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                child: Text(
                                  "Instant Booking",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                          // Wishlist Button
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                if (!mainControl.isLogin.value) {
                                  Get.toNamed(AppRoute.login);
                                  return;
                                }

                                final listingId = controller.listingDetails.value.id;
                                if (listingId != null) {
                                  Get.find<WishlistController>().toggleWishlist(listingId);
                                }
                              },
                              child: Opacity(
                                opacity:1,
                                child: Obx(() {
                                  final listingId = controller.listingDetails.value.id;
                                  final isInWishlist = listingId != null &&
                                      (Get.find<WishlistController>().inWishlistMap[listingId] ?? false);
                                  return Container(
                                    padding: EdgeInsets.all(6),
                                    margin: EdgeInsets.only(right: 10),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                    ),
                                    child: Icon(
                                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                                      color: const Color(0xFFF15925),

                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(10),

                      // Share Button
                      Opacity(
                        opacity:1,
                        child: GestureDetector(
                          onTap: () {
                            _share(
                              context,
                              'https://stayverz.com/rooms/${controller.listingDetails.value.uniqueId}',
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(6),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Icon(
                              Icons.share,

                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),

                      // Image Counter
                      Obx(() {
                        final images = controller.listingDetails.value.images;
                        final imageCount = images?.length ?? 0;
                        final currentIndex = controller.currentImageIndex.value;

                        if (imageCount == 0) return SizedBox.shrink();

                        return Opacity(
                          opacity: 1,
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            width: 50,
                            alignment: Alignment.center,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:  Colors.black.withValues(alpha: 0.40),
                            ),
                            child: Text(
                              "${currentIndex + 1}/$imageCount",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }),
                      Gap(10),
                    ],
                  ),

                  Positioned(
                    top: 20,
                    left: 20,
                    child: InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${controller.listingDetails.value.title}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF090909),
                  fontSize: 26,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ),
            Gap(6),

            Row(
              children: [
                Gap(20),
                Icon(Icons.star,color: Colors.yellow,size: 15,),
                Gap(4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:   '${controller.listingDetails.value.avgRating}',
                        style: TextStyle(
                          color: const Color(0xFF5D5F61),
                          fontSize: 12,
                          fontFamily: 'Airbnb Cereal App',
                          fontWeight: FontWeight.w400,

                        ),
                      ),
                      TextSpan(
                        text: ' - ',
                        style: TextStyle(
                          color: const Color(0xFF5D5F61),
                          fontSize: 12,
                          fontFamily: 'Airbnb Cereal App',
                          fontWeight: FontWeight.w400,

                        ),
                      ),
                      TextSpan(
                        text: '${controller.listingDetails.value.totalRatingCount} reviews',
                        style: TextStyle(
                          color: const Color(0xFF5D5F61),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,

                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(5),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                '${controller.listingDetails.value.address}'??"N/A",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF717375),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,

                ),
              ),
            ),

            Gap(5),
            Divider(color: const Color(0xFFDCDEE3)),
            Gap(5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (
                  int i = 0;
                  i < controller.roomDetailsList.length;
                  i++
                  ) ...[
                    // Changed from myRoomList to controller.roomDetailsList
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          controller.roomDetailsList[i]['icon']
                          as IconData, // Changed from myRoomList to controller.roomDetailsList
                          size: 16,
                          color: Color(0xFF67666B),
                        ),
                        SizedBox(height: 8),
                        Text(
                          " ${getCountByIndex(i)} ${controller.roomDetailsList[i]['title']}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF67666B),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                    // if (i != controller.roomDetailsList.length - 1)  // Changed from myRoomList to controller.roomDetailsList
                    //   SizedBox(width: 5), // spacing between items, not after the last one
                  ],
                ],
              ),
            ),
            Gap(10),
            Divider(color: const Color(0xFFDCDEE3)),
            Gap(10),
            if ((controller.listingDetails.value.lengthOfStayDiscounts ?? {}).isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'You have ${controller.listingDetails.value.lengthOfStayDiscounts!.entries.first.value}% discount up to ${controller.listingDetails.value.lengthOfStayDiscounts!.entries.first.key} days reservation',
                ),
              ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Description',
                // test
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(10),
// NEW CODE - Better handling for HTML / Markdown / Plain text
Padding(
  padding: EdgeInsets.symmetric(horizontal: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Preview with limited height
      SizedBox(
        height: 88, // ≈ 4 lines
        child: ClipRect(
          child: buildFormattedText(
            controller.listingDetails.value.description ?? '',
          ),
        ),
      ),
      const SizedBox(height: 6),
      GestureDetector(
        onTap: () => _showDescriptionBottomSheet(
          context,
          controller.listingDetails.value.description ?? '',
        ),
        child: Text(
          'Show more >',
          style: TextStyle(
            color: Color(0xFFF15B25),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.38,
          ),
        ),
      ),
    ],
  ),
),
           
            Gap(15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'What this place offers',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(10),
            (amenities != null && amenities.isNotEmpty)
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                final visibleItems = controller.showAllAmenities.value
                    ? amenities
                    : amenities.take(4).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      direction: Axis.vertical,
                      children: List.generate(
                        visibleItems.length,
                            (i) {
                          final amenity = visibleItems[i].amenity;

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              //   color: const Color(0xFFF0F1F5),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildAmenityIcon(amenity.icon),
                                const SizedBox(width: 8),
                                Text(
                                  amenity.name ??'',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    /// VIEW ALL BUTTON

                  ],
                );
              }),
            )
                : const Center(child: Text('Update soon')),
              Gap(10),
            if(controller.amenitiesList.length>0)
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (_) => FractionallySizedBox(
                    heightFactor: 0.85, // 👈 90% screen height
                    child: SafeArea(
                      top: false, // allow rounded top
                      child: AmenitiesBottomSheet(
                        listingAmenities:
                        controller.listingDetails.value.amenities ?? [],
                        allCategorizedAmenities: controller.amenitiesList,
                        buildIcon: buildAmenityIcon,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin:EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFE4E9EC)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Show all amenities',
                  style: const TextStyle(
                    color: Color(0xFF3D3F40),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.38,
                  ),
                ),
              ),
            ),
            Gap(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'House Rules',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Check-in ${controller.listingDetails.value.checkIn} PM',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Gap(6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Check-out ${controller.listingDetails.value.checkOut} AM',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Gap(6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${controller.listingDetails.value.guestCount} guests maximum',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Gap(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Cancellation policy',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Cancellation policy is ${controller.listingDetails.value.cancellationPolicy?.policyName ?? ""}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Gap(6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                controller
                    .listingDetails
                    .value
                    .cancellationPolicy
                    ?.description ??
                    '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Gap(6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Refund protection by Stayverz',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Gap(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      openImageGalleryBottomSheet(context);
                    },
                    child: Text(
                      'See All >>',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Gap(20),
            (controller.listingDetails.value.images ?? []).isEmpty
                ? Center(child: Text('Update soon'))
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: min(
                  4,
                  controller.listingDetails.value.images?.length ?? 0,
                ), // Changed from items.length to controller.galleryImages.length
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  mainAxisSpacing: 12, // Vertical gap
                  crossAxisSpacing: 12, // Horizontal gap
                  childAspectRatio:
                  (MediaQuery.of(context).size.width / 2 - 20) / 175,
                  // width / height to maintain height = 175
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                            () => ImageGalleryScreen(
                          imageUrls:
                          controller.listingDetails.value.images!,
                          initialIndex: index,
                        ),
                      );
                    },
                    child: Container(
                      height: 175,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        controller.listingDetails.value.images![index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 175,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 175,
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
                  );
                },
              ),
            ),
            Gap(15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Obx(
                    () => Text(
                  '${controller.selectedDateCount.value == 0 ? 0 : controller.selectedDateCount.value} nights in ${controller.listingDetails.value.title}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                final dates = controller.selectedDates;
                String text;

                String formatDate(DateTime? dt) {
                  if (dt == null) return "";
                  return DateFormat(
                    'MMM d, yyyy',
                  ).format(dt); // e.g. Feb 6, 2026
                }

                if (dates.isEmpty || dates[0] == null) {
                  text = "Arrival Date - Leaving Date";
                } else if (dates[0] != null &&
                    (dates.length < 2 || dates[1] == null)) {
                  text = "${formatDate(dates[0])} - Leaving Date";
                } else if (dates.length >= 2 &&
                    dates[0] != null &&
                    dates[1] != null) {
                  text = "${formatDate(dates[0])} - ${formatDate(dates[1])}";
                } else {
                  text = "Arrival Date - Leaving Date";
                }

                return Text(
                  text,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Color(0xFFA9A9B0), // Grey-50
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                );
              }),
            ),

            // CalendarDatePicker2(
            //   config: config,
            //   value: controller.selectedDates,
            //   onValueChanged: (dates) {
            //     if (dates.length >= 2 && dates[0] != null && dates[1] != null) {
            //       final start = dates[0]!;
            //       final end = dates[1]!;
            //
            //       bool hasDisabledDate = false;
            //       int totalDays = 0;
            //
            //       for (
            //         DateTime day = start;
            //         day.isBefore(end.add(Duration(days: 1)));
            //         day = day.add(Duration(days: 1))
            //       ) {
            //         final key =
            //             "${day.year.toString().padLeft(4, '0')}-"
            //             "${day.month.toString().padLeft(2, '0')}-"
            //             "${day.day.toString().padLeft(2, '0')}";
            //
            //         final data =
            //             controller.listingDetails.value.calendarData?[key];
            //         if (data != null &&
            //             (data.isBooked == true || data.isBlocked == true)) {
            //           hasDisabledDate = true;
            //           break;
            //         }
            //         totalDays++;
            //       }
            //
            //       if (hasDisabledDate) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(
            //             content: Text(
            //               "Selected range contains blocked/booked dates",
            //             ),
            //           ),
            //         );
            //         return;
            //       }
            //
            //       controller.updateSelectedDates(dates);
            //       controller.selectedDateCount.value = totalDays;
            //     } else {
            //       controller.updateSelectedDates(dates);
            //       controller.selectedDateCount.value = 0;
            //     }
            //   },
            // ),
            CalendarDatePicker2(
              config: config,
              value: controller.selectedDates,
              onValueChanged: (dates) {
                if (dates.length >= 2 && dates[0] != null && dates[1] != null) {
                  final start = dates[0]!;
                  final end = dates[1]!;

                  DateTime? adjustedEnd;

                  for (DateTime day = start.add(const Duration(days: 1));
                  day.isBefore(end.add(const Duration(days: 1)));
                  day = day.add(const Duration(days: 1))) {
                    final key =
                        "${day.year.toString().padLeft(4, '0')}-"
                        "${day.month.toString().padLeft(2, '0')}-"
                        "${day.day.toString().padLeft(2, '0')}";

                    final data = controller.listingDetails.value.calendarData?[key];

                    if (data != null && (data.isBooked == true || data.isBlocked == true)) {
                      // ✅ Check previous day
                      final prevDay = day.subtract(const Duration(days: 1));
                      final prevKey =
                          "${prevDay.year.toString().padLeft(4, '0')}-"
                          "${prevDay.month.toString().padLeft(2, '0')}-"
                          "${prevDay.day.toString().padLeft(2, '0')}";

                      final prevData = controller.listingDetails.value.calendarData?[prevKey];

                      // If previous date is free, allow current blocked date as selectable
                      if (prevData == null || (prevData.isBooked != true && prevData.isBlocked != true)) {
                        adjustedEnd = day; // allow selection of this blocked date
                      } else {
                        adjustedEnd = day.subtract(const Duration(days: 1)); // stop before blocked
                      }
                      break;
                    }
                  }

                  if (adjustedEnd != null) {
                    controller.updateSelectedDates([start, adjustedEnd]);
                    controller.selectedDateCount.value = adjustedEnd.difference(start).inDays;
                  } else {
                    controller.updateSelectedDates(dates);
                    controller.selectedDateCount.value = end.difference(start).inDays;
                  }
                } else {
                  controller.updateSelectedDates(dates);
                  controller.selectedDateCount.value = 0;
                }
              },
            ),


            Gap(16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(9),
              decoration: ShapeDecoration(
                color: Colors.white /* white */,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFF0F1F5) /* Grey-10 */,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD9D9D9),
                            shape: OvalBorder(),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image:
                                controller.listingDetails.value.coverPhoto ==
                                    null ||
                                    controller
                                        .listingDetails
                                        .value
                                        .coverPhoto ==
                                        ""
                                    ? AssetImage("assets/default_image.jpg")
                                    : NetworkImage(
                                  controller
                                      .listingDetails
                                      .value
                                      .coverPhoto ??
                                      "",
                                ),
                                fit: BoxFit.cover,
                              ),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                        Gap(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Hosted by',
                                style: TextStyle(
                                  color: const Color(0xFF67666B) /* Grey-70 */,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                              Gap(5),
                              Text(
                                controller.listingDetails.value.host?.fullName ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Joined in ${formatToDayMonthYear("${controller.listingDetails.value.host?.dateJoined}")}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: const Color(0xFF67666B) /* Grey-70 */,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Colors.yellow,
                                      ),
                                      Gap(5),
                                      Text(
                                        '${(controller.listingDetails.value.reviews ?? []).length} Reviews',
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
                                ],
                              ),

                              // ✅ ADD THIS BELOW

// ✅ NEW: Conditional Response Time Label
Obx(() {
  final data = controller.hostAvgResponseTime;
  if (data.isEmpty || data['data'] == null) return const SizedBox.shrink();

  final overall = data['data']['overall'];
  final replied = data['data']['replied'];
  final pending = data['data']['pending'];

  final avgTimeInSeconds = overall?['avg_response_time_seconds'] ?? 0;
  final avgFormatted = overall?['avg_response_time_formatted'] ?? 'N/A';
  final totalResponses = replied?['total_responses'] ?? 0;
  final totalPending = pending?['total_pending'] ?? 0;
  final totalConversations = overall?['total_conversations'] ?? 0;
  final responseRate = totalConversations > 0
      ? ((totalResponses / totalConversations) * 100).round()
      : 0;

  // 🎯 Categorize response time (User-friendly labels)
  String responseTitle;
  Color titleColor;
  IconData titleIcon;

  if (avgTimeInSeconds <= 3600) {                    // ≤ 1 hour
    responseTitle = "Lightning Fast";
    titleColor = Colors.green;
    titleIcon = Icons.bolt;
  } 
  else if (avgTimeInSeconds <= 7200) {               // ≤ 2 hours
    responseTitle = "Very Fast";
    titleColor = Colors.green;
    titleIcon = Icons.flash_on;
  } 
  else if (avgTimeInSeconds <= 14400) {              // ≤ 4 hours
    responseTitle = "Fast";
    titleColor = Colors.orange;
    titleIcon = Icons.thumb_up_alt_outlined;
  } 
  else if (avgTimeInSeconds <= 28800) {              // ≤ 8 hours
    responseTitle = "Quick Responder";
    titleColor = Colors.orange;
    titleIcon = Icons.schedule;
  } 
  else if (avgTimeInSeconds <= 86400) {              // ≤ 24 hours
    responseTitle = "Usually responds within a day";
    titleColor = Colors.deepOrange;
    titleIcon = Icons.timer_outlined;
  } 
  else {                                             // > 24 hours
    responseTitle = "Responds within a few days";
    titleColor = Colors.redAccent;
    titleIcon = Icons.hourglass_bottom;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Gap(10),
      const Divider(color: Color(0xFFF0F1F5)),
      const Gap(6),

      // Dynamic Title Row
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: titleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(titleIcon, color: titleColor, size: 18),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                responseTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Responds in $avgFormatted',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      const Gap(8),

      // Stats Row
      Wrap(
        spacing: 12,
        runSpacing: 4,
        children: [
          _statDot(Colors.green, '$totalResponses responses'),
          _statDot(Colors.orange, '$totalPending waiting for reply'),
          _statDot(Colors.blue, '$responseRate% response rate'),
        ],
      ),
    ],
  );
}),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {

                          if(!mainControl.isLogin.value) {
                            Get.toNamed(AppRoute.login);
                            return;
                          }

                          final dates = controller.selectedDates;



                          // Check if check-in and check-out dates are selected
                          if (dates.length < 2) {
                            Fluttertoast.showToast(
                              msg:
                              "Please select both check-in and check-out dates.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                            );
                            return;
                          }

                          int totalNights = controller.selectedDateCount.value;


                          if (totalNights <= 0) {
                            Fluttertoast.showToast(
                              msg:
                              "Invalid date range. Check-out must be after check-in.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                            );
                            return;
                          }

                          final hostId =
                              controller.listingDetails.value.host?.id;
                          if (hostId == null) {
                            Fluttertoast.showToast(
                              msg: "Host information not available.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                            );
                            return;
                          }

                          String formatDate(DateTime? dt) {
                            if (dt == null) return "";
                            return DateFormat(
                              'yyyy-MM-dd',
                            ).format(dt); // API format
                          }

                          final String checkInDate = formatDate(dates[0]);
                          final String checkOutDate = formatDate(dates[1]);



                          /// 🔽 Show Dialog and get user message
                          String? userMessage = await showDialog<String>(
                            context: context, // 🔥 use widget context
                            builder: (context) {
                              final TextEditingController messageController =
                              TextEditingController();

                              return AlertDialog(
                                title: const Text('Send Message'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Check-in: ",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(checkInDate),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text(
                                          "Check-out: ",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(checkOutDate),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: messageController,
                                      maxLines: 4,
                                      decoration: const InputDecoration(
                                        hintText: 'Write your message here...',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context), // cancel
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final text = messageController.text.trim();
                                      if (text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: 'Message cannot be empty',
                                        );
                                        return;
                                      }
                                      Navigator.pop(context, text); // 🔥 return value
                                    },
                                    child: const Text('Submit'),
                                  ),
                                ],
                              );
                            },
                          );

                          /// ❌ If cancelled or empty
                          if (userMessage == null || userMessage.isEmpty) {
                            return;
                          }

                          /// ✅ Build and send request now
                          final messageRequest = MessageBookingRequest(
                            listing: controller.listingDetails.value.id,
                            toUser: hostId,
                            bookingData: MessageBookingData(
                              checkIn: checkInDate,
                              checkOut: checkOutDate,
                              adult: 1,
                              children: 0,
                              infant: 0,
                              pets: 0,
                              totalGuestCount: 1,
                            ),
                            message: userMessage,
                          );

                          // Show loading
                          // showDialog(
                          //   context: context,
                          //   barrierDismissible: false,
                          //   builder: (_) => const Center(
                          //     child: CircularProgressIndicator(),
                          //   ),
                          // );

                          // API call
                          await controller.startUserChatRequest(
                            request: messageRequest,
                            guestId: mainControl.userId.value, // ADD THIS
                          );

                          // Close loading
                          Get.back();

                          // Show result
                          if (controller.chatRoomId.value.isNotEmpty) {


                            Get.toNamed(
                              MessageConversationScreen.routeName,
                              arguments: {
                                'conversationId': controller.chatRoomId.value,
                                'participantId': mainControl.userId.value, // Fallback to room.id if toUser.id is null
                                'participantName': controller.listingDetails.value.host?.fullName ?? '',
                                'participantAvatar': controller.listingDetails.value.host?.image ?? '',
                                'isOnline': false,
                                'receiver': User(
                                  id: "${controller.listingDetails.value.host?.id ?? ''}",
                                  name: controller.listingDetails.value.host?.fullName ?? '',
                                  avatar: controller.listingDetails.value.host?.image ?? '',
                                  email: controller.listingDetails.value.host?.email ?? '',
                                )
                              },
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg:
                              controller.errorMessage.value.isNotEmpty
                                  ? controller.errorMessage.value
                                  : 'Failed to start chat.',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.zero,
                          side: BorderSide(width: 0.6, color: Colors.black12),
                          elevation: 2,
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(OwnIcons.message_icon, size: 16, color: Colors.black,),
                            SizedBox(width: 5),
                            Text(
                              'Message',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.safety_check, size: 25, color: Colors.red),
                  Gap(10),
                  Expanded(
                    child: Text(
                      'To protect your payment, never transfer money or communicate outside of the Stayverz website or app.',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(25),
            InkWell(
              onTap: (controller.listingDetails.value.reviews ?? []).isEmpty ? null : (){
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Reviews",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.grey.shade200
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: ShapeDecoration(
                                                shape: CircleBorder(),
                                                color: Colors.white
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.network(
                                                controller.listingDetails.value.reviews![index].reviewBy.image,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, object, trace) {
                                                  return Icon(Icons.person);
                                                }
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            spacing: 4,
                                            children: [
                                              Text(
                                                controller.listingDetails.value.reviews![index].reviewBy.fullName,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              RatingBar.builder(
                                                initialRating: double.parse("${controller.listingDetails.value.reviews![index].rating}"),
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 15,
                                                ignoreGestures: true,
                                                itemBuilder:
                                                    (context, _) => const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {},
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        controller.listingDetails.value.reviews![index].review.trim(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }, separatorBuilder: (context, index) {
                            return Gap(6);
                          },
                              itemCount: controller.listingDetails.value.reviews!.length
                            // itemCount: 19
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                width: 168,
                margin: EdgeInsets.symmetric(horizontal: 85),
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF0F1F5) /* Grey-10 */,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 25),
                    Gap(5),
                    Text(
                      '${controller.listingDetails.value.avgRating?.toStringAsFixed(2)} | ${controller.listingDetails.value.reviews?.length ?? 0} Reviews',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(40),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                          color: const Color(0xFF4F4F4F),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(10),
                      Obx(() {

                        double discountPercent = (controller.listingDetails.value.lengthOfStayDiscounts!.isNotEmpty
                            ? (
                            int.tryParse(controller.listingDetails.value.lengthOfStayDiscounts!.entries.first.key) != null && int.parse(controller.listingDetails.value.lengthOfStayDiscounts!.entries.first.key) <= controller.selectedDateCount.value
                                ? controller.listingDetails.value.lengthOfStayDiscounts!.entries.first.value
                                : 0
                        )
                            : 0)/100;

                        return RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '৳${controller.listingDetails.value.price}',
                                style: TextStyle(
                                  color: Color(0xFFF15925), // Brand-color
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' /night',
                                style: TextStyle(
                                  color: Color(0xFF4F4F4F),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              if((controller.totalSelectedDatePrice.value - (controller.totalSelectedDatePrice.value* discountPercent) )> 0)TextSpan(
                                text: '\nTotal: ৳${controller.totalSelectedDatePrice.value - (controller.totalSelectedDatePrice.value* discountPercent) }',
                                style: TextStyle(
                                  color: Color(0xFF4F4F4F),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {

                      if(!mainControl.isLogin.value) {
                        Get.toNamed(AppRoute.login);
                        return;
                      }

                      final dates = controller.selectedDates;
                      int totalNights = controller.selectedDateCount.value;

                      // Validation: ensure date range is valid
                      if (totalNights <= 0) {
                        Fluttertoast.showToast(
                          msg: "Please select a valid date range or room.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }

                      // Extract min/max nights and handle nulls
                      int minNights =
                          controller.listingDetails.value.minimumNights ?? 1;
                      int maxNights =
                          controller.listingDetails.value.maximumNights ?? 30;

                      // Validate night count range
                      if (totalNights < minNights || totalNights > maxNights) {
                        Fluttertoast.showToast(
                          msg:
                          "Please select between $minNights and $maxNights nights.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                        );
                        return;
                      }

                      // Date formatting function
                      String formatDate(DateTime? dt) {
                        if (dt == null) return "";
                        return DateFormat(
                          'MMM d, yyyy',
                        ).format(dt); // e.g. Feb 6, 2026
                      }

                      // Navigate if validation passed
                      Get.to(
                        BookingScreen(
                          endDate: formatDate(dates[1]),
                          startDate: formatDate(dates[0]),
                          totalNight: totalNights,
                          total: controller.totalSelectedDatePrice.value,
                          data: controller.listingDetails.value,
                          discount: controller.listingDetails.value.lengthOfStayDiscounts!.isNotEmpty
                              ? (
                              int.tryParse(controller.listingDetails.value.lengthOfStayDiscounts!.entries.first.key) != null && int.parse(controller.listingDetails.value.lengthOfStayDiscounts!.entries.first.key) <= totalNights
                                  ? controller.listingDetails.value.lengthOfStayDiscounts!.entries.first.value
                                  : 0
                          )
                              : 0,
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: Colors.white /* white */,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFDCDEE3) /* Grey-30 */,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.black /* Black */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(kBottomNavigationBarHeight+30),
          ],
        );
      }),
    ));
  }

Widget buildFormattedText(String text) {
  if (text.trim().isEmpty) {
    return const Text('No description available.');
  }

  final trimmed = text.trimLeft();

  // Check for HTML
  if (trimmed.startsWith('<') && (trimmed.contains('</') || trimmed.contains('/>'))) {
    return Html(
      data: text,
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(14),
          lineHeight: LineHeight(1.5),
          color: Colors.black,
        ),
      },
    );
  }

  // Check for Markdown (common indicators)
  else if (trimmed.contains('**') || 
           trimmed.contains('__') || 
           trimmed.contains('# ') || 
           trimmed.contains('- ') || 
           trimmed.contains('1. ')) {
    return MarkdownBody(
      data: text,
      softLineBreak: true,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(fontSize: 14, height: 1.5),
        strong: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Plain text fallback
  return Text(
    text,
    style: const TextStyle(fontSize: 14, height: 1.5),
  );
}

  void _showDescriptionBottomSheet(BuildContext context, String description) {
    print("This is text description- ${description}");
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'About this place',
                    style: TextStyle(
                      color: const Color(0xFF090909),
                      fontSize: 26,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.31,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade200),

            // Scrollable HTML Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                // child:Text(description),
                child:buildFormattedText(description)
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getCountByIndex(int index) {
    final listing = controller.listingDetails.value;
    switch (index) {
      case 0:
        return listing.guestCount.toString();
      case 1:
        return listing.bedroomCount.toString();
      case 2:
        return listing.bedCount.toString();
      case 3:
        return listing.bathroomCount.toString();
      default:
        return '';
    }
  }

  String formatToDayMonthYear(String input) {
    try {
      DateTime dateTime = DateTime.parse(input);
      return DateFormat('d MMM yyyy').format(dateTime); // e.g. 4 Jun 2025
    } catch (e) {
      return 'Invalid date';
    }
  }
  Widget buildAmenityIcon(String? url) {
    if (url == null || url.isEmpty) {
      return const SizedBox.shrink(); // empty if no image
    }

    final isSvg = url.toLowerCase().endsWith(".svg");

    return isSvg
        ? SvgPicture.network(
      url,
      height: 22,
      width: 22,
      color: Colors.black,
      placeholderBuilder: (context) => Container(
        height: 22,
        width: 22,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
    )
        : Image.network(
      url,
      height: 22,
      width: 22,
      color: Colors.black,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          height: 22,
          width: 22,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      },
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.broken_image,
        size: 22,
        color: Color(0xFFA9A9B0),
      ),
    );
  }
}
// class AmenitiesBottomSheet extends StatelessWidget {
//   final List amenities;
//   final Widget Function(String? icon) buildIcon;
//
//   const AmenitiesBottomSheet({
//     super.key,
//     required this.amenities,
//     required this.buildIcon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Group amenities by category
//     final Map<String, List> groupedAmenities = {};
//     for (var item in amenities) {
//       final category = item.amenity.category ?? 'Others';
//       groupedAmenities.putIfAbsent(category, () => []);
//       groupedAmenities[category]!.add(item.amenity);
//     }
//
//     final categories = groupedAmenities.entries.toList();
//
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//         child: Column(
//           children: [
//             // Drag handle
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//
//             // Header
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(Icons.arrow_back_ios_new, size: 18),
//                 ),
//                 const Expanded(
//                   child: Text(
//                     'Amenities',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'Inter',
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 48),
//               ],
//             ),
//
//             const Divider(
//               thickness: 1,
//               height: 1,
//               color: Color(0xFFE4E9EC),
//             ),
//
//             Gap(6),
//
//             // Content
//             Expanded(
//               child: ListView.builder(
//                 itemCount: categories.length,
//                 itemBuilder: (context, catIndex) {
//                   final categoryEntry = categories[catIndex];
//                   final amenitiesList = categoryEntry.value;
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Category Title
//                       Padding(
//                         padding: const EdgeInsets.only(top: 16, bottom: 8),
//                         child: Text(
//                           categoryEntry.key,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: 'Inter',
//                           ),
//                         ),
//                       ),
//
//                       // Amenities under this category
//                       ...List.generate(amenitiesList.length, (i) {
//                         final amenity = amenitiesList[i];
//                         final isLastItem = i == amenitiesList.length - 1;
//
//                         return Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               child: Row(
//                                 children: [
//                                   buildIcon(amenity.icon),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: Text(
//                                       amenity.name ?? '',
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w400,
//                                         fontFamily: 'Inter',
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             // Only add divider if not last item in category
//                             if (!isLastItem)
//                               const Divider(
//                                 height: 1,
//                                 thickness: 0.6,
//                                 color: Color(0xFFF0F1F5),
//                               ),
//                           ],
//                         );
//                       }),
//
//                       // Only add category divider if not last category
//                       if (catIndex != categories.length - 1)
//                         const Padding(
//                           padding: EdgeInsets.only(top: 12),
//                           child: Divider(
//                             thickness: 1,
//                             color: Color(0xFFE4E9EC),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class AmenitiesBottomSheet extends StatelessWidget {
  final List<AmenityItem> listingAmenities;
  final List<AmenitiesCategoryModel> allCategorizedAmenities;
  final Widget Function(String?) buildIcon;

  const AmenitiesBottomSheet({
    super.key,
    required this.listingAmenities,
    required this.allCategorizedAmenities,
    required this.buildIcon,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIds = listingAmenities
        .map((e) => e.amenity.id)
        .whereType<int>()
        .toSet();

    return SafeArea(
      child: Column(
        children: [
         Gap(20),
          /// 🔹 HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Amenities",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          /// 🔹 BODY
          /// 🔹 BODY
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: allCategorizedAmenities
                      .map((category) {
                    // Filter only matched amenities in this category
                    final matchedAmenities = category.data
                        ?.where((amenity) => selectedIds.contains(amenity.id))
                        .toList() ??
                        [];

                    // Skip category entirely if no matched amenities
                    if (matchedAmenities.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Category Title
                        Text(
                          category.title ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        /// Matched Amenities Only
                        ...matchedAmenities.map((amenity) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                child: Row(
                                  children: [
                                    buildIcon(amenity.iconMobile),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        amenity.name ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                            ],
                          );
                        }).toList(),

                        const SizedBox(height: 20),
                      ],
                    );
                  })
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
enum ImageLayoutType { type1, type2 }

Widget imageGalleryView({
  required String title,
  required ImageLayoutType layoutType,
  required List<String> images,
}) {
  // Preload all images in background
  for (var url in images) {
    precacheImage(CachedNetworkImageProvider(url), Get.context!);
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      const gap = 10.0;

      Widget imageBox({
        required double width,
        required double height,
        required String url,
      }) {
        return InkWell(
          onTap: () {
            // Open full screen gallery
            Get.back();
            Get.to(() => ImageGalleryScreen(imageUrls: images));
          },
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/default_image.jpg", fit: BoxFit.cover),
                maxHeightDiskCache: 1200, // resize in disk cache
                maxWidthDiskCache: 1200,
              ),
            ),
          ),
        );
      }

      final unitWidth = (width - gap) / 3;
      final rightImageHeight = (unitWidth * 3 - gap) / 2;

      Widget buildType1() {
        return Column(
          children: [
            if (images.isNotEmpty)
              imageBox(width: width, height: 200, url: images[0]),
            const SizedBox(height: 8),
            Row(
              children: [
                if (images.length > 1)
                  Expanded(
                    child: imageBox(
                      width: double.infinity,
                      height: 120,
                      url: images[1],
                    ),
                  ),
                if (images.length > 2) const SizedBox(width: 8),
                if (images.length > 2)
                  Expanded(
                    child: imageBox(
                      width: double.infinity,
                      height: 120,
                      url: images[2],
                    ),
                  ),
              ],
            ),
          ],
        );
      }

      Widget buildType2() {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (images.isNotEmpty)
              imageBox(
                width: unitWidth * 2,
                height: unitWidth * 3,
                url: images[0],
              ),
            const SizedBox(width: gap),
            Column(
              children: [
                if (images.length > 1)
                  imageBox(
                    width: unitWidth,
                    height: rightImageHeight,
                    url: images[1],
                  ),
                if (images.length > 2) const SizedBox(height: gap),
                if (images.length > 2)
                  imageBox(
                    width: unitWidth,
                    height: rightImageHeight,
                    url: images[2],
                  ),
              ],
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF3D3F40),
              fontSize: 17.25,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          layoutType == ImageLayoutType.type1 ? buildType1() : buildType2(),
        ],
      );
    },
  );
}

// Hello I am Tamim