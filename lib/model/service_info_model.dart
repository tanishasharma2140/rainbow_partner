class ServiceInfoModel {
  bool? success;
  String? message;
  Data? data;
  dynamic errors;

  ServiceInfoModel({this.success, this.message, this.data, this.errors});

  ServiceInfoModel.fromJson(Map<String, dynamic> json) {
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
  dynamic acceptedBooking;
  dynamic completedBooking;
  dynamic totalEarning;

  Data({this.acceptedBooking, this.completedBooking, this.totalEarning});

  Data.fromJson(Map<String, dynamic> json) {
    acceptedBooking = json['accepted_booking'];
    completedBooking = json['completed_booking'];
    totalEarning = json['total_earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accepted_booking'] = acceptedBooking;
    data['completed_booking'] = completedBooking;
    data['total_earning'] = totalEarning;
    return data;
  }
}
