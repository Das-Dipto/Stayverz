import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {

  static SharedPreferences? _pref;
  
  /// Synchronous access to SharedPreferences
  static SharedPreferences? get prefs => _pref;

  static bool _isInitialized = false;
  
  static Future<SharedPreferences> initAuth([Function(SharedPreferences)? onComplete]) async {
    if (!_isInitialized) {
      _pref = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
    
    if (onComplete != null) {
      onComplete(_pref!);
    }
    
    return _pref!;
  }


  static Future<String> get getToken async {
    await _ensureInitialized();
    return _getFromCache<String>(CacheKeys.token.name);
  }
  
  static Future<void> _ensureInitialized() async {
    _pref ??= await SharedPreferences.getInstance();
  }
  static String get userId => _getFromCache<String>(CacheKeys.userId.name);
  static bool get openAgain => _getFromCache<bool>(CacheKeys.firstOpen.name);
  static String get languageCode => _getFromCache<String>(CacheKeys.languageCode.name);
  static String get countryCode => _getFromCache<String>(CacheKeys.countryCode.name);
  static String get roleName => _getFromCache<String>(CacheKeys.role.name);
  static String get selectedOrgId => _getFromCache<String>(CacheKeys.organizationId.name);
  static String get teacherId => _getFromCache<String>(CacheKeys.teacherId.name);
  static String get guardianId => _getFromCache<String>(CacheKeys.guardianId.name);
  static String get studentId => _getFromCache<String>(CacheKeys.studentId.name);
  static String get profileImageUrl => _getFromCache<String>(CacheKeys.profileImageUrl.name);
  static String get username => _getFromCache<String>(CacheKeys.username.name);
  static String get password => _getFromCache<String>(CacheKeys.password.name);
  static String get mongoUserId => _getFromCache<String>(CacheKeys.mongoUserId.name);
  static Future<bool> setToken(String tokenValue) async => await _saveToCache(CacheKeys.token.name, tokenValue);
  static Future<bool> setRefreshToken(String refreshTokenValue) async => await _saveToCache(CacheKeys.refreshToken.name, refreshTokenValue);
  static Future<bool> setUserId(String userId) async => await _saveToCache(CacheKeys.userId.name, userId);
  // static Future<bool> seteacherId(String msisdnValue) async => await _saveToCache(CacheKeys.msisdn.name, msisdnValue);
  static Future<bool> setFirstOpen() async => await _saveToCache(CacheKeys.firstOpen.name, true);
  static Future<bool> setLanguageCode(String languageCodeValue) async => await _saveToCache(CacheKeys.languageCode.name, languageCodeValue);
  static Future<bool> setCountryCode(String countryCodeValue) async => await _saveToCache(CacheKeys.countryCode.name, countryCodeValue);
  static Future<bool> setRoleName(String role) async => await _saveToCache(CacheKeys.role.name, role);
  static Future<bool> setSelectedOrgId(String org) async => await _saveToCache(CacheKeys.organizationId.name, org);
  static Future<bool> setTeacherId(String org) async => await _saveToCache(CacheKeys.teacherId.name, org);
  static Future<bool> setGuardianId(String org) async => await _saveToCache(CacheKeys.guardianId.name, org);
  static Future<bool> setProfileImageUrl(String org) async => await _saveToCache(CacheKeys.profileImageUrl.name, org);
  static Future<bool> setStudentId(String org) async => await _saveToCache(CacheKeys.studentId.name, org);
  static Future<bool> setUserName(String username) async => await _saveToCache(CacheKeys.username.name, username);
  static Future<bool> setPassword(String password) async => await _saveToCache(CacheKeys.password.name, password);
  static Future<bool> setMongoUserId(String id) async => await _saveToCache(CacheKeys.mongoUserId.name, id);

  static Future<bool> removeToken() async => _remove(CacheKeys.token.name);
  static Future<bool> removeRefreshToken() async => _remove(CacheKeys.refreshToken.name);
  static Future<bool> removeUserId() async => _remove(CacheKeys.userId.name);

  /// Gets the current user ID from cache
  static Future<String?> getCurrentUserId() async {
    await _ensureInitialized();
    return _pref?.getString(CacheKeys.userId.name);
  }
  
  /// Gets the current auth token from cache
  static Future<String?> getAuthToken() async {
    await _ensureInitialized();
    return _pref?.getString(CacheKeys.token.name);
  }
  
  /// Gets the current refresh token from cache
  // For testing: set this flag to true to use a test refresh token
  static bool useTestRefreshToken = true;
  
  static Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    
    // Return cached token if it exists
    final cachedToken = _pref?.getString(CacheKeys.refreshToken.name);
    if (cachedToken != null && cachedToken.isNotEmpty) {
      return cachedToken;
    }
    
    // If no cached token and test mode is enabled, return test token
    if (useTestRefreshToken) {
      return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjIxMjEyMTIxMjEzX2d1ZXN0IiwiZXhwIjoxNzUwMjI3NTk3LCJ0b2tlbl90eXBlIjoicmVmcmVzaCJ9.x1EqGevl27ZMjVjQyBbeB-106urpXVXq5YVwDsKE7A0';
    }
    
    return null;
  }
  static Future<bool> removeAll() async => _pref!.clear();

  static Future<bool> _remove(String key) async {
    if(_pref == null) {
      return false;
    }
    if(!_pref!.containsKey(key)) {
      return false;
    }
    return await _pref!.remove(key);
  }

  static dynamic _getFromCache<T>(String key) {
    if(_pref == null) return '';
    if(T == int) {
      return  _pref!.getInt(key) ?? 0;
    }else if(T == bool) {
      return  _pref!.getBool(key) ?? false;
    }
    return  _pref!.getString(key) ?? '';
  }

  static Future<bool> _saveToCache(String key, dynamic value) async {

    if(_pref == null || value == null) return false;
    if(value is bool) {
      return await _pref!.setBool(key, value);
    }else if(value is int) {
      return await _pref!.setInt(key, value);
    }
    return await _pref!.setString(key, value);
  }

}

enum CacheKeys {
  token,
  refreshToken,
  firstOpen,
  msisdn,
  languageCode,
  countryCode,
  role,
  organizationId,
  teacherId,
  guardianId,
  studentId,
  profileImageUrl,
  userId,
  username,
  password,
  mongoUserId
}

// Hello I am Tamim