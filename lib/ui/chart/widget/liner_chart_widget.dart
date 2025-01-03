import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../model/enum/calender_type.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget(
      {super.key, required this.spots, required this.calenderType});

  final List<FlSpot> spots;
  final CalenderType calenderType;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 1,
        maxX: _getMaxX(calenderType),
        minY: 1,
        maxY: 100,
      );

  double _getMaxX(CalenderType calenderType) {
    switch (calenderType) {
      case CalenderType.c2w:
        return 14;
      case CalenderType.c1m:
        return 31;
      case CalenderType.c6m:
        return 184;
      case CalenderType.c1y:
        return 365;
      case CalenderType.c5y:
        return 1825;
    }
  }

  LineTouchData get lineTouchData => LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              return LineTooltipItem(
                '${touchedSpot.y.toInt()}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData => [
        // lineChartBarData2_1,
        // lineChartBarData2_2,
        // lineChartBarData2_3,
        lineChartBarData_A,
      ];

  LineChartBarData get lineChartBarData_A => lineChartBarData(
        spots: spots,
        color: Colors.cyan.withValues(alpha: 0.5),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 25:
        text = '25';
        break;
      case 50:
        text = '50';
        break;
      case 75:
        text = '75';
        break;
      case 100:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(
      CalenderType calenderType, double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    String text = value.toInt().toString();
    if (calenderType == CalenderType.c2w) {
      switch (value.toInt()) {
        case 2:
          text = '2';
          break;
        case 4:
          text = '4';
          break;
        case 6:
          text = '6';
          break;
        case 8:
          text = '8';
          break;
        case 10:
          text = '10';
          break;
        case 12:
          text = '12';
          break;
        case 14:
          text = '14';
          break;
        default:
          text = '';
      }
    } else if (calenderType == CalenderType.c1m) {
      switch (value.toInt()) {
        case 1:
          text = '1';
          break;
        case 5:
          text = '5';
          break;
        case 10:
          text = '10';
          break;
        case 15:
          text = '15';
          break;
        case 20:
          text = '20';
          break;
        case 25:
          text = '25';
          break;
        case 30:
          text = '30';
          break;
      }
    } else if (calenderType == CalenderType.c6m) {
      switch (value.toInt()) {
        case 1:
          text = '1';
          break;
        case 2:
          text = '2';
          break;
        case 3:
          text = '3';
          break;
        case 4:
          text = '4';
          break;
        case 5:
          text = '5';
          break;
        case 6:
          text = '6';
          break;
      }
    } else if (calenderType == CalenderType.c1y) {
      switch (value.toInt()) {
        case 1:
          text = '1';
          break;
        case 2:
          text = '2';
          break;
        case 3:
          text = '3';
          break;
        case 4:
          text = '4';
          break;
        case 5:
          text = '5';
          break;
        case 6:
          text = '6';
          break;
        case 7:
          text = '7';
          break;
        case 8:
          text = '8';
          break;
        case 9:
          text = '9';
          break;
        case 10:
          text = '10';
          break;
        case 11:
          text = '11';
          break;
        case 12:
          text = '12';
          break;
      }
    } else if (calenderType == CalenderType.c5y) {
      switch (value.toInt()) {
        case 1:
          text = '1';
          break;
        case 2:
          text = '2';
          break;
        case 3:
          text = '3';
          break;
        case 4:
          text = '4';
          break;
        case 5:
          text = '5';
          break;
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, meta) =>
            bottomTitleWidgets(calenderType, value, meta),
      );

  FlGridData get gridData => FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: 25,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 0.25,
            dashArray: [5, 5],
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 0.25,
            dashArray: [5, 5],
          );
        },
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
      );

  LineChartBarData lineChartBarData({
    required List<FlSpot> spots,
    required Color color,
  }) =>
      LineChartBarData(
        isCurved: false,
        curveSmoothness: 0,
        color: color,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 6,
            color: color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          ),
        ),
        belowBarData: BarAreaData(show: false),
        spots: spots,
      );

  // List<FlSpot> get spot_1 => [
  //       FlSpot(1, 10),
  //       FlSpot(3, 12),
  //       FlSpot(5, 14),
  //       FlSpot(7, 34),
  //       FlSpot(10, 20),
  //       FlSpot(12, 22),
  //     ];

  // List<FlSpot> get spot_2 => [
  //       FlSpot(1, 38),
  //       FlSpot(3, 19),
  //       FlSpot(6, 5),
  //       FlSpot(10, 33),
  //     ];

  // List<FlSpot> get spot_3 => [
  //       FlSpot(1, 15),
  //       FlSpot(6, 25),
  //       FlSpot(12, 38),
  //     ];

  // LineChartBarData get lineChartBarData2_1 => lineChartBarData(
  //       spots: spot_1,
  //       color: Colors.cyan.withValues(alpha: 0.5),
  //     );
  // LineChartBarData get lineChartBarData2_2 => lineChartBarData(
  //       spots: spot_2,
  //       color: Colors.cyan.withValues(alpha: 0.5),
  //     );
  // LineChartBarData get lineChartBarData2_3 => lineChartBarData(
  //       spots: spot_3,
  //       color: Colors.cyan.withValues(alpha: 0.5),
  //     );
}
