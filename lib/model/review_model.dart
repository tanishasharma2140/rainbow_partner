class ReviewModel {
  bool? success;
  String? message;
  List<Data>? data;
  dynamic errors;

  ReviewModel({this.success, this.message, this.data, this.errors});

  ReviewModel.fromJson(Map<String, dynamic> json) {
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
  dynamic servicemanId;
  dynamic userId;
  dynamic rating;
  dynamic orderId;
  dynamic serviceName;
  dynamic userName;
  dynamic createdAt;
  dynamic image;

  Data(
      {this.id,
        this.servicemanId,
        this.userId,
        this.rating,
        this.orderId,
        this.serviceName,
        this.userName,
        this.createdAt,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    servicemanId = json['serviceman_id'];
    userId = json['user_id'];
    rating = json['rating'];
    orderId = json['order_id'];
    serviceName = json['service_name'];
    userName = json['user_name'];
    createdAt = json['created_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serviceman_id'] = servicemanId;
    data['user_id'] = userId;
    data['rating'] = rating;
    data['order_id'] = orderId;
    data['service_name'] = serviceName;
    data['user_name'] = userName;
    data['created_at'] = createdAt;
    data['image'] = image;
    return data;
  }
}
