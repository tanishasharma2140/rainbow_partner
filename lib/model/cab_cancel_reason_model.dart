class CabCancelReasonModel {
  bool? success;
  int? type;
  List<Data>? data;

  CabCancelReasonModel({this.success, this.type, this.data});

  CabCancelReasonModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    type = json['type'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['type'] = type;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic reasonTitle;

  Data({this.id, this.reasonTitle});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reasonTitle = json['reason_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reason_title'] = reasonTitle;
    return data;
  }
}
