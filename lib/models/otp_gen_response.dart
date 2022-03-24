import 'dart:convert';

OTPGENMODEL OTPGENMODELFromJson(String str) =>
    OTPGENMODEL.fromJson(json.decode(utf8.decode(str.codeUnits)));

String OTPGENMODELToJson(OTPGENMODEL data) => json.encode(data.toJson());

class OTPGENMODEL {
  String message;
  bool user_status;

  OTPGENMODEL({
    required this.message,
    required this.user_status,
  });

  factory OTPGENMODEL.fromJson(Map<String, dynamic> json) => OTPGENMODEL(
        message: json["message"],
        user_status: json["user_status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user_status": user_status,
      };
}
