import 'package:app_store_db/model/enum/calender_type.dart';
import 'package:app_store_db/ui/chart/widget/liner_chart_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LineChartWidget bottomTitleWidgets tests', () {
    // Helper function to create a LineChartWidget instance for testing
    // We don't need actual spots data for testing bottomTitleWidgets,
    // but the constructor requires it.
    LineChartWidget createTestWidget({
      required CalenderType calenderType,
      required DateTime startDate,
      List<FlSpot>? spots, // Optional, defaults to a single spot
    }) {
      return LineChartWidget(
        spots: spots ?? [FlSpot(0, 1)], // Default dummy spots
        calenderType: calenderType,
        startDate: startDate,
      );
    }

    // Helper to extract text from SideTitleWidget
    String getTextFromSideTitleWidget(Widget widget) {
      if (widget is SideTitleWidget) {
        final child = widget.child;
        if (child is Text) {
          return child.data!;
        }
      }
      throw Exception('Widget is not a SideTitleWidget with a Text child');
    }

    // Mock TitleMeta
    const TitleMeta mockTitleMeta = TitleMeta(
      formattedValue: '',
      maxReservedWidth: 0,
      parentAxisSize: 0,
      appliedInterval: 0,
      axisPosition: 0,
      axisSide: AxisSide.bottom,
      creationMode: AxisCreationMode.manual,
    );

    group('CalenderType.c2w', () {
      final calenderType = CalenderType.c2w;
      final startDate = DateTime(2024, 1, 1); // Monday, Jan 1, 2024
      final testWidget =
          createTestWidget(calenderType: calenderType, startDate: startDate);

      test('label for index 0', () {
        // Index 0 corresponds to startDate (Jan 1)
        final widget = testWidget.bottomTitleWidgets(calenderType, 0, mockTitleMeta);
        expect(getTextFromSideTitleWidget(widget), '1/1');
      });

      test('label for mid-period index (e.g., index 7 - Jan 8)', () {
        // Index 7 corresponds to startDate + 7 days (Jan 8)
        final widget = testWidget.bottomTitleWidgets(calenderType, 7, mockTitleMeta);
        expect(getTextFromSideTitleWidget(widget), '1/8');
      });

      test('label for last day of 2 weeks (index 13 - Jan 14)', () {
        // Index 13 corresponds to startDate + 13 days (Jan 14)
        final widget = testWidget.bottomTitleWidgets(calenderType, 13, mockTitleMeta);
        expect(getTextFromSideTitleWidget(widget), '1/14');
      });
    });

    group('CalenderType.c1m', () {
      final calenderType = CalenderType.c1m;
      
      test('label for index 0 (Jan 1)', () {
        final startDate = DateTime(2024, 1, 1);
        final testWidget =
            createTestWidget(calenderType: calenderType, startDate: startDate);
        final widget = testWidget.bottomTitleWidgets(calenderType, 0, mockTitleMeta);
        // For c1m, index 0 (first day of month) should show M/d
        expect(getTextFromSideTitleWidget(widget), '1/1');
      });

      test('label for mid-month index (Jan 15, index 14)', () {
        final startDate = DateTime(2024, 1, 1);
        final testWidget =
            createTestWidget(calenderType: calenderType, startDate: startDate);
        // Index 14 corresponds to startDate + 14 days (Jan 15)
        final widget = testWidget.bottomTitleWidgets(calenderType, 14, mockTitleMeta);
        // Mid-month days show 'd'
        expect(getTextFromSideTitleWidget(widget), '15');
      });

      test('label for first day of a new month (Feb 1, index 0 of Feb period)', () {
        // Scenario: chart starts on Feb 1. Index 0 is Feb 1.
        final startDate = DateTime(2024, 2, 1);
        final testWidget =
            createTestWidget(calenderType: calenderType, startDate: startDate);
        final widget = testWidget.bottomTitleWidgets(calenderType, 0, mockTitleMeta);
        // Index 0, and it's the first day of the month, so M/d
        expect(getTextFromSideTitleWidget(widget), '2/1');
      });

       test('label for a day that is first of month but not index 0 (e.g. March 1st in a Jan-Mar range)', () {
        // This tests the specific logic: `currentDate.day == 1`
        // If startDate is Jan 1, and value makes currentDate March 1
        // Jan has 31 days, Feb has 29 days (2024 is leap)
        // So, March 1 is index 31 (for Jan) + 29 (for Feb) = 60
        final startDate = DateTime(2024, 1, 1); 
        final testWidget = createTestWidget(calenderType: calenderType, startDate: startDate);
        final widget = testWidget.bottomTitleWidgets(calenderType, 60, mockTitleMeta);
        // currentDate is March 1 (2024,3,1), so it should display 'M/d'
        expect(getTextFromSideTitleWidget(widget), '3/1');
      });

       test('label for a day that is NOT first of month and NOT index 0 (e.g. March 2nd)', () {
        final startDate = DateTime(2024, 1, 1); 
        final testWidget = createTestWidget(calenderType: calenderType, startDate: startDate);
        // March 2nd is index 61
        final widget = testWidget.bottomTitleWidgets(calenderType, 61, mockTitleMeta);
        // currentDate is March 2 (2024,3,2), so it should display 'd'
        expect(getTextFromSideTitleWidget(widget), '2');
      });
    });

    group('CalenderType.c1y', () {
      final calenderType = CalenderType.c1y;
      final startDate = DateTime(2024, 1, 1); // Start of the year
      final testWidget =
          createTestWidget(calenderType: calenderType, startDate: startDate);

      test('label for an index in January (e.g., Jan 15, index 14)', () {
        // Index 14 corresponds to Jan 15
        final widget = testWidget.bottomTitleWidgets(calenderType, 14, mockTitleMeta);
        expect(getTextFromSideTitleWidget(widget), 'Jan');
      });

      test('label for an index in July (e.g., July 1, index for July 1)', () {
        // Days: Jan 31, Feb 29 (2024), Mar 31, Apr 30, May 31, Jun 30
        // Total days before July = 31+29+31+30+31+30 = 182
        // So, July 1 is index 182
        final widget = testWidget.bottomTitleWidgets(calenderType, 182, mockTitleMeta);
        expect(getTextFromSideTitleWidget(widget), 'Jul');
      });

      test('label for an index in December (e.g. Dec 31)', () {
        // Dec 31 is index 365 for a leap year (2024)
        final widget = testWidget.bottomTitleWidgets(calenderType, 365, mockTitleMeta);
        expect(getTextFromSideTitleWidget(widget), 'Dec');
      });
    });
  });
}
```
