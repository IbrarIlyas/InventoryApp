import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:inventoryapp/data/employee_checkIn_data.dart';
import 'package:inventoryapp/data/item_data.dart';
import 'package:inventoryapp/ui/auth_screens/login_screen.dart';
import 'package:inventoryapp/assets/widgets/custom_drawer.dart';
import 'package:inventoryapp/utils/constants.dart';
import '../../../Model/item_class.dart';
import '../../../Model/sold_item_class.dart';
import '../../../Model/discount_class.dart';
import '../../../assets/widgets/POS_widgets/custom_item_list.dart';
import '../../../assets/widgets/POS_widgets/pos_cart.dart';
import '../../../assets/widgets/POS_widgets/search_bar.dart';
import '../../../assets/widgets/POS_widgets/sub_total.dart';
import '../../sevices/database/discount_table_helper.dart';
import '../../sevices/database/item_table_helper.dart';
import '../../sevices/database/soldItem_table_helper.dart';
import '../../sevices/printer_helper.dart';
import 'dashboard_page.dart';
import 'manage_item_pages/add_items.dart';
import 'manage_item_pages/add_items_page.dart';
import 'manage_item_pages/import_items.dart';

class PointofSalePage extends StatefulWidget {
  final bool showAppBar;
  final String eRole;

  PointofSalePage(this.showAppBar, {required this.eRole});

  @override
  _PointofSalePageState createState() => _PointofSalePageState();
}

class _PointofSalePageState extends State<PointofSalePage> {
  final SoldItemClassDatabaseHelper soldItemDBHelper = SoldItemClassDatabaseHelper();
  final ItemClassDatabaseHelper itemDBHelper = ItemClassDatabaseHelper();
  final DiscountClassDatabaseHelper discountDBHelper =
  DiscountClassDatabaseHelper();
  List<Item> cartItems = [];
  List<Item> filteredItems = [];
  List<Discount> discounts = []; // List to hold available discounts
  Discount? selectedDiscount; // Selected discount
  Timer? _timer;

