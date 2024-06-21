import 'package:flutter/material.dart';
import '../../../Model/discount_class.dart';
import '../../../assets/widgets/discount_card.dart';
import '../../../sevices/database/discount_table_helper.dart';
import 'add_discount.dart';

class DiscountPage extends StatefulWidget {
  DiscountPage({Key? key}) : super(key: key);

  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  late Future<List<Discount>> _discountsFuture;

  @override
  void initState() {
    super.initState();
    _discountsFuture = DiscountClassDatabaseHelper().getDiscounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: FutureBuilder<List<Discount>>(
        future: _discountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No discounts available.'));
          } else {
            final discounts = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: discounts.length + 1, // Adding 1 for the add button card
              itemBuilder: (context, index) {
                if (index == discounts.length) {
                  return DiscountCardWidget(
                    onAddPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddDiscountPage()),
                      );
                      setState(() {
                        _discountsFuture = DiscountClassDatabaseHelper().getDiscounts();
                      });
                    },
                    onDeletePressed: () {}, // This should be handled in the DiscountCardWidget
                  );
                } else {
                  return DiscountCardWidget(
                    discount: discounts[index],
                    onDeletePressed: () async {
                      await DiscountClassDatabaseHelper().deleteDiscount(discounts[index].id!);
                      setState(() {
                        _discountsFuture = DiscountClassDatabaseHelper().getDiscounts();
                      });
                    },
                    onAddPressed: () {}, // This should be handled in the DiscountCardWidget
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
