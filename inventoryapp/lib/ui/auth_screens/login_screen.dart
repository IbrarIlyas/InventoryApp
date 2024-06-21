import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventoryapp/Utils/constants.dart';
import 'package:inventoryapp/Utils/image_paths.dart';
import 'package:inventoryapp/assets/widgets/auth_screen_widgets.dart';
import 'package:inventoryapp/ui/auth_screens/resgister_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double _screenHeight;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool _rememberMe =false;

  Images images = Images();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20, bottom: 100, right: 30, left: 30),
            child: MediaQuery.of(context).size.width > 700 ? Row(
              children: [
                Expanded(
                  flex: 6,
                  child: AuthScreenWidgets.titleWidget(350, images.darkLogo),),
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _loginForm(),
                        AuthScreenWidgets.authScreenButton(context, "LogIn",_emailController,_passwordController,true),
                        AuthScreenWidgets.linkedText(context,"Don't have an account? Register" , RegisterPage()),
                      ],
                    ),
                  ),
                ),
              ],
            ) : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AuthScreenWidgets.titleWidget(200, images.darkLogo),
                Text('Sign In to account', style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),),
                _loginForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){setState(() {if(_rememberMe==false){_rememberMe=true;}else{_rememberMe=false;}});},
                          child: _rememberMe?const Icon(Icons.check_box_rounded, color: primaryColor):const Icon(Icons.check_box_outline_blank_rounded, color: primaryColor),
                        ),
                        const Text('Remember me'),
                      ],
                    ),
                    AuthScreenWidgets.authScreenButton(context, "LogIn",_emailController,_passwordController,true),
                  ],
                ),
                AuthScreenWidgets.linkedText(context,"Don't have an account? Register" , RegisterPage()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return SizedBox(
      height: _screenHeight * 0.20,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AuthScreenWidgets.emailTextField(_emailController),
            AuthScreenWidgets.passwordTextField(_passwordController, _isObscure, () {setState(() {_isObscure = !_isObscure;});},),
          ],
        ),
      ),
    );
  }
}
