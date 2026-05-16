import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/reservation/presentation/view_all_reservations_screen.dart';
import 'package:stayverz_flutter_app/main.dart';
import 'package:stayverz_flutter_app/views/home_root/home/menu/payment_mehtod/payment_method_screen.dart';
import 'package:stayverz_flutter_app/views/home_root/home/menu/profile/profile_screen.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';
import 'package:stayverz_flutter_app/widgets/profile_avatar_widget.dart';
import 'package:stayverz_flutter_app/features/auth/controllers/auth_controller.dart';
import 'package:stayverz_flutter_app/features/profile/bindings/profile_binding.dart';
import 'package:stayverz_flutter_app/controllers/profile_controller.dart';
import '../../../../features/blog/bindings/blog_binding.dart';
import '../../../../features/booking/presentation/views/host_instant_booking_screen.dart';
import '../../../../features/finance_report/presentation/finance_report/finance_screen.dart';
import '../../guest_bottom_navigation_bar_view.dart';
import '../../menu_screen/blog_screen.dart';
import '../../menu_screen/change_password.dart';
import '../../menu_screen/contact_us.dart';
import '../../menu_screen/refaral_screen.dart';
import '../../menu_screen/terms_conditions.dart';
import 'co_host/co_host_option_screen.dart';
import '../../../../features/listing/presentation/views/my_listing/my_listing_screen.dart';
import 'superhost/superhost_performance_dashboard_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final AuthController _authController;
  final ProfileController controller = Get.find<ProfileController>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
    // ProfileController.onReady() already fetches profile automatically - no duplicate API calls
  }

  List<MenuData> menus = [
    MenuData('My Listing', OwnIcons.favourite_icon),
    MenuData('Instant Book', OwnIcons.favourite_icon),
    MenuData('Finance Report', OwnIcons.finance_icon),
    MenuData('Reservations', OwnIcons.reservation_icon),
    MenuData('Payout Method', OwnIcons.payout_method_icon),
    MenuData('Refer Host', OwnIcons.refer_host_icon),
    MenuData('Super Host', OwnIcons.super_host_icon),
    MenuData('Host Assist', OwnIcons.co_host_control_icon),
    MenuData('Change Password', OwnIcons.favourite_icon),
    MenuData('Blogs', OwnIcons.blogs_icon),
    MenuData('Contact Us', OwnIcons.contact_support_icon),
    MenuData('Terms and Condition', OwnIcons.terms_and_condition_icon),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Gap(30),
                InkWell(
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
                          side: BorderSide(width: 1, color: Colors.black12)
                      ),
                    ),
                    child: Obx(() {
                      final profileData = controller.profile.value;
                      if (controller.isLoading.value && profileData == null) {
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.black12,
                              child: SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black54),
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 16,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const Gap(4),
                                  Container(
                                    height: 14,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          ProfileAvatarWidget(
                            url: profileData?.image ?? '',
                            radius: 28,
                            size: 28,
                          ),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileData?.fullName ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1.33,
                                  ),
                                ),
                                Text(
                                  profileData?.uType ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.black12
                            ),
                            child: Icon(OwnIcons.right_arrow_icon, color: Colors.black38, size: 14,),
                          )
                        ],
                      );
                    }),
                  ),
                ),
                const Gap(30),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Menu',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            switch(menus.elementAt(index).title) {
                              case 'My Listing':
                                Get.to(MyListingScreen());
                                break;
                              case 'Finance Report':
                                Get.to(FinanceScreen());
                                break;
                              case 'Payout Method':
                                Get.to(PaymentMethodScreen());
                                break;
                              case 'Refer Host':
                                Get.to(ReferralScreen());
                                break;
                              case 'Super Host':
                                final userId = controller.profile.value?.id;
                                if (userId != null) {
                                  Get.to(SuperHostPerformanceDashboardScreen(id: userId));
                                }
                                break;
                              case 'Host Assist':
                                Get.to(CoHostOptionScreen());
                                break;
                              case 'Change Password':
                                Get.to(ChangePassword());
                                break;
                              case 'Terms and Condition':
                                Get.to(TermsConditions());
                                break;
                              case 'Blogs':
                                Get.to(
                                      () => const BlogScreen(),
                                  binding: BlogBinding(),
                                );
                                break;
                              case 'Contact Us':
                                Get.to(ContactUs());
                                break;
                              case 'Instant Book':
                                Get.toNamed(HostInstantBookingScreen.routeName);
                                break;
                              case 'Reservations':
                                Get.to(ViewAllReservationsScreen());
                                break;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(width: 1, color: Colors.black12)),
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.all(12),
                              elevation: 0
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 17,
                            children: [
                              Icon(menus.elementAt(index).icon, size: 15, color: Colors.black,),
                              Expanded(
                                child: Text(
                                  menus.elementAt(index).title ?? '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_outlined, size: 16, color: Colors.black87,)
                            ],
                          )
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gap(8),
                  itemCount: menus.length,
                ),
                const Divider(height: 48,),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: Obx( () {
                    return ElevatedButton(
                        onPressed: _authController.isLoading.value ? null : () async {
                          await _authController.logOut();
                          await _authController.login(mainControl.username.value, mainControl.password.value, 'guest');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange.shade50,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(width: 1, color: Colors.deepOrange.shade100)
                            )
                        ),
                        child: _authController.isLoading.value ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.deepOrange,),) : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(OwnIcons.switch_icon, color: Colors.deepOrange, size: 18,),
                            Text(
                              'Switch to Guest',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        )
                    );
                  }
                  ),
                ),
                const Gap(16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) {
                          return StatefulBuilder(
                            builder: (dialogContext, setDialogState) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: AlertDialog(
                                  title: const Text('Logout'),
                                  content: isLoading
                                      ? const SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(width: 12),
                                          Text('Logging out...'),
                                        ],
                                      ),
                                    ),
                                  )
                                      : const Text('Are you sure you want to logout?'),
                                  actions: isLoading
                                      ? []
                                      : [
                                    TextButton(
                                      onPressed: () => Navigator.of(dialogContext).pop(),
                                      child: const Text('CANCEL'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        setDialogState(() => isLoading = true);
                                        try {
                                          await _authController.logOut();
                                          await mainControl.clearUserData();
                                          if (dialogContext.mounted) {
                                            Navigator.of(dialogContext).pop();
                                          }
                                          Get.offAll(() => GuestBottomNavigationBarView());
                                        } catch (e) {
                                          setDialogState(() => isLoading = false);
                                          if (dialogContext.mounted) {
                                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                                              const SnackBar(
                                                content: Text('Failed to logout. Please try again.'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'LOGOUT',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    }, child: Text('Logout'),
                  ),
                ),
                const Gap(30),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class MenuData {
  IconData? icon;
  String? title;
  MenuData(this.title, this.icon);
}
