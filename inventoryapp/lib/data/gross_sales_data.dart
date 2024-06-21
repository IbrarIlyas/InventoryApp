import 'package:fl_chart/fl_chart.dart';
import 'package:inventoryapp/Model/sold_item_class.dart';
import '../sevices/database/soldItem_table_helper.dart';

class GrossSalesData {
  static final List<FlSpot> dataList = [];
}

Future<void> grossSalesValue(int month, int year) async {
  final SoldItemClassDatabaseHelper soldItemDBHelper = SoldItemClassDatabaseHelper();
  Map<DateTime, double> cartMap = {};

  final currentDate = DateTime.now();
  final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;

  for (int day = 1; day <= lastDayOfMonth; day++) {
    cartMap[DateTime(currentDate.year, currentDate.month, day)] = 0.0;
  }

  final List<SoldItem> soldItemsList = await soldItemDBHelper.getSoldItemsByMonthAndYear(month, year);
  for (SoldItem soldItem in soldItemsList) {
    final DateTime date = DateTime(soldItem.date.year, soldItem.date.month, soldItem.date.day);

    double costPrice = double.parse(soldItem.item.price);
    double margin = double.parse(soldItem.item.margin.replaceAll('%', '')) / 100;
    double quantity = double.parse(soldItem.item.quantity);

    double sellingPrice = costPrice * (1 + margin);
    double totalSales = sellingPrice * quantity;
    double totalCost = costPrice * quantity;
    double totalProfit = totalSales - totalCost;

    cartMap.update(date, (value) => value + totalSales);
  }

  GrossSalesData.dataList.clear();

  for (int day = 1; day <= lastDayOfMonth; day++) {
    final date = DateTime(currentDate.year, currentDate.month, day);
    GrossSalesData.dataList.add(FlSpot(day.toDouble(), cartMap[date]!));
  }
}
