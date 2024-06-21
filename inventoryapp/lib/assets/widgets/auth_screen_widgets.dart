import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:inventoryapp/Model/employee_checkIn_class.dart';
import 'package:inventoryapp/Utils/constants.dart';
import 'package:inventoryapp/data/employee_checkIn_data.dart';
import '../../Model/employee_class.dart';
import '../../sevices/database/employee_table_helper.dart';
import '../../sevices/firebase_auth_service.dart';
import '../../ui/home_screen.dart';
import '../../ui/menu_screens/point_of_sale_page.dart';

class AuthScreenWidgets {
  static Widget titleWidget(double height, String imagePath) {
    return Image(
      height: height,
      image: AssetImage(imagePath),
    );
  }

  static Widget emailTextField(TextEditingController emailController) {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        hintText: "Email...",
        hintStyle: GoogleFonts.aBeeZee(
            color: const Color.fromRGBO(105, 105, 105, 0.4)),
        prefixIcon: const Icon(Icons.email_outlined, color: primaryColor),
      ),
      validator: (value) {
        bool result = EmailValidator.validate(value!);
        return result ? null : "Please enter a valid Email";
      },
    );
  }

  static Widget passwordTextField(TextEditingController passwordController,
      bool isObscure, VoidCallback toggleObscure) {
    return TextFormField(
      controller: passwordController,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: "Password...",
        hintStyle: GoogleFonts.aBeeZee(
            color: const Color.fromRGBO(105, 105, 105, 0.4)),
        prefixIcon: const Icon(Icons.key_outlined, color: primaryColor),
        suffixIcon: GestureDetector(
          onTap: toggleObscure,
          child: Icon(isObscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
        ),
      ),
      validator: (value) =>
      value!.length > 6 ? null : "Please enter the correct password",
    );
  }

  static Widget authScreenButton(
      BuildContext context, String _text, TextEditingController email, TextEditingController password, bool isLoginMode) {
    return ElevatedButton(
      onPressed: () async {
        final dbHelper = EmployeeClassDatabaseHelper();
        await dbHelper.initializeDatabase();
        List<Employee> employees = await dbHelper.getAllEmployees();
        Employee? foundEmployee;

        if (isLoginMode) {
          // Login Mode
          for (Employee employee in employees) {
            if (employee.email == email.text && employee.password == password.text) {
              foundEmployee = employee;
              break;
            }
          }

          if (foundEmployee != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PointofSalePage(
                    true,
                    eRole: foundEmployee!.role,
                  )),
            );
          } else {
            final firebaseAuthService = FirebaseAuthService();
            User? firebaseUser = await firebaseAuthService.signInWithEmailPassword(email.text, password.text);

            if (firebaseUser != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Email or password is wrong'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          // Sign-Up Mode
          final firebaseAuthService = FirebaseAuthService();
          User? firebaseUser = await firebaseAuthService.signUpWithEmailPassword(email.text, password.text);

          if (firebaseUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign up failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        shape: const RoundedRectangleBorder(),
      ),
      child: Text(
        _text,
        style: GoogleFonts.aBeeZee(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 4,
        ),
      ),
    );
  }

  static Widget linkedText(
      BuildContext context, String text, Widget nextScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => nextScreen));
      },
      child: Text(
        text,
        style:
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
      ),
    );
  }
}
