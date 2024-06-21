import 'package:flutter/material.dart';
import 'package:inventoryapp/Utils/constants.dart';
import 'package:inventoryapp/data/gross_profit_data.dart';
import 'package:inventoryapp/data/gross_sales_data.dart';
import 'package:inventoryapp/data/total_refund_data.dart';
import '../../../assets/widgets/data_table.dart';
import '../../../assets/widgets/line_chart/chart_box.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget {
  bool showAppBar = false;

  DashboardPage(this.showAppBar);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(microseconds: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
        title: Text('Dashboard'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      )
          : null,
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Material(
                elevation: 10,
                child: Container(
                  height: 600,
                  padding: const EdgeInsets.all(16),
                  width: widget.showAppBar
                      ? MediaQuery.of(context).size.width - 100
                      : MediaQuery.of(context).size.width - 400,
                  color: Colors.white,
                  child: MyGraph(),
                ),
              ),
              const SizedBox(height: 20),
              Material(
                elevation: 10,
                child: Container(
                  height: 600,
                  padding: const EdgeInsets.all(16),
                  width: widget.showAppBar
                      ? MediaQuery.of(context).size.width - 100
                      : MediaQuery.of(context).size.width - 400,
                  color: Colors.white,
                  child: MyDataTable(
                    grossSalesSpots: GrossSalesData.dataList,
                    grossProfitSpots: GrossProfitData.dataList,
                    grossRefundSpots:GrossRefundData.dataList,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
