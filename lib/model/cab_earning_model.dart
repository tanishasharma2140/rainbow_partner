class CabEarningModel {
  bool? success;
  Data? data;

  CabEarningModel({this.success, this.data});

  CabEarningModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  double totalEarning = 0.0;
  int totalCompletedRide = 0;
  double totalDistance = 0.0;
  OnlineTime? onlineTime;
  List<TripDetails>? tripDetails;

  Data({
    this.totalEarning = 0.0,
    this.totalCompletedRide = 0,
    this.totalDistance = 0.0,
    this.onlineTime,
    this.tripDetails,
  });

  Data.fromJson(Map<String, dynamic> json) {
    totalEarning = _parseDouble(json['total_earning']);
    totalCompletedRide = _parseInt(json['total_completed_ride']);
    totalDistance = _parseDouble(json['total_distance']);

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
}

class OnlineTime {
  int hours = 0;
  int minutes = 0;

  OnlineTime({this.hours = 0, this.minutes = 0});

  OnlineTime.fromJson(Map<String, dynamic> json) {
    hours = _parseInt(json['hours']);
    minutes = _parseInt(json['minutes']);
  }
}

class TripDetails {
  dynamic id;
  String pickupLocation = "";
  String dropLocation = "";
  dynamic orderStatus;
  double distanceKm = 0.0;
  double finalAmount = 0.0;
  dynamic payMode;
  String createdAt = "";

  TripDetails(
      {this.id,
        this.pickupLocation = "",
        this.dropLocation = "",
        this.orderStatus,
        this.distanceKm = 0.0,
        this.finalAmount = 0.0,
        this.payMode,
        this.createdAt = ""});

  TripDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickupLocation = json['pickup_location']?.toString() ?? "";
    dropLocation = json['drop_location']?.toString() ?? "";
    orderStatus = json['order_status'];
    distanceKm = _parseDouble(json['distance_km']);
    finalAmount = _parseDouble(json['final_amount']);
    payMode = json['pay_mode'];
    createdAt = json['created_at']?.toString() ?? "";
  }
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}
