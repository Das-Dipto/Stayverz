import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stayverz_flutter_app/core/bindings/guest_binding.dart';
import 'package:stayverz_flutter_app/core/bindings/host_binding.dart';
import 'package:stayverz_flutter_app/features/booking/bindings/assistance_booking_binding.dart';
import 'package:stayverz_flutter_app/features/booking/bindings/instant_booking_binding.dart';
import 'package:stayverz_flutter_app/features/booking/presentation/views/host_instant_booking_screen.dart';
import 'package:stayverz_flutter_app/features/assistance_service/bindings/assistance_service_binding.dart';
import 'package:stayverz_flutter_app/features/messaging/presentation/views/share_recommendation_page.dart';
import 'package:stayverz_flutter_app/services/notification_service.dart';
import 'core/bindings/main_binding.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_routes.dart';
import 'controllers/main_controller.dart';
import 'package:stayverz_flutter_app/core/middleware/auth_guard.dart';
import 'package:stayverz_flutter_app/core/middleware/connectivity_guard.dart';
import 'features/assistance_service/bindings/public_assistance_service_binding.dart';
import 'features/assistance_service/presentation/views/assistance_reservation_info_form_screen.dart';
import 'features/assistance_service/presentation/views/assistance_schedule_booking_screen.dart';
import 'features/assistance_service/presentation/views/category_wise_assistance_listing_screen.dart';
import 'features/assistance_service/presentation/views/create_assistance/create_assistance_service_screen.dart';
import 'features/assistance_service/presentation/views/public_assistance_all_review_screen.dart';
import 'features/assistance_service/presentation/views/public_assistance_details_screen.dart';
import 'features/auth/views/login_view.dart';
import 'features/auth/views/signup_screen.dart';
import 'features/booking/presentation/views/assistance/public_assistance_payment_screen.dart';
import 'features/booking/presentation/views/book_and_go_screen.dart';
import 'features/listing/bindings/listing_binding.dart';
import 'features/listing/presentation/create_listing/create_listing_screen.dart';
import 'features/messaging/data/models/chat_room_model.dart';
import 'features/notification/binding/notification_binding.dart';
import 'features/notification/presentation/view/notification_screen.dart';
import 'widgets/connectivity_listener.dart';
import 'features/splash/presentation/splash_lancher.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/messaging/presentation/views/archived_message_screen.dart';
import 'features/messaging/presentation/views/inbox_settings_screen.dart';
import 'features/user_feedback/presentation/give_user_feedback_screen.dart';
import 'features/user_feedback/bindings/user_feedback_binding.dart';
import 'services/cache/cache_manager.dart';
import 'package:stayverz_flutter_app/views/home_root/guest_bottom_navigation_bar_view.dart';
import 'package:stayverz_flutter_app/views/home_root/menu_screen/blog_details.dart';
import 'package:stayverz_flutter_app/features/blog/data/models/guest_blog_model.dart';
import 'views/home_root/host_bottom_navigation_bar_view.dart';
import 'package:stayverz_flutter_app/features/public_listings/bindings/public_listings_binding.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/public_listings_view.dart';
import 'package:stayverz_flutter_app/features/messaging/presentation/views/message_conversation_page.dart';
import 'package:stayverz_flutter_app/features/messaging/bindings/messaging_binding.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

// Global navigator key for showing bottom sheet before GetMaterialApp is ready
final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

// Global instance of MainController for easy access
late final MainController mainControl;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize HTTP overrides for development
    await GetStorage.init();
    HttpOverrides.global = MyHttpOverrides();

    await Firebase.initializeApp();
    await NotificationService().initFCM();

    // Lock orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize bindings & services
    MainBinding().dependencies();

    final prefs = await CacheManager.initAuth();

    // Get controller
    mainControl = Get.find<MainController>();

    // Restore cached session
    await _restoreAppState(prefs);

    // Decide initial route
    final String initialRoute =
        mainControl.isLogin.value
            ? (mainControl.uType.value == 'host'
                ? AppRoute.host
                : AppRoute.guest)
            : AppRoute.guest;

    // 🚀 START APP WITH SPLASH
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: globalNavigatorKey, // Assign global key for bottom sheet access
            localizationsDelegates: const [                        // 👈 add this
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      FlutterQuillLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],   
        home: SplashLauncher(initialRoute: initialRoute),
      ),
    );
  } catch (e) {
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(), // fallback splash
      ),
    );
  }
}

