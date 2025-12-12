class AuthModel {
  bool? success;
  String? message;
  int? servicemanId;
  dynamic errors;

  AuthModel({this.success, this.message, this.servicemanId, this.errors});

  AuthModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    servicemanId = json['serviceman_id'];
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['serviceman_id'] = servicemanId;
    data['errors'] = errors;
    return data;
  }
}
