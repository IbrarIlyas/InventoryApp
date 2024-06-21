import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventoryapp/Utils/image_paths.dart';
import 'package:inventoryapp/utils/responsive.dart';
import '../../../assets/widgets/auth_screen_widgets.dart';
import 'login_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _screenHeight;

  Images images = Images();

  bool _isObscure = true;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 100, left: 30, right: 30),
          child: Center(
            child: Responsive.isMobile(context)?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                AuthScreenWidgets.titleWidget(200, images.darkLogo),
                Text(
                  'Register to account',
                  style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                ),
                _registrationForm(),
                AuthScreenWidgets.authScreenButton(context,"Register",_emailController,_passwordController,false),
                AuthScreenWidgets.linkedText(context, "Already have an account? Login", LoginScreen())
              ],
            ):Row(
              children: [
                Expanded(
                  flex: 6,
                    child: AuthScreenWidgets.titleWidget(350, images.darkLogo)
                ),
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Register to account',
                          style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                        ),
                        _registrationForm(),
                        AuthScreenWidgets.authScreenButton(context,"Register",_emailController,_passwordController,false),
                        AuthScreenWidgets.linkedText(context, "Already have an account? Login", LoginScreen())
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registrationForm() {
    return SizedBox(
      height: _screenHeight * 0.27,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            AuthScreenWidgets.emailTextField(_emailController),
            AuthScreenWidgets.passwordTextField(_passwordController, _isObscure, () {setState(() {_isObscure = !_isObscure;});},),
          ],
        ),
      ),
    );
  }
}
