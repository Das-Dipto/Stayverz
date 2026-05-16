import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../features/profile/bindings/profile_binding.dart';
import '../../../features/booking/presentation/views/book_and_go_screen.dart';
import '../../../main.dart';
import '../../../widgets/own_app_bar.dart';
import '../../../widgets/own_icons_icons.dart';
import '../../../widgets/profile_avatar_widget.dart';
import '../menu_screen/blog_screen.dart';
import '../menu_screen/change_password.dart';
import '../menu_screen/contact_us.dart';
import '../../../features/wishlist/presentation/views/my_wishlist_screen.dart';
import '../menu_screen/refaral_screen.dart';
import '../menu_screen/terms_conditions.dart';
import '../../../../features/blog/bindings/blog_binding.dart';
import 'menu/profile/profile_screen.dart';

class GuestMenuScreen extends StatefulWidget {
  const GuestMenuScreen({super.key});

  @override
  State<GuestMenuScreen> createState() => _GuestMenuScreenState();
}

class _GuestMenuScreenState extends State<GuestMenuScreen> {
  late final AuthController _authController;
  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
  }

  List<MenuData> menus = [
    if(mainControl.isLogin.value)...[
      MenuData('My Wishlist\'s', OwnIcons.favourite_icon),
      MenuData('Book & Go',Icons.healing),
      MenuData('Refer Guest', OwnIcons.reservation_icon),
      MenuData('Change Password', OwnIcons.favourite_icon),
    ],
    MenuData('Blogs', OwnIcons.blogs_icon),
   // MenuData('About us', OwnIcons.about_us_icon),
    MenuData('Contact Us', OwnIcons.contact_support_icon),
    MenuData('Terms and Condition', OwnIcons.terms_and_condition_icon),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnAppBar(
        backgroundColor: Colors.white,
        appHeight: 00,
        child: Row(
          children: [
          //  Image.asset('./assets/stayverz_logo.png', height: 40,),
          ],
        ),
      ),
      backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Gap(10),
                // ✅ Profile Section (only shows when logged in AND profile is loaded)
                if (mainControl.isLogin.value)
                  Obx(() {
                    final profile = controller.profile.value;
                    if (profile == null) {
                      // Show small placeholder instead of full screen loader
                      return Container(
                        height: 80,
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(width: 1, color: Colors.black12),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey.shade300,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(height: 16, width: 120, color: Colors.grey.shade300),
                                  const SizedBox(height: 8),
                                  Container(height: 14, width: 80, color: Colors.grey.shade300),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // ✅ Profile loaded
                    return InkWell(
                      onTap: () {
                        if (!Get.isRegistered<ProfileController>()) {
                          ProfileBinding().dependencies();
                        }
                        Get.to(() => ProfileScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(width: 1, color: Colors.black12),
                          ),
                        ),
                        child: Row(
                          children: [
                            ProfileAvatarWidget(
                              url: profile.image ?? '',
                              radius: 28,
                              size: 28,
                            ),
                            const Gap(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.fullName ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 1.33,
                                    ),
                                  ),
                                  Text(
                                    profile.uType ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.black12,
                              ),
                              child: Icon(
                                OwnIcons.right_arrow_icon,
                                color: Colors.black38,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                const Gap(30),

                // ✅ Menu Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),

                // ✅ Menu List (always visible)
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (menus[index].title == 'My Wishlist\'s') {
                            Get.to(MyWishlistScreen());
                          }
                          if (menus[index].title == 'Blogs') {
                            Get.to(
                                  () => const BlogScreen(),
                              binding: BlogBinding(),
                            );
                          }
                          if (menus[index].title == 'Contact Us') {
                            Get.to(ContactUs());
                          }
                          // if (index == 4) {
                          //   Get.to(AboutUs());
                          // }
                          if (menus[index].title == 'Terms and Condition') {
                            Get.to(TermsConditions());
                          }

                          if (menus[index].title == 'Change Password') {
                            Get.to(ChangePassword());
                          }
                          if (menus[index].title == 'Refer Guest') {
                            Get.to(ReferralScreen());
                          }
                          if (menus[index].title == 'Book & Go') {
                            Get.toNamed(BookAndGoScreen.routeName);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(width: 1, color: Colors.black12),
                          ),
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(12),
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              menus[index].icon,
                              size: 15,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 17),
                            Expanded(
                              child: Text(
                                menus[index].title ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined, size: 16, color: Colors.black87),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Gap(8),
                ),

                // ✅ Switch / Logout Buttons (only if logged in)
                if (mainControl.isLogin.value) ...[
                  const Divider(height: 48),
                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _authController.isLoading.value ? null : () async {
                          await _authController.login(
                              mainControl.username.value, mainControl.password.value, 'host');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange.shade50,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(width: 1, color: Colors.deepOrange.shade100),
                          ),
                        ),
                        child: _authController.isLoading.value
                            ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.deepOrange,
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(OwnIcons.switch_icon, color: Colors.deepOrange, size: 18),
                            const SizedBox(width: 10),
                            Text(
                              'Switch to Host',
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const Gap(16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _handleLogout(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(width: 1, color: Colors.black12),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const Gap(30),
              ],
            ),
          ),
        )

    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      final bool shouldLogout = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {  // ← renamed to dialogContext
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);  // ← use dialogContext
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);  // ← use dialogContext
                },
                child: const Text(
                  'LOGOUT',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      ) ??
          false;

      if (shouldLogout) {
        await Future.delayed(Duration.zero); // ← let dialog fully dismiss first
        try {
          await _authController.logOut();
        } catch (e) {
          Get.snackbar(
            'Error',
            'Failed to logout. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

}

class MenuData {
  IconData? icon;
  String? title;
  MenuData(this.title, this.icon);
}

// Hello I am Tamim