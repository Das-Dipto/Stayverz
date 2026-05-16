import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/auth/controllers/auth_controller.dart';
import 'package:stayverz_flutter_app/features/auth/views/otp_verification_view.dart';
import 'package:stayverz_flutter_app/main.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // RxBool setGuestRole = false.obs; // Replaced by AuthController's selectedRole
  // RxBool setHostRole = false.obs;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Schedule the API call after the current build frame is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.fetchCode();
    });
  }

  void _onNextPressed() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final fullName = _fullNameController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text;
      final uType = authController.selectedRole;

      // Request OTP and wait for the result
      final bool otpRequestSuccessful = await authController.requestOtp(phone, "register", uType);

      // Navigate only if OTP request was successful
      if (otpRequestSuccessful) {

        Get.to(() => OtpVerificationView(
            fullName: fullName,
            phoneNumber: phone,
            password: password, // Pass the password to OTP screen
            uType: uType,
        ));
      }
      // If not successful, the AuthController's error handling (snackbar) will have already informed the user.
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: CustomPaint(
                  painter: RPSCustomPainter(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        width: 250,
                        'assets/login_screen_logo.png',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 6, child: SizedBox())
            ],
          ),
          Column(
            children: [
              Expanded(flex: 3, child: SizedBox()),
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom:24, left: 24, right: 24),
                  child: Column(
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildRoleCard(
                              'Signup as Guest',
                              'assets/guets.gif',
                              authController.selectedRole == 'guest',
                              (mainControl.deepLinkReferer ?? '').isNotEmpty && authController.referCode.isNotEmpty ? ( ) {} : () {
                                authController.setRole('guest');
                              },
                            ),
                            const Gap(8),
                            _buildRoleCard(
                              'Signup as Host',
                              'assets/host.gif',
                              authController.selectedRole == 'host',
                              (mainControl.deepLinkReferer ?? '').isNotEmpty && authController.referCode.isNotEmpty ? ( ) {} : () {
                                authController.setRole('host');
                              },
                            ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      /// Input Fields Box
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
                              _buildTextFormField(
                                controller: _fullNameController,
                                labelText: 'Full Name',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                              ),
                              const Divider(color: Color(0xFFF15925), thickness: 1, height: 0),
                              _buildTextFormField(
                                controller: _phoneController,
                                labelText: 'Phone Number',
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  // Add more specific phone validation if needed
                                  return null;
                                },
                              ),
                              const Divider(color: Color(0xFFF15925), thickness: 1, height: 0),
                              Obx(() {
                                  if(!authController.willShowReferField.value) {
                                    return SizedBox();
                                  }

                                  return _buildTextFormField(
                                      controller: authController.referCodeController,
                                      labelText: 'Refer code',
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your refer code';
                                        }
                                        // Add more specific phone validation if needed
                                        return null;
                                      },
                                      onChange: (value) {
                                          if(value.isNotEmpty) {
                                            authController.referCode.value = value;
                                          }
                                      },
                                    suffixIcon: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: IconButton(
                                        icon: Icon(Icons.close,
                                          size: 16,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed: () => authController.willShowReferField.value = false,
                                      ),
                                    ),
                                  );
                                }
                              ),
                              const Divider(color: Color(0xFFF15925), thickness: 1, height: 0),
                              Obx(() => _buildTextFormField(
                                    controller: _passwordController,
                                    labelText: 'Password',
                                    obscureText: !authController.passwordVisible.value,
                                    suffixIcon: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: IconButton(
                                        icon: Icon(
                                          authController.passwordVisible.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 16,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed: () => authController.togglePasswordVisibility(),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      } else if (value.length < 5) {
                                        return 'Password must be at least 5 characters';
                                      }
                                      return null;
                                    },
                                  )),
                              const Divider(color: Color(0xFFF15925), thickness: 1, height: 0),
                              Obx(() => _buildTextFormField(
                                    controller: _confirmPasswordController,
                                    labelText: 'Confirm Password',
                                    obscureText: !authController.confirmPasswordVisible.value, // Assuming you add this to controller
                                    suffixIcon: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: IconButton(
                                        icon: Icon(
                                          authController.confirmPasswordVisible.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 16,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed: () => authController.toggleConfirmPasswordVisibility(), // Assuming you add this to controller
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      } else if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Obx(() {
                        if(authController.willShowReferField.value) {
                          return Gap(24);
                        }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Do you have any refer code?',
                                style: TextStyle(color: Color(0xFF67666B)),
                              ),
                              TextButton(
                                onPressed: () => authController.willShowReferField.value = true,
                                child: const Text(
                                  'Enter',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                      /// Next Button (Replaces Signup Button)
                      Obx(() => ElevatedButton(
                        onPressed: authController.isLoading.value ? null : _onNextPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange.shade700,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: authController.isLoading.value
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Kumbh Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      )),

                      /// Login Redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an Account?',
                            style: TextStyle(color: Color(0xFF67666B)),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
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
          // Removed "or" and Email Login Icon as per new flow
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
        borderRadius: BorderRadius.circular(12),
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
                Image.asset(
                  imageUrl,
                  height: 62,
                  width: 62,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 8),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    Function(String)? onChange
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: labelText,
        labelStyle: const TextStyle(
          color: Color(0xFFA9A9B0),
          fontSize: 16,
          fontFamily: 'Kumbh Sans',
          fontWeight: FontWeight.w300,
        ),
        border: InputBorder.none,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        isDense: true,
        isCollapsed: true,
      ),
      onChanged: onChange,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    // Circle

    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 241, 90, 38)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_0 = Path();
    path_0.moveTo(size.width*0.5000698,size.height*-0.1289091);
    path_0.cubicTo(size.width*0.7310155,size.height*-0.1289091,size.width*1.2306124,size.height*-0.2447273,size.width*1.1422791,size.height*0.4407652);
    path_0.cubicTo(size.width*1.1422791,size.height*0.6664773,size.width*0.9042248,size.height*0.9996288,size.width*0.5000698,size.height*0.9996288);
    path_0.cubicTo(size.width*0.2690930,size.height*0.9996288,size.width*-0.1308295,size.height*0.8400152,size.width*-0.1308295,size.height*0.4450303);
    path_0.cubicTo(size.width*-0.2413566,size.height*-0.0874015,size.width*0.0958992,size.height*-0.1289091,size.width*0.5000698,size.height*-0.1289091);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
// Hello I am Tamim