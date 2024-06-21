import 'package:flutter/material.dart';
import 'package:inventoryapp/Utils/constants.dart';

class CustomDrawer extends StatelessWidget {

  String role;
  final VoidCallback onProfilePressed;
  final VoidCallback onAddItemPressed;
  final VoidCallback onDashBoardPressed;
  final VoidCallback onLogoutPressed;

  CustomDrawer({
    required this.role,
    required this.onProfilePressed,
    required this.onAddItemPressed,
    required this.onDashBoardPressed,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: this.role=="Cashier"?ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Text(
              'Employee Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: onProfilePressed,
          ),
          ListTile(
            title: const Text('Add Item'),
            onTap: onAddItemPressed,
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: onLogoutPressed,
          ),
        ],
      ):ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Text(
              'Employee Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: onProfilePressed,
          ),
          ListTile(
            title: const Text('Add Item'),
            onTap: onAddItemPressed,
          ),
          ListTile(
            title: const Text('DashBoard'),
            onTap: onDashBoardPressed,
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: onLogoutPressed,
          ),
        ],
      ),
    );
  }
}
