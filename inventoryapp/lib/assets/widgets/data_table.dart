import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventoryapp/Utils/constants.dart';
import 'package:inventoryapp/data/total_refund_data.dart';

class MyDataTable extends StatefulWidget {
  final List<FlSpot> grossSalesSpots;
  final List<FlSpot> grossProfitSpots;
  final List<FlSpot> grossRefundSpots;

  const MyDataTable({
    super.key,
    required this.grossSalesSpots,
    required this.grossProfitSpots,
    required this.grossRefundSpots,
  });

  @override
  State<MyDataTable> createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: DataTable(
            columnSpacing: 90,
            headingRowColor: MaterialStateProperty.all(primaryColor),
            columns: const [
              DataColumn(
                label: Text(
                  'Date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Gross Sales',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Refund',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Gross Profit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            rows: widget.grossSalesSpots.asMap().entries.map((entry) {
              int index = entry.key;
              FlSpot grossSaleSpot = entry.value;
              FlSpot grossProfitSpot = widget.grossProfitSpots[index];
              FlSpot grossRefundSpot = widget.grossRefundSpots[index];

              return DataRow(
                color: WidgetStateProperty.all<Color>(
                  index % 2 == 0
                      ? primaryColor.withOpacity(0.1)
                      : Colors.white,
                ),
                cells: [
                  DataCell(Text(grossSaleSpot.x.toStringAsFixed(0))), // Date column
                  DataCell(Text(grossSaleSpot.y.toStringAsFixed(2))), // Gross Sale column
                  DataCell(Text(grossRefundSpot.y.toStringAsFixed(2))), // Placeholder for Refund column
                  DataCell(Text(grossProfitSpot.y.toStringAsFixed(2))), // Gross Profit column
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
