import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/auth/controllers/auth_controller.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationView extends GetView<AuthController> {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String uType;

  OtpVerificationView({
    super.key,
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.uType,
  });

  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      final otp = _otpController.text.trim();

      controller.register(
        fullName,
        phoneNumber,
        uType,
        password,
        otp,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color(0xFFF15925)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Text(
                  'Enter OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'An OTP has been sent to your phone number $phoneNumber',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 32),
                Pinput(
                  controller: _otpController,
                  length: 5, // As per your API requirement
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  validator: (s) {
                    if (s == null || s.isEmpty) {
                      return 'Please enter OTP';
                    }
                    if (s.length < 5) {
                      return 'OTP must be 5 digits';
                    }
                    return null;
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) => _verifyOtp(),
                ),
                SizedBox(height: 32),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Verify OTP',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed: () async {
                    // Implement resend OTP functionality
                    // Show loading indicator if needed, or rely on AuthController's isLoading state
                    bool success = await controller.requestOtp(phoneNumber, 'register', uType);
                    if (success) {
                      // Optionally, inform the user that OTP has been resent
                      // Get.snackbar('Info', 'OTP has been resent.'); // Already handled by requestOtp
                    } else {
                      // Error is already handled by AuthController's snackbar
                    }
                  },
                  child: Text('Resend OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Hello I am Tamim