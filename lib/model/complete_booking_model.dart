class CompleteBookingModel {
  bool? success;
  String? message;
  int? count;
  List<Data>? data;

  CompleteBookingModel({this.success, this.message, this.count, this.data});

  CompleteBookingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic serviceAddress;
  dynamic serviceLatitude;
  dynamic serviceLongitude;
  dynamic userId;
  dynamic userName;
  dynamic userMobile;
  dynamic servicemanId;
  dynamic servicemanName;
  dynamic servicemanMobile;
  dynamic amount;
  dynamic couponDiscount;
  dynamic gstCharges;
  dynamic finalAmount;
  dynamic paymentStatus;
  dynamic serviceStatus;
  dynamic serviceId;
  dynamic serviceName;
  dynamic payMode;
  dynamic couponId;
  dynamic availableServiceMan;
  dynamic serviceDatetime;
  dynamic updatedAt;
  dynamic createdAt;
  dynamic quantity;
  dynamic cancelReason;
  dynamic orderOtp;
  dynamic description;
  dynamic serviceImage;
  dynamic servicemanProfilePhoto;

  Data(
      {this.id,
        this.serviceAddress,
        this.serviceLatitude,
        this.serviceLongitude,
        this.userId,
        this.userName,
        this.userMobile,
        this.servicemanId,
        this.servicemanName,
        this.servicemanMobile,
        this.amount,
        this.couponDiscount,
        this.gstCharges,
        this.finalAmount,
        this.paymentStatus,
        this.serviceStatus,
        this.serviceId,
        this.serviceName,
        this.payMode,
        this.couponId,
        this.availableServiceMan,
        this.serviceDatetime,
        this.updatedAt,
        this.createdAt,
        this.quantity,
        this.cancelReason,
        this.orderOtp,
        this.description,
        this.serviceImage,
        this.servicemanProfilePhoto});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceAddress = json['service_address'];
    serviceLatitude = json['service_latitude'];
    serviceLongitude = json['service_longitude'];
    userId = json['user_id'];
    userName = json['user_name'];
    userMobile = json['user_mobile'];
    servicemanId = json['serviceman_id'];
    servicemanName = json['serviceman_name'];
    servicemanMobile = json['serviceman_mobile'];
    amount = json['amount'];
    couponDiscount = json['coupon_discount'];
    gstCharges = json['gst_charges'];
    finalAmount = json['final_amount'];
    paymentStatus = json['payment_status'];
    serviceStatus = json['service_status'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    payMode = json['pay_mode'];
    couponId = json['coupon_id'];
    availableServiceMan = json['available_service_man'];
    serviceDatetime = json['service_datetime'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    quantity = json['quantity'];
    cancelReason = json['cancel_reason'];
    orderOtp = json['orderOtp'];
    description = json['description'];
    serviceImage = json['service_image'];
    servicemanProfilePhoto = json['serviceman_profile_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_address'] = serviceAddress;
    data['service_latitude'] = serviceLatitude;
    data['service_longitude'] = serviceLongitude;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_mobile'] = userMobile;
    data['serviceman_id'] = servicemanId;
    data['serviceman_name'] = servicemanName;
    data['serviceman_mobile'] = servicemanMobile;
    data['amount'] = amount;
    data['coupon_discount'] = couponDiscount;
    data['gst_charges'] = gstCharges;
    data['final_amount'] = finalAmount;
    data['payment_status'] = paymentStatus;
    data['service_status'] = serviceStatus;
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['pay_mode'] = payMode;
    data['coupon_id'] = couponId;
    data['available_service_man'] = availableServiceMan;
    data['service_datetime'] = serviceDatetime;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['quantity'] = quantity;
    data['cancel_reason'] = cancelReason;
    data['orderOtp'] = orderOtp;
    data['description'] = description;
    data['service_image'] = serviceImage;
    data['serviceman_profile_photo'] = servicemanProfilePhoto;
    return data;
  }
}
