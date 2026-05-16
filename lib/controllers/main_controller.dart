import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:stayverz_flutter_app/features/auth/controllers/auth_controller.dart';
import 'package:stayverz_flutter_app/features/auth/models/user_model.dart';
import 'package:stayverz_flutter_app/features/auth/repositories/auth_repository_interface.dart';
import 'package:stayverz_flutter_app/services/cache/cache_manager.dart';
import 'package:stayverz_flutter_app/features/messaging/data/services/websocket_service.dart'
    as ws;

class MainController extends GetxController with WidgetsBindingObserver {
  final AuthRepositoryInterface _authRepository;

  MainController({required AuthRepositoryInterface authRepository})
    : _authRepository = authRepository {
    // Initialize timezone data
    tzdata.initializeTimeZones();

    // Initialize FlutterLocalNotificationsPlugin
    _initNotifications();

    // Initialize connectivity
    _initConnectivity();
  }

  final Rxn<UserModel> _user = Rxn<UserModel>();
  UserModel? get user => _user.value;
  void setUser(UserModel? user) => _user.value = user;

  // Initialize notifications
  void _initNotifications() {
    // Your notification initialization code here
  }

  // Initialize connectivity
  void _initConnectivity() {
    // Your connectivity initialization code here
  }

  final RxBool _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;
  void setLoggedIn(bool value) => _isLoggedIn.value = value;

  RxBool isLogin = RxBool(false);
  RxBool isSubscribe = RxBool(false);
  RxString accessToken = RxString('');
  RxString refreshToken = RxString('');
  RxString userId = RxString('');
  RxString userName = RxString('');
  RxString teacherId = RxString('');
  RxString guardianId = RxString('');
  RxString email = RxString('');
  RxString username = RxString('');
  RxString password = RxString('');
  RxString profileImageUrl = RxString('');
  RxString mongouserId = RxString('');

  RxString studentId = RxString('');
  RxString deviceToken = RxString('');
  RxString roleName = RxString('');
  RxString uType = RxString(''); // 'host' or 'guest'
  RxBool missCallStatus = false.obs;
  RxBool isInternetAvailable = RxBool(false);
  RxInt buttonNavigationBarIndex = RxInt(2);
  RxInt tabBarIndex = RxInt(0);
  RxInt examTabBarIndex = RxInt(0);
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  String? deepLinkReferer;

  /// Updates user data after successful login
  Future<void> updateUserData(
    String id,
    String token,
    String userType, {
    String? name,
    String? email,
    String? profileImage,
    String? refreshTokens,
    String? mongoUserId,
  }) async {
    userId.value = id;
    accessToken.value = token;
    uType.value = userType;
    refreshToken.value = refreshTokens ?? '';
    isLogin.value = true;

    if (name != null) userName.value = name;
    if (email != null) this.email.value = email;
    if (profileImage != null) profileImageUrl.value = profileImage;
    if (mongoUserId != null) mongouserId.value = mongoUserId;

    // Cache the user data
    CacheManager.setRoleName(userType);
    CacheManager.setToken(token);

    // Cache refresh token if provided
    if (refreshToken.isNotEmpty) {
      CacheManager.setRefreshToken(refreshTokens ?? '');
    }

    // Initialize WebSocket connections for real-time notifications
    await _initializeWebSocketConnections();
  }

