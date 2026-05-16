import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/constants/app_colors.dart';
import 'package:stayverz_flutter_app/features/finance_report/bindings/finance_report_binding.dart';
import 'package:stayverz_flutter_app/features/finance_report/controllers/finance_report_controller.dart';
import 'package:stayverz_flutter_app/features/listing/bindings/listing_binding.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/features/finance_report/presentation/finance_report/finance_screen.dart';
import 'package:stayverz_flutter_app/controllers/profile_controller.dart';
import 'package:stayverz_flutter_app/features/profile/bindings/profile_binding.dart';
import 'package:stayverz_flutter_app/features/listing/presentation/views/calendar/calendar_screen.dart';
import 'package:stayverz_flutter_app/features/reservation/presentation/today_screen.dart';
import 'package:stayverz_flutter_app/views/home_root/home/menu/menu_screen.dart';
import 'package:upgrader/upgrader.dart';
import '../../core/constants/app_images.dart';
import '../../controllers/main_controller.dart';
import '../../core/utils/main_utils.dart';
import 'package:stayverz_flutter_app/features/messaging/bindings/messaging_binding.dart';
import 'package:stayverz_flutter_app/features/messaging/controllers/inbox_controller.dart';
import 'package:stayverz_flutter_app/features/messaging/presentation/views/inbox_page.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';
import 'package:badges/badges.dart' as badges;

import '../../features/notification/presentation/view/notification_screen.dart';

class HostBottomNavigationBarView extends StatefulWidget {
  const HostBottomNavigationBarView({super.key});
  static const String routeName = '/host-home';

  @override
  State<HostBottomNavigationBarView> createState() =>
      _HostBottomNavigationBarViewState();
}

class _HostBottomNavigationBarViewState extends State<HostBottomNavigationBarView> {
  final MainController mainControl = Get.find<MainController>();

  List<Widget> get child => [
    TodayScreen(),
    const InboxScreen(),
    // WebViewInboxScreen(),
     CalendarScreen(),
    const NotificationScreen(),
    const MenuScreen(),
  ];

  @override
  void initState() {
    super.initState();
    
    // Set default to TodayScreen (index 0)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainControl.updateButtonNavigationBarIndex(0);
    });
    
    // Initialize all required bindings
    _initializeBindings();
  }
  
  // Initialize all required bindings
  void _initializeBindings() {
    // Initialize messaging bindings
    if (!Get.isRegistered<InboxController>()) {
      MessagingBinding().dependencies();
    }
    
    // Initialize profile bindings if not already registered
    if (!Get.isRegistered<ProfileController>()) {
      ProfileBinding().dependencies();
    }
    
    // Initialize other required bindings
    if (!Get.isRegistered<ListingController>()) {
      ListingBinding().dependencies();
    }
    
    if (!Get.isRegistered<FinanceReportController>()) {
      FinanceReportBinding().dependencies();
    }

    // // Initialize messaging bindings if not already registered
    // if (!Get.isRegistered<InboxController>()) {
    //   Get.put(InboxController(), permanent: true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    var c = Get.find<InboxController>();
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
            if (mainControl.buttonNavigationBarIndex.value == 0) {
              return MainUtils.onBackPressed(context: context);
            } else {
              mainControl.updateButtonNavigationBarIndex(0);
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
                if(value == 1) {
                  MessagingBinding().dependencies();
                }
                mainControl.updateButtonNavigationBarIndex(value);
              },
              items: [
                // BottomNavigationBarItem(icon: SvgPicture.asset(Assets.iconsHomeIconGrey,height: 25,width: 25,fit: BoxFit.fill,), label: 'Community', activeIcon: SvgPicture.asset(Assets.iconsHomeIconBlack,height: 25,width: 25,fit: BoxFit.fill,), backgroundColor: Colors.white),
                BottomNavigationBarItem(
                  icon: Icon(OwnIcons.today_icon_outlined, size: 20),
                  label: 'Today',
                  activeIcon: Icon(OwnIcons.today_icon, size: 20),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Obx(() {
                    return badges.Badge(
                      badgeContent: Text("${c.totalUnreadCount}", style: TextStyle(fontSize: 10, color: Colors.white),),
                      showBadge: c.totalUnreadCount > 0,
                      badgeStyle: badges.BadgeStyle(
                          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                          badgeColor: Colors.black54
                      ),
                      child: Icon(Icons.message_outlined, size: 20),
                    );
                  }),
                  label: 'Inbox',
                  activeIcon: Obx(() {
                      return badges.Badge(
                          badgeContent: Text("${c.totalUnreadCount}", style: TextStyle(fontSize: 10, color: Colors.white),),
                          showBadge: c.totalUnreadCount > 0,
                          badgeStyle: badges.BadgeStyle(
                            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2)
                          ),
                          child: Icon(Icons.message, size: 20));
                    }
                  ),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(OwnIcons.calender_icon, size: 18),
                  label: 'Calendar',
                  activeIcon: Icon(OwnIcons.calender_icon, size: 18),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active_outlined, size: 20),
                  label: 'Notification',
                  activeIcon: Icon(Icons.notifications_active_rounded, size: 20),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(OwnIcons.menu_icon, size: 20),
                  label: 'Menu',
                  activeIcon: Icon(OwnIcons.menu_icon, size: 20),
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
