class AppImages {

  static String bkash = 'bkash'.png;
  static String nagad = 'nagad_logo'.png;
  static String rocket = 'rocket'.png;
  static String subscriptionSuccessMark = 'subscription_success_check_mark'.png;
  static String wpfBankCards = 'wpf_bank-cards'.png;

  //bottom nav icon
  static Map<String, String> get  homeIcon  => <String, String> {
    'un_selected': 'un_selected_home_icon'.svg,
    'selected': 'selected_home_icon'.svg,

  };

  static Map<String, String>  get cellRingIcon  => <String, String> {
    'un_selected': 'un_selected_call_ring_icon'.svg,
    'selected': 'selected_call_ring_icon'.svg,

  };
  static Map<String, String>  get doctorsIcon  => <String, String> {
    'un_selected': 'un_selected_doctor_icon'.svg,
    'selected': 'selected_doctor_icon'.svg,

  };

  static Map<String, String>  get subscribeIcon  => <String, String> {
    'un_selected': 'un_selected_subscribe_icon'.svg,
    'selected': 'selected_subscribe_icon'.svg,

  };
  static Map<String, String>  get moreIcon  => <String, String> {
    'un_selected': 'un_selected_more_icon'.svg,
    'selected': 'selected_more_icon'.svg,

  };

  //bmi icon

  static Map<String, String>  get bmiMaleSign  => <String, String> {
    'selected': 'selected_male_sign'.png,
    'un_selected': 'un_selected_male_sign'.png,
  };
  static Map<String, String>  get bmiFeMaleSign  => <String, String> {
    'selected': 'selected_female_sign'.png,
    'un_selected': 'un_selected_female_sign'.png,
  };
}

extension on String {
  String get svg => 'assets/icons/$this.svg';
}
extension on String {
  String get png => 'assets/images/$this.png';
}


// Hello I am Tamim