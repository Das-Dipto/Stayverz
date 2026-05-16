import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../services/network/error_display_manager.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../core/utils/main_utils.dart';
import '../../../../../features/booking/controllers/booking_controller.dart';
import '../../../../widgets/own_app_bar.dart';
import '../../data/models/assistance_book_data.dart';

class TripAssistanceDetails extends StatefulWidget {
  final String invId;
  final bool isRate;
  final bool isCancel;

  const TripAssistanceDetails({super.key, required this.invId,  this.isRate=false,this.isCancel=false });

  @override
  State<TripAssistanceDetails> createState() => _TripAssistanceDetailsState();
}

class _TripAssistanceDetailsState extends State<TripAssistanceDetails> {
  // late final BookingController _bookingController;
  final BookingController _bookingController = Get.find<BookingController>();
  final RxString errorMessage = ''.obs;
  void _openBottomSheet(BuildContext context, Map<String, dynamic>? priceInfo) {
    // Ensure priceInfo is not null and properly casted
    final Map<String, PriceInfo> data =
    (priceInfo ?? <String, dynamic>{}).map((key, value) {
      // Safely cast each value to PriceInfo (or create a default if not possible)
      if (value is PriceInfo) {
        return MapEntry(key, value);
      } else {
        return MapEntry(key, PriceInfo(price: 0)); // adjust based on your PriceInfo model
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Base Price Breakdown',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),

              // List of dates and prices
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final String date = data.keys.elementAt(index);
                    final PriceInfo info = data[date]!;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '৳ ${info.price?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Divider(),

              // Total price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total price',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '৳ ${data.values.fold<double>(0, (sum, item) => sum + (item.price ?? 0)).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }



  final TextEditingController feedbackController = TextEditingController();
  void showAwesomeFeedbackDialog({required String bookingId}) {
    final controller = Get.put(FeedbackController());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  'Feedback',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                /// ⭐ Rating Stars
                Obx(() {
                  return RatingStars(
                    value: controller.rating.value,
                    onValueChanged: controller.setRating,
                    starBuilder: (index, color) =>
                        Icon(Icons.star, color: color),
                    starCount: 5,
                    starSize: 40,
                    maxValue: 5,
                    starSpacing: 2,
                    maxValueVisibility: false,
                    valueLabelVisibility: false,
                    animationDuration:
                    const Duration(milliseconds: 1000),
                    starOffColor: const Color(0xffe7e8ea),
                    starColor: Colors.yellow,
                  );
                }),

                const SizedBox(height: 10),

                /// 📝 Review Input
                TextField(
                  maxLines: 6,
                  controller: controller.feedbackController,
                  decoration: InputDecoration(
                    hintText: 'Leave a review (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ✅ Submit Button
                Obx(() {
                  return controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : GestureDetector(
                    onTap: () async {

                      controller.isLoading.value = true;

                      await _bookingController
                          .submitAssistanceBookingReview(
                        id: bookingId,
                        rating: controller.rating.value,
                        review:
                        controller.feedbackController.text,
                      );

                      controller.isLoading.value = false;

                      /// ✅ Close only if no error
                      if (_bookingController
                          .errorMessage.value.isEmpty) {

                        Navigator.pop(context);

                        _bookingController
                            .fetchAssistanceBookingReviewDetails(
                            bookingId);
                      }
                    },
                    child: Container(
                      width: 124,
                      padding:
                      const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1,
                              color:
                              Color(0xFFDCDEE3)),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  final TextEditingController cancelController = TextEditingController();
  void showAwesomeCancelDialog({required String bookingId}) {
    cancelController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  'Cancel Reason',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                /// 📝 Cancel Reason Input
                TextField(
                  maxLines: 6,
                  controller: cancelController,
                  decoration: InputDecoration(
                    hintText: 'Write your cancel reason properly',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ✅ Submit Button
                Obx(() {
                  return _bookingController.isCancellingBooking.value
                      ? const CircularProgressIndicator()
                      : GestureDetector(
                    onTap: () async {

                      final reason =
                      cancelController.text.trim();

                      /// 🔥 FIX: isNull not needed
                      if (reason.isEmpty) {
                        Fluttertoast.showToast(
                          msg:
                          "Please write a valid reason to submit it!",
                        );
                        return;
                      }

                      await _bookingController
                          .cancelAssistanceBooking(
                        bookingId: bookingId,
                        cancellationReason: reason,
                      );

                      /// ✅ Close only if no error
                      if (_bookingController
                          .errorMessage.value.isEmpty) {

                        Navigator.pop(context);

                        Fluttertoast.showToast(
                          msg:
                          "Booking cancelled successfully",
                        );

                        _bookingController
                            .fetchAssistanceBookings();
                      }
                    },
                    child: Container(
                      width: 124,
                      padding:
                      const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFDCDEE3),
                          ),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void showReviewPopup(BuildContext context, dynamic reviewData) {
    showDialog(
      context: context,
      builder: (_) {
        final String fullName = reviewData.fullName;
        final String review = reviewData.review;
        final double rating = reviewData.rating.toDouble();
        final String image = reviewData.image;
        final String createdAt = reviewData.createdAt;

        final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a')
            .format(DateTime.parse(createdAt));

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: image.isNotEmpty
                      ? NetworkImage(image)
                      : const AssetImage('assets/avatar_placeholder.png') as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 10),
                RatingBarIndicator(
                  rating: rating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 24.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(height: 10),
                Text(
                  '"$review"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  child: const Text("Close", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  void initState() {


    // TODO: implement initState
    _bookingController.fetchAssistanceDetails(widget.invId);
   _bookingController.fetchAssistanceBookingReviewDetails(widget.invId);

    super.initState();
  }


  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Use booking data in the UI when implementing the details view
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OwnAppBar(
        appHeight: 60,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back, size: 20,),
                color: Colors.black,
              ),
            ),
            Text(
              'Assistance Trip Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            Gap(30),

          ],
        ),
      ),
      body: Obx(() {

        if (_bookingController.isAssisLoading.value ) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_bookingController.errorAssisMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _bookingController.errorAssisMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            Gap(16),
            Container(
              height: 128,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: ShapeDecoration(
                color: Colors.white /* White */,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.05,
                    color: const Color(0xFFF0F1F5) /* Grey-10 */,
                  ),
                  borderRadius: BorderRadius.circular(12.63),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 124,
                    height: 128,
                    child:_bookingController.bookingAssitanceDetails.value?.data?.listing?.coverPhoto== null ?Image.asset('assets/default_image.jpg',fit: BoxFit.fill,) : Image.network("${_bookingController.bookingAssitanceDetails.value?.data?.listing?.coverPhoto}", fit: BoxFit.fill),
                  ),
                  Gap(10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(5),
                        Text(
                          '${_bookingController.bookingAssitanceDetails.value?.data?.listing?.title}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black /* Black */,
                            fontSize: 16.84,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.50,
                          ),
                        ),
                        Gap(5),
                        Text(
                          'BDT ${(_bookingController.bookingAssitanceDetails.value?.data?.price)!/(_bookingController.bookingAssitanceDetails.value!.data!.nightCount!)}/per night',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF67666B) /* Grey-70 */,
                            fontSize: 12.63,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.star, size: 15),
                            Gap(2),
                            Text(
                              '${_bookingController.bookingAssitanceDetails.value?.data?.listing?.avgRating} (${_bookingController.bookingAssitanceDetails.value?.data?.listing?.totalRatingCount} reviews)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF67666B) /* Grey-70 */,
                                fontSize: 12.63,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    'Invoice Number: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    "${_bookingController.bookingAssitanceDetails.value?.data?.invoiceNo}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: const Color(0xFFA9A9B0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    'Property:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${_bookingController.bookingAssitanceDetails.value?.data?.listing?.title}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: const Color(0xFFA9A9B0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    'Host:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                   "${ _bookingController.bookingAssitanceDetails.value?.data?.host?.firstName}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: const Color(0xFFA9A9B0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    'Check-in:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    MainUtils.formatDate(timeStamp:  "${_bookingController.bookingAssitanceDetails.value?.data?.checkIn}",formatPattern: "MMM dd yyyy"),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: const Color(0xFFA9A9B0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    'Checkout:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    MainUtils.formatDate(timeStamp: "${_bookingController.bookingAssitanceDetails.value?.data?.checkOut}",formatPattern: "MMM dd yyyy"),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: const Color(0xFFA9A9B0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    'Total night:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${_bookingController.bookingAssitanceDetails.value?.data?.nightCount}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
            Gap(16),
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFDCDEE3) /* Grey-30 */,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price details',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                        Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                _openBottomSheet(
                                  context,
                                  _bookingController.bookingAssitanceDetails.value?.data?.priceInfo ?? <String, PriceInfo>{},
                                );
                              },
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                      // '৳ ${( (_bookingController.bookingAssitanceDetails.value?.data?.price ?? 0).toDouble() ).toStringAsFixed(2)} '
                                          '৳ ${((_bookingController.bookingAssitanceDetails.value?.data?.listing?.price ?? 0).toDouble()).toStringAsFixed(2)} '
                                          'x ${_bookingController.bookingAssitanceDetails.value?.data?.priceInfo?.length ?? 0} days',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline,
                                        height: 1.50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              '৳ ${(_bookingController.bookingAssitanceDetails.value?.data?.listing?.price?? 0) * (_bookingController.bookingAssitanceDetails.value?.data?.nightCount?? 0)}',
                              textAlign: TextAlign.right,
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
                        Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Extra guest fee',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              '৳ ${_bookingController.bookingAssitanceDetails.value?.data?.extraGuestCharge ?? 0}',
                              textAlign: TextAlign.right,
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
                        Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Gateway fee ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              '৳ ${_bookingController.bookingAssitanceDetails.value?.data?.guestServiceCharge}',
                              textAlign: TextAlign.right,
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
                        Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Discount Amount ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              '৳ ${_bookingController.bookingAssitanceDetails.value?.data?.discountAmountApplied}',
                              textAlign: TextAlign.right,
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
                        Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Paid amount',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              '৳ ${_bookingController.bookingAssitanceDetails.value?.data?.paidAmount}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,

                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: const Color(0xFFA9A9B0)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cancellation Policy',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                        Gap(5),
                        Text(
                          'You will not receive a refund if you cancel your reservation',
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
            ),
            if(widget.isCancel==true)
              Gap(16),
            if(widget.isCancel==true)
              InkWell(
                onTap: () => showAwesomeCancelDialog(bookingId: "${_bookingController.bookingAssitanceDetails.value?.data?.invoiceNo}"),
                child: Text(
                  'Cancel this assistance',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: const Color(0xFFF15925) /* Brand-color */,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    height: 2,
                  ),
                ),
              ),
            Gap(16),
            widget.isRate==true?
            _bookingController.bookingAssitanceDetails.value?.data?.reviewData==null?
            InkWell(
              onTap: () => showAwesomeFeedbackDialog(bookingId: "${_bookingController.bookingAssitanceDetails.value?.data?.invoiceNo}"),
              child: Text(
                'Rate this trip',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color(0xFFF15925) /* Brand-color */,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  height: 2,
                ),
              ),
            ):  InkWell(
              onTap: () =>showReviewPopup(context, _bookingController.bookingAssitanceDetails.value?.data!.reviewData![0]),
              child: Text(
                'See Review',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color(0xFFF15925) /* Brand-color */,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  height: 2,
                ),
              ),
            ):SizedBox.shrink(),
            Gap(16),
            if(_bookingController.bookingAssitanceDetails.value?.data!.status == 'confirmed' || _bookingController.bookingAssitanceDetails.value?.data!.status == 'cancelled' )InkWell(
              borderRadius: BorderRadius.circular(10),
              focusColor: Colors.transparent,
              onTap: () {
                _generateInvoicePdf(_bookingController.bookingAssitanceDetails.value!.data!);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 70),
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFFF0F1F5) /* Grey-10 */,
                    ),
                    borderRadius: BorderRadius.circular(8),
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
                  'Download Invoice',
                  textAlign: TextAlign.center,
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
            Gap(20),
          ],
        );
      },),
    );
  }

  Future<void> _generateInvoicePdf(AssistanceBookData invoiceData) async {
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
                      pw.Text("${invoiceData.invoiceNo}", style: pw.TextStyle(fontSize: 24)),
                    ],
                  ),
                  pw.Container(
                    height: 40,
                    width: 80,
                    child: pw.Image(image, fit: pw.BoxFit.contain),
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
                  MainUtils.formatDate(timeStamp: "${invoiceData.checkIn}",formatPattern: "MMM dd yyyy"),
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
                  MainUtils.formatDate(timeStamp: "${invoiceData.checkOut}",formatPattern: "MMM dd yyyy"),
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
                  'Extra guest',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.normal,
                    height: 1.5,
                    // font: interFont, // Uncomment if you're using the Inter font
                  ),
                ),

                pw.Text(
                  "${invoiceData.extraGuestCount}",
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
                  '৳ ${invoiceData.listing?.price} x ${invoiceData.nightCount} nights',
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
                  '৳ ${(invoiceData.listing?.price ??0) * (invoiceData.nightCount ?? 0)}',
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

              if((invoiceData.extraGuestCharge ?? 0) > 0)pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Extra guest free',
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
                      '৳ ${invoiceData.extraGuestCharge ?? 0}',
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
                  'Gateway fee',
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

          pw.SizedBox(
            height: 8
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

class FeedbackController extends GetxController {
  RxDouble rating = 5.0.obs;
  final TextEditingController feedbackController = TextEditingController();

  RxBool isLoading = false.obs;

  void setRating(double value) {
    rating.value = value;
  }

  Future<void> submitFeedback() async {
    if (isLoading.value) return; // prevent multiple taps
    isLoading.value = true;

    final ratingValue = rating.value;
    final review = feedbackController.text;

    try {
      // Simulate API call with delay
      await Future.delayed(Duration(seconds: 2));


      Get.back(); // close dialog
      Get.snackbar('Success', 'Feedback submitted successfully');
    } catch (e) {
      Get.find<ErrorDisplayManager>().showError('Failed to submit feedback');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}

// Hello I am Tamim