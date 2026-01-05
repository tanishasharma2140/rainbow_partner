class CabEarningModel {
  bool? success;
  Data? data;

  CabEarningModel({this.success, this.data});

  CabEarningModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  double? totalEarning;
  int? totalCompletedRide;
  double? totalDistance;
  OnlineTime? onlineTime;
  List<TripDetails>? tripDetails;

  Data(
      {this.totalEarning,
        this.totalCompletedRide,
        this.totalDistance,
        this.onlineTime,
        this.tripDetails});

  Data.fromJson(Map<String, dynamic> json) {
    totalEarning = json['total_earning'];
    totalCompletedRide = json['total_completed_ride'];
    totalDistance = json['total_distance'];
    onlineTime = json['online_time'] != null
        ? OnlineTime.fromJson(json['online_time'])
        : null;
    if (json['trip_details'] != null) {
      tripDetails = <TripDetails>[];
      json['trip_details'].forEach((v) {
        tripDetails!.add(TripDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_earning'] = totalEarning;
    data['total_completed_ride'] = totalCompletedRide;
    data['total_distance'] = totalDistance;
    if (onlineTime != null) {
      data['online_time'] = onlineTime!.toJson();
    }
    if (tripDetails != null) {
      data['trip_details'] = tripDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OnlineTime {
  int? hours;
  int? minutes;

  OnlineTime({this.hours, this.minutes});

  OnlineTime.fromJson(Map<String, dynamic> json) {
    hours = json['hours'];
    minutes = json['minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hours'] = hours;
    data['minutes'] = minutes;
    return data;
  }
}

class TripDetails {
  dynamic id;
  dynamic pickupLocation;
  dynamic dropLocation;
  dynamic orderStatus;
  dynamic distanceKm;
  dynamic finalAmount;
  dynamic payMode;
  dynamic createdAt;

  TripDetails(
      {this.id,
        this.pickupLocation,
        this.dropLocation,
        this.orderStatus,
        this.distanceKm,
        this.finalAmount,
        this.payMode,
        this.createdAt});

  TripDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickupLocation = json['pickup_location'];
    dropLocation = json['drop_location'];
    orderStatus = json['order_status'];
    distanceKm = json['distance_km'];
    finalAmount = json['final_amount'];
    payMode = json['pay_mode'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pickup_location'] = pickupLocation;
    data['drop_location'] = dropLocation;
    data['order_status'] = orderStatus;
    data['distance_km'] = distanceKm;
    data['final_amount'] = finalAmount;
    data['pay_mode'] = payMode;
    data['created_at'] = createdAt;
    return data;
  }
}
