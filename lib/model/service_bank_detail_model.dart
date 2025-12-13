class ServiceBankDetailModel {
  bool? success;
  String? message;
  BankDetails? bankDetails;

  ServiceBankDetailModel({this.success, this.message, this.bankDetails});

  ServiceBankDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    bankDetails = json['bank_details'] != null
        ? BankDetails.fromJson(json['bank_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (bankDetails != null) {
      data['bank_details'] = bankDetails!.toJson();
    }
    return data;
  }
}

class BankDetails {
  dynamic id;
  dynamic userId;
  dynamic type;
  dynamic bankName;
  dynamic accountNumber;
  dynamic reAccountNumber;
  dynamic accountHolderName;
  dynamic ifscCode;
  dynamic datetime;
  dynamic updatedAt;

  BankDetails(
      {this.id,
        this.userId,
        this.type,
        this.bankName,
        this.accountNumber,
        this.reAccountNumber,
        this.accountHolderName,
        this.ifscCode,
        this.datetime,
        this.updatedAt});

  BankDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    reAccountNumber = json['re_account_number'];
    accountHolderName = json['account_holder_name'];
    ifscCode = json['ifsc_code'];
    datetime = json['datetime'];
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
    data['datetime'] = datetime;
    data['updated_at'] = updatedAt;
    return data;
  }
}
