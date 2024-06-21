import 'package:flutter/material.dart';
import 'package:inventoryapp/UI/auth_screens/login_screen.dart';
import 'package:inventoryapp/data/employee_checkIn_data.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  bool locationAccess = false;
  bool emailUpdates = true;
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Container(
          width: isMobile ? double.infinity : 600,
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SwitchListTile(
                title: Text('Dark Mode'),
                value: isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
              Divider(
                color: Color(0xFF2C1E5E).withOpacity(0.5),
              ),
              SwitchListTile(
                title: Text('Enable Notifications'),
                value: notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
              Divider(
                color: Color(0xFF2C1E5E).withOpacity(0.5),
              ),
              SwitchListTile(
                title: Text('Allow Location Access'),
                value: locationAccess,
                onChanged: (bool value) {
                  setState(() {
                    locationAccess = value;
                  });
                },
              ),
              Divider(
                color: Color(0xFF2C1E5E).withOpacity(0.5),
              ),
              SwitchListTile(
                title: Text('Receive Email Updates'),
                value: emailUpdates,
                onChanged: (bool value) {
                  setState(() {
                    emailUpdates = value;
                  });
                },
              ),
              Divider(
                color: Color(0xFF2C1E5E).withOpacity(0.5),
              ),
              ListTile(
                title: Text('Language'),
                subtitle: Text(language),
                onTap: () => _showLanguageDialog(context),
              ),
              Divider(
                color: Color(0xFF2C1E5E).withOpacity(0.5),
              ),
              ListTile(
                title: Text('Privacy Settings'),
                onTap: () {
                  // Navigate to privacy settings page
                },
              ),
              Divider(
                color: Color(0xFF2C1E5E).withOpacity(0.5),
              ),
              ListTile(
                title: Text('Log OUt'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                  EmployeeCheckInData.currentCheckInUser!
                      .checkOutTime(DateTime.now());
                  EmployeeCheckInData.checkIn
                      .add(EmployeeCheckInData.currentCheckInUser!);
                  EmployeeCheckInData.currentCheckInUser = null;
                  print(
                      "CHECk IN LIST  length ${EmployeeCheckInData.checkIn.length}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                ['English', 'Spanish', 'French'].map((String languageOption) {
              return RadioListTile(
                title: Text(languageOption),
                value: languageOption,
                groupValue: language,
                onChanged: (value) {
                  setState(() {
                    language = value as String;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
