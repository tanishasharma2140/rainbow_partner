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
  static const String competeBookingUrl ="${baseUrl}my-orders";
  static const String jobRequestUrl ="${baseUrl}job_request";
  static const String citiesUrl ="${baseUrl}cities";
  static const String acceptOrderUrl ="${baseUrl}serviceman/accept-order";
  static const String changeOrderStatusUrl ="${baseUrl}change_order_status";
  static const String transactionHistoryUrl ="${baseUrl}serviceman_transaction";
  static const String servicemanWithdrawUrl ="${baseUrl}serviceman-withdraw-request";
  static const String servicemanWithdrawHistoryUrl ="${baseUrl}serviceman-withdraw-history";
  static const String paymentUrl ="${baseUrl}payment";
  static const String callbackServiceUrl ="${baseUrl}callback_service";
  static const String reviewUrl ="${baseUrl}serviceman-ratings";
  static const String servicemanEarningUrl ="${baseUrl}serviceman-earnings";
  static const String serviceInfoUrl ="${baseUrl}serviceman-service-info";

  /// CabDriver

  static const String vehiclesUrl ="${baseUrl}vehicles";
  static const String driverRegisterUrl ="${baseUrl}driver_register";
  static const String getBrandUrl ="${baseUrl}get-brand";
  static const String getVehicleModelUrl ="${baseUrl}get-model";
  static const String vehicleColorsUrl ="${baseUrl}colors";
  static const String driverProfileUrl ="${baseUrl}driver_profile";




  static const String sendOtpUrl ="https://otp.fctechteam.org/send_otp.php?mode=test&digit=4&mobile=";
  static const String verifyOtpUrl ="https://otp.fctechteam.org/verifyotp.php?mobile=";
}