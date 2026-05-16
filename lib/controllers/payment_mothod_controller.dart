import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/profile_controller.dart';
import 'package:stayverz_flutter_app/core/utils/main_utils.dart';
import 'package:stayverz_flutter_app/widgets/otp_pop_up_widget.dart';

import '../core/utils/enums/product_listing_enums.dart';
import '../features/profile/models/payment_post_data_model.dart';

class PaymentMethodController extends GetxController {

  Rx<CurrentState> currentState = Rx<CurrentState>(CurrentState.FIRST);

  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController routingNumberController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController onlinePhoneNumberController = TextEditingController();
  TextEditingController mobilePhoneNumberController = TextEditingController();
  TextEditingController mobileMerchantNameController = TextEditingController();
  TextEditingController onlineMerchantController = TextEditingController();
  RxString selectedPayoutMethod = RxString('');
  RxList userPaymentMethods = RxList();
  final ProfileController profile = Get.find<ProfileController>();

  RxBool isBankEditMode = RxBool(false);
  RxBool isSetAsDefaultPaymentMethod = RxBool(false);
  RxBool isSubmittingOtp = RxBool(false);

  RxString selectedEditId = RxString('');

  // Store dialog context
  BuildContext? _dialogContext;

  void resetAllData() {
    selectedPayoutMethod.value = '';
    selectedEditId.value = '';
    bankNameController.clear();
    branchNameController.clear();
    routingNumberController.clear();
    accountNumberController.clear();
    accountNameController.clear();
    mobilePhoneNumberController.clear();
    mobileMerchantNameController.clear();
    isSetAsDefaultPaymentMethod.value = false;
  }

  void handleContinue() async {
    final state = currentState.value;

    bool isValid = false;
    if(selectedEditId.isEmpty){
      if (state == CurrentState.SECOND) {
        isValid = _validateBankFields();
      } else if (state == CurrentState.THIRD) {
        isValid = _validateMobileBankingFields();
      } else {
        goNext();
        return;
      }
    }else {
      if(isBankEditMode.value) {
        isValid = _validateBankFields();
      }else{
        isValid = _validateMobileBankingFields();
      }
    }

    if (!isValid) {
      MainUtils.showErrorSnackBar('Please fill in all required fields');
      return;
    }

    try {
      final String? email = profile.profile.value!.phoneNumber;
      final scope = 'payment_method';

      final response = await profile.requestEmailUpdate(
        email: "$email",
        scope: scope,
      );

      _showOtpDialog();

    } catch (e) {
      MainUtils.showErrorSnackBar('Failed to send verification: $e');
    }
  }

  bool _validateBankFields() {
    return bankNameController.text.isNotEmpty &&
        branchNameController.text.isNotEmpty &&
        routingNumberController.text.isNotEmpty &&
        accountNameController.text.isNotEmpty &&
        accountNumberController.text.isNotEmpty;
  }

  bool _validateMobileBankingFields() {
    return mobilePhoneNumberController.text.isNotEmpty &&
        mobileMerchantNameController.text.isNotEmpty;
  }

  void _showOtpDialog() {
    final otpController = TextEditingController();

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        _dialogContext = dialogContext; // Store the dialog context
        return OtpPopUpWidget(
          otpController: otpController,
          controller: this,
        );
      },
    );
  }

  Future<void> handleOtpSubmit(String otp) async {
    if (otp.length != 5) {
      MainUtils.showErrorSnackBar('Please enter a valid 5-digit OTP');
      return;
    }

    isSubmittingOtp.value = true;

    try {
      await _handleOtpSubmission(otp);
      await profile.fetchProfile();
      await profile.fetchHostPaymentMethods();

      // Close OTP dialog using stored context
      if (_dialogContext != null && _dialogContext!.mounted) {
        Navigator.of(_dialogContext!).pop();
        _dialogContext = null;
      }

      // Small delay to ensure dialog closes
      await Future.delayed(const Duration(milliseconds: 100));

      // Close Add/Edit Payment screen
      Get.back();

      // Show success message
      MainUtils.showSuccessSnackBar(
          'Payment method ${selectedEditId.isEmpty ? 'created' : 'updated'} successfully!'
      );

    } catch (e) {
      MainUtils.showErrorSnackBar('Error: $e');
    } finally {
      isSubmittingOtp.value = false;
    }
  }

  Future<void> _handleOtpSubmission(String otp) async {
    final current = currentState.value;

    String branchName = current == CurrentState.SECOND ? branchNameController.text : '';
    String routingNumber = current == CurrentState.SECOND ? routingNumberController.text : '';
    String accountName = current == CurrentState.SECOND ? accountNameController.text : mobileMerchantNameController.text;
    String accountNo = current == CurrentState.SECOND ? accountNumberController.text : mobilePhoneNumberController.text;

    if(isBankEditMode.value && selectedPayoutMethod.isNotEmpty) {
      branchName = branchNameController.text;
      routingNumber = routingNumberController.text;
      accountName = accountNameController.text;
      accountNo = accountNumberController.text;
    }

    final paymentRequest = PaymentMethodRequest(
      mType: selectedPayoutMethod.value,
      bankName: bankNameController.text,
      branchName: branchName,
      routingNumber: routingNumber,
      accountName: accountName,
      accountNo: accountNo,
      isDefault: isSetAsDefaultPaymentMethod.value,
      otp: otp,
    );

    if(selectedEditId.isEmpty) {
      await profile.createPaymentMethod(paymentRequest);
    }else{
      await profile.updatePaymentMethod(paymentRequest, selectedEditId.value);
    }

    resetAllData();
  }

  void goNext() {

    if((currentState.value == CurrentState.SECOND) || (currentState.value == CurrentState.THIRD)){

      if(currentState.value == CurrentState.SECOND) {
        userPaymentMethods.add({
          'method': selectedPayoutMethod.value,
          'name': accountNameController.text,
          'bank_name': bankNameController.text,
          'ac_no': accountNumberController.text
        });
      }

      if(currentState.value == CurrentState.THIRD) {
        userPaymentMethods.add({
          'method': selectedPayoutMethod.value,
          'name': onlineMerchantController.text,
          'ac_no': onlinePhoneNumberController.text
        });
      }

      Get.back();
    }else if(selectedPayoutMethod.value == 'bank') {
      currentState(CurrentState.SECOND);
    } else {
      currentState(CurrentState.THIRD);
    }
  }
}
// Hello I am Tamim