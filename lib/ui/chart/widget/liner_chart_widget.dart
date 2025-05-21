import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/enum/calender_type.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget(
      {super.key,
      required this.spots,
      required this.calenderType,
      required this.startDate});

  final List<FlSpot> spots;
  final CalenderType calenderType;
  final DateTime startDate;

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

  LineChartData get sampleData {
    double minX = 0.0;
    double maxX;

    // Calculate maxX based on calenderType and startDate
    // This logic should mirror the calculation in generateChartData for consistency.
    switch (calenderType) {
      case CalenderType.c2w:
        // Duration is 14 days, so 0 to 13.
        maxX = 13.0;
        break;
      case CalenderType.c1m:
        // Number of days in the month of startDate.
        // The x values range from 0 to (daysInMonth - 1).
        final daysInMonth =
            DateTime(startDate.year, startDate.month + 1, 0).day;
        maxX = (daysInMonth - 1).toDouble();
        break;
      case CalenderType.c1y:
        // Number of days in the year of startDate.
        // The x values range from 0 to (daysInYear - 1).
        final lastDayOfYear = DateTime(startDate.year, 12, 31);
        final firstDayOfYear = DateTime(startDate.year, 1, 1);
        maxX = lastDayOfYear.difference(firstDayOfYear).inDays.toDouble();
        break;
    }
    // Ensure maxX is always greater than minX, even if startDate is at the end of a period
    // or if the period is very short.
     if (maxX <= minX && spots.isNotEmpty) { // If spots exist, maxX should be at least spots.last.x or period length
        // Heuristic: if spots are present, ensure maxX can accommodate them.
        // However, the primary logic is period-based.
        // If spots go beyond calculated maxX (should not happen with correct generateChartData),
        // this might need adjustment, but ideally generateChartData ensures spots are within 0 to maxX.
        maxX = minX + 1; // Fallback to ensure chart can render.
    } else if (maxX <= minX) {
        maxX = minX + 1; // Default fallback for empty spots or very short periods
    }


    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: lineBarsData,
      minX: minX,
      maxX: maxX,
      minY: 1, // Assuming rank is always >= 1
      maxY: 100, // Assuming rank is always <= 100
    );
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
    final DateTime currentDate = startDate.add(Duration(days: value.toInt()));
    String text;

    switch (calenderType) {
      case CalenderType.c2w:
        text = DateFormat('M/d').format(currentDate);
        break;
      case CalenderType.c1m:
        text = DateFormat('d').format(currentDate);
        // Optionally, show M/d for first label or if month changes
        if (value == 0 || currentDate.day == 1) {
          text = DateFormat('M/d').format(currentDate);
        }
        break;
      case CalenderType.c1y:
        text = DateFormat('MMM').format(currentDate);
        break;
      default:
        text = '';
        break;
    }

    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10, // Reduced font size for more labels
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4, // Reduced space
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  double get _bottomTitlesInterval {
    double minValX = 0.0;
    double maxValX;

    switch (calenderType) {
      case CalenderType.c2w:
        maxValX = 13.0;
        return 2.0; // Show label every 2 days for 2 weeks
      case CalenderType.c1m:
        final daysInMonth =
            DateTime(startDate.year, startDate.month + 1, 0).day;
        maxValX = (daysInMonth - 1).toDouble();
        // Aim for 4-5 labels (e.g., weekly)
        return (maxValX / 4).roundToDouble().clamp(1.0, 7.0);
      case CalenderType.c1y:
        final lastDayOfYear = DateTime(startDate.year, 12, 31);
        final firstDayOfYear = DateTime(startDate.year, 1, 1);
        maxValX = lastDayOfYear.difference(firstDayOfYear).inDays.toDouble();
        // Aim for 12 labels (monthly)
        return (maxValX / 11).roundToDouble().clamp(1.0, 31.0); // Use 11 to get 12 intervals for 12 months
      default:
        // Fallback, though all CalenderType cases should be handled.
        // This calculation might need to use the actual minX and maxX from sampleData if they were dynamic.
        // Since they are now fixed based on calenderType, this can also be fixed.
        maxValX = 13.0; // Defaulting to 2W range for safety.
        return (maxValX / 5).roundToDouble().clamp(1.0, 5.0);
    }
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: _bottomTitlesInterval,
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
