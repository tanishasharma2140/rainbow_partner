class HelpSupportModel {
  bool? success;
  String? message;
  Data? data;

  HelpSupportModel({this.success, this.message, this.data});

  HelpSupportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? email;
  String? supportMobile;

  Data({this.email, this.supportMobile});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    supportMobile = json['support_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['support_mobile'] = supportMobile;
    return data;
  }
}
