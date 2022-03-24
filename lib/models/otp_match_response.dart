import 'dart:convert';

OtpMatchMode OtpMatchModelFromJson(String str) =>
    OtpMatchMode.fromJson(json.decode(utf8.decode(str.codeUnits)));

String OtpMatchModeToJson(OtpMatchMode data) => json.encode(data.toJson());

class OtpMatchMode {
  String refresh;
  String refresh_expiry_time;
  String access;
  String access_expiry_time;

  OtpMatchMode({
    required this.refresh,
    required this.refresh_expiry_time,
    required this.access,
    required this.access_expiry_time,
  });

  factory OtpMatchMode.fromJson(Map<String, dynamic> json) => OtpMatchMode(
        refresh: json["refresh"],
        refresh_expiry_time: json["refresh_expiry_time"],
        access: json["access"],
        access_expiry_time: json["access_expiry_time"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "refresh_expiry_time": refresh_expiry_time,
        "access": access,
        "access_expiry_time": access_expiry_time,
      };
}
