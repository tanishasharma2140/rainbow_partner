class TransactionHistoryModel {
  bool? success;
  String? message;
  List<Data>? data;
  dynamic errors;

  TransactionHistoryModel({this.success, this.message, this.data, this.errors});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
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
  String? sectionType;
  int? sectionStatus;
  Payment? payment;

  Data({this.sectionType, this.sectionStatus, this.payment});

  Data.fromJson(Map<String, dynamic> json) {
    sectionType = json['section_type'];
    sectionStatus = json['section_status'];
    payment =
    json['payment'] != null ? Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['section_type'] = sectionType;
    data['section_status'] = sectionStatus;
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    return data;
  }
}

class Payment {
  dynamic id;
  dynamic amount;
  dynamic finalAmount;
  dynamic status;
  dynamic paymentType;
  dynamic platformFee;
  dynamic paymentDate;

  Payment(
      {this.id,
        this.amount,
        this.finalAmount,
        this.status,
        this.paymentType,
        this.platformFee,
        this.paymentDate});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    finalAmount = json['final_amount'];
    status = json['status'];
    paymentType = json['payment_type'];
    platformFee = json['platform_fee'];
    paymentDate = json['payment_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['final_amount'] = finalAmount;
    data['status'] = status;
    data['payment_type'] = paymentType;
    data['platform_fee'] = platformFee;
    data['payment_date'] = paymentDate;
    return data;
  }
}
