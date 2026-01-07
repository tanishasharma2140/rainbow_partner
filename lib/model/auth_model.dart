class AuthModel {
  String? message;
  dynamic role;
  dynamic servicemanId;
  dynamic driverId;
  dynamic platformType;
  dynamic errors;

  AuthModel(
      {this.message,
        this.role,
        this.servicemanId,
        this.driverId,
        this.platformType,
        this.errors});

  AuthModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    role = json['role'];
    servicemanId = json['serviceman_id'];
    driverId = json['driver_id'];
    platformType = json['platform_type'];
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['role'] = role;
    data['serviceman_id'] = servicemanId;
    data['driver_id'] = driverId;
    data['platform_type'] = platformType;
    data['errors'] = errors;
    return data;
  }
}
