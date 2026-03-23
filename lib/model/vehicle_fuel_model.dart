class VehicleFuelModel {
  bool? success;
  String? message;
  List<Data>? data;
  dynamic errors;

  VehicleFuelModel({this.success, this.message, this.data, this.errors});

  VehicleFuelModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['errors'] = errors;
    return data;
  }
}

class Data {
  dynamic id;
  dynamic vehicleCategory;
  dynamic fuelType;

  Data({this.id, this.vehicleCategory, this.fuelType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleCategory = json['vehicle_category'];
    fuelType = json['fuel_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vehicle_category'] = vehicleCategory;
    data['fuel_type'] = fuelType;
    return data;
  }
}
