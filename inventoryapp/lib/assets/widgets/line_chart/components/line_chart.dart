import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventoryapp/Utils/constants.dart';

class MyLineChart extends StatelessWidget {
  final List<FlSpot> spots;

  const MyLineChart({Key? key, required this.spots}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxYValue = calculateMaxY(spots);

    return AspectRatio(
      aspectRatio: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          _mainData(spots, maxYValue),
        ),
      ),
    );
  }

  double calculateMaxY(List<FlSpot> spots) {
    double maxSumPrice = 0;

    Map<int, double> sumPricesByDay = {};
    for (FlSpot spot in spots) {
      int day = spot.x.toInt();
      double price = spot.y;
      sumPricesByDay[day] = (sumPricesByDay[day] ?? 0) + price;
    }
    sumPricesByDay.values.forEach((price) {
      if (price > maxSumPrice) {
        maxSumPrice = price;
      }
    });
    return maxSumPrice;
  }

  LineChartData _mainData(List<FlSpot> spots, double maxYValue) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: const LineTouchTooltipData(),
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: const FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: _bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: _leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false, // Don't show border
      ),
      minX: 1,
      maxX: 30,
      minY: 0,
      maxY: maxYValue+500,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: primaryColor.withOpacity(0.5),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (FlSpot spot, double? xPercentage, LineChartBarData barData, int index) {
              return FlDotCirclePainter(
                radius: 6,
                strokeWidth: 2,
                color: primaryColor,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case 2:
        text = const Text('2', style: style);
        break;
      case 3:
        text = const Text('3', style: style);
        break;
      case 4:
        text = const Text('4', style: style);
        break;
      case 5:
        text = const Text('5', style: style);
        break;
      case 6:
        text = const Text('6', style: style);
        break;
      case 7:
        text = const Text('7', style: style);
        break;
      case 8:
        text = const Text('8', style: style);
        break;
      case 9:
        text = const Text('9', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;
      case 11:
        text = const Text('11', style: style);
        break;
      case 12:
        text = const Text('12', style: style);
        break;
      case 13:
        text = const Text('13', style: style);
        break;
      case 14:
        text = const Text('14', style: style);
        break;
      case 15:
        text = const Text('15', style: style);
        break;
      case 16:
        text = const Text('16', style: style);
        break;
      case 17:
        text = const Text('17', style: style);
        break;
      case 18:
        text = const Text('18', style: style);
        break;
      case 19:
        text = const Text('19', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 21:
        text = const Text('21', style: style);
        break;
      case 22:
        text = const Text('22', style: style);
        break;
      case 23:
        text = const Text('23', style: style);
        break;
      case 24:
        text = const Text('24', style: style);
        break;
      case 25:
        text = const Text('25', style: style);
        break;
      case 26:
        text = const Text('26', style: style);
        break;
      case 27:
        text = const Text('27', style: style);
        break;
      case 28:
        text = const Text('28', style: style);
        break;
      case 29:
        text = const Text('29', style: style);
        break;
      case 30:
        text = const
        Text('30', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }


    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    if (value == 0) {
      text = '0.0';
    } else {
      return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}