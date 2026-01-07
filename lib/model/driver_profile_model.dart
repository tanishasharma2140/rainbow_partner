class DriverProfileModel {
  String? message;
  Data? data;

  DriverProfileModel({this.message, this.data});

  DriverProfileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic wallet;
  dynamic dueWallet;
  dynamic platformType;
  dynamic vehicleType;
  dynamic vehicleName;
  dynamic firstName;
  dynamic lastName;
  dynamic mobile;
  dynamic dateOfBirth;
  dynamic profilePhoto;
  dynamic deviceId;
  dynamic fcmToken;
  dynamic onlineStatus;
  dynamic personalInformationStatus;
  dynamic personalInformationRejectReason;
  dynamic driverLicenceStatus;
  dynamic driverLicenceRejectReason;
  dynamic driverLicenceNumber;
  dynamic licenceValidityDate;
  dynamic driverLicenceFront;
  dynamic driverLicenceBack;
  dynamic aadhaarPanStatus;
  dynamic aadhaarPanRejectReason;
  dynamic aadhaarNumber;
  dynamic panCardNumber;
  dynamic aadhaarFront;
  dynamic aadhaarBack;
  dynamic panCardFront;
  dynamic panCardBack;
  dynamic requiredCertificatesStatus;
  dynamic requiredCertificatesRejectReason;
  dynamic fitnessCertificate;
  dynamic pollutionCertificate;
  dynamic insuranceCertificate;
  dynamic policeCertificate;
  dynamic vehicleInfoStatus;
  dynamic vehicleInfoRejectReason;
  dynamic brandId;
  dynamic brandName;
  dynamic modelId;
  dynamic modelName;
  dynamic vehicleColor;
  dynamic vehiclePlateNumber;
  dynamic vehicleProductionYear;
  dynamic vehiclePhoto;
  dynamic vehicleDocumentsStatus;
  dynamic vehicleDocumentsRejectReason;
  dynamic vehiclePermitPartA;
  dynamic vehiclePermitPartB;
  dynamic vehicleRegistrationFront;
  dynamic vehicleRegistrationBack;
  dynamic currentLatitude;
  dynamic currentLongitude;
  dynamic createdAt;
  dynamic updatedAt;

  Data(
      {this.id,
        this.wallet,
        this.dueWallet,
        this.platformType,
        this.vehicleType,
        this.vehicleName,
        this.firstName,
        this.lastName,
        this.mobile,
        this.dateOfBirth,
        this.profilePhoto,
        this.deviceId,
        this.fcmToken,
        this.onlineStatus,
        this.personalInformationStatus,
        this.personalInformationRejectReason,
        this.driverLicenceStatus,
        this.driverLicenceRejectReason,
        this.driverLicenceNumber,
        this.licenceValidityDate,
        this.driverLicenceFront,
        this.driverLicenceBack,
        this.aadhaarPanStatus,
        this.aadhaarPanRejectReason,
        this.aadhaarNumber,
        this.panCardNumber,
        this.aadhaarFront,
        this.aadhaarBack,
        this.panCardFront,
        this.panCardBack,
        this.requiredCertificatesStatus,
        this.requiredCertificatesRejectReason,
        this.fitnessCertificate,
        this.pollutionCertificate,
        this.insuranceCertificate,
        this.policeCertificate,
        this.vehicleInfoStatus,
        this.vehicleInfoRejectReason,
        this.brandId,
        this.brandName,
        this.modelId,
        this.modelName,
        this.vehicleColor,
        this.vehiclePlateNumber,
        this.vehicleProductionYear,
        this.vehiclePhoto,
        this.vehicleDocumentsStatus,
        this.vehicleDocumentsRejectReason,
        this.vehiclePermitPartA,
        this.vehiclePermitPartB,
        this.vehicleRegistrationFront,
        this.vehicleRegistrationBack,
        this.currentLatitude,
        this.currentLongitude,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wallet = json['wallet'];
    dueWallet = json['due_wallet'];
    platformType = json['platform_type'];
    vehicleType = json['vehicle_type'];
    vehicleName = json['vehicle_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    dateOfBirth = json['date_of_birth'];
    profilePhoto = json['profile_photo'];
    deviceId = json['device_id'];
    fcmToken = json['fcm_token'];
    onlineStatus = json['online_status'];
    personalInformationStatus = json['personal_information_status'];
    personalInformationRejectReason =
    json['personal_information_reject_reason'];
    driverLicenceStatus = json['driver_licence_status'];
    driverLicenceRejectReason = json['driver_licence_reject_reason'];
    driverLicenceNumber = json['driver_licence_number'];
    licenceValidityDate = json['licence_validity_date'];
    driverLicenceFront = json['driver_licence_front'];
    driverLicenceBack = json['driver_licence_back'];
    aadhaarPanStatus = json['aadhaar_pan_status'];
    aadhaarPanRejectReason = json['aadhaar_pan_reject_reason'];
    aadhaarNumber = json['aadhaar_number'];
    panCardNumber = json['pan_card_number'];
    aadhaarFront = json['aadhaar_front'];
    aadhaarBack = json['aadhaar_back'];
    panCardFront = json['pan_card_front'];
    panCardBack = json['pan_card_back'];
    requiredCertificatesStatus = json['required_certificates_status'];
    requiredCertificatesRejectReason =
    json['required_certificates_reject_reason'];
    fitnessCertificate = json['fitness_certificate'];
    pollutionCertificate = json['pollution_certificate'];
    insuranceCertificate = json['insurance_certificate'];
    policeCertificate = json['police_certificate'];
    vehicleInfoStatus = json['vehicle_info_status'];
    vehicleInfoRejectReason = json['vehicle_info_reject_reason'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    modelId = json['model_id'];
    modelName = json['model_name'];
    vehicleColor = json['vehicle_color'];
    vehiclePlateNumber = json['vehicle_plate_number'];
    vehicleProductionYear = json['vehicle_production_year'];
    vehiclePhoto = json['vehicle_photo'];
    vehicleDocumentsStatus = json['vehicle_documents_status'];
    vehicleDocumentsRejectReason = json['vehicle_documents_reject_reason'];
    vehiclePermitPartA = json['vehicle_permit_part_a'];
    vehiclePermitPartB = json['vehicle_permit_part_b'];
    vehicleRegistrationFront = json['vehicle_registration_front'];
    vehicleRegistrationBack = json['vehicle_registration_back'];
    currentLatitude = json['current_latitude'];
    currentLongitude = json['current_longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['wallet'] = this.wallet;
    data['due_wallet'] = this.dueWallet;
    data['platform_type'] = this.platformType;
    data['vehicle_type'] = this.vehicleType;
    data['vehicle_name'] = this.vehicleName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['date_of_birth'] = this.dateOfBirth;
    data['profile_photo'] = this.profilePhoto;
    data['device_id'] = this.deviceId;
    data['fcm_token'] = this.fcmToken;
    data['online_status'] = this.onlineStatus;
    data['personal_information_status'] = this.personalInformationStatus;
    data['personal_information_reject_reason'] =
        this.personalInformationRejectReason;
    data['driver_licence_status'] = this.driverLicenceStatus;
    data['driver_licence_reject_reason'] = this.driverLicenceRejectReason;
    data['driver_licence_number'] = this.driverLicenceNumber;
    data['licence_validity_date'] = this.licenceValidityDate;
    data['driver_licence_front'] = this.driverLicenceFront;
    data['driver_licence_back'] = this.driverLicenceBack;
    data['aadhaar_pan_status'] = this.aadhaarPanStatus;
    data['aadhaar_pan_reject_reason'] = this.aadhaarPanRejectReason;
    data['aadhaar_number'] = this.aadhaarNumber;
    data['pan_card_number'] = this.panCardNumber;
    data['aadhaar_front'] = this.aadhaarFront;
    data['aadhaar_back'] = this.aadhaarBack;
    data['pan_card_front'] = this.panCardFront;
    data['pan_card_back'] = this.panCardBack;
    data['required_certificates_status'] = this.requiredCertificatesStatus;
    data['required_certificates_reject_reason'] =
        this.requiredCertificatesRejectReason;
    data['fitness_certificate'] = this.fitnessCertificate;
    data['pollution_certificate'] = this.pollutionCertificate;
    data['insurance_certificate'] = this.insuranceCertificate;
    data['police_certificate'] = this.policeCertificate;
    data['vehicle_info_status'] = this.vehicleInfoStatus;
    data['vehicle_info_reject_reason'] = this.vehicleInfoRejectReason;
    data['brand_id'] = this.brandId;
    data['brand_name'] = this.brandName;
    data['model_id'] = this.modelId;
    data['model_name'] = this.modelName;
    data['vehicle_color'] = this.vehicleColor;
    data['vehicle_plate_number'] = this.vehiclePlateNumber;
    data['vehicle_production_year'] = this.vehicleProductionYear;
    data['vehicle_photo'] = this.vehiclePhoto;
    data['vehicle_documents_status'] = this.vehicleDocumentsStatus;
    data['vehicle_documents_reject_reason'] = this.vehicleDocumentsRejectReason;
    data['vehicle_permit_part_a'] = this.vehiclePermitPartA;
    data['vehicle_permit_part_b'] = this.vehiclePermitPartB;
    data['vehicle_registration_front'] = this.vehicleRegistrationFront;
    data['vehicle_registration_back'] = this.vehicleRegistrationBack;
    data['current_latitude'] = this.currentLatitude;
    data['current_longitude'] = this.currentLongitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
