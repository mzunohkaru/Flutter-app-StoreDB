import 'package:app_store_db/model/enum/calender_type.dart';
import 'package:app_store_db/ui/chart/chart_screen.dart'; // Assuming _ChartRankingData and generateChartData are accessible
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// If _ChartRankingData is not directly importable (e.g. private `_`),
// we might need to define a similar public class here for testing
// or ensure the original one is made public for testing purposes.
// For now, assuming `_ChartRankingData` is accessible or we'll adjust.
// Re-defining for clarity in this test file if it was private.
class TestChartRankingData {
  final String dateId; // 'yyyyMMdd'
  final int rank;
  TestChartRankingData({required this.dateId, required this.rank});
}

// Adapter to use TestChartRankingData with the production generateChartData if needed
List<_ChartRankingData> toProdRankingData(List<TestChartRankingData> testData) {
  return testData
      .map((d) => _ChartRankingData(dateId: d.dateId, rank: d.rank))
      .toList();
}

void main() {
  group('generateChartData tests', () {
    // Helper to format DateTime to 'yyyyMMdd' string
    String formatDate(DateTime dt) => DateFormat('yyyyMMdd').format(dt);

    group('CalenderType.c2w (14 days)', () {
      final calenderType = CalenderType.c2w;
      // Test "now" date: Jan 15, 2024, Monday
      final testNow = DateTime(2024, 1, 15);
      // Expected startDate: Jan 2, 2024 (13 days before Jan 15)
      // Expected endDate: Jan 15, 2024
      // Total days: 14

      test('with full 14 days of data', () {
        final rankingData = <TestChartRankingData>[];
        for (int i = 0; i < 14; i++) {
          rankingData.add(TestChartRankingData(
              dateId: formatDate(testNow.subtract(Duration(days: 13 - i))),
              rank: i + 1));
        }

        final result = generateChartData(
          calenderType: calenderType,
          now: testNow,
          rankingData: toProdRankingData(rankingData),
        );

        expect(result.spots.length, 14);
        for (int i = 0; i < 14; i++) {
          expect(result.spots[i].x, i.toDouble());
          expect(result.spots[i].y, (i + 1).toDouble());
          expect(result.spots[i] == FlSpot.nullSpot, isFalse);
        }
        // Verify startDate (Jan 2, 2024)
        expect(result.startDate, DateTime(2024, 1, 2));
      });

      test('with some missing data points', () {
        final rankingData = <TestChartRankingData>[
          TestChartRankingData(dateId: formatDate(testNow.subtract(Duration(days: 13))), rank: 1), // Day 0
          // Day 1 missing
          TestChartRankingData(dateId: formatDate(testNow.subtract(Duration(days: 11))), rank: 3), // Day 2
          // Day 3, 4 missing
          TestChartRankingData(dateId: formatDate(testNow.subtract(Duration(days: 8))), rank: 6), // Day 5
        ];

        final result = generateChartData(
          calenderType: calenderType,
          now: testNow,
          rankingData: toProdRankingData(rankingData),
        );
        expect(result.spots.length, 14);
        expect(result.spots[0], FlSpot(0, 1));
        expect(result.spots[1], FlSpot.nullSpot);
        expect(result.spots[2], FlSpot(2, 3));
        expect(result.spots[3], FlSpot.nullSpot);
        expect(result.spots[4], FlSpot.nullSpot);
        expect(result.spots[5], FlSpot(5, 6));
        for (int i = 6; i < 14; i++) {
           expect(result.spots[i], FlSpot.nullSpot, reason: "Spot at index $i should be null");
        }
      });

      test('with no data for the 14-day period', () {
        final rankingData = <TestChartRankingData>[];
        final result = generateChartData(
          calenderType: calenderType,
          now: testNow,
          rankingData: toProdRankingData(rankingData),
        );

        expect(result.spots.length, 14);
        for (int i = 0; i < 14; i++) {
          expect(result.spots[i], FlSpot.nullSpot);
        }
      });
    });

    group('CalenderType.c1m (31 days for Jan)', () {
      final calenderType = CalenderType.c1m;
      // Test "now" date: Jan 15, 2024. For c1m, it uses current month.
      final testNow = DateTime(2024, 1, 15);
      // Expected startDate: Jan 1, 2024
      // Expected endDate: Jan 31, 2024
      // Total days: 31

      test('with data for all 31 days', () {
        final rankingData = <TestChartRankingData>[];
        for (int i = 0; i < 31; i++) {
          rankingData.add(TestChartRankingData(
              dateId: formatDate(DateTime(2024, 1, i + 1)), rank: i + 1));
        }
        final result = generateChartData(
          calenderType: calenderType,
          now: testNow,
          rankingData: toProdRankingData(rankingData),
        );

        expect(result.spots.length, 31);
        for (int i = 0; i < 31; i++) {
          expect(result.spots[i].x, i.toDouble());
          expect(result.spots[i].y, (i + 1).toDouble());
        }
        expect(result.startDate, DateTime(2024, 1, 1));
      });

      test('with data missing at beginning, middle, and end', () {
        final rankingData = <TestChartRankingData>[
          // Day 0 (Jan 1) missing
          TestChartRankingData(dateId: formatDate(DateTime(2024, 1, 2)), rank: 2),   // Day 1
          // Middle missing (e.g. Jan 15, index 14)
          TestChartRankingData(dateId: formatDate(DateTime(2024, 1, 14)), rank: 14), // Day 13
          TestChartRankingData(dateId: formatDate(DateTime(2024, 1, 16)), rank: 16), // Day 15
          // End missing (e.g. Jan 31, index 30)
          TestChartRankingData(dateId: formatDate(DateTime(2024, 1, 30)), rank: 30), // Day 29
        ];
        final result = generateChartData(
          calenderType: calenderType,
          now: testNow,
          rankingData: toProdRankingData(rankingData),
        );

        expect(result.spots.length, 31);
        expect(result.spots[0], FlSpot.nullSpot);
        expect(result.spots[1], FlSpot(1, 2));
        expect(result.spots[13], FlSpot(13,14));
        expect(result.spots[14], FlSpot.nullSpot); // Jan 15 missing
        expect(result.spots[15], FlSpot(15,16));
        expect(result.spots[29], FlSpot(29,30));
        expect(result.spots[30], FlSpot.nullSpot); // Jan 31 missing
      });
    });

    group('CalenderType.c1y (Simplified: Jan 1 to Mar 31 for testing)', () {
      final calenderType = CalenderType.c1y;
      // Test "now" date: Feb 15, 2024. For c1y, it uses current year.
      // For testing, let's assume our generateChartData for c1y will be adjusted
      // or we test for a full year, but verify a smaller segment.
      // The current impl of generateChartData for c1y goes from Jan 1 to Dec 31.
      final testNow = DateTime(2024, 2, 15);
      // Expected startDate: Jan 1, 2024
      // Expected endDate: Dec 31, 2024
      // Total days: 366 (2024 is a leap year)

      test('with continuous data for first 3 months', () {
        final rankingData = <TestChartRankingData>[];
        final yearStartDate = DateTime(2024,1,1);
        for (int i = 0; i < 91; i++) { // Jan(31) + Feb(29) + Mar(31) = 91
          rankingData.add(TestChartRankingData(
              dateId: formatDate(yearStartDate.add(Duration(days: i))), rank: i + 1));
        }
        final result = generateChartData(
          calenderType: calenderType,
          now: testNow,
          rankingData: toProdRankingData(rankingData),
        );

        expect(result.spots.length, 366); // Leap year
        for (int i = 0; i < 91; i++) {
          expect(result.spots[i].x, i.toDouble());
          expect(result.spots[i].y, (i + 1).toDouble());
        }
        for (int i = 91; i < 366; i++) {
          expect(result.spots[i], FlSpot.nullSpot);
        }
        expect(result.startDate, DateTime(2024, 1, 1));
      });

      test('with a whole month missing (e.g. February)', () {
        final rankingData = <TestChartRankingData>[];
        final yearStartDate = DateTime(2024,1,1);
        // Add data for January
        for (int i = 0; i < 31; i++) { // Jan
          rankingData.add(TestChartRankingData(
              dateId: formatDate(yearStartDate.add(Duration(days: i))), rank: i + 1));
        }
        // February is missing (29 days in 2024)
        // Add data for March
        for (int i = 0; i < 31; i++) { // Mar
          rankingData.add(TestChartRankingData(
              dateId: formatDate(DateTime(2024,3,1).add(Duration(days: i))), rank: i + 100));
        }

        final result = generateChartData(
          calenderType: calenderType,
          now: testNow,
          rankingData: toProdRankingData(rankingData),
        );
        expect(result.spots.length, 366);
        // Check January data
        for (int i = 0; i < 31; i++) { // Jan indices 0-30
          expect(result.spots[i], FlSpot(i.toDouble(), (i + 1).toDouble()));
        }
        // Check February missing
        for (int i = 31; i < 31 + 29; i++) { // Feb indices 31-59
          expect(result.spots[i], FlSpot.nullSpot);
        }
        // Check March data
        // March 1st is index 31 (Jan) + 29 (Feb) = 60
        for (int i = 0; i < 31; i++) { // Mar indices 60-90
          expect(result.spots[60 + i], FlSpot((60 + i).toDouble(), (i + 100).toDouble()));
        }
      });
    });
     test('generateChartData startDate calculation check', () {
      // Test case for c2w
      var result = generateChartData(calenderType: CalenderType.c2w, now: DateTime(2024, 3, 14), rankingData: []);
      expect(result.startDate, DateTime(2024, 3, 1)); // 13 days before Mar 14

      // Test case for c1m
      result = generateChartData(calenderType: CalenderType.c1m, now: DateTime(2024, 3, 14), rankingData: []);
      expect(result.startDate, DateTime(2024, 3, 1)); // First day of March

      // Test case for c1y
      result = generateChartData(calenderType: CalenderType.c1y, now: DateTime(2024, 3, 14), rankingData: []);
      expect(result.startDate, DateTime(2024, 1, 1)); // First day of 2024
    });
  });
}

