import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventoryapp/Utils/constants.dart';
import 'package:inventoryapp/ui/menu_screens/refund_item.dart';
import '../Utils/image_paths.dart';
import '../assets/widgets/sidebar.dart';
import 'menu_screens/aboutUs_page.dart';
import 'menu_screens/dashboard_page.dart';
import 'menu_screens/manage_discount_page/discount_page.dart';
import 'menu_screens/favorite_page.dart';
import 'menu_screens/manage_customer_pages/customer_page.dart';
import 'menu_screens/manage_employee_pages/employee_access_right.dart';
import 'menu_screens/manage_employee_pages/employee_list_page.dart';
import 'menu_screens/point_of_sale_page.dart';
import 'menu_screens/manage_item_pages/Item_list_Page.dart';
import 'menu_screens/manage_item_pages/add_items_page.dart';
import 'menu_screens/profile_page.dart';
import 'menu_screens/settings_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Images images = Images();
  bool visible = true;
  int _cartSelectedIndex = 0;
  int _employeeSelectedIndex = 0;
  int _aISelectedIndex=0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ProfilePage(),
      DashboardPage(false),
      FavoritePage(),
      FavoritePage(),
      EmployeeAccessRightsPage(),
      CustomerPage(),
      SettingsPage(),
      AboutUsPage(),
    ];

    final List<Widget> cartPages = [
      AddItem(showAppBar: false),
      ItemListPage(),
      DiscountPage(),
    ];

    final List<Widget> employeePages = [
      EmployeeList(),
      EmployeeAccessRightsPage(),
    ];

    final List<Widget> advanceInventoryPages=[
      PointofSalePage(false, eRole: " "),
      RefundItemPage(),
    ];

    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(images.lightLogo, scale: 5),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 20,
        backgroundColor: primaryColor,
        title: Text(
          'Sales Summary',
          style: GoogleFonts.aBeeZee(
            color: Colors.white,
            letterSpacing: 2,
            wordSpacing: 10,
          ),
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              if (!isMobile)
                Expanded(
                  flex: 3,
                  child: SideBar(
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        _selectedIndex = index;
                        visible = true;
                      });
                    },
                  ),
                ),
              Expanded(
                flex: 9,
                child: Builder(
                  builder: (context) {
                    if (_selectedIndex == 2) {
                      return cartPages[_cartSelectedIndex];
                    } else if (_selectedIndex == 4) {
                      return employeePages[_employeeSelectedIndex];
                    }else if(_selectedIndex == 3){
                      return advanceInventoryPages[_aISelectedIndex];
                    }
                    else {
                      return pages[_selectedIndex];
                    }
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: _selectedIndex == 2 ? 130 : _selectedIndex == 4 ? 260 : 180,
            left: MediaQuery.of(context).size.width * 0.25,
            child: Visibility(
              visible: (_selectedIndex == 2 || _selectedIndex == 4 || _selectedIndex==3) && visible,
              child: Container(
                width: 150,
                color: Colors.grey.shade200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedIndex == 2) {
                            _cartSelectedIndex = 0;
                          }else if(_selectedIndex == 3){
                            _aISelectedIndex=0;
                          }
                          else {
                            _employeeSelectedIndex = 0;
                          }
                          visible = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        fixedSize: const Size.fromWidth(150),
                      ),
                      child: Text(_selectedIndex == 4 ? 'Employee List' : _selectedIndex == 3 ? 'POS' : 'Add Items'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedIndex == 2) {
                            _cartSelectedIndex = 1;
                          }else if(_selectedIndex == 3){
                            _aISelectedIndex=1;
                          }
                          else {
                            _employeeSelectedIndex = 1;
                          }
                          visible = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        fixedSize: const Size.fromWidth(150),
                      ),
                      child: Text(_selectedIndex == 4 ? 'Access Right' : _selectedIndex == 3 ? 'Add Refunded Item' : 'Items List'),
                    ),
                    if (_selectedIndex == 2)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _cartSelectedIndex = 2;
                            visible = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          fixedSize: const Size.fromWidth(150),
                        ),
                        child: const Text('Discount'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}