import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../services/network/error_display_manager.dart';
import '../features/booking/presentation/views/trip_details.dart';
import '../features/reservation/controllers/reservation_controller.dart';
import '../../features/booking/controllers/booking_controller.dart'; // Adjust path
import 'profile_avatar_widget.dart';

class ReservationCardItem extends StatelessWidget {
  final AlignmentGeometry? stackAlignment;
  final String? reservationStatus;
  final Function()? onPress;
  final String? title, date, guestName, eventType, bookingId,imageUrl;

  const ReservationCardItem({
    super.key,
    this.onPress,
    this.stackAlignment,
    this.reservationStatus,
    this.title,
    this.eventType,
    this.date,
    this.guestName,
    this.bookingId, this.imageUrl,
  });

  void showAwesomeFeedbackDialog({
    required BuildContext context,
    required String bookingId,
  }) {
    final controller = Get.put(FeedbackController());
    final ReservationController _bookingController =
    Get.find<ReservationController>();

    controller.feedbackController.clear();

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

                /// Rating Stars
                Obx(() => RatingStars(
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
                )),

                const SizedBox(height: 10),

                /// Feedback Field
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

                /// Submit Button
                Obx(() {
                  return controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : GestureDetector(
                    onTap: () async {
                      controller.isLoading.value = true;

                      await _bookingController.submitBookingReview(
                        id: bookingId,
                        person: "host",
                        bisbook: "reservations",
                        rating:
                        controller.rating.value.toInt(),
                        review: controller.feedbackController.text,
                      );

                      controller.isLoading.value = false;

                      _bookingController
                          .fetchReservationStats(type: 'pending_review');

                      if (!_bookingController.reviewHasError.value) {
                        Navigator.pop(context); // ✅ native close
                      } else {
                        Get.snackbar(
                          'Error',
                          _bookingController
                              .reviewErrorMessage.value,
                        );
                      }
                    },
                    child: Container(
                      width: 124,
                      padding: const EdgeInsets.all(10),
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
                          fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: stackAlignment ?? AlignmentDirectional.topEnd,
      children: [
        InkWell(
          onTap: onPress,
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFDCDEE3)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Text(
                      date ?? '',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'By ',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: guestName ?? 'Guest',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 12, // Bigger than "By"
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if ((eventType ?? '').contains('Pending Review'))
                      ElevatedButton.icon(
                        onPressed: () {
                          if (bookingId != null) {
                            showAwesomeFeedbackDialog(context: context,bookingId: bookingId!);
                          } else {
                            Get.find<ErrorDisplayManager>().showError('Booking ID not found');
                          }
                        },
                        icon: const Icon(Icons.rate_review, size: 18, color: Colors.white),
                        label: const Text(
                          'Review',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                      ),
                  ],
                ),



              ],
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: EdgeInsets.only(right: 15, left: 25),
          decoration: ShapeDecoration(
            color: Colors.white /* white */,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            shadows: [
              BoxShadow(
                color: Color(0x13000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Text(
            reservationStatus ?? 'Your Reservations',
            style: TextStyle(
              color: const Color(0xFFF15925) /* Brand-color */,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }
}

// Hello I am Tamim