
class GetProfileModel {
  GetProfileModel._privateConstructor();
  static final GetProfileModel _instance = GetProfileModel._privateConstructor();
  factory GetProfileModel() => _instance;

  int responseCode = 0;
  String responseMessage = '';
  Data? data;

  void fromJson(Map<String, dynamic> json) {
    responseCode = json["responseCode"] ?? 0;
    responseMessage = json["responseMessage"] ?? "";
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "responseMessage": responseMessage,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.fcmToken,
    required this.loginType,
    required this.otp,
    required this.otpVerified,
    required this.otpExipredAt,
    required this.role,
    required this.uid,
    required this.isDeleted,
    required this.accessToken,
    required this.createdAt,
    required this.updatedAt,
    required this.dailyReminder,
    required this.enableNotification,
    required this.streakReminder,
  });

  String id;
  String name;
  String email;
  String image;
  String fcmToken;
  String loginType;
  String otp;
  bool otpVerified;
  dynamic otpExipredAt;
  String role;
  String uid;
  bool isDeleted;
  String accessToken;
  String? createdAt;
  String? updatedAt;

  bool dailyReminder;
  bool enableNotification;
  bool streakReminder;


  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      image: json["image"] ?? "",
      fcmToken: json["fcmToken"] ?? "",
      loginType: json["loginType"] ?? "",
      otp: json["otp"] ?? "",
      otpVerified: json["otpVerified"] ?? false,
      otpExipredAt: json["otpExipredAt"],
      role: json["role"] ?? "",
      uid: json["uid"] ?? "",
      isDeleted: json["isDeleted"] ?? false,
      accessToken: json["accessToken"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      dailyReminder : json["dailyReminder"] ?? false,
      enableNotification : json["enableNotification"] ?? false,
      streakReminder : json["streakReminder"] ?? false,

    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "image": image,
    "fcmToken": fcmToken,
    "loginType": loginType,
    "otp": otp,
    "otpVerified": otpVerified,
    "otpExipredAt": otpExipredAt,
    "role": role,
    "uid": uid,
    "isDeleted": isDeleted,
    "accessToken": accessToken,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "dailyReminder": dailyReminder,
    "enableNotification": enableNotification,
    "streakReminder": streakReminder,
  };
}