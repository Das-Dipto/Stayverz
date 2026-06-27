import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../services/network/error_display_manager.dart';
import 'package:intl/intl.dart';
import 'package:stayverz_flutter_app/features/booking/presentation/views/book_and_go_screen.dart';
import 'package:stayverz_flutter_app/features/listing/bindings/listing_binding.dart';
import 'package:stayverz_flutter_app/views/home_root/booking/payment_web_view_screen.dart';
import '../../../features/booking/controllers/booking_controller.dart';
import '../../../features/listing/controllers/listing_controller.dart';
import '../../../features/listing/models/booking_post_model.dart';
import '../../../widgets/own_app_bar.dart';

class PaymentScreen extends GetView<ListingController> {
  final dynamic data;
  final double price;
  final int night;
  final double serviceCharge;
  final double discount;
  final String startDate;
  final String endDate;
  final int adultCount;
  final int childrenCount;
  final int infartCount;

   PaymentScreen(  {super.key,required this.adultCount, this.discount = 0.0, required this.childrenCount,required this.infartCount, required this.data,required this.startDate,required this.endDate, required this.price, required this.night, required this.serviceCharge});


   final BookingController _bookingController= Get.find<BookingController>();
  final gridController = Get.put(GridController());


  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat("dd MMM. yyyy").format(now); // e.g. "18 Feb. 2025"
  }

  String getFormattedTime() {
    final now = DateTime.now();
    return DateFormat("hh:mm a").format(now); // e.g. "08:30 PM"
  }
  final RxBool isSubmitting = false.obs;
  @override
  Widget build(BuildContext context) {


    WidgetsBinding.instance.addPostFrameCallback((_){
      if (!Get.isRegistered<ListingBinding>()) {
        ListingBinding().dependencies();
      }
    });

    _bookingController.decrasePrice.value=0.0;
    _bookingController.cuponCode.value='';


    double total = price*night;
    double totalAfterDiscount = total-(total*discount);
    double gatewayCharge = totalAfterDiscount *serviceCharge;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OwnAppBar(
        appHeight: 60,
         backgroundColor: Colors.white,
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
              'Payment',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(30)
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Gap(20),
          Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white /* White */,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.46),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: const Color(0xFFA9A9B0) /* Grey-50 */,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${getFormattedDate()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.61,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                  Text(
                    'Time: ${getFormattedTime()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.61,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
            Gap(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(
                'Room Rent',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black /* Black */,
                  fontSize: 18.68,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.56,
                ),
              ),
                  Text(
                    '${night} x ${price} TK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF505050) /* Gray */,
                      fontSize: 16.61,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
            Gap(5),
            Divider(color: const Color(0xFFE6E8EE),thickness: 3,),
            Gap(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gateway Charges',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black /* Black */,
                      fontSize: 18.68,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.56,
                    ),
                  ),
                  Text(
                    '${(gatewayCharge).toStringAsFixed(2)} TK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF505050) /* Gray */,
                      fontSize: 16.61,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
            Gap(5),
            Divider(color: const Color(0xFFE6E8EE),thickness: 3,),
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFA9A9B0),
                  ),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: Row(
                children: [
                  // TextField
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: _bookingController.couponCodeController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Coupon Code...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Submit Button with multiple click handling
                  Obx(() {
                    final isLoading = _bookingController.isClaimingCoupon.value;

                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                        final code = _bookingController.couponCodeController.text.trim();
                        final orderTotal = totalAfterDiscount.toStringAsFixed(2);
                        _bookingController.decrasePrice.value=0.0;
                        _bookingController.cuponCode.value='';
                        if (code.isNotEmpty) {
                          _bookingController.applyReferralCoupon(
                            code: code,
                            orderTotal: orderTotal,
                          );
                        } else {
                          Get.snackbar('Invalid', 'Please enter a coupon code');
                        }
                      },
                      child: Container(
                        width: 111,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: isLoading ? Colors.grey[300] : const Color(0xFFF0F1F5),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFF15925),
                            ),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFF15925)),
                          ),
                        )
                            : const Text(
                          'Submit',
                          style: TextStyle(
                            color: Color(0xFFF15925),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Divider(color: const Color(0xFFE6E8EE),thickness: 3,),
            Gap(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF15925) /* Brand-color */,
                      fontSize: 20.76,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                  Obx(() {
                    return Text(
                      '${((totalAfterDiscount - _bookingController.decrasePrice.value) + gatewayCharge).toStringAsFixed(2)} TK',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF505050) /* Gray */,
                        fontSize: 20.76,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    );
                  },),
                ],
              ),
            ),


          ],
        ),

      ),
          Gap(20),
          // Text(
          //   'Payment Method',
          //   style: TextStyle(
          //     color: Colors.black /* Black */,
          //     fontSize: 16.61,
          //     fontFamily: 'Inter',
          //     fontWeight: FontWeight.w600,
          //     height: 1.50,
          //   ),
          // ),
          // Gap(10),
          // GridView.builder(
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //     maxCrossAxisExtent: 200,
          //     mainAxisSpacing: 10,
          //     crossAxisSpacing: 10,
          //     mainAxisExtent: 100,
          //   ),
          //   itemCount: 4,
          //     itemBuilder: (context, index) {
          //       final images = [
          //         'assets/bks.png',
          //         'assets/ngd.png',
          //         'assets/roket.png',
          //         'assets/other.png',
          //       ];
          //
          //       return InkWell(
          //         borderRadius: BorderRadius.circular(12),
          //         onTap: () {
          //           gridController.selectedIndex.value = index;
          //         },
          //         child: Obx(() => Container(
          //           padding: EdgeInsets.all(8),
          //           clipBehavior: Clip.antiAlias,
          //           decoration: ShapeDecoration(
          //             color: gridController.selectedIndex.value == index
          //                 ? Colors.white
          //                 : Colors.grey.shade200, // 🔹 Unselected items gray background
          //             shape: RoundedRectangleBorder(
          //               side: BorderSide(
          //                 width: 1.56,
          //                 color: gridController.selectedIndex.value == index
          //                     ? Color(0xFFF15925)
          //                     : Colors.grey,
          //               ),
          //               borderRadius: BorderRadius.circular(16.61),
          //             ),
          //           ),
          //           child: Stack(
          //             children: [
          //               // Centered image
          //               Center(
          //                 child: Container(
          //                   height: 50,
          //                   width: 100,
          //                   decoration: BoxDecoration(
          //                     image: DecorationImage(
          //                       image: AssetImage(images[index]),
          //                       fit: BoxFit.contain,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //
          //               // Top-right checkmark
          //               if (gridController.selectedIndex.value == index)
          //                 Positioned(
          //                   top: 4,
          //                   right: 4,
          //                   child: Icon(
          //                     Icons.check_circle,
          //                     color: Colors.green,
          //                     size: 20,
          //                   ),
          //                 ),
          //             ],
          //           ),
          //         )),
          //       );
          //     }
          // ),
          // Gap(200),
          const Gap(18),
          Center(
            child: Obx(() => InkWell(
              onTap: () async {
                if (isSubmitting.value) return;
              isSubmitting.value = true;
               // 👇 Add this temporarily
  print('DATA ID: ${data.id}');
  print('DATA ID TYPE: ${data.id.runtimeType}');
  print('DATA UUID: ${data.uniqueId}');
// print('DATA SLUG: ${data.slug}');
                try {
                  final booking = BookingPostModel(
                    listing_id: data.uniqueId,
                    checkIn: convertToDateFormat(startDate),
                    checkOut: convertToDateFormat(endDate),
                    childrenCount: childrenCount,
                    infantCount: infartCount,
                    adultCount: adultCount,
                    couponCode: _bookingController.cuponCode.value != ''
                        ? _bookingController.cuponCode.value
                        : null,
                  );

                  final result = await controller.createBooking(booking);

                  if(data.instantBookingAllowed==true){
                    if (result != null) {
                      final bookingCode = result.invoiceNo ?? '';
                      final paymentData = await controller.createPayment(bookingCode);
                      if (paymentData != null) {
                        // 🔹 Navigate to WebView and wait for result
                        final resultWebView = await Get.to(() => PaymentWebViewScreen(
                          url: paymentData.paymentGatewayUrl,
                          booKiD: bookingCode,
                        ));

                        if (resultWebView == "success") {
                          // Optional: verify payment with backend using bookingCode
                          Get.snackbar("Payment", "Payment successful ✅");
                          // Example: navigate to booking success screen
                          // Get.offAll(() => BookingSuccessScreen(bookingCode: bookingCode));
                        } else if (resultWebView == "fail") {
                          Get.snackbar("Payment", "Payment failed ❌");
                        } else if (resultWebView == "cancel") {
                          Get.snackbar("Payment", "Payment cancelled ⚠️");
                        }
                      } else {
                        Get.find<ErrorDisplayManager>().showError("Payment failed");
                      }

                    } else {
                      Get.find<ErrorDisplayManager>().showError("Booking failed");
                    }
                  } else{
                     if (result != null) {
        Get.back();
        Get.back();
        Get.back();
        Get.offNamed(BookAndGoScreen.routeName);
        Get.snackbar(
            'Success',
            'A request has been sent to host. Please wait for approval',
            backgroundColor: Colors.green.withOpacity(0.9),
            duration: const Duration(seconds: 2),
        );
    } else {
        Get.find<ErrorDisplayManager>().showError("Booking failed");
    }
                  }
                } finally {
                 isSubmitting.value = false;
                }
              },
              child: Container(
                height: 44,
                width: 180,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFDCDEE3)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: isSubmitting.value
                    ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
                    : Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )),
          ),
          Gap(20),
        ],
      ),
    );
  }
  void showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Image
                Image.asset(
                  'assets/check.png', // Use your own image asset
                  height: 80,
                  width: 80,
                ),
                SizedBox(height: 30),
                Text(
                  'Payment Successful!',
                  style: TextStyle(
                    color: Colors.black /* Black */,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'The doctor will call you. Please stay online.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black /* Black */,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.90,
                  ),
                ),
                SizedBox(height: 20),
                // Button
               InkWell(
              onTap: (){
                Get.back();
              },
              child: Container(
                width: 160,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white /* white */,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFFDCDEE3) /* Grey-30 */,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                      spreadRadius: 2,
                    )
                  ],
                ),
              child:      Text(
                'Done',
                style: TextStyle(
                  color: Colors.black /* Black */,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
              ),
            )

              ],
            ),
          ),
        );
      },
    );
  }
}
String convertToDateFormat(String input) {
  try {
    DateTime parsedDate = DateFormat('MMM dd, yyyy').parse(input);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    return formattedDate;
  } catch (e) {
    return 'Invalid date';
  }
}
class GridController extends GetxController {
  RxInt selectedIndex = (-1).obs; // -1 means no selection
}

class PaymentData {
  final String paymentGatewayUrl;
  final String successUrl;
  final String failUrl;
  final String cancelUrl;
  final String logo;

  PaymentData({
    required this.paymentGatewayUrl,
    required this.successUrl,
    required this.failUrl,
    required this.cancelUrl,
    required this.logo,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return PaymentData(
      paymentGatewayUrl: data['payment_gateway_url'],
      successUrl: data['success_url'],
      failUrl: data['fail_url'],
      cancelUrl: data['cancel_url'],
      logo: data['logo'],
    );
  }
}

// Hello I am Tamim