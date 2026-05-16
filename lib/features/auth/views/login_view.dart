import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../services/network/error_display_manager.dart';
import 'package:pinput/pinput.dart';
import 'package:stayverz_flutter_app/features/auth/views/signup_screen.dart';
import '../../../services/notification_service.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final AuthController controller = Get.find();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final phone = controller.phoneController.text.trim();
      final password = controller.passwordController.text;
      final role = controller.selectedRole;

      controller.login(phone, password, role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image + gradient overlay
          Column(
            children: [
              Expanded(
                flex: 4,
                child: CustomPaint(
                  painter: RPSCustomPainter(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(width: 250, 'assets/login_screen_logo.png'),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 5, child: SizedBox()),
            ],
          ),
          Column(
            children: [
              Expanded(flex: 4, child: SizedBox()),
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildRoleCard(
                              'Login as Guest',
                              'assets/guets.gif',
                              controller.selectedRole == 'guest',
                              () => controller.setRole('guest'),
                            ),
                            const Gap(8),
                            _buildRoleCard(
                              'Login as Host',
                              'assets/host.gif',
                              controller.selectedRole == 'host',
                              () => controller.setRole('host'),
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),
                      Form(
                        key: _formKey,
                        child: Container(
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFF15925),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            shadows: [
                              BoxShadow(
                                color: const Color(0x26000000),
                                blurRadius: 10,
                                offset: Offset(0, 0),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                key: const Key('phone_field'),
                                controller: controller.phoneController,
                                decoration: const InputDecoration(
                                  hintText: 'Phone Number',
                                  border: InputBorder.none,
                                  isDense: true,
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                              ),
                              const Divider(
                                color: Colors.deepOrangeAccent,
                                thickness: 1,
                                height: 0,
                              ),
                              Obx(
                                () => TextFormField(
                                  key: const Key('password_field'),
                                  controller: controller.passwordController,
                                  obscureText:
                                      !controller.passwordVisible.value,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    isDense: true,
                                    isCollapsed: true,
                                    suffixIcon: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: IconButton(
                                        icon: Icon(
                                          controller.passwordVisible.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 16,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed:
                                            () =>
                                                controller
                                                    .togglePasswordVisibility(),
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            showUserTypeAndPhoneBottomSheet(
                              context,
                              controller,
                            );
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Color(0xFF67666B),
                              fontSize: 16,
                              fontFamily: 'Kumbh Sans',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ),
                      ),
                      const Gap(48),
                      Obx(
                        () => SizedBox(
                          width: 180,
                          child: ElevatedButton(
                            onPressed:
                                controller.isLoading.value
                                    ? null
                                    : () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        FocusScope.of(context).unfocus();
                                        controller.login(
                                          controller.phoneController.text
                                              .trim(),
                                          controller.passwordController.text,
                                          controller.selectedRole,
                                        );
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.deepOrange.shade700,
                              elevation: 0,
                            ),
                            child:
                                controller.isLoading.value
                                    ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      ' Login',
                                      style: TextStyle(fontSize: 22),
                                    ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(SignupScreen.routeName);
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.red,
                                decorationThickness: 2,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    String title,
    String imageUrl,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? const Color(0xFFF15925) : Colors.grey.shade300,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      color: Colors.white24,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Image.asset(imageUrl, height: 62, width: 62, fit: BoxFit.fill),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Kumbh Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showUserTypeAndPhoneBottomSheet(
    BuildContext context,
    AuthController controller,
  ) {
    final TextEditingController phoneController = TextEditingController();
    final RxString selectedType = 'guest'.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 16),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTypeCard(
                        title: 'Guest',
                        imagePath: 'assets/guest_log.png',
                        isSelected: selectedType.value == 'guest',
                        onTap: () => selectedType.value = 'guest',
                      ),
                      SizedBox(width: 16),
                      _buildTypeCard(
                        title: 'Host',
                        imagePath: 'assets/host_log.png',
                        isSelected: selectedType.value == 'host',
                        onTap: () => selectedType.value = 'host',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  decoration: InputDecoration(
                    hintText: 'Enter your 11-digit phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    counterText: '',
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.green.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final phone = phoneController.text.trim();
                    if (phone.length != 11) {
                      Get.snackbar(
                        'Error',
                        'Please enter a valid 11-digit phone number',
                        backgroundColor: Colors.red.shade100,
                      );
                      return;
                    }

                    Navigator.pop(context);

                    try {
                      await controller.requestOtpFiled(
                        phone: phone,
                        scope: 'reset_password',
                        type: selectedType.value,
                      );

                      showOtpBottomSheet(
                        context,
                        phone,
                        selectedType.value,
                        'reset_password',
                        controller.verifyOtpCode,
                      );
                    } catch (e) {
                      Get.find<ErrorDisplayManager>().showError('Failed to send OTP');
                    }
                  },
                  child: Text('Send OTP'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void showOtpBottomSheet(
    BuildContext context,
    String phone,
    String type,
    String scope,
    Future<void> Function({
      required String phone,
      required String type,
      required String otp,
      required String scope,
    })
    verifyOtpCallback,
  ) {
    final TextEditingController otpController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter OTP',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Pinput(
                controller: otpController,
                length: 5,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final otp = otpController.text.trim();

                  if (otp.length != 5) {
                    Fluttertoast.showToast(msg: 'Please enter the 5-digit OTP');
                    return;
                  }

                  try {
                    await verifyOtpCallback(
                      phone: phone,
                      type: type,
                      otp: otp,
                      scope: scope,
                    );
                    Get.back();
                    showSetPasswordBottomSheet(
                      context: context,
                      phone: phone,
                      otp: otp,
                      type: type,
                      controller: controller,
                    );
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: 'OTP verification failed. Please try again.',
                    );
                  }
                },
                child: Text('Verify OTP'),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void showSetPasswordBottomSheet({
    required BuildContext context,
    required String phone,
    required String otp,
    required String type,
    required AuthController controller,
  }) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Set New Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Re-type Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () async {
                            final password = passwordController.text.trim();
                            final confirm =
                                confirmPasswordController.text.trim();
                            if (password.isEmpty || confirm.isEmpty) {
                              Fluttertoast.showToast(
                                msg: 'Please fill all fields',
                              );
                              return;
                            }
                            if (password.length <= 5) {
                              Fluttertoast.showToast(
                                msg: 'Password must be at least 5 characters',
                              );
                              return;
                            }
                            if (password != confirm) {
                              Fluttertoast.showToast(
                                msg: 'Passwords do not match',
                              );
                              return;
                            }
                            try {
                              await controller.resetPassword(
                                phone: phone,
                                otp: otp,
                                password: password,
                                type: type,
                              );
                              Get.back();
                            } catch (_) {}
                          },
                  child:
                      controller.isLoading.value
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text('Submit'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Colors.redAccent.withOpacity(0.3)
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Circle

    Paint paint_fill_0 =
        Paint()
          ..color = const Color.fromARGB(255, 241, 90, 38)
          ..style = PaintingStyle.fill
          ..strokeWidth = size.width * 0.00
          ..strokeCap = StrokeCap.butt
          ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5000698, size.height * -0.1289091);
    path_0.cubicTo(
      size.width * 0.7310155,
      size.height * -0.1289091,
      size.width * 1.2306124,
      size.height * -0.2447273,
      size.width * 1.1422791,
      size.height * 0.4407652,
    );
    path_0.cubicTo(
      size.width * 1.1422791,
      size.height * 0.6664773,
      size.width * 0.9042248,
      size.height * 0.9996288,
      size.width * 0.5000698,
      size.height * 0.9996288,
    );
    path_0.cubicTo(
      size.width * 0.2690930,
      size.height * 0.9996288,
      size.width * -0.1308295,
      size.height * 0.8400152,
      size.width * -0.1308295,
      size.height * 0.4450303,
    );
    path_0.cubicTo(
      size.width * -0.2413566,
      size.height * -0.0874015,
      size.width * 0.0958992,
      size.height * -0.1289091,
      size.width * 0.5000698,
      size.height * -0.1289091,
    );
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Hello I am Tamim