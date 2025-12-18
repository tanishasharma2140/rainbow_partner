class ServiceWithdrawHistoryModel {
  bool? success;
  String? message;
  List<Data>? data;
  dynamic errors;

  ServiceWithdrawHistoryModel(
      {this.success, this.message, this.data, this.errors});

  ServiceWithdrawHistoryModel.fromJson(Map<String, dynamic> json) {
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
  dynamic amount;
  dynamic status;
  dynamic transactionId;
  dynamic rejectedReason;
  dynamic createdAt;

  Data(
      {this.id,
        this.amount,
        this.status,
        this.transactionId,
        this.rejectedReason,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    status = json['status'];
    transactionId = json['transaction_id'];
    rejectedReason = json['rejected_reason'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['status'] = status;
    data['transaction_id'] = transactionId;
    data['rejected_reason'] = rejectedReason;
    data['created_at'] = createdAt;
    return data;
  }
}
