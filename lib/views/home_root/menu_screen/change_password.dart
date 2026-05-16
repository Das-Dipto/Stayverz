import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/profile_controller.dart';

import '../../../widgets/custom_input_text.dart';
import '../../../widgets/own_app_bar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final ProfileController controller = Get.find<ProfileController>();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _toggleOldPassword() {
    setState(() {
      _obscureOldPassword = !_obscureOldPassword;
    });
  }

  void _toggleNewPassword() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _submitChangePassword() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      await controller.changePassword(
        oldPassword: oldPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      if (controller.changePasswordError.value.isEmpty) {
        // Show success toast
        Fluttertoast.showToast(
          msg: controller.changePasswordSuccess.value.isNotEmpty
              ? controller.changePasswordSuccess.value
              : "Password changed successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,   // Show at top
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Wait for the snackbar to show before going back
       // await Future.delayed(const Duration(seconds: 2));
        Get.back();
      }
      else{
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: Colors.grey.withOpacity(0.1),
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: Colors.black,
              ),
            ),
            const Gap(20),
            const Expanded(
              child: Text(
                'Change Password',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(40),
                Image.asset(
                  'assets/password.png',
                  fit: BoxFit.cover,
                  height: 130,
                  width: 130,
                ),
                const Gap(85),
                Center(
                  child: Text("Reset Password",style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 18,fontWeight: FontWeight.w600
                  ),),
                ),
                Gap(20),

                // Old Password
                CustomInputText(
                  controller: oldPasswordController,
                  helperText: "Old password",
                  obscureText: _obscureOldPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureOldPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: _toggleOldPassword,
                  ),
                ),
                const Gap(10),

                // New Password
                CustomInputText(
                  controller: newPasswordController,
                  helperText: "New password",
                  obscureText: _obscureNewPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: _toggleNewPassword,
                  ),
                ),
                const Gap(10),

                // Confirm Password
                CustomInputText(
                  controller: confirmPasswordController,
                  helperText: "Confirm password",
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: _toggleConfirmPassword,
                  ),
                ),
                const Gap(40),

                Obx(() {
                  if (controller.isChangingPassword.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return InkWell(
                    onTap: _submitChangePassword,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                      margin: const EdgeInsets.symmetric(horizontal: 100),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFA9A9B0),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Submit',
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
                  );
                }),

                const Gap(40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Hello I am Tamim