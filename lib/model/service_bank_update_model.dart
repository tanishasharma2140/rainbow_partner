class ServiceBankUpdateModel {
  bool? success;
  String? message;
  UpdateRequest? updateRequest;

  ServiceBankUpdateModel({this.success, this.message, this.updateRequest});

  ServiceBankUpdateModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    updateRequest = json['update_request'] != null
        ? UpdateRequest.fromJson(json['update_request'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (updateRequest != null) {
      data['update_request'] = updateRequest!.toJson();
    }
    return data;
  }
}

class UpdateRequest {
  dynamic id;
  dynamic userId;
  dynamic type;
  dynamic bankName;
  dynamic accountNumber;
  dynamic reAccountNumber;
  dynamic accountHolderName;
  dynamic ifscCode;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  UpdateRequest(
      {this.id,
        this.userId,
        this.type,
        this.bankName,
        this.accountNumber,
        this.reAccountNumber,
        this.accountHolderName,
        this.ifscCode,
        this.status,
        this.createdAt,
        this.updatedAt});

  UpdateRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    reAccountNumber = json['re_account_number'];
    accountHolderName = json['account_holder_name'];
    ifscCode = json['ifsc_code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['bank_name'] = bankName;
    data['account_number'] = accountNumber;
    data['re_account_number'] = reAccountNumber;
    data['account_holder_name'] = accountHolderName;
    data['ifsc_code'] = ifscCode;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
