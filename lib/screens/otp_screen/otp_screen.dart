import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hamaara_uttrakhand/config/color_pallete.dart';
import 'package:hamaara_uttrakhand/custom_widgets/custom_buton.dart';
import 'package:hamaara_uttrakhand/models/otp_match_response.dart';
import 'package:hamaara_uttrakhand/screens/home_screen/home_screen.dart';
import 'package:hamaara_uttrakhand/services/envs.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class OTPScreen extends StatefulWidget {
  const OTPScreen(
      {Key? key, required this.isAlreadyUser, required this.phoneNumber})
      : super(key: key);

  final bool isAlreadyUser;
  final String phoneNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();

  //Following is the var, that we will be using for showing loading on the screen
  var isLOading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Following is the method, that we will be using for the otp matching process
    //Following is the mehod, that will generate the OTP for the respective number
    Future<void> matchOTP(String phoneNumber) async {
      Map data = {
        "phonenumber": phoneNumber,
        "OTP": otpController.text,
      };

      Uri uri = Uri.parse("${Envs.baseUrl}/otp-match");

      String body = json.encode(data);

      http.Response response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        //The POST Call is sucessfull..and the OTP is matched
        var result = OtpMatchModelFromJson(response.body);

        //Here, as the OTP is sent sucessfully , we will poss to the new page
        //STEP-1Now, all the screens need to be closed, and user should be taken to hopme page
        //STEP-2The acess token and other respective data should be stored in local storage
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("acess", result.access);
        prefs.setString("access_expiry_time", result.access_expiry_time);
        prefs.setString("refresh", result.refresh);
        prefs.setString("refresh_expiry_time", result.refresh_expiry_time);

        //TODO
        //Here, we need to ckeck if user is first time, or old user
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
      } else {
        print(response.body);
        //The POST call has failed
        setState(() {
          isLOading = false;
        });
        var snackBar = const SnackBar(
            backgroundColor: ColorPallete.colorMain,
            content: Text("OTP match has failed. Please try again."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    //Getting the screen constraints
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.grey),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //The main Text
                  const Text(
                    "Verify Mobile Number to\ncontinue",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //The sub text
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Text(
                      "A six digit one time password has been sent to your mobile number. We will try to read the OTP  automatically. In case we are not able to do so, please enter it manually.",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 12),
                    ),
                  ),

                  //Here, we ned to verify the OTP automatically
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: PinCodeTextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      appContext: context,
                      length: 4,
                      onChanged: (value) {
                        print(value);
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        fieldWidth: 40,
                        fieldHeight: 40,
                        inactiveColor: Colors.grey,
                        activeColor: ColorPallete.colorMain,
                        selectedColor: ColorPallete.colorMain,
                      ),
                    ),
                  ),
                  //The Didn't recieve Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Didn't recieve the OTP? ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 13),
                      ),
                      Text(
                        "Resend",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  )
                ],
              ),
            ),
            //The verify button
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                        label: "Vetify OTP",
                        onTap: () {
                          //Here we need to verify the OTP
                          if (otpController.text.isEmpty) {
                            var snackBar = const SnackBar(
                                backgroundColor: ColorPallete.colorMain,
                                content: Text('Look like the OTP is empty.'));
                          } else if (otpController.text.length < 4) {
                            var snackBar = const SnackBar(
                                backgroundColor: ColorPallete.colorMain,
                                content: Text(
                                    'Oops!! Seems like the OTP is inavlid.'));
                          } else {
                            //Everything semms good, we are good to verify the otp with new call
                            //Starting the loading view
                            setState(() {
                              isLOading = true;
                            });
                            matchOTP(widget.phoneNumber);
                          }
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: const Text(
                        "You agree to all the  Terms and Conditions of use registered under Hamaara Utrrakhand application.",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 11.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                )),

            isLOading
                ? GestureDetector(
                    onTap: () {
                      var snackBar = const SnackBar(
                          backgroundColor: ColorPallete.colorMain,
                          content: Text("Please wait!! Loading...."));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    ));
  }
}
