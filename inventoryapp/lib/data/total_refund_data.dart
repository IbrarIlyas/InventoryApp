import 'package:fl_chart/fl_chart.dart';

import '../Model/Refunded_Items.dart';
import '../sevices/database/refunded_table_helper.dart';

class GrossRefundData {
  static final List<FlSpot> dataList = [];
}

Future<void> grossRefundValue(int month, int year) async {
  final RefundedItemClassDatabaseHelper refundedItemDBHelper = RefundedItemClassDatabaseHelper();
  Map<DateTime, double> refundMap = {};

  final lastDayOfMonth = DateTime(year, month + 1, 0).day;

  // Initialize the refundMap with zeros for each day of the specified month
  for (int day = 1; day <= lastDayOfMonth; day++) {
    refundMap[DateTime(year, month, day)] = 0.0;
  }

  // Get the refunded items for the specified month and year
  final List<RefundedItem> refundedItemsList = await refundedItemDBHelper.getRefundedItemsByMonthAndYear(month, year);
  for (RefundedItem refundedItem in refundedItemsList) {
    final DateTime date = DateTime(refundedItem.date.year, refundedItem.date.month, refundedItem.date.day);

    double costPrice = double.parse(refundedItem.item.price);
    double margin = double.parse(refundedItem.item.margin.replaceAll('%', '')) / 100;
    double quantity = double.parse(refundedItem.item.quantity);

    double sellingPrice = costPrice * (1 + margin);
    double totalRefund = sellingPrice * quantity;

    // Update the refundMap for the specific date
    refundMap.update(date, (value) => value + totalRefund);
  }

  // Clear the previous data in GrossRefundData.dataList
  GrossRefundData.dataList.clear();

  // Populate GrossRefundData.dataList with the refund values for each day of the month
  for (int day = 1; day <= lastDayOfMonth; day++) {
    final date = DateTime(year, month, day);
    GrossRefundData.dataList.add(FlSpot(day.toDouble(), refundMap[date]!));
  }
}