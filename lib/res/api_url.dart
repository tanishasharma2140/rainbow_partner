class ApiUrl {
  static const String baseUrl ="https://yoyomiles.codescarts.com/api/";
  /// ServiceMan
  static const String servicemanLoginUrl ="${baseUrl}serviceman_login";
  static const String servicemanRegisterUrl ="${baseUrl}serviceman_register";
  static const String servicemanProfileUrl ="${baseUrl}serviceman_profile";
  static const String onlineStatusUrl ="${baseUrl}online_status";
  static const String addBankDetailUrl ="${baseUrl}add_bank_details";
  static const String getBankDetailUrl ="${baseUrl}get_bank_details";
  static const String serviceBankEditUrl ="${baseUrl}bank_update_request";
  static const String serviceBankUpdateUrl ="${baseUrl}get_bank_update_request";
  static const String categoriesUrl ="${baseUrl}categories";


  static const String sendOtpUrl ="https://otp.fctechteam.org/send_otp.php?mode=test&digit=4&mobile=";
  static const String verifyOtpUrl ="https://otp.fctechteam.org/verifyotp.php?mobile=";
}