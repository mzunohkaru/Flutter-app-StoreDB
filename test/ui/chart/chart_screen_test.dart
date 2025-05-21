import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// Assuming 'app' is the placeholder for the actual package name.
// The paths should resolve to where CalenderType and generateChartData/_ChartRankingData are defined.
import 'package:app/model/enum/calender_type.dart';
import 'package:app/ui/chart/chart_screen.dart';


// Helper to convert a DateTime to 'yyyyMMdd' string, matching the app's format.
String dateToId(DateTime date) {
  return DateFormat('yyyyMMdd').format(date);
}

void main() {
  group('generateChartData Tests', () {
    // Consistent 'now' dates for predictable date calculations across tests.
    // For c2w (14 days total): If now is Jan 15, startDate = Jan 2, endDate = Jan 15.
    final testNowC2W = DateTime(2023, 1, 15); // Sunday
    final expectedStartDateC2W = DateTime(2023, 1, 2); // Jan 2, 2023

    // For c1m (current month): If now is Jan 15, startDate = Jan 1, endDate = Jan 31.
    final testNowC1M = DateTime(2023, 1, 15);
    final expectedStartDateC1M = DateTime(2023, 1, 1);
    final daysInJan2023 = 31;

    // For c1y (current year): If now is Jan 15, 2023, startDate = Jan 1, 2023, endDate = Dec 31, 2023.
    final testNowC1Y = DateTime(2023, 1, 15); // Not a leap year
    final expectedStartDateC1Y = DateTime(2023, 1, 1);
    final daysIn2023 = 365;


    test('1. Empty rankingData returns all null spots', () {
      final result = generateChartData(
        calenderType: CalenderType.c2w,
        now: testNowC2W,
        rankingData: [],
      );

      expect(result.spots.length, 14, reason: "Should be 14 spots for 2 weeks.");
      for (int i = 0; i < 14; i++) {
        expect(result.spots[i].x, i.toDouble(), reason: "X-value mismatch at index $i.");
        expect(result.spots[i].y.isNaN, isTrue, reason: "Y-value at index $i should be NaN for empty data.");
      }
      expect(result.startDate, expectedStartDateC2W, reason: "StartDate for c2w is incorrect.");
    });

    group('2. Single Data Point Tests', () {
      test('  Point at the beginning of 2w period', () {
        final rankingData = [
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W), rank: 10), // Jan 2 (idx 0)
        ];
        final result = generateChartData(
          calenderType: CalenderType.c2w,
          now: testNowC2W,
          rankingData: rankingData,
        );

        expect(result.spots.length, 14);
        expect(result.spots[0], FlSpot(0, 10), reason: "Spot at index 0 (start) is incorrect.");
        for (int i = 1; i < 14; i++) { // Spots for Jan 3 (idx 1) to Jan 15 (idx 13) should be null
          expect(result.spots[i].y.isNaN, isTrue, reason: "Spot at index $i should be null.");
        }
        expect(result.startDate, expectedStartDateC2W);
      });

      test('  Point in the middle of 2w period', () {
        final middleDate = expectedStartDateC2W.add(const Duration(days: 6)); // Jan 8 (idx 6)
        final rankingData = [
          _ChartRankingData(dateId: dateToId(middleDate), rank: 5),
        ];
        final result = generateChartData(
          calenderType: CalenderType.c2w,
          now: testNowC2W,
          rankingData: rankingData,
        );
        expect(result.spots.length, 14);
        for (int i = 0; i < 14; i++) {
          if (i == 6) { // Jan 8 (idx 6)
            expect(result.spots[i], FlSpot(6, 5), reason: "Spot at index 6 (middle) is incorrect.");
          } else {
            expect(result.spots[i].y.isNaN, isTrue, reason: "Spot at index $i should be null.");
          }
        }
      });

       test('  Point at the end of 2w period', () {
        final endDate = expectedStartDateC2W.add(const Duration(days: 13)); // Jan 15 (idx 13)
        final rankingData = [
          _ChartRankingData(dateId: dateToId(endDate), rank: 7),
        ];
        final result = generateChartData(
          calenderType: CalenderType.c2w,
          now: testNowC2W,
          rankingData: rankingData,
        );
        expect(result.spots.length, 14);
        for (int i = 0; i < 13; i++) { // Spots for Jan 2 (idx 0) to Jan 14 (idx 12) should be null
          expect(result.spots[i].y.isNaN, isTrue, reason: "Spot at index $i should be null.");
        }
        expect(result.spots[13], FlSpot(13, 7), reason: "Spot at index 13 (end) is incorrect.");
      });
    });

    group('3. No Gaps > 4 Days (Small Gaps)', () {
      test('  Points 1 day apart (e.g., Day 2 and Day 3 of period)', () {
        // Data on Jan 4 (idx 2) and Jan 5 (idx 3)
        final rankingData = [
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W.add(const Duration(days: 2))), rank: 10), 
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W.add(const Duration(days: 3))), rank: 12), 
        ];
        final result = generateChartData(calenderType: CalenderType.c2w, now: testNowC2W, rankingData: rankingData);
        
        expect(result.spots[2], FlSpot(2, 10), reason: "Data on Day 2 (idx 2)");
        expect(result.spots[3], FlSpot(3, 12), reason: "Data on Day 3 (idx 3)");
        // All other spots should be NaN
        for(int i=0; i<14; i++) {
          if (i != 2 && i != 3) { // Exclude idx 2 and 3
            expect(result.spots[i].y.isNaN, isTrue, reason: "Spot $i (not part of 1-day apart data) y was ${result.spots[i].y}");
          }
        }
      });

      test('  Points 4 days apart (e.g. Day 2 and Day 6 of period)', () {
        // Data on Jan 4 (idx 2) and Jan 8 (idx 6).
        // Date difference is 4 days. daysSinceLastData = 4. Not > 4.
        // Intermediate days Jan 5,6,7 (indices 3, 4, 5) should be NaN by default fill.
        final rankingData = [
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W.add(const Duration(days: 2))), rank: 8),
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W.add(const Duration(days: 6))), rank: 9),
        ];
        final result = generateChartData(calenderType: CalenderType.c2w, now: testNowC2W, rankingData: rankingData);
        expect(result.spots[2], FlSpot(2, 8));
        expect(result.spots[3].y.isNaN, isTrue, reason: "Spot at index 3 (Jan 5, small gap) should be null.");
        expect(result.spots[4].y.isNaN, isTrue, reason: "Spot at index 4 (Jan 6, small gap) should be null.");
        expect(result.spots[5].y.isNaN, isTrue, reason: "Spot at index 5 (Jan 7, small gap) should be null.");
        expect(result.spots[6], FlSpot(6, 9));
      });
    });

    group('4. Gap Greater Than 4 Days', () {
      test('  Data for Day 0 (Jan 2) and Day 6 (Jan 8). (6 day date diff, 5 day actual gap)', () {
        // Data on Jan 2 (idx 0) and Jan 8 (idx 6). daysSinceLastData = 6. This is > 4.
        // Gap days: Jan 3,4,5,6,7 (indices 1,2,3,4,5) should be NaN due to explicit >4 day gap logic.
        final rankingData = [
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W), rank: 10), 
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W.add(const Duration(days: 6))), rank: 20),
        ];
        final result = generateChartData(calenderType: CalenderType.c2w, now: testNowC2W, rankingData: rankingData);
        
        expect(result.spots[0], FlSpot(0, 10));
        for (int i = 1; i <= 5; i++) { // Indices 1 to 5 are gap days
          expect(result.spots[i].y.isNaN, isTrue, reason: "Spot at index $i (explicit >4 day gap) should be null.");
        }
        expect(result.spots[6], FlSpot(6, 20));
        for (int i = 7; i < 14; i++) { // Remaining days in period after last data point
             expect(result.spots[i].y.isNaN, isTrue, reason: "Spot at index $i (post-data) should be null.");
        }
      });
    });

    group('5. Multiple Gaps (Small and Large for 1 Month Period)', () {
      test('  Mix of gaps for 1 month period (Jan 2023)', () {
        final rankingData = [
          _ChartRankingData(dateId: dateToId(expectedStartDateC1M.add(const Duration(days: 0))), rank: 5),  // Jan 1 (idx 0)
          _ChartRankingData(dateId: dateToId(expectedStartDateC1M.add(const Duration(days: 2))), rank: 8),  // Jan 3 (idx 2). Gap P1-P2 is 2 days. Day idx 1 is null.
          _ChartRankingData(dateId: dateToId(expectedStartDateC1M.add(const Duration(days: 9))), rank: 15), // Jan 10 (idx 9). Gap P2-P3 is 7 days. Days idx 3-8 are null (>4 day rule).
          _ChartRankingData(dateId: dateToId(expectedStartDateC1M.add(const Duration(days: 12))), rank: 10),// Jan 13 (idx 12). Gap P3-P4 is 3 days. Days idx 10,11 are null.
        ];
        final result = generateChartData(calenderType: CalenderType.c1m, now: testNowC1M, rankingData: rankingData);
        
        expect(result.spots.length, daysInJan2023); // 31 days in Jan
        expect(result.startDate, expectedStartDateC1M);

        expect(result.spots[0], FlSpot(0, 5), reason: "Data for Jan 1 (idx 0)");
        expect(result.spots[1].y.isNaN, isTrue, reason: "Jan 2 (idx 1) - small gap, should be null");
        expect(result.spots[2], FlSpot(2, 8), reason: "Data for Jan 3 (idx 2)");

        // Large gap: Jan 4 (idx 3) to Jan 9 (idx 8) should be null by >4 day rule
        for (int i = 3; i <= 8; i++) { 
            expect(result.spots[i].y.isNaN, isTrue, reason: "Spot at index $i (Jan ${i+1}, large gap) should be null.");
        }
        expect(result.spots[9], FlSpot(9, 15), reason: "Data for Jan 10 (idx 9)");

        expect(result.spots[10].y.isNaN, isTrue, reason: "Jan 11 (idx 10) - small gap, should be null");
        expect(result.spots[11].y.isNaN, isTrue, reason: "Jan 12 (idx 11) - small gap, should be null");
        expect(result.spots[12], FlSpot(12, 10), reason: "Data for Jan 13 (idx 12)");

        // Remaining days until end of month should be NaN
        for (int i = 13; i < daysInJan2023; i++) { // From Jan 14 (idx 13) to Jan 31 (idx 30)
            expect(result.spots[i].y.isNaN, isTrue, reason: "Spot at index $i (Jan ${i+1}, end of month) should be null.");
        }
      });
    });
    
    group('6. Data at Period Edges with Large Gap', () {
      test('  Data on Day 0 and Day 13 of 2w period (12 day intermediate gap)', () {
        // Data on Jan 2 (idx 0) and Jan 15 (idx 13). daysSinceLastData = 13. This is > 4.
        // Intermediate days (indices 1-12) should be NaN by >4 day gap logic.
        final rankingData = [
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W), rank: 100), 
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W.add(const Duration(days: 13))), rank: 200),
        ];
        final result = generateChartData(calenderType: CalenderType.c2w, now: testNowC2W, rankingData: rankingData);

        expect(result.spots.length, 14);
        expect(result.spots[0], FlSpot(0, 100));
        for (int i = 1; i <= 12; i++) { // Indices 1 to 12 are gap days
            expect(result.spots[i].y.isNaN, isTrue, reason: "Spot at index $i (large edge gap) should be null.");
        }
        expect(result.spots[13], FlSpot(13, 200));
      });
    });

    group('7. Data Outside calenderType Range', () {
      final c2wEndDate = expectedStartDateC2W.add(const Duration(days: 13)); // Jan 15
      
      test('  All data before period start', () {
        final rankingData = [
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W.subtract(const Duration(days: 1))), rank: 1), // Jan 1
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W.subtract(const Duration(days: 5))), rank: 2), // Dec 28
        ];
        final result = generateChartData(calenderType: CalenderType.c2w, now: testNowC2W, rankingData: rankingData);
        expect(result.spots.length, 14);
        for (int i = 0; i < 14; i++) {
            expect(result.spots[i].y.isNaN, isTrue, reason: "Spot $i should be null as all data is outside (before) range");
        }
      });

      test('  All data after period end', () {
        final rankingData = [
          _ChartRankingData(dateId: dateToId(c2wEndDate.add(const Duration(days: 1))), rank: 1), // Jan 16
          _ChartRankingData(dateId: dateToId(c2wEndDate.add(const Duration(days: 5))), rank: 2), // Jan 20
        ];
        final result = generateChartData(calenderType: CalenderType.c2w, now: testNowC2W, rankingData: rankingData);
        expect(result.spots.length, 14);
        for (int i = 0; i < 14; i++) {
            expect(result.spots[i].y.isNaN, isTrue, reason: "Spot $i should be null as all data is outside (after) range");
        }
      });
      
      test('  Mix of data inside and outside period', () {
        final rankingData = [
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W.subtract(const Duration(days: 1))), rank: 1), // Outside (Jan 1)
          _ChartRankingData(dateId: dateToId(expectedStartDateC2W.add(const Duration(days: 1))), rank: 50),   // Inside (Jan 3, Index 1)
          _ChartRankingData(dateId: dateToId(c2wEndDate.add(const Duration(days: 1))), rank: 2),       // Outside (Jan 16)
        ];
        final result = generateChartData(calenderType: CalenderType.c2w, now: testNowC2W, rankingData: rankingData);
        expect(result.spots.length, 14);
        expect(result.spots[1], FlSpot(1, 50)); // Data for Jan 3 (idx 1)
        for (int i = 0; i < 14; i++) {
          if (i != 1) { // All other spots should be null
            expect(result.spots[i].y.isNaN, isTrue, reason: "Spot $i should be null (mix data)");
          }
        }
      });
    });
    
    group('8. Correct X-Value and startDate Association (C1Y check)', () {
      test('  c1y check with specific data points', () {
        final rankingData = [
          // Data on Jan 11, 2023 (index 10 if startDate is Jan 1)
          _ChartRankingData(dateId: dateToId(expectedStartDateC1Y.add(const Duration(days: 10))), rank: 10),
          // Data on July 20, 2023 (Jan 1 + 200 days is July 20th, so index 200)
          _ChartRankingData(dateId: dateToId(expectedStartDateC1Y.add(const Duration(days: 200))), rank: 20),
        ];
        final result = generateChartData(calenderType: CalenderType.c1y, now: testNowC1Y, rankingData: rankingData);
        
        expect(result.startDate, expectedStartDateC1Y);
        expect(result.spots.length, daysIn2023); // 365 days in 2023
        
        expect(result.spots[10], FlSpot(10, 10), reason: "Spot for day 10 (index 10) is wrong.");
        // Gap between day 10 (idx 10) and day 200 (idx 200): daysSinceLastData = 190. This is > 4.
        // So spots from index 11 to 199 should be NaN.
        for(int i = 11; i < 200; i++) { // Indices for days 11 to 199
             expect(result.spots[i].y.isNaN, isTrue, reason: "Spot $i in long C1Y gap should be NaN");
        }
        expect(result.spots[200], FlSpot(200, 20), reason: "Spot for day 200 (index 200) is wrong.");

        // Check all x values are sequential
        for (int i = 0; i < daysIn2023; i++) {
          expect(result.spots[i].x, i.toDouble(), reason: "X-value incorrect at index $i for C1Y test.");
        }
      });
    });

  });
}
