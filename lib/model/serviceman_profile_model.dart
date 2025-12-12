class ServicemanProfileModel {
  bool? success;
  String? message;
  Data? data;
  dynamic errors;

  ServicemanProfileModel({this.success, this.message, this.data, this.errors});

  ServicemanProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['errors'] = errors;
    return data;
  }
}

class Data {
  dynamic id;
  dynamic wallet;
  dynamic dueWallet;
  dynamic firstName;
  dynamic lastName;
  dynamic email;
  dynamic address;
  dynamic mobile;
  dynamic serviceCategory;
  dynamic aadhaarFront;
  dynamic aadhaarBack;
  dynamic skillStatus;
  dynamic experienceCertificate;
  dynamic deviceId;
  dynamic fcmToken;
  dynamic formStatus;
  dynamic rejectReasion;
  dynamic loginStatus;
  dynamic onlineStatus;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic currentLatitude;
  dynamic currentLongitude;
  dynamic profilePhoto;
  dynamic serviceName;

  Data(
      {this.id,
        this.wallet,
        this.dueWallet,
        this.firstName,
        this.lastName,
        this.email,
        this.address,
        this.mobile,
        this.serviceCategory,
        this.aadhaarFront,
        this.aadhaarBack,
        this.skillStatus,
        this.experienceCertificate,
        this.deviceId,
        this.fcmToken,
        this.formStatus,
        this.rejectReasion,
        this.loginStatus,
        this.onlineStatus,
        this.createdAt,
        this.updatedAt,
        this.currentLatitude,
        this.currentLongitude,
        this.profilePhoto,
        this.serviceName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wallet = json['wallet'];
    dueWallet = json['due_wallet'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    address = json['address'];
    mobile = json['mobile'];
    serviceCategory = json['service_category'];
    aadhaarFront = json['aadhaar_front'];
    aadhaarBack = json['aadhaar_back'];
    skillStatus = json['skill_status'];
    experienceCertificate = json['experience_certificate'];
    deviceId = json['device_id'];
    fcmToken = json['fcm_token'];
    formStatus = json['form_status'];
    rejectReasion = json['reject_reasion'];
    loginStatus = json['login_status'];
    onlineStatus = json['online_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    currentLatitude = json['current_latitude'];
    currentLongitude = json['current_longitude'];
    profilePhoto = json['profile_photo'];
    serviceName = json['service_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wallet'] = wallet;
    data['due_wallet'] = dueWallet;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['address'] = address;
    data['mobile'] = mobile;
    data['service_category'] = serviceCategory;
    data['aadhaar_front'] = aadhaarFront;
    data['aadhaar_back'] = aadhaarBack;
    data['skill_status'] = skillStatus;
    data['experience_certificate'] = experienceCertificate;
    data['device_id'] = deviceId;
    data['fcm_token'] = fcmToken;
    data['form_status'] = formStatus;
    data['reject_reasion'] = rejectReasion;
    data['login_status'] = loginStatus;
    data['online_status'] = onlineStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['current_latitude'] = currentLatitude;
    data['current_longitude'] = currentLongitude;
    data['profile_photo'] = profilePhoto;
    data['service_name'] = serviceName;
    return data;
  }
}