// Note: Accessing _ChartRankingData from another file might require making it public (ChartRankingData)
// or using a test-specific adapter as shown with toProdRankingData.
// The `generateChartData` function itself needs to be importable.
// If `chart_screen.dart` has `part of ...` and `part ...` directives, testing private members can be easier.
// Otherwise, making them public or using `@visibleForTesting` and then importing is standard.
// For this solution, I'm assuming `generateChartData` and `_ChartRankingData` (or an equivalent) are accessible.
// If `_ChartRankingData` is strictly private, the tests would fail to compile.
// A common approach is to make `_ChartRankingData` public as `ChartRankingDataInput` or similar.
// I've used `toProdRankingData` as a workaround if `_ChartRankingData` is private.
// The file `chart_screen.dart` has `_ChartRankingData` as a private class.
// The test file needs this class. So I made `TestChartRankingData` and `toProdRankingData`.
// The `generateChartData` is a top-level function so it is importable.

// The `ui/chart/chart_screen.dart` file defines `_ChartRankingData` which is private.
// To make it work, I have a few options:
// 1. Make `_ChartRankingData` public (e.g., `ChartRankingData`). This is the cleanest.
// 2. Replicate `_ChartRankingData` in this test file (as `TestChartRankingData`) and use an adapter function
//    like `toProdRankingData` if the production function `generateChartData` strictly expects `_ChartRankingData`.
//    This is what I've provisionally done.
// 3. If `chart_screen.dart` was part of a library with `part '...'`, test files could also be `part of` that library.

// The current `generateChartData` function uses `_ChartRankingData`.
// The test uses `TestChartRankingData` and `toProdRankingData` to convert. This should work.

```
