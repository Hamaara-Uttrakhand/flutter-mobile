import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hamaara_uttrakhand/config/color_pallete.dart';
import 'package:hamaara_uttrakhand/custom_widgets/custom_buton.dart';
import 'package:hamaara_uttrakhand/models/otp_gen_response.dart';
import 'package:hamaara_uttrakhand/screens/otp_screen/otp_screen.dart';
import 'package:hamaara_uttrakhand/services/envs.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Following is the controller that we, will be using as the controller for the phone number input fields
  final TextEditingController _phomnNumberController = TextEditingController();

  //Following, is the var to handle if the progress is showingh
  var isLOading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phomnNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Following is the mehod, that will generate the OTP for the respective number
    Future<void> generateOTP(String phoneNumber) async {
      Map data = {
        "phonenumber": phoneNumber,
      };

      Uri uri = Uri.parse("${Envs.baseUrl}/otp-gen");

      String body = json.encode(data);

      http.Response response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        //The POST Call is sucessfull..and the OTP is generated
        var result = OTPGENMODELFromJson(response.body);

        //Here, as the OTP is sent sucessfully , we will poss to the new page
        //Replacing the screen with OTP page
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                  isAlreadyUser: result.user_status, phoneNumber: phoneNumber),
            ));
      } else {
        //The POST call has failed
        setState(() {
          isLOading = false;
        });
        var snackBar = const SnackBar(
            backgroundColor: ColorPallete.colorMain,
            content: Text("Couldn't generate OTP. Please try again later"));
        ScaffoldMessenger.of(context);
      }
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          //Removing the focus from the text field, if foucused
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.grey),
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
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
                      "Enter the phone number for\nverification",
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
                        "The number will be used for all the application related commnication. You shall recieve a SMS with code for confirmation.",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 12),
                      ),
                    ),

                    Container(
                        margin: const EdgeInsets.only(right: 20, top: 15),
                        child: PhoneFieldHint(
                          controller: _phomnNumberController,
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              width: 55,
                              margin:
                                  const EdgeInsets.only(right: 0, bottom: 5),
                              child: Center(
                                  child: Row(
                                children: const [
                                  Text(
                                    "+91",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  )
                                ],
                              )),
                            ),
                            hintText: 'Enter the mobile number',
                            suffixIcon: const Icon(Icons.phone_android),
                          ),
                        )),
                    const Spacer(),

                    Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        width: double.infinity,
                        child: Align(
                            alignment: Alignment.center,
                            child: CustomButton(
                                label: 'Send OTP',
                                onTap: () {
                                  //Validating the mobile number
                                  if (_phomnNumberController.text.isEmpty) {
                                    var snackBar = const SnackBar(
                                        backgroundColor: ColorPallete.colorMain,
                                        content: Text(
                                            'Please eneter the mobile number.'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (_phomnNumberController
                                          .text.length !=
                                      10) {
                                    var snackBar = const SnackBar(
                                        backgroundColor: ColorPallete.colorMain,
                                        content: Text(
                                            'OOPS!! Mobile number seems invalid.'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    //Phone number seems OK, go for the call
                                    setState(() {
                                      isLOading = true;
                                    });
                                    generateOTP(
                                        "+91${_phomnNumberController.text}");
                                  }
                                })))
                  ],
                ),
              ),
              //The Loading dialog
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
      ),
    );
  }
}