  @override
  void onInit() async {
    super.onInit();

    // Initialize AuthController with AuthRepositoryInterface
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(_authRepository),
        fenix: true,
      );
    }

    // Add app lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // Restore session if token exists
    await _restoreSession();

    // Initialize WebSocket connections regardless of login status
    // This ensures global notifications work even when not logged in
    await _initializeWebSocketConnections();

    // Listen to authentication state changes
    isLogin.listen((isLoggedIn) async {
      if (!isLoggedIn) {
        await clearUserData();
      }
    });

    email.listen((value) {
      // Cache email if needed
      // Example: if (value.isNotEmpty) CacheManager.setUserEmail(value);
    });

    accessToken.listen((value) async {
      // Cache token
      if (value.isNotEmpty) {
        await CacheManager.setToken(value);
      }
    });

    userId.listen((value) async {
      if (value.isNotEmpty) {
        await CacheManager.setUserId(value);
      }
    });

    // Handle user type changes
    uType.listen((type) async {
      if (type.isNotEmpty) {
        await CacheManager.setRoleName(type);
      }
    });
  }

  @override
  void onClose() {
    // Remove app lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // Always initialize WebSocket connections on resume for global notifications
        _initializeWebSocketConnections();
        break;
      case AppLifecycleState.paused:
        // Keep connections alive but could add logic to reduce activity
        break;
      case AppLifecycleState.detached:
        _disconnectWebSocketConnections();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Restores user session from cache if token exists
  Future<void> _restoreSession() async {
    try {
      final token = await CacheManager.getAuthToken();
      final refreshToken = await CacheManager.getRefreshToken();

      if (token?.isNotEmpty ?? false) {
        // Restore user data from cache
        userId.value = await CacheManager.getCurrentUserId() ?? '';
        uType.value = CacheManager.roleName;
        accessToken.value = token!;
        isLogin.value = true;

        // Initialize WebSocket connections for restored session
        await _initializeWebSocketConnections();
      }
    } catch (e) {
      await clearUserData();
    }
  }

  /// Clears all user data and cache
  Future<void> clearUserData() async {
    // Disconnect WebSocket connections before clearing user data
    await _disconnectWebSocketConnections();

    // Clear reactive variables
    accessToken.value = '';
    userId.value = '';
    uType.value = '';
    userName.value = '';
    email.value = '';
    profileImageUrl.value = '';

    // Clear cache
    await CacheManager.removeToken();
    await CacheManager.removeRefreshToken(); // Also remove refresh token
    await CacheManager.removeUserId();
    // Consider removing other cached items like email, username, profileImage if set
    // await CacheManager.removeUserEmail();
    // await CacheManager.removeUserName();
    // await CacheManager.removeProfileImageUrl();

    isLogin.value = false;

  }

  /// Initializes WebSocket connections for real-time notifications
  Future<void> _initializeWebSocketConnections() async {
    try {
      final webSocketService = Get.find<ws.WebSocketService>();
      if (accessToken.value.isNotEmpty && isLogin.value) {
        // Initialize WebSocket service with auth token and connect to all channels
        await webSocketService.initialize(
          accessToken.value,
          connectStats: true,
          connectGlobal: true,
        );
      } else {
        // Initialize WebSocket service without auth token but connect to global channels for notifications
        await webSocketService.initialize(
          '', // Empty token for unauthenticated connections
          connectStats: false, // Don't connect to stats without auth
          connectGlobal: true, // Connect to global for notifications
        );
      }
    } catch (e) {
    }
  }

  /// Disconnects WebSocket connections
  Future<void> _disconnectWebSocketConnections() async {
    try {
      if (Get.isRegistered<ws.WebSocketService>()) {
        final webSocketService = Get.find<ws.WebSocketService>();
        await webSocketService.disconnect();
      }
    } catch (e) {
    }
  }

  void setPreloader({int? delay}) async => Future.delayed(
    delay == null ? Duration.zero : Duration(seconds: delay),
    () async {
      await _waitForInitialization();

      ///code
      // var result = await HttpRequests().get(ApiRoutes.allPracticeExams);
      // print("the result :$result");
      // FlutterNativeSplash.remove();
    },
  );

  void resetTabIndex() {
    tabBarIndex.value = 0;
  }

  void updateButtonNavigationBarIndex(int index) {
    buttonNavigationBarIndex.value = index;
  }

  Future<void> _waitForInitialization() async {
    tzdata.initializeTimeZones();
    // await NetworkConnectionUtils.init();
    // await Get.put(ProfileController()).fetchProfile(null);
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // LocalNotificationService.init();
    // await LogEventUtils.init();
  }
}

// Hello I am Tamim