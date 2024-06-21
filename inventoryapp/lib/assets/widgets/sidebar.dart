import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const SideBar({
    required this.selectedIndex,
    required this.onTabChange,
    Key? key,
  }) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: Colors.white,
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onTabChange,
      labelType: NavigationRailLabelType.all,
      useIndicator: true,
      destinations:  [
        NavigationRailDestination(
          icon: Icon(Icons.account_circle,color: Colors.deepOrange.shade700,),
          label: const Text('Profile'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bar_chart,color: Colors.greenAccent.shade700,),
          label: const Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.shopping_basket,color: Colors.pinkAccent.shade700,),
          label: const Text('Items'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.trolley,color: Colors.lightBlueAccent.shade700,),
          label: const Text('Advance Inventory'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.contact_mail_rounded,color: Colors.lightGreenAccent.shade700,),
          label: const Text('Employee'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.group,color: Colors.deepPurple.shade700,),
          label: const Text('Customers'),
          indicatorColor: Colors.green
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings, color:Colors.blueGrey.shade700,),
          label: const Text('Setting'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.help_outline,color: Colors.blue.shade700,),
          label: const Text('About Us'),
        ),
      ],
    );
  }
}
