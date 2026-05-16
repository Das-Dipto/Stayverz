import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/public_listings/bindings/public_listings_binding.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/public_listings_view.dart';
import 'package:stayverz_flutter_app/features/booking/presentation/views/trip_screen.dart';
import 'package:stayverz_flutter_app/features/booking/bindings/trip_binding.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/controllers/public_listings_controller.dart';
import 'package:upgrader/upgrader.dart';
import '../../core/constants/app_colors.dart';
import '../../controllers/main_controller.dart';
import '../../core/utils/main_utils.dart';
import '../../features/messaging/bindings/messaging_binding.dart';
import '../../features/messaging/controllers/inbox_controller.dart';
import '../../features/messaging/presentation/views/inbox_page.dart';
import '../../features/notification/presentation/view/notification_screen.dart';
import '../../widgets/own_icons_icons.dart';
import 'home/guest_home_screen.dart';
import 'home/guest_menu_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:stayverz_flutter_app/core/constants/app_routes.dart';

class GuestBottomNavigationBarView extends StatefulWidget {
  final int? page;
  const GuestBottomNavigationBarView({super.key, this.page});
  static const String routeName = '/guest-home';

  @override
  State<GuestBottomNavigationBarView> createState() =>
      _GuestBottomNavigationBarViewState();
}

class _GuestBottomNavigationBarViewState
    extends State<GuestBottomNavigationBarView> {
  final MainController mainControl = Get.find<MainController>();


  @override
  void initState() {
    super.initState();
    _initializeBindings();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainControl.updateButtonNavigationBarIndex(widget.page ?? 2); // ✅ safe here
    });
  }

  // Initialize all required bindings
  void _initializeBindings() {
    if (!Get.isRegistered<PublicListingsController>()) {
      Get.put(PublicListingsBinding(), permanent: true).dependencies();
    }

    if (mainControl.isLogin.value) {
      if (!Get.isRegistered<InboxController>()) {
        Get.put(MessagingBinding(), permanent: true).dependencies();
      }
      if (!Get.isRegistered<TripBinding>()) {
        Get.put(TripBinding(), permanent: true).dependencies();
      }
    }
  }

  List<Widget> get child {
    return [
      const TripScreen(),
      const InboxScreen(),
      PublicListingsView(), // Venture tab - uses PublicListingsView instead of ListPage
      NotificationScreen(),
      // const GuestHomeScreen(),
      // WebViewInboxScreen(),
      const GuestMenuScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final InboxController? c = Get.isRegistered<InboxController>() ? Get.find<InboxController>() : null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainControl.updateButtonNavigationBarIndex(widget.page??2);
    });
    return UpgradeAlert(
      upgrader: Upgrader(
        debugLogging: false,
        countryCode: 'BD',
        durationUntilAlertAgain: Duration.zero,
      ),
      dialogStyle: 
          Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
      shouldPopScope: () => false,
      showLater: false,
      showIgnore: false,
      child: Obx(() {
        return WillPopScope(
          onWillPop: () {
            if (mainControl.buttonNavigationBarIndex.value == 2) {
              return MainUtils.onBackPressed(context: context);
            } else {
              mainControl.updateButtonNavigationBarIndex(2);
            }
            return Future(() => false);
          },
          child: Scaffold(
            body: child[mainControl.buttonNavigationBarIndex.value],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              fixedColor: AppColors.primaryColor,
              backgroundColor: Color(0XFFF2F2F7),
              currentIndex: mainControl.buttonNavigationBarIndex.value,
              onTap: (value) {
                if ((value == 0||value==1||value==4 || value == 3) && !mainControl.isLogin.value) {
                  Get.toNamed(AppRoute.login) ;
                } else {
                  if (value == 3) {
                    MessagingBinding().dependencies();
                  }
                  mainControl.updateButtonNavigationBarIndex(value);
                }
              },
              items: [
                // BottomNavigationBarItem(icon: SvgPicture.asset(Assets.iconsHomeIconGrey,height: 25,width: 25,fit: BoxFit.fill,), label: 'Community', activeIcon: SvgPicture.asset(Assets.iconsHomeIconBlack,height: 25,width: 25,fit: BoxFit.fill,), backgroundColor: Colors.white),
                BottomNavigationBarItem(
                  icon: Icon(OwnIcons.trip_icon_outlined, size: 17),
                  label: 'Trip',
                  activeIcon: Icon(OwnIcons.trip_icon_filled, size: 19,),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: c == null
                      ? const Icon(Icons.message_outlined, size: 20)
                      : Obx(() {
                    return badges.Badge(
                      badgeContent: Text(
                        "${c.totalUnreadCount}",
                        style: const TextStyle(
                            fontSize: 10, color: Colors.white),
                      ),
                      showBadge: c.totalUnreadCount > 0,
                      badgeStyle: const badges.BadgeStyle(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3, vertical: 2),
                          badgeColor: Colors.black54),
                      child: const Icon(Icons.message_outlined,
                          size: 20),
                    );
                  }),
                  label: 'Inbox',
                  activeIcon: c == null
                      ? const Icon(Icons.message, size: 20)
                      : Obx(() {
                    return badges.Badge(
                      badgeContent: Text(
                        "${c.totalUnreadCount}",
                        style: const TextStyle(
                            fontSize: 10, color: Colors.white),
                      ),
                      showBadge: c.totalUnreadCount > 0,
                      badgeStyle: const badges.BadgeStyle(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3, vertical: 2),
                      ),
                      child: const Icon(Icons.message,
                          size: 20),
                    );
                  }),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(OwnIcons.today_icon_outlined, size: 20),
                  label: 'Home',
                  activeIcon: Icon(OwnIcons.today_icon, size: 20),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active_outlined, size: 20),
                  label: 'Notification',
                  activeIcon: Icon(Icons.notifications_active_rounded, size: 20),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu, size: 20),
                  label: 'Menu',
                  activeIcon: Icon(Icons.menu, size: 20),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// Hello I am Tamim