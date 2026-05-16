class ApiRoutes {

  // Base URLs
  static const String baseURL = 'https://apix.stayverz.com';
  //static const String baseURL = 'http://192.168.8.156:8000';
  static const String assistanceBaseURL = "https://api-assistance.stayverz.com";
  static const String messagingBaseURL = "https://api-chat.stayverz.com";
  static String get chatWebSocketUrl => 'wss://api-chat.stayverz.com/api/v1/ws/chat/';

  // Dev Base URLs
  // static const String baseURL = 'https://btayverz.divergenttechbd.com';
  // static const String assistanceBaseURL = "https://as-stayverz.divergenttechbd.com";
  // static const String messagingBaseURL = "https://ctayverz.divergenttechbd.com";
  // static String get chatWebSocketUrl => 'wss://ctayverz.divergenttechbd.com/api/v1/ws/chat/';
  
  // API base URLs
  static const String apiBaseURL = "$baseURL/api/v1";
  static const String messagingApiBaseURL = "$messagingBaseURL/api/v1";
  static const String archivedChatList = '$messagingBaseURL/api/v1/chat/archive/archived/';
  
  // WebSocket endpoints
  static String getChatRoomWebSocketUrl(String roomId, String token) => '${chatWebSocketUrl}user/$roomId/?token=$token';
  static String chatGlobalRoomWebSocketUrl(String authToken) => '${chatWebSocketUrl}user/user-global-room/?token=$authToken';
  static String chatStatsWebSocketUrl(String authToken) => '${chatWebSocketUrl}user/chat-stat/?token=$authToken';
  
  // Auth endpoints
  static const String login = "$apiBaseURL/accounts/login/";
  static const String register = "$apiBaseURL/accounts/register/";
  
  // User endpoints
  static const String getUser = "$apiBaseURL/accounts/user/profile/";
  static const String getProfile = "/accounts/user/profile/";
  static const String getUserNotifications = '/notifications/user/notifications/';
  static const String referLInk = "$apiBaseURL/referrals/my-link/";

  // Organization endpoints
  static const String organizations = "$apiBaseURL/organizations/";
  static const String requestJoinOrganization = "$apiBaseURL/organizations/join/";
  
  // Helper methods for dynamic URLs
  static String getSingleUser(String id) => "$apiBaseURL/accounts/user/$id/";
  static String updateUser(String id) => "$apiBaseURL/accounts/user/$id/update/";
  static String organizationStudents(String orgId) => "$apiBaseURL/organizations/$orgId/students/";
  static String studentProfile(String studentId) => "$apiBaseURL/students/$studentId/profile/";
  static String archiveChat = "$messagingBaseURL/api/v1/chat/archive";

  // Posts endpoints
  static const String posts = "$apiBaseURL/posts";
  
  // Messaging endpoints
  static String get chatUserRooms => '$messagingApiBaseURL/chat/user/rooms/';
  static String get quickReply => '$apiBaseURL/quick_reply/';
  static String chatUserRoomMessages(String conversationId) => "${ApiRoutes.messagingApiBaseURL}/chat/user/rooms/$conversationId/";
  
  // Helper to build query parameters
  static String buildUrlWithParams(String baseUrl, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return baseUrl;
    
    final uri = Uri.parse(baseUrl);
    return uri.replace(queryParameters: params).toString();
  }

  // Referral
  static String getReferralCode(String code) => '$baseURL/referral-code/$code/';


  // assistance
  static String get assistanceSearch => '$assistanceBaseURL/assistance/search';
  static String get postAssistanceBookings => '$assistanceBaseURL/bookings';
  static String get getAssistanceCategory => '$assistanceBaseURL/assistance/categories';
  static String get getAssistanceCancellationPolices => '$assistanceBaseURL/assistance/cancellation-polices';
  static String get getAssistanceHostList => '$assistanceBaseURL/assistance-host/list/';
  static String get postAssistancePaymentsInitiateSslcommerz => '$assistanceBaseURL/payments/initiate/sslcommerz';
  static String get postAssistanceCreateAssistance => '$assistanceBaseURL/assistance/create-assistance';
  static String getAssistanceDetailsById (String id)=> '$assistanceBaseURL/assistance/details/$id';
  static String getAssistancePublicDetailsById (String id)=> '$assistanceBaseURL/assistance/public-details/$id';
  static String pathAssistanceListingDetailsById (String id)=> '$assistanceBaseURL/assistance/listings/$id/';
  static String getAssistanceListingCalendarById (String id)=> '$assistanceBaseURL/assistance/listing-calendars/$id/';

}



// Hello I am Tamim