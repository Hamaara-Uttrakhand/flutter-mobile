import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamaara_uttrakhand/config/color_pallete.dart';
import 'package:hamaara_uttrakhand/config/text_theme.dart';
import 'package:hamaara_uttrakhand/custom_widgets/custom_buton.dart';
import 'package:hamaara_uttrakhand/login_screen.dart/login_screen.dart';
import 'package:hamaara_uttrakhand/screens/home_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../services/envs.dart';

String acess = "";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //Following is the variable that, will manage the state of the Splash Screen
  var isCircularShowing = true;

  //Following is the method, that will return the acess token, if stored in local storage
  Future<void> checkForAcessToken() async {
    final prefs = await SharedPreferences.getInstance();
    acess = prefs.getString('acess') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    checkForAcessToken(); //Following is the method, that will look for the acess token in the local storage, and will assign it in local variable if present
//Following is the timer, that will hold the splash screen according to the required time
    Timer(const Duration(seconds: 5), () {
      //Here need to perform a check, whether the acess token is already stored in the local storage
      if (acess != "") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
      } else {
        //Else, we need to perform this and show the user these two butons
        setState(() {
          isCircularShowing = false;
        });
      }
    });

    //Getting the screen constraints
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //The container with the icon
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //The Image (Logo)
                  Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.cover,
                    width: size.width * 0.4,
                  ),
                  Text(
                    "Hamaara Uttrakhand",
                    style: CustomTetxStyle.splashHeading(context)
                        .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Simply Heaven",
                    style: CustomTetxStyle.splashSubHeading(context)
                        .copyWith(fontSize: 16, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
          ),
          //THe container with the circular indicator and buttons
          Container(
            margin: EdgeInsets.only(bottom: size.height * 0.08),
            width: double.infinity,
            height: double.infinity,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: isCircularShowing ? 1 : 0,
                    child: SizedBox(
                      width: size.width * 0.8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          //Following is the list of children, we need in column when the progress is showing
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Please Wait..",
                            style: TextStyle(color: ColorPallete.colorMain),
                          )
                        ],
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: isCircularShowing ? 0 : 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomButton(
                          label: 'Login Now',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ));
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                          label: 'Become a partner',
                          onTap: () {
                            print('Partner button pressed');
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          //The Bottom Tag
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Government of Uttrakhand\n",
                  style: TextStyle(color: Colors.grey),
                )),
          )
        ],
      ),
    );
  }
}