  TextEditingController categoryController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItemsFromDatabase();
    _loadDiscounts();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    categoryController.addListener(_filterItems);
    nameController.addListener(_filterItems);
  }

  Future<void> _loadItemsFromDatabase() async {
    List<Item> items = await itemDBHelper.getAllItems();
    setState(() {
      ItemData.items = items;
      filteredItems = items;
    });
  }

  Future<void> _loadDiscounts() async {
    List<Discount> loadedDiscounts = await discountDBHelper.getDiscounts();
    setState(() {
      discounts = loadedDiscounts;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    categoryController.removeListener(_filterItems);
    nameController.removeListener(_filterItems);
    categoryController.dispose();
    nameController.dispose();
    super.dispose();
  }

  double getSubtotal() {
    double subtotal = cartItems.fold(0, (sum, item) {
      double price = double.parse(item.price);
      double margin = double.parse(item.margin.replaceAll('%', '')) / 100;
      int quantity = int.parse(item.quantity);

      double sellingPrice = price * (1 + margin);
      return sum + (sellingPrice * quantity);
    });
    if (selectedDiscount != null) {
      double discountAmount = subtotal * (selectedDiscount!.percentage / 100);
      subtotal -= discountAmount;
    }
    return subtotal;
  }

  void importItems() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImportItemsPage()),
    );
  }

  void addItem() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemPage()),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _filterItems() {
    String categoryQuery = categoryController.text.toLowerCase();
    String nameQuery = nameController.text.toLowerCase();

    setState(() {
      filteredItems = ItemData.items.where((item) {
        return item.category.toLowerCase().contains(categoryQuery) &&
            item.name.toLowerCase().contains(nameQuery);
      }).toList();
    });
  }

  void onItemTap(Item item) async {
    int newQuantity = int.parse(item.quantity) - 1;
    if (newQuantity > 0) {
      await itemDBHelper.updateItemQuantity(item.id!, newQuantity.toString());
    } else {
      await itemDBHelper.deleteItem(item.id!);
    }
    await _loadItemsFromDatabase();

    setState(() {
      int cartIndex = cartItems.indexWhere((cartItem) =>
      cartItem.id == item.id &&
          cartItem.name == item.name &&
          cartItem.category == item.category);

      if (cartIndex != -1) {
        Item cartItem = cartItems[cartIndex];
        int updatedQuantity = int.parse(cartItem.quantity) + 1;
        cartItems[cartIndex] = Item(
          id: cartItem.id,
          name: cartItem.name,
          price: cartItem.price,
          quantity: updatedQuantity.toString(),
          category: cartItem.category,
          margin: cartItem.margin,
        );
      } else {
        Item cartItem = Item(
          id: item.id,
          name: item.name,
          price: item.price,
          quantity: '1',
          category: item.category,
          margin: item.margin,
        );
        cartItems.add(cartItem);
      }
    });
  }

  void onRemoveItem(int index) async {
    Item item = cartItems[index];
    int existingQuantity =
    int.parse(ItemData.items.firstWhere((i) => i.id == item.id).quantity);
    int newQuantity = existingQuantity + int.parse(item.quantity);
    await itemDBHelper.updateItemQuantity(item.id!, newQuantity.toString());
    await _loadItemsFromDatabase();

    setState(() {
      cartItems.removeAt(index);
    });
  }

  Future<void> onCheckout() async {
    if (cartItems.isEmpty) {
      showErrorDialog('Cart is empty. Add items to checkout.');
      return;
    }

    // Show discount selection dialog
    selectedDiscount = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Discount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var discount in discounts)
                ListTile(
                  title: Text(discount.name),
                  subtitle: Text('${discount.percentage}% off'),
                  onTap: () {
                    Navigator.pop(context, discount);
                  },
                ),
              ListTile(
                title: Text('No Discount'),
                onTap: () {
                  Navigator.pop(context, null);
                },
              ),
            ],
          ),
        );
      },
    );

    // Perform checkout logic
    DateTime now = DateTime.now();
    for (Item item in cartItems) {
      SoldItem soldItem = SoldItem(
        item: item,
        date: now,
      );
      await soldItemDBHelper.insertSoldItem(soldItem);
    }
    await PrinterHelper.printReceipt(cartItems,getSubtotal());
    setState(() {
      cartItems.clear();
      selectedDiscount = null; // Reset selected discount after checkout
    });
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'No items available',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: importItems,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Import Items'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: addItem,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Item'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      drawer: CustomDrawer(
        onProfilePressed: () {},
        onAddItemPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddItem(showAppBar: true)),
          );
        },
        onLogoutPressed: () {
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
              "CHECK IN LIST length ${EmployeeCheckInData.checkIn.length}");
        },
        role: widget.eRole,
        onDashBoardPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(true)),
          );
        },
      ),
      appBar: widget.showAppBar
          ? AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Point of Sale',
              style: TextStyle(color: Colors.white),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  String barcodeScanRes =
                  await FlutterBarcodeScanner.scanBarcode(
                      "#ff6666", "Cancel", true, ScanMode.BARCODE);
                  if (barcodeScanRes != '-1') {
                    var item = Item(
                      id: null,
                      name: 'Sample Item',
                      category: 'Sample Category',
                      price: '10.00',
                      margin: '2.00',
                      quantity: '1',
                    );
                    ItemData.items.add(item);
                  }
                },
                child: const Icon(Icons.document_scanner_outlined),
              ),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      )
          : null,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Wrap(
                  spacing: 50,
                  children: [
                    CustomSearchBar(
                      controller: categoryController,
                      hintText: "search by category",
                    ),
                    CustomSearchBar(
                      controller: nameController,
                      hintText: "search by name",
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: filteredItems.isEmpty
                        ? buildEmptyState()
                        : ItemList(
                      filteredItems: filteredItems,
                      onItemTap: onItemTap,
                      showErrorDialog: showErrorDialog,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            color: primaryColor,
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Cart(
                      cartItems: cartItems,
                      onRemoveItem: onRemoveItem,
                    ),
                  ),
                ),
                Subtotal(
                  subtotal: getSubtotal(),
                  onCheckout: onCheckout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


