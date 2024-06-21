import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventoryapp/Utils/constants.dart';
import 'package:page_transition/page_transition.dart';
import '../Assets/widgets/circles.dart';
import '../Utils/image_paths.dart';
import 'auth_screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late double _screenWidth;
  late double _screenHeight;

  Images images = Images();

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          child: AnimatedSplashScreen(
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.rightToLeftWithFade,
            animationDuration: const Duration(seconds: 2),
            duration: 6000,
            splashIconSize: 500,
            backgroundColor: primaryColor,
            splash: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    'Point of Sale Solution',
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        letterSpacing: 3,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Image(
                  image: AssetImage(images.lightLogo),
                  width: 300,
                  height: 300,
                ),
              ],
            ),
            nextScreen: LoginScreen(),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            border: Border.all(),
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.elliptical(250, 200)),
          ),
        ),
        Circle(
          circleSize: 20,
          circleColor: Colors.orange,
          circleLeftMargin: _screenWidth - 50,
          circleTopMargin: _screenHeight - 200,
          circleRightMargin: 0,
          circleBottomMargin: 0,
        ),
        Circle(
          circleSize: 40,
          circleColor: Colors.redAccent,
          circleLeftMargin: _screenWidth - 150,
          circleTopMargin: _screenHeight - 200,
          circleRightMargin: 0,
          circleBottomMargin: 0,
        ),
        Circle(
          circleSize: 100,
          circleColor: Colors.blueGrey,
          circleLeftMargin: _screenWidth - 150,
          circleTopMargin: _screenHeight - 150,
          circleRightMargin: 0,
          circleBottomMargin: 0,
        ),
        Circle(
          circleSize: 50,
          circleColor: Colors.lightGreenAccent,
          circleLeftMargin: _screenWidth - 50,
          circleTopMargin: _screenHeight - 100,
          circleRightMargin: 0,
          circleBottomMargin: 0,
        ),
      ],
    ));
  }
}
