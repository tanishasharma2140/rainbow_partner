class ApiUrl {
  static const String baseUrl ="https://admin.rainbowsenterprises.com/api/";
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
  static const String zoneCitiesUrl ="${baseUrl}zone_cities";

  /// CabDriver

  static const String vehiclesUrl ="${baseUrl}vehicles";
  static const String driverRegisterUrl ="${baseUrl}driver_register";
  static const String getBrandUrl ="${baseUrl}get-brand";
  static const String getVehicleModelUrl ="${baseUrl}get-model";
  static const String vehicleColorsUrl ="${baseUrl}colors";
  static const String driverProfileUrl ="${baseUrl}driver_profile";
  static const String driverOnlineUrl ="${baseUrl}driver-online-status";
  static const String driverCanDiscountUrl ="${baseUrl}driver-can-discount";
  static const String driverOfferUrl ="${baseUrl}driver-offer";
  static const String deleteExpiredUrl ="${baseUrl}delete-expired-orders";
  static const String changeCabOrderStatusUrl ="${baseUrl}change-cab-order-status";
  static const String driverTransactionUrl ="${baseUrl}driver_transactions";
  static const String cabEarningUrl ="${baseUrl}cab-earning";
  static const String cabHistoryUrl ="${baseUrl}cab-history";
  static const String activeRideUrl ="${baseUrl}active-ride";
  static const String driverIgnoreOrderUrl ="${baseUrl}driver-ignore-ride-order";
  static const String driverWithdrawRequestUrl ="${baseUrl}driver-withdraw-request";
  static const String driverWithdrawHistoryUrl ="${baseUrl}driver-withdraw-history";
  static const String acceptLaterRideUrl ="${baseUrl}accept-later-ride";
  static const String cabCancelReasonUrl ="${baseUrl}cab-cancel-reasons?";






  static const String sendOtpUrl ="https://admin.rainbowsenterprises.com/api/send_otp?mode=live&digit=4&mobile=";
  static const String verifyOtpUrl ="https://admin.rainbowsenterprises.com/api/verifyotp?mobile=";
  static const String partnerNotificationUrl ="${baseUrl}user_notification/";
  static const String policyUrl ="${baseUrl}policy/";
  static const String helpSupportUrl ="${baseUrl}help-support";

}