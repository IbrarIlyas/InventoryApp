import 'package:flutter/material.dart';
import 'package:inventoryapp/data/gross_profit_data.dart';
import 'package:inventoryapp/data/total_refund_data.dart';
import '../../../data/gross_sales_data.dart';
import '../drop_down.dart';
import 'components/data_selection_button.dart';
import 'components/line_chart.dart';

class MyGraph extends StatefulWidget {
  @override
  _MyGraphState createState() => _MyGraphState();
}

class _MyGraphState extends State<MyGraph> {
  String? selectedOption = 'Gross Sales';
  String selectedMonth = 'Months';
  String selectedYear = 'Year';
  List<String> years = ['Year'];

  @override
  void initState() {
    super.initState();
    // Initialize the years list with the range 2023 to 2050
    for (int i = 2023; i <= 2050; i++) {
      years.add(i.toString());
    }

    try {
      grossSalesValue(DateTime.now().month, DateTime.now().year);
      grossValue(DateTime.now().month, DateTime.now().year);
      grossRefundValue(DateTime.now().month, DateTime.now().year);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.green[50],
            title: const Text('Error'),
            shape: const RoundedRectangleBorder(),
            icon: const Icon(Icons.error, size: 20),
            iconColor: Colors.red,
          );
        },
      );
    }
    for (int i = 0; i < GrossSalesData.dataList.length; i++) {
      print("x: ${GrossSalesData.dataList[i].x}  y: ${GrossSalesData.dataList[i].y} ");
    }
  }

  void updateChartData(String month, String year,String? option) {
    setState(() {
      selectedMonth = month;
      selectedYear = year;
      int monthNumber = getMonthNumber(month);
      if (year=="Year")
        {
          year=DateTime.now().year.toString();
        }
      int yearNumber = int.parse(year);


      // Update the data based on the selected month and year
      if (monthNumber != 0 && yearNumber != 0) {
        try {
          if (option=='Gross Sales') {
            print("function1");
            grossSalesValue(monthNumber, yearNumber);
          }else if(option=='Gross Profit' )
          {
            print("Function2");
            grossValue(monthNumber, yearNumber);
          }else if(option=='Total amount of Refund Today')
            {
              print("Function3");
              grossRefundValue(monthNumber, yearNumber);
            }
          else
            {
              print("Else Condition");
            }
        } catch (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.green[50],
                title: const Text('Error'),
                shape: const RoundedRectangleBorder(),
                icon: const Icon(Icons.error, size: 20),
                iconColor: Colors.red,
              );
            },
          );
        }
      }
    });
  }

  int getMonthNumber(String month) {
    switch (month) {
      case "January":
        return 1;
      case "February":
        return 2;
      case "March":
        return 3;
      case "April":
        return 4;
      case "May":
        return 5;
      case "June":
        return 6;
      case "July":
        return 7;
      case "August":
        return 8;
      case "September":
        return 9;
      case "October":
        return 10;
      case "November":
        return 11;
      case "December":
        return 12;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: DataSelectionButton(
                  option: 'Gross Sales\n€0.0\n€0.00 (0%)',
                  isSelected: selectedOption == 'Gross Sales',
                  onPressed: () {
                    setState(() {
                      selectedOption = 'Gross Sales';
                      updateChartData(selectedMonth, selectedYear,selectedOption);
                    });
                  },
                ),
              ),
              Expanded(
                child: DataSelectionButton(
                  option: 'Refunds\n€0.0\n€0.00 (0%)',
                  isSelected: selectedOption == 'Total amount of Refund Today',
                  onPressed: () {
                    setState(() {
                      selectedOption = 'Total amount of Refund Today';
                      updateChartData(selectedMonth, selectedYear,selectedOption);
                    });
                  },
                ),
              ),
              Expanded(
                child: DataSelectionButton(
                  option: 'Gross Profit\n€0.0\n€0.00 (0%)',
                  isSelected: selectedOption == 'Gross Profit',
                  onPressed: () {
                    setState(() {
                      selectedOption = 'Gross Profit';
                      updateChartData(selectedMonth, selectedYear,selectedOption);
                    });
                  },
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedOption!),
              Row(
                children: [
                  MyDropDown(
                    selectedItem: selectedMonth,
                    items: const [
                      "Months",
                      "January",
                      "February",
                      "March",
                      "April",
                      "May",
                      "June",
                      "July",
                      "August",
                      "September",
                      "October",
                      "November",
                      "December"
                    ],
                    onChanged: (value) {
                      if (value != "Months" || selectedYear != "Year") {
                        updateChartData(value, selectedYear,selectedOption);
                      }
                    },
                  ),
                  MyDropDown(
                    selectedItem: selectedYear,
                    items: years,
                    onChanged: (value) {
                      if (value != "Year" || selectedMonth != "Months") {
                        updateChartData(selectedMonth, value,selectedOption);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: MyLineChart(spots: selectedOption=="Gross Sales"?GrossSalesData.dataList:selectedOption=="Gross Profit"?GrossProfitData.dataList:GrossRefundData.dataList),
              ),
            ),
          ),
        ],
      ),
    );
  }
}