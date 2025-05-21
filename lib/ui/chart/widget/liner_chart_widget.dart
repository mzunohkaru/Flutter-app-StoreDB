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
    if (spots.isEmpty) {
      return const Center(child: Text('データがありません'));
    }

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
        minX: spots.isNotEmpty ? spots.first.x : 0,
        maxX: spots.isNotEmpty ? spots.last.x : 0,
        minY: 1,
        maxY: 100,
      );

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
    final int intValue = value.toInt();
    if (intValue == 1 || intValue == 100) {
      text = intValue.toString();
    } else if (intValue % 10 == 0 && intValue > 1 && intValue < 100) {
      text = intValue.toString();
    } else {
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

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(value.toStringAsFixed(2),
          style: style, textAlign: TextAlign.center),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: (spots.last.x - spots.first.x) / 5 <= 0
            ? 1
            : (spots.last.x - spots.first.x) / 5,
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
}
