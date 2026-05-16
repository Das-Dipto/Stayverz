import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/payment_mothod_controller.dart';

class OtpPopUpWidget extends StatefulWidget {
  const OtpPopUpWidget({
    super.key,
    required this.otpController,
    required this.controller,
  });

  final TextEditingController otpController;
  final PaymentMethodController controller;

  @override
  State<OtpPopUpWidget> createState() => _OtpPopUpWidgetState();
}

class _OtpPopUpWidgetState extends State<OtpPopUpWidget> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = widget.controller.isSubmittingOtp.value;

      return WillPopScope(
        onWillPop: () async => !isLoading,
        child: AlertDialog(
          title: const Text('Enter OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: widget.otpController,
                keyboardType: TextInputType.number,
                maxLength: 5,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  hintText: 'Enter 5-digit OTP',
                  counterText: '',
                ),
              ),
              if (isLoading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                const Text(
                  'Processing...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                final otp = widget.otpController.text.trim();
                widget.controller.handleOtpSubmit(otp);
              },
              child: isLoading
                  ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text('Submit'),
            ),
          ],
        ),
      );
    });
  }
}
// Hello I am Tamim