Future<void> _restoreAppState(SharedPreferences prefs) async {
  try {
    // Restore authentication state
    final token = prefs.getString(CacheKeys.token.name);
    final refToken = prefs.getString(CacheKeys.refreshToken.name);
    final userName = prefs.getString(CacheKeys.username.name);
    final password = prefs.getString(CacheKeys.password.name);

    if (token != null && token.isNotEmpty) {

      // Update MainController state
      mainControl.accessToken.value = token;
      mainControl.refreshToken.value = refToken ?? '';
      mainControl.isLogin.value = true;
      mainControl.username.value = userName ?? '';
      mainControl.password.value = password ?? '';

      // Restore other user data
      mainControl.userId.value = prefs.getString(CacheKeys.msisdn.name) ?? '';
      mainControl.mongouserId.value =
          prefs.getString(CacheKeys.mongoUserId.name) ?? '';
      mainControl.uType.value =
          (prefs.getString(CacheKeys.role.name) ?? '').toLowerCase();
      mainControl.teacherId.value =
          prefs.getString(CacheKeys.teacherId.name) ?? '';
      mainControl.studentId.value =
          prefs.getString(CacheKeys.studentId.name) ?? '';
      mainControl.guardianId.value =
          prefs.getString(CacheKeys.guardianId.name) ?? '';
      mainControl.profileImageUrl.value =
          prefs.getString(CacheKeys.profileImageUrl.name) ?? '';


      // Force update the UI
      mainControl.update();
    } else {
      mainControl.isLogin.value = false;
      mainControl.accessToken.value = '';
      mainControl.uType.value = '';
    }
  } catch (e) {
    // Ensure we're in a clean state if restoration fails
    mainControl.isLogin.value = false;
    mainControl.accessToken.value = '';
    mainControl.uType.value = '';
    rethrow;
  } finally {
  }
}

final List<GetPage> appPages = [
  GetPage(
    name: AppRoute.login,
    page: () => LoginView(),
    // MainBinding is already initialized, no need for separate AuthBinding
  ),
  GetPage(
    name: SignupScreen.routeName,
    page: () => SignupScreen(),
    // MainBinding is already initialized, no need for separate AuthBinding
  ),
  GetPage(
    name: AppRoute.host,
    page: () => const HostBottomNavigationBarView(),
    middlewares: [AuthGuard(), ConnectivityGuard()], // Add connectivity guard
    binding: HostBinding(),
  ),
  GetPage(
    name: AppRoute.guest,
    page: () => const GuestBottomNavigationBarView(),
    binding: GuestBinding(),
    middlewares: [ConnectivityGuard()], // Add connectivity guard
  ),
  GetPage(
    name: AppRoute.blogDetails,
    page: () {
      final blog = Get.arguments as DataItem?;
      return BlogDetails(blog: blog!);
    },
  ),
  GetPage(
    name: '/notifications',
    page: () => const NotificationScreen(),
    binding: NotificationBinding(),
  ),
  GetPage(
    name: AppRoute.publicListings,
    page: () => PublicListingsView(),
    binding: PublicListingsBinding(),
  ),
  GetPage(
    name: CreateListingScreen.route,
    page: () => CreateListingScreen(),
    binding: ListingBinding(),
  ),
  GetPage(
    name: CreateAssistanceServiceScreen.route,
    page: () => CreateAssistanceServiceScreen(),
    binding: AssistanceServiceBinding(),
  ),
  GetPage(
    name: ShareRecommendationScreen.routeName,
    page: () => ShareRecommendationScreen(),
    binding: ListingBinding(),
  ),
  // Conversation screen route - using the static route name from MessageConversationScreen
  GetPage(
    name: MessageConversationScreen.routeName,
    page: () {
      final args = Get.arguments as Map<String, dynamic>;
      // if (!args.containsKey('conversationId') || !args.containsKey('receiver') || !args.containsKey('sender')) {
      //   throw ArgumentError('Missing required arguments for conversation screen');
      // }
      return MessageConversationScreen(
        conversationId: args['conversationId'] ?? '',
        sender: args['receiver'] as dynamic?,
        //sender: args['receiver'] as User?,
        receiver: args['sender'] as dynamic?,
        // receiver: args['sender'] as User?,
        isGroupChat: args['is_group_chat'] ?? false,
        roomMembers: args['room_members'] ?? [],
        status: args['status'] ?? 'Inquiry',
      );
    },
    binding: ConversationBinding(),
  ),
  GetPage(
    name: BookAndGoScreen.routeName,
    page: () => BookAndGoScreen(),
    binding: InstantBookingBinding(),
  ),
  GetPage(
    name: HostInstantBookingScreen.routeName,
    page: () => HostInstantBookingScreen(),
    binding: InstantBookingBinding(),
  ),
  GetPage(
    name: CategoryWiseAssistanceListingScreen.route,
    page: () => CategoryWiseAssistanceListingScreen(),
    binding: PublicAssistanceServiceBinding(),
  ),
  GetPage(
    name: PublicAssistanceDetailsScreen.route,
    page: () => PublicAssistanceDetailsScreen(),
    binding: PublicAssistanceServiceBinding(),
  ),
  GetPage(
    name: PublicAssistanceAllReviewScreen.route,
    page: () => PublicAssistanceAllReviewScreen(),
    binding: PublicAssistanceServiceBinding(),
  ),
  GetPage(
    name: AssistanceScheduleBookingScreen.route,
    page: () => AssistanceScheduleBookingScreen(),
    binding: PublicAssistanceServiceBinding(),
  ),
  // GetPage(
  //   name: GiveUserFeedbackScreen.route,
  //   page: () => const GiveUserFeedbackScreen(),
  //   binding: UserFeedbackBinding(),
  // ),
  GetPage(
    name: AssistanceReservationInfoFormScreen.route,
    page: () => AssistanceReservationInfoFormScreen(),
    binding: PublicAssistanceServiceBinding(),
  ),
  GetPage(
    name: PublicAssistancePaymentScreen.route,
    page: () => PublicAssistancePaymentScreen(),
    binding: AssistanceBookingBinding(),
  ),
  GetPage(name: InboxSettingsScreen.route, page: () => InboxSettingsScreen()),
  GetPage(
    name: ArchivedMessageScreen.route,
    page: () => ArchivedMessageScreen(),
  ),
  GetPage(
    name: GiveUserFeedbackScreen.route,
    page: () => GiveUserFeedbackScreen(),
    binding: UserFeedbackBinding(),
  ),
];

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stayverz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: false,
      ),
        localizationsDelegates: const [                         // 👈 add this
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    FlutterQuillLocalizations.delegate,
  ],
  supportedLocales: const [Locale('en')],  
      builder: (context, child) {
        // Wrap entire app with connectivity listener
        return ConnectivityListener(
          child: child ?? const SizedBox.shrink(),
        );
      },
      onGenerateRoute: (RouteSettings settings) {
        final routeName =
            (settings.name == '/')
                ? initialRoute
                : (settings.name ?? initialRoute);


        Uri? uri = Uri.tryParse(routeName);
        final String path = uri?.path ?? routeName;

        final arguments = settings.arguments ?? uri?.queryParameters;
        // Handle referral deep links: /r/<code>
        if (path.startsWith('/r/') && path.length > 3) {
          final referralCode = path.substring(3); // Extract code after "/r/"

          // Store the referral code in MainController
          try {
            final mainController = Get.find<MainController>();
            mainController.deepLinkReferer = referralCode;
          } catch (e) {}

          // Navigate to splash screen which can handle the referral logic
          final splashPage = appPages.firstWhere(
            (p) => p.name == SignupScreen.routeName,
          );
          return GetPageRoute(
            settings: RouteSettings(
              name: SignupScreen.routeName,
              arguments: {'referralCode': referralCode},
            ),
            page: splashPage.page,
            binding: splashPage.binding,
            bindings: splashPage.bindings,
            middlewares: splashPage.middlewares,
            transition: splashPage.transition,
            transitionDuration:
                splashPage.transitionDuration ??
                const Duration(milliseconds: 300),
          );
        }

        final page = appPages.firstWhere(
          (p) => p.name == path,
          orElse: () {
            return appPages.firstWhere((p) => p.name == AppRoute.guest);
          },
        );

        return GetPageRoute(
          settings: RouteSettings(name: path, arguments: arguments),
          page: page.page,
          binding: page.binding,
          bindings: page.bindings,
          middlewares: page.middlewares,
          transition: page.transition,
          transitionDuration:
              page.transitionDuration ?? const Duration(milliseconds: 300),
        );
      },
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      defaultTransition: Transition.fadeIn,
      // getPages: appPages, // Disabled: using onGenerateRoute exclusively to ensure middlewares/bindings apply to deep links
      initialBinding: MainBinding(),
    );
  }
}

// Hello I am Tamim