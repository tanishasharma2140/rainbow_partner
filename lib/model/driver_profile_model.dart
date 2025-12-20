class DriverProfileModel {
  String? message;
  Data? data;

  DriverProfileModel({this.message, this.data});

  DriverProfileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['platform_type'] = platformType;
    data['vehicle_type'] = vehicleType;
    data['vehicle_name'] = vehicleName;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['mobile'] = mobile;
    data['date_of_birth'] = dateOfBirth;
    data['profile_photo'] = profilePhoto;
    data['device_id'] = deviceId;
    data['fcm_token'] = fcmToken;
    data['personal_information_status'] = personalInformationStatus;
    data['personal_information_reject_reason'] =
        personalInformationRejectReason;
    data['driver_licence_status'] = driverLicenceStatus;
    data['driver_licence_reject_reason'] = driverLicenceRejectReason;
    data['driver_licence_number'] = driverLicenceNumber;
    data['licence_validity_date'] = licenceValidityDate;
    data['driver_licence_front'] = driverLicenceFront;
    data['driver_licence_back'] = driverLicenceBack;
    data['aadhaar_pan_status'] = aadhaarPanStatus;
    data['aadhaar_pan_reject_reason'] = aadhaarPanRejectReason;
    data['aadhaar_number'] = aadhaarNumber;
    data['pan_card_number'] = panCardNumber;
    data['aadhaar_front'] = aadhaarFront;
    data['aadhaar_back'] = aadhaarBack;
    data['pan_card_front'] = panCardFront;
    data['pan_card_back'] = panCardBack;
    data['required_certificates_status'] = requiredCertificatesStatus;
    data['required_certificates_reject_reason'] =
        requiredCertificatesRejectReason;
    data['fitness_certificate'] = fitnessCertificate;
    data['pollution_certificate'] = pollutionCertificate;
    data['insurance_certificate'] = insuranceCertificate;
    data['police_certificate'] = policeCertificate;
    data['vehicle_info_status'] = vehicleInfoStatus;
    data['vehicle_info_reject_reason'] = vehicleInfoRejectReason;
    data['brand_id'] = brandId;
    data['brand_name'] = brandName;
    data['model_id'] = modelId;
    data['model_name'] = modelName;
    data['vehicle_color'] = vehicleColor;
    data['vehicle_plate_number'] = vehiclePlateNumber;
    data['vehicle_production_year'] = vehicleProductionYear;
    data['vehicle_photo'] = vehiclePhoto;
    data['vehicle_documents_status'] = vehicleDocumentsStatus;
    data['vehicle_documents_reject_reason'] = vehicleDocumentsRejectReason;
    data['vehicle_permit_part_a'] = vehiclePermitPartA;
    data['vehicle_permit_part_b'] = vehiclePermitPartB;
    data['vehicle_registration_front'] = vehicleRegistrationFront;
    data['vehicle_registration_back'] = vehicleRegistrationBack;
    data['current_latitude'] = currentLatitude;
    data['current_longitude'] = currentLongitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
