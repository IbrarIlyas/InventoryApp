import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventoryapp/Utils/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String name = 'Admin';
  String email = 'admin123@gmail.com';
  bool isEditingName = false;
  bool isEditingEmail = false;
  bool isEditingPassword = false;
  bool isPasswordVisible = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      name = user!.displayName ?? 'Admin';
      email = user!.email ?? 'admin123@gmail.com';
      nameController.text = name;
      emailController.text = email;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateEmail(String newEmail) async {
    try {
      await user?.updateEmail(newEmail);
      await user?.reload();
      user = _auth.currentUser;
      setState(() {
        email = newEmail;
        isEditingEmail = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Failed to update email'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateName(String newName) async {
    try {
      await user?.updateDisplayName(newName);
      await user?.reload();
      user = _auth.currentUser;
      setState(() {
        name = newName;
        isEditingName = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Failed to update name'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updatePassword(String newPassword) async {
    try {
      await user?.updatePassword(newPassword);
      setState(() {
        isEditingPassword = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Failed to update password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 600,
          width: 300,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.person, color: primaryColor),
                    const SizedBox(width: 10),
                    const Text(
                      'Name:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit, color: primaryColor),
                      onPressed: () {
                        setState(() {
                          isEditingName = !isEditingName;
                        });
                      },
                    ),
                  ],
                ),
                isEditingName
                    ? Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _updateName(nameController.text);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white),
                      child: const Text('Save Changes'),
                    ),
                  ],
                )
                    : Text(
                  name,
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.email, color: primaryColor),
                    const SizedBox(width: 10),
                    const Text(
                      'Email:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit, color: primaryColor),
                      onPressed: () {
                        setState(() {
                          isEditingEmail = !isEditingEmail;
                        });
                      },
                    ),
                  ],
                ),
                isEditingEmail
                    ? Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _updateEmail(emailController.text);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white),
                      child: const Text('Save Changes'),
                    ),
                  ],
                )
                    : Text(
                  email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.lock, color: primaryColor),
                    const SizedBox(width: 10),
                    const Text(
                      'Password:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit, color: primaryColor),
                      onPressed: () {
                        setState(() {
                          isEditingPassword = !isEditingPassword;
                        });
                      },
                    ),
                  ],
                ),
                isEditingPassword
                    ? Column(
                  children: [
                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _updatePassword(passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white),
                      child: const Text('Save Changes'),
                    ),
                  ],
                )
                    : Text(
                  '********',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
