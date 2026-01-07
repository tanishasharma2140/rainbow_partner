class CabHistoryModel {
  bool? success;
  int? count;
  List<Data>? data;

  CabHistoryModel({this.success, this.count, this.data});

  CabHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
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
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic walletApply;
  dynamic payMode;
  dynamic amountAfterWallet;
  dynamic finalAmount;
  dynamic vehicleName;
  dynamic brandName;
  dynamic modelName;
  dynamic distanceKm;
  dynamic estimatedAmount;
  dynamic orderStatus;
  dynamic cancelReason;
  dynamic orderType;
  dynamic scheduleTime;
  dynamic paymentStatus;
  dynamic userComment;
  dynamic overLimitPassenger;
  dynamic profilePhoto;
  dynamic vehicleColor;
  dynamic driverName;
  dynamic vehiclePlateNumber;
  dynamic contactNumber;
  dynamic orderOtp;
  dynamic rating;
  dynamic userName;
  dynamic userMobile;

  Data(
      {this.id,
        this.walletApply,
        this.payMode,
        this.amountAfterWallet,
        this.finalAmount,
        this.vehicleName,
        this.brandName,
        this.modelName,
        this.distanceKm,
        this.estimatedAmount,
        this.orderStatus,
        this.cancelReason,
        this.orderType,
        this.scheduleTime,
        this.paymentStatus,
        this.userComment,
        this.overLimitPassenger,
        this.profilePhoto,
        this.vehicleColor,
        this.driverName,
        this.vehiclePlateNumber,
        this.contactNumber,
        this.orderOtp,
        this.rating,
        this.userName,
        this.userMobile});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    walletApply = json['wallet_apply'];
    payMode = json['pay_mode'];
    amountAfterWallet = json['amount_after_wallet'];
    finalAmount = json['final_amount'];
    vehicleName = json['vehicle_name'];
    brandName = json['brand_name'];
    modelName = json['model_name'];
    distanceKm = json['distance_km'];
    estimatedAmount = json['estimated_amount'];
    orderStatus = json['order_status'];
    cancelReason = json['cancel_reason'];
    orderType = json['order_type'];
    scheduleTime = json['schedule_time'];
    paymentStatus = json['payment_status'];
    userComment = json['user_comment'];
    overLimitPassenger = json['over_limit_passenger'];
    profilePhoto = json['profile_photo'];
    vehicleColor = json['vehicle_color'];
    driverName = json['driver_name'];
    vehiclePlateNumber = json['vehicle_plate_number'];
    contactNumber = json['contact_number'];
    orderOtp = json['orderOtp'];
    rating = json['rating'];
    userName = json['user_name'];
    userMobile = json['user_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wallet_apply'] = walletApply;
    data['pay_mode'] = payMode;
    data['amount_after_wallet'] = amountAfterWallet;
    data['final_amount'] = finalAmount;
    data['vehicle_name'] = vehicleName;
    data['brand_name'] = brandName;
    data['model_name'] = modelName;
    data['distance_km'] = distanceKm;
    data['estimated_amount'] = estimatedAmount;
    data['order_status'] = orderStatus;
    data['cancel_reason'] = cancelReason;
    data['order_type'] = orderType;
    data['schedule_time'] = scheduleTime;
    data['payment_status'] = paymentStatus;
    data['user_comment'] = userComment;
    data['over_limit_passenger'] = overLimitPassenger;
    data['profile_photo'] = profilePhoto;
    data['vehicle_color'] = vehicleColor;
    data['driver_name'] = driverName;
    data['vehicle_plate_number'] = vehiclePlateNumber;
    data['contact_number'] = contactNumber;
    data['orderOtp'] = orderOtp;
    data['rating'] = rating;
    data['user_name'] = userName;
    data['user_mobile'] = userMobile;
    return data;
  }
}
