import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/network/error_display_manager.dart';
import 'package:stayverz_flutter_app/features/assistance_service/models/single_public_assistance_listing_response_model.dart';

import '../data/models/assistance_booking_arguments.dart';
import '../data/models/assistance_booking_model.dart';
import '../data/models/cupon_model.dart';
import '../data/models/post_assistance_payment_model.dart';
import '../domain/repositories/booking_repository_interface.dart';

import 'package:stayverz_flutter_app/features/listing/models/stripe/exchange_rates_model.dart';

import '../../listing/models/stripe/exchange_rates_model.dart';
import '../../listing/models/stripe/stripe_payment_models.dart';
import '../../../controllers/main_controller.dart';


class AssistanceBookingController extends GetxController {
  final _errorDisplay = Get.find<ErrorDisplayManager>();

  AssistanceBookingController(this._repository);

  final RxString cuponCode = ''.obs;
  final RxString claimErrorMessage = ''.obs;
  final RxBool isClaimingCoupon = false.obs;
  final RxDouble decrasePrice = 0.0.obs;
  final Rx<CouponData?> appliedCoupon = Rxn<CouponData>();
  final couponCodeController = TextEditingController();
  PublicAssistanceData? assistanceData;
  DateTime? startDate;
  DateTime? endDate;
  int? extraGuestCount, nightCount;
  String? location;
  String? phoneNumber;

  final Rx<ExchangeRatesResponseModel?> exchangeRates = Rx<ExchangeRatesResponseModel?>(null);
  final RxBool isLoadingExchangeRates = false.obs;
  final RxString selectedStripeCurrency = 'USD'.obs;
  final RxBool isCreatingStripePayment = false.obs;
  final RxBool isConfirmingStripePayment = false.obs;

  final BookingRepositoryInterface _repository;

  void setArgumentData() {
    var arg = AssistanceBookingArguments.fromJson(Get.arguments);
    assistanceData = arg.assistanceData;
    startDate = arg.checkIn;
    endDate = arg.checkOut;
    extraGuestCount = arg.extraGuestCount;
    phoneNumber = arg.phoneNumber;
    location = arg.location;
    nightCount = arg.nightCount;
  }

  Future<void> applyReferralCoupon({
    required String code,
    required String orderTotal,
  }) async {
    try {
      isClaimingCoupon.value = true;
      claimErrorMessage.value = '';
      appliedCoupon.value = null;

      final result = await _repository.applyReferralCoupon(
        code: code,
        orderTotal: orderTotal,
      );

      result.fold(
            (error) {
          claimErrorMessage.value = error;
          _errorDisplay.showError(error);
        },
            (response) {
          if (response.data.isValid) {
            appliedCoupon.value = response.data;
            decrasePrice.value = double.parse(
              double.parse(
                '${response.data.discountAmount}',
              ).toStringAsFixed(2),
            ); // ✅ Store here
            cuponCode.value = code;
            // couponCodeController.clear();
            Get.snackbar(
              'Success',
              'Coupon applied: ${response.data.discountDisplay}',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 2),
            );
          } else {
            claimErrorMessage.value = response.data.message;

            Get.snackbar('Invalid Coupon', response.data.message);
          }
        },
      );
    } catch (e) {
      final errorMsg = 'Something went wrong: $e';
      claimErrorMessage.value = errorMsg;
      _errorDisplay.showError(errorMsg);
    } finally {
      isClaimingCoupon.value = false;
    }
  }

  Future<BookedAssistanceData?> createBooking(Map<String, dynamic> booking) async {
    final result = await _repository.postBooking(booking);
    return result?.data;
  }

  Future<PostAssistancePaymentData?> createPayment(Map<String, dynamic> bookingCode) async {
    final result = await _repository.postPayment(bookingCode);
    return result?.data;
  }

  String get _stripeUserId => Get.find<MainController>().userId.value;

  Future<ExchangeRatesResponseModel?> fetchStripeExchangeRates(String bookingId) async {
    isLoadingExchangeRates.value = true;
    try {
      final result = await _repository.getStripeExchangeRates(
        bookingId: bookingId,
        userId: _stripeUserId,
      );
      exchangeRates.value = result;
      return result;
    } catch (e) {
      print("DEBUG fetchStripeExchangeRates ERROR: $e");
      Get.snackbar("Error", "Failed to load exchange rates");
      return null;
    } finally {
      isLoadingExchangeRates.value = false;
    }
  }

  Future<CreateStripePaymentResponse?> createStripePayment({
    required String bookingId,
    required String currency,
    String email = '',
  }) async {
    isCreatingStripePayment.value = true;
    try {
      final payload = CreateStripePaymentRequest(
        bookingId: bookingId,
        currency: currency,
        email: email,
      );
      final result = await _repository.createStripePayment(
        payload: payload,
        userId: _stripeUserId,
      );
      print("DEBUG createStripePayment result raw: ${result.raw}");
      return result;
    } catch (e) {
      print("DEBUG createStripePayment ERROR: $e");
      Get.snackbar("Error", "Failed to initiate Stripe payment");
      return null;
    } finally {
      isCreatingStripePayment.value = false;
    }
  }

  Future<ConfirmStripePaymentResponse?> confirmStripePayment(String paymentIntentId) async {
    isConfirmingStripePayment.value = true;
    try {
      final payload = ConfirmStripePaymentRequest(paymentIntentId: paymentIntentId);
      final result = await _repository.confirmStripePayment(
        payload: payload,
        userId: _stripeUserId,
      );
      print("DEBUG confirmStripePayment result raw: ${result.raw}");
      return result;
    } catch (e) {
      print("DEBUG confirmStripePayment ERROR: $e");
      Get.snackbar("Error", "Failed to confirm Stripe payment");
      return null;
    } finally {
      isConfirmingStripePayment.value = false;
    }
  }

}

// Hello I am Tamim