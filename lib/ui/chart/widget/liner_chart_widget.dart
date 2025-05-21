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
    final validSpots = spots.where((spot) => spot != FlSpot.nullSpot).toList();

    // Determine minX and maxX based on validSpots
    double minX = 0;
    double maxX = 10; // Default if no valid spots, adjust as needed

    if (validSpots.isNotEmpty) {
      minX = validSpots.first.x; // Assumes spots are sorted by x before filtering
      maxX = validSpots.last.x;  // Assumes spots are sorted by x before filtering
      // Ensure maxX is greater than minX, if only one valid spot, make maxX slightly larger
      if (maxX <= minX) {
        maxX = minX + 1; 
      }
    } else if (spots.isNotEmpty) {
      // All spots are FlSpot.nullSpot
      // Default range based on the total number of spots (days in period)
      minX = 0;
      maxX = spots.length.toDouble() -1; 
      if (maxX < minX) { // handles spots.length == 1 (all null)
        maxX = minX +1; 
      }
    }
    // If spots itself is empty, build() method returns early.
    // Final safety check if above logic results in maxX <= minX (e.g. spots.length == 0 somehow bypassed build check)
    if (maxX <= minX) {
        maxX = minX + 1;
    }

    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: lineBarsData,
      minX: minX,
      maxX: maxX,
      minY: 1,
      maxY: 100,
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
    final validSpots = spots.where((spot) => spot.y != null && spot != FlSpot.nullSpot).toList();
    if (validSpots.isEmpty) {
      return 1;
    }
    // Ensure spots are sorted by x if not already guaranteed
    // validSpots.sort((a, b) => a.x.compareTo(b.x));
    
    double minX = double.maxFinite;
    double maxX = double.minPositive;

    for (final spot in validSpots) {
      if (spot.x < minX) minX = spot.x;
      if (spot.x > maxX) maxX = spot.x;
    }

    if (minX == double.maxFinite || maxX == double.minPositive) return 1; // no valid spots found

    final xRange = maxX - minX;

    if (xRange <= 0) {
      return 1;
    }

    switch (calenderType) {
      case CalenderType.c1y:
        // Aim for roughly 12 labels (monthly)
        // Max days in a year is 366. Interval should be around 30.
        // XRange is number of days.
        return (xRange / 12).roundToDouble().clamp(1.0, 30.0); 
      case CalenderType.c1m:
        // Aim for 4-5 labels (weekly)
        // XRange is number of days in month (28-31)
        return (xRange / 4).roundToDouble().clamp(1.0, 7.0);
      case CalenderType.c2w:
        // Aim for 7 labels (every other day)
        // XRange is 13 days
        return (xRange / 7).roundToDouble().clamp(1.0, 2.0);
      default:
        return (xRange / 5).roundToDouble().clamp(1.0, 5.0);
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
