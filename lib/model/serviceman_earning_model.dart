class ServicemanEarningModel {
  bool? success;
  String? message;
  Data? data;
  dynamic errors;

  ServicemanEarningModel({this.success, this.message, this.data, this.errors});

  ServicemanEarningModel.fromJson(Map<String, dynamic> json) {
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
  dynamic totalEarning;
  dynamic todayEarning;
  dynamic weekEarning;
  dynamic monthEarning;
  List<RecentEarnings>? recentEarnings;

  Data(
      {this.totalEarning,
        this.todayEarning,
        this.weekEarning,
        this.monthEarning,
        this.recentEarnings});

  Data.fromJson(Map<String, dynamic> json) {
    totalEarning = json['total_earning'];
    todayEarning = json['today_earning'];
    weekEarning = json['week_earning'];
    monthEarning = json['month_earning'];
    if (json['recent_earnings'] != null) {
      recentEarnings = <RecentEarnings>[];
      json['recent_earnings'].forEach((v) {
        recentEarnings!.add(RecentEarnings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_earning'] = totalEarning;
    data['today_earning'] = todayEarning;
    data['week_earning'] = weekEarning;
    data['month_earning'] = monthEarning;
    if (recentEarnings != null) {
      data['recent_earnings'] =
          recentEarnings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentEarnings {
  String? serviceName;
  String? serviceDatetime;
  String? finalAmount;

  RecentEarnings({this.serviceName, this.serviceDatetime, this.finalAmount});

  RecentEarnings.fromJson(Map<String, dynamic> json) {
    serviceName = json['service_name'];
    serviceDatetime = json['service_datetime'];
    finalAmount = json['final_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_name'] = serviceName;
    data['service_datetime'] = serviceDatetime;
    data['final_amount'] = finalAmount;
    return data;
  }
}
