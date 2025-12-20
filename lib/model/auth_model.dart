class AuthModel {
  String? message;
  String? role;
  int? servicemanId;
  int? platformType;
  dynamic errors;

  AuthModel(
      {this.message,
        this.role,
        this.servicemanId,
        this.platformType,
        this.errors});

  AuthModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    role = json['role'];
    servicemanId = json['serviceman_id'];
    platformType = json['platform_type'];
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['role'] = role;
    data['serviceman_id'] = servicemanId;
    data['platform_type'] = platformType;
    data['errors'] = errors;
    return data;
  }
}
