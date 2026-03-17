class PaytmGatewayModel {
  bool? status;
  String? message;
  Data? data;

  PaytmGatewayModel({this.status, this.message, this.data});

  PaytmGatewayModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? orderId;
  int? moduleType;
  String? txnToken;
  int? amount;
  String? platformFee;
  int? finalAmount;

  Data(
      {this.orderId,
        this.moduleType,
        this.txnToken,
        this.amount,
        this.platformFee,
        this.finalAmount});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    moduleType = json['module_type'];
    txnToken = json['txnToken'];
    amount = json['amount'];
    platformFee = json['platform_fee'];
    finalAmount = json['final_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['module_type'] = moduleType;
    data['txnToken'] = txnToken;
    data['amount'] = amount;
    data['platform_fee'] = platformFee;
    data['final_amount'] = finalAmount;
    return data;
  }
}
