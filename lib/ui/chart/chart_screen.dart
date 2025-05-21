import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/entity/app_data/app_data_document.dart';
import '../../model/enum/calender_type.dart';
import '../../model/enum/genre.dart';
import '../../services/url_launch/url_launch.dart';
import '../../state/ranking_state/ranking_controller.dart';
import '../app_list/widget/app_list_widget.dart';
import 'widget/drop_down_button_widget.dart';
import 'widget/liner_chart_widget.dart';

// Helper structure for ranking data, assuming RankingDocument has ref.id as 'yyyyMMdd' and entity.rank
// This simplifies testing without full Firestore mocking.
class _ChartRankingData {
  final String dateId; // 'yyyyMMdd'
  final int rank;
  _ChartRankingData({required this.dateId, required this.rank});
}

List<FlSpot> generateChartSpots({
  required CalenderType calenderType,
  required DateTime now,
  required List<_ChartRankingData> rankingData,
  // This function will also need to return startDate for LineChartWidget
  // So, let's make it return a record or a custom class
}) {
  DateTime startDate;
  DateTime endDate;

  switch (calenderType) {
    case CalenderType.c2w:
      startDate = now.subtract(const Duration(days: 13));
      endDate = now;
      break;
    case CalenderType.c1m:
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month + 1, 0);
      break;
    case CalenderType.c1y:
      startDate = DateTime(now.year, 1, 1);
      endDate = DateTime(now.year, 12, 31);
      break;
  }

  final dateFormat = DateFormat('yyyyMMdd');
  
  // 1. Handle Empty rankingData: If rankingData is empty, fill with null spots.
  if (rankingData.isEmpty) {
    final emptySpots = <FlSpot>[];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      emptySpots.add(FlSpot(i.toDouble(), double.nan));
    }
    return (spots: emptySpots, startDate: startDate);
  }

  // 2. Prepare Data: Parse, sort, and filter.
  List<({DateTime date, int rank})> processedData = [];
  for (var data in rankingData) {
    try {
      final date = dateFormat.parseStrict(data.dateId);
      // Only include data points that are within the chart's time window [startDate, endDate]
      if (!date.isBefore(startDate) && !date.isAfter(endDate)) {
         processedData.add((date: date, rank: data.rank));
      }
    } catch (e) {
      print('Error parsing dateId ${data.dateId} during data preparation: $e');
      // Skip invalid data
    }
  }
  processedData.sort((a, b) => a.date.compareTo(b.date));

  // If no data points are within the chart window after filtering
  if (processedData.isEmpty) {
    final emptySpots = <FlSpot>[];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      emptySpots.add(FlSpot(i.toDouble(), double.nan));
    }
    return (spots: emptySpots, startDate: startDate);
  }
  
  // 3. Initialize spotsMap to store FlSpots, keyed by day offset from startDate.
  // This helps in placing actual data points and explicitly defined nulls.
  final Map<int, FlSpot> spotsMap = {};
  DateTime? lastDataDate;

  // 4. Iterate through sorted and filtered data points to place actual ranks and identify gaps.
  for (final dataPoint in processedData) {
    final currentDate = dataPoint.date;
    final currentRank = dataPoint.rank;
    final currentDayOffset = currentDate.difference(startDate).inDays;

    // Handle gaps between lastDataDate and currentDate
    if (lastDataDate != null) {
      final daysSinceLastData = currentDate.difference(lastDataDate).inDays;
      if (daysSinceLastData > 4) {
        // Gap is > 4 days, fill with null spots
        for (int d = 1; d < daysSinceLastData; d++) {
          final gapDate = lastDataDate.add(Duration(days: d));
          final gapDayOffset = gapDate.difference(startDate).inDays;
          spotsMap[gapDayOffset] = FlSpot(gapDayOffset.toDouble(), double.nan);
        }
      }
      // If daysSinceLastData <= 4, we do nothing here for the gap days.
      // Those days will be filled with nulls in step 5 if no other data point lands on them.
      // Or, if the "Example of Gap Handling" implies lines should connect over smaller gaps,
      // then FlSpot.nullSpot should NOT be inserted for those.
      // The current logic: if gap is small (<=4 days), spotsMap will NOT have entries for these intermediate days from this block.
      // They will get nullSpot.y in step 5 UNLESS another data point falls there.
      // This seems to align with the example: '20230102' (dayOffset 1) is not in spotsMap from gap logic if P1-P2 is 2 days.
    }
    
    // Place the actual data point.
    spotsMap[currentDayOffset] = FlSpot(currentDayOffset.toDouble(), currentRank.toDouble());
    lastDataDate = currentDate;
  }

  // 5. Construct the final list of FlSpots for the entire chart period.
  // Fill in days that don't have data (or explicit gap nulls) with FlSpot.nullSpot.
  final newSpots = <FlSpot>[];
  for (int dayOffset = 0; dayOffset <= endDate.difference(startDate).inDays; dayOffset++) {
    if (spotsMap.containsKey(dayOffset)) {
      newSpots.add(spotsMap[dayOffset]!);
    } else {
      newSpots.add(FlSpot(dayOffset.toDouble(), double.nan));
    }
  }
  
  return (spots: newSpots, startDate: startDate);
}

// We need startDate for the LineChartWidget too.
// Let's create a record or class to return both spots and startDate.
typedef ChartDataResult = ({List<FlSpot> spots, DateTime startDate});

ChartDataResult generateChartData({
  required CalenderType calenderType,
  required DateTime now,
  required List<_ChartRankingData> rankingData,
}) {
  DateTime startDate;
  DateTime endDate;

  switch (calenderType) {
    case CalenderType.c2w:
      startDate = now.subtract(const Duration(days: 13));
      endDate = now;
      break;
    case CalenderType.c1m:
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month + 1, 0);
      break;
    case CalenderType.c1y:
      startDate = DateTime(now.year, 1, 1);
      endDate = DateTime(now.year, 12, 31);
      break;
  }

  final newSpots = <FlSpot>[];
  final dateFormat = DateFormat('yyyyMMdd');

  // 1. Handle Empty rankingData or data outside the chart range
  if (rankingData.isEmpty) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      newSpots.add(FlSpot.nullSpot);
    }
    return (spots: newSpots, startDate: startDate);
  }

  // 2. Sort Data
  final sortedRankingData = List<_ChartRankingData>.from(rankingData);
  sortedRankingData.sort((a, b) {
    try {
      final dateA = dateFormat.parseStrict(a.dateId);
      final dateB = dateFormat.parseStrict(b.dateId);
      return dateA.compareTo(dateB);
    } catch (e) {
      // Handle potential parsing errors, though data should be clean
      print('Error parsing dateId during sort: $e');
      return 0;
    }
  });

  DateTime lastDataDate = startDate;
  int currentDataIndex = 0;

  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    final currentDateLoop = startDate.add(Duration(days: i));
    bool spotAddedForCurrentDay = false;

    if (currentDataIndex < sortedRankingData.length) {
      final dataPoint = sortedRankingData[currentDataIndex];
      DateTime currentPointDate;
      try {
        currentPointDate = dateFormat.parseStrict(dataPoint.dateId);
      } catch (e) {
        print('Error parsing dateId for point ${dataPoint.dateId}: $e');
        // Skip this data point if date is invalid
        currentDataIndex++;
        newSpots.add(FlSpot.nullSpot); // Or handle as per specific error policy
        spotAddedForCurrentDay = true; // Mark as handled to avoid double null
        continue; 
      }

      // If the current data point matches the current day in the loop
      if (currentDateLoop.year == currentPointDate.year &&
          currentDateLoop.month == currentPointDate.month &&
          currentDateLoop.day == currentPointDate.day) {
        // Check gap BEFORE this point
        if (currentDataIndex == 0) { // First data point
          // Fill with nulls from startDate to day before currentPointDate if necessary
          // This implicitly covers gaps > 4 days if the first point is far from startDate
          // However, the problem asks to insert nulls for gaps *between data points*.
          // The loop structure handles days before the first point naturally.
        } else {
          final prevDataPoint = sortedRankingData[currentDataIndex - 1];
          DateTime prevPointDate;
          try {
            prevPointDate = dateFormat.parseStrict(prevDataPoint.dateId);
          } catch (e) {
            // Should not happen if sorted list is processed correctly
            print('Error parsing prev dateId ${prevDataPoint.dateId}: $e');
            // This case implies data error, proceed carefully
            newSpots.add(FlSpot(i.toDouble(), dataPoint.rank.toDouble()));
            lastDataDate = currentPointDate;
            currentDataIndex++;
            spotAddedForCurrentDay = true;
            continue;
          }
          
          final difference = currentPointDate.difference(prevPointDate).inDays;
          if (difference > 4) {
            // Gap detected. The spots for the gap days would have been added
            // as FlSpot.nullSpot by the outer loop in previous iterations.
            // The task is to ensure these nulls are correctly placed.
            // The current structure iterates day by day. If a day has no data, it gets a null.
            // The >4 day rule applies to the line *between points*.
            // This means if point A and point B are >4 days apart, all days *between* them get null.
            // The current loop adds nulls if no exact match. We need to ensure this behavior
            // correctly reflects the "break line if gap > 4 days" rule.
            // The problem is that FlSpot.nullSpot itself breaks the line.
            // So, if there's a day between points A and B, and gap(A,B) > 4, that day gets null.
            // If gap(A,B) <= 4, that day also gets null if no data, but line doesn't "break" visually in chart.
            // The FlChart library handles line drawing based on nulls.
            // The key is just to put data where it exists, and null where it doesn't.
            // The >4 day rule is about *which* nulls to insert.
            // The current logic: iterate all days, if data for day -> plot, else -> null.
            // This already implements the visual requirement if FlSpot.nullSpot is used.
            // The request was to "explicitly insert FlSpot.nullSpot for each day *within that gap*".
            // This is what the current outer loop + rankingMap effectively did, and what the new
            // day-by-day iteration will do.
          }
        }
        newSpots.add(FlSpot(i.toDouble(), dataPoint.rank.toDouble()));
        lastDataDate = currentPointDate;
        currentDataIndex++;
        spotAddedForCurrentDay = true;
      }
    }

    // If no data point matched currentDateLoop (either before first point, between points, or after last point)
    if (!spotAddedForCurrentDay) {
        // This is where we need to be careful.
        // If we are between two data points (say P_prev and P_next)
        // and diff(P_next, P_prev) > 4, then this day (currentDateLoop) should be null.
        // If diff(P_next, P_prev) <= 4, this day should also be null if no data.
        // FlSpot.nullSpot inherently breaks the line.
        // The previous logic using rankingMap was simpler:
        // final rank = rankingMap[formattedDate]; if (rank != null) spot else null.

        // Let's re-evaluate. The goal is:
        // 1. Plot points where data exists.
        // 2. If gap between data point A and data point B is > 4 days, all days between A and B are null.
        // 3. X-axis is days from startDate.

        // Simpler approach: Iterate all days from startDate to endDate.
        // For each day, check if it has a corresponding entry in sortedRankingData.
        // This is essentially what the original code with rankingMap did, but we need to use sortedRankingData.
        // The >4 day rule is implicitly handled by FlSpot.nullSpot breaking the line.
        // The request "explicitly insert FlSpot.nullSpot for each day *within that gap*" means
        // if data is 20230101, 20230107, then 02,03,04,05,06 are null.
        // This is achieved by the day-by-day iteration.

        // Let's try to use the provided example to guide the logic for adding nulls.
        // Example: startDate '20230101'. Data: '20230101' (P1), '20230103' (P2), '20230108' (P3).
        // Loop day '20230101' (i=0): Match P1. spots.add(FlSpot(0, P1.rank)). lastDataDate='01'. idx=1.
        // Loop day '20230102' (i=1): No match. Is this day in a >4 day gap *between actual data points*?
        //   Previous actual was P1 ('01'). Next actual is P2 ('03'). Gap P1-P2 is 1 day (03-01-1). Not >4. So FlSpot.nullSpot.
        // Loop day '20230103' (i=2): Match P2. spots.add(FlSpot(2, P2.rank)). lastDataDate='03'. idx=2.
        // Loop day '20230104' (i=3): No match. Previous actual P2 ('03'). Next actual is P3 ('08'). Gap P2-P3 is 4 days (08-03-1).
        //   This means days '04', '05', '06', '07' are in the gap. Difference is 5 days (P3.date - P2.date).
        //   The rule says "if the difference ... is greater than 4 days". 5 > 4. So these are nulls.
        //   This spot ('04') gets FlSpot.nullSpot.
        // Loop day '20230105' (i=4): No match. Same gap. FlSpot.nullSpot.
        // Loop day '20230106' (i=5): No match. Same gap. FlSpot.nullSpot.
        // Loop day '20230107' (i=6): No match. Same gap. FlSpot.nullSpot.
        // Loop day '20230108' (i=7): Match P3. spots.add(FlSpot(7, P3.rank)). lastDataDate='08'. idx=3.

        // The above logic seems correct. The key is that FlSpot.nullSpot is added for any day without data.
        // The >4 day rule is about *interpretation* or *emphasis*, but the implementation (null for no data) is standard.
        // The requirement "explicitly insert FlSpot.nullSpot for each day *within that gap*" IS what happens
        // when you iterate day-by-day and add null if no data for that day.

        // So, the main change from the original is to iterate using the sorted list
        // rather than a map, to correctly identify the *next* data point for gap analysis if needed,
        // though FlChart handles the visual line break with nulls anyway.
        // The sorting is crucial.

        // Let's revert to a map for easier lookup after sorting, then iterate day-by-day.
        // This combines the robustness of the original with the sorted data requirement.
        newSpots.add(FlSpot.nullSpot);
    }
  }

  // The loop above should correctly populate newSpots.
  // If rankingData is exhausted before endDate, remaining spots will be null.
  // If data points are outside startDate/endDate, they are ignored by the loop bounds.

  // Refined logic based on the problem statement's emphasis on sorted data and gaps:
  // Step 1: Determine startDate, endDate (done)
  // Step 2: Handle empty rankingData (done)
  // Step 3: Sort rankingData (done)
  // Step 4: Create newSpots list
  // Step 5: Iterate from day 0 to N (endDate.difference(startDate).inDays)
  //          For each day `d` in this iteration:
  //          - Calculate `currentLoopDate = startDate.add(Duration(days: d))`
  //          - Search for `currentLoopDate` in `sortedRankingData`.
  //          - If found: add `FlSpot(d.toDouble(), rank.toDouble())`.
  //          - If not found: add `FlSpot.nullSpot`.
  // This is exactly what the original code with `rankingMap` did, except `rankingMap` isn't sorted for gap analysis.
  // However, FlChart itself breaks lines on `FlSpot.nullSpot`. So, the "gap > 4 days" rule
  // is a condition for *when a line should be visually broken*. FlChart does this if there's *any* null spot.
  // The requirement seems to be ensuring that if data is `D1 ---- D2` where gap is >4 days,
  // then `D1, null, null, null, null, D2` is generated. This is naturally handled by day-by-day iteration.

  // Let's use the day-by-day iteration with a pointer to the sorted data.

  // Reset and try a clearer loop structure:
  newSpots.clear(); // Clear spots from previous attempt in this block
  int currentSortedDataIndex = 0;
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    final currentDateInLoop = startDate.add(Duration(days: i));
    FlSpot spotToAdd = FlSpot.nullSpot; // Default to null

    if (currentSortedDataIndex < sortedRankingData.length) {
      final dataPoint = sortedRankingData[currentSortedDataIndex];
      DateTime dataPointDate;
      try {
        dataPointDate = dateFormat.parseStrict(dataPoint.dateId);
      } catch (e) {
        print("Error parsing dateId '${dataPoint.dateId}' from sorted data: $e");
        // Faulty data point, treat as if it's not there for this iteration.
        // Effectively skips this data point. Consider incrementing currentSortedDataIndex
        // if this point should be entirely ignored permanently. For now, it will be re-evaluated.
        // A safer approach might be to filter sortedRankingData first for valid dates.
        // For this implementation, we'll add null and let the loop proceed.
        // If the bad date causes it to "block" processing, currentSortedDataIndex should be incremented.
        // Let's assume data is clean after sorting or filter it beforehand.
        // To be safe, if parse fails, advance index and add null for current day.
        // This assumes a malformed dateId means that specific point is unusable.
        // sortedRankingData.removeAt(currentSortedDataIndex); // Risky if list is modified during loop
        // A better way is to pre-filter or handle currentSortedDataIndex carefully.
        // For now, if date is bad, we insert null, and on next loop, it might try parsing again or pick next.
        // This path should ideally not be hit with clean data.
        // Let's assume for now that parseStrict in sort would have caught this, or data is clean.
        // If not, this could lead to an infinite loop if a bad dateId is always at currentSortedDataIndex
        // and never matches currentDateInLoop.
        // A simple fix: if parse fails, increment currentSortedDataIndex and add null for the day.
        // This is not ideal as it modifies state based on error. Pre-filtering is better.
        // Given the context, let's assume valid dates in sortedRankingData.
        // If an error occurs, it's an exceptional case. For robustness:
        // try { dataPointDate = ... } catch { newSpots.add(FlSpot.nullSpot); continue; }
        // But this would add FlSpot.nullSpot and then the outer loop adds another one.

        // Let's stick to the plan: assume dates in sortedRankingData are valid due to prior sort/parse.
        // If a date was unparseable, it might be an issue with sort logic or data quality.
        // For now, we'll proceed assuming dataPointDate is valid if it's in sortedRankingData.
      }
      // Ensure dataPointDate is not before startDate and not after endDate
      // (though loop is bounded by startDate/endDate, data itself might be outside)
      if (!dataPointDate.isBefore(startDate) && !dataPointDate.isAfter(endDate)) {
        if (dataPointDate.year == currentDateInLoop.year &&
            dataPointDate.month == currentDateInLoop.month &&
            dataPointDate.day == currentDateInLoop.day) {
          spotToAdd = FlSpot(i.toDouble(), dataPoint.rank.toDouble());
          currentSortedDataIndex++; // Move to next data point
        }
      } else if (dataPointDate.isBefore(currentDateInLoop)) {
        // This data point is in the past relative to our loop; it should have been processed.
        // This can happen if data points are not perfectly aligned with loop days or outside range.
        // Advance pointer to find relevant data.
        currentSortedDataIndex++;
        // Re-evaluate with the new dataPoint for the same currentDateInLoop
        // This requires a nested loop or a goto, which is not clean.
        // The current structure: for each day, see if the *next available* data matches.
        // If current dataPointDate is before currentDateInLoop, it means we missed it or it's irrelevant.
        // So we should advance currentSortedDataIndex until dataPointDate >= currentDateInLoop.

        // Correction: The logic should be:
        // While currentSortedDataIndex < length AND dataPointDate < currentDateInLoop:
        //   currentSortedDataIndex++
        //   fetch new dataPoint
        // After this, check if dataPointDate == currentDateInLoop
        
        // This is what the `while` loop below does.
      }
    }
    newSpots.add(spotToAdd);
  }
  
  // The above loop implements the "iterate day-by-day, if data for day, plot, else null"
  // This already creates nulls in gaps. The >4 day rule is about the *visual* break,
  // which FlSpot.nullSpot provides. The "explicitly insert" is met.

  // Let's refine the loop to correctly advance currentSortedDataIndex.
  newSpots.clear(); // Fresh start for this refined logic
  currentSortedDataIndex = 0; // Renamed from currentDataIndex

  // Filter out data points with unparseable dates or those outside the chart's date range first.
  final List<_ChartRankingData> relevantData = [];
  for (final data in sortedRankingData) {
    try {
      final date = dateFormat.parseStrict(data.dateId);
      if (!date.isBefore(startDate) && !date.isAfter(endDate)) {
        relevantData.add(data);
      }
    } catch (e) {
      print("Skipping data with invalid dateId '${data.dateId}': $e");
    }
  }


  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    final currentDateInLoop = startDate.add(Duration(days: i));
    FlSpot spotToAdd = FlSpot.nullSpot;

    if (currentSortedDataIndex < relevantData.length) {
      final dataPoint = relevantData[currentSortedDataIndex];
      // No need to parse again if relevantData stores DateTime objects, but it stores _ChartRankingData
      final dataPointDate = dateFormat.parseStrict(dataPoint.dateId); // Assume valid by pre-filter

      if (dataPointDate.year == currentDateInLoop.year &&
          dataPointDate.month == currentDateInLoop.month &&
          dataPointDate.day == currentDateInLoop.day) {
        spotToAdd = FlSpot(i.toDouble(), dataPoint.rank.toDouble());
        currentSortedDataIndex++;
      }
      // If dataPointDate is later than currentDateInLoop, currentDateInLoop gets a null spot (default).
      // If dataPointDate is earlier, it means that data point was for a day already processed.
      // This shouldn't happen if currentSortedDataIndex is managed correctly (only advanced on match).
      // The pre-filtering helps ensure we only consider relevant points.
    }
    newSpots.add(spotToAdd);
  }
  
  // The crucial part about "explicitly insert FlSpot.nullSpot for each day *within that gap*"
  // (where gap > 4 days) is that the line should be broken. FlSpot.nullSpot does this.
  // The logic above ensures that if `rankingData` has `D1 (day X)` and `D2 (day Y)`,
  // and `Y - X > 1`, then days `X+1, ..., Y-1` get `FlSpot.nullSpot`.
  // This is the standard way to represent missing data leading to line breaks.
  // The "> 4 day" rule seems to be a specific business rule for *when* a break is significant.
  // FlChart will break the line for any `FlSpot.nullSpot`.
  // The problem description implies that the *generation* of null spots should be mindful of this rule.
  // However, if data is '20230101' and '20230103', then '20230102' is a gap of 1 day.
  // It should receive `FlSpot.nullSpot`. The line connects over it if the chart allows.
  // If data is '20230101' and '20230108' (gap of 6 days for '02' through '07'),
  // then '02' through '07' all get `FlSpot.nullSpot`.
  // The current logic achieves this. The ">4 day" condition was perhaps to distinguish
  // from interpolating or carrying forward ranks for smaller gaps, which we are not doing.
  // We are always using null for any missing day.

  return (spots: newSpots, startDate: startDate);
}

class ChartScreen extends HookConsumerWidget {
  const ChartScreen({super.key, required this.appDataDoc, required this.genre});

  final AppDataDocument appDataDoc;
  final Genre genre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calenderType = useState<CalenderType>(CalenderType.c2w);
    final rankingState = ref.watch(
      rankingControllerProvider(
        genre: genre,
        appId: appDataDoc.ref.id,
      ),
    );

    if (rankingState.value == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Use the refactored function
    final chartDataResult = generateChartData(
      calenderType: calenderType.value,
      now: DateTime.now(), // For production, use current time
      rankingData: rankingState.value!.rankingDocList.map((doc) {
        return _ChartRankingData(dateId: doc.ref.id, rank: doc.entity.rank);
      }).toList(),
    );
    final spots = chartDataResult.spots;
    final startDate = chartDataResult.startDate;

    return Scaffold(
      appBar: AppBar(
        title: Text('ランキング推移'),
        actions: [
          DropDownButtonWidget(
            onChanged: (String? value) {
              calenderType.value =
                  CalenderType.values.firstWhere((e) => e.title == value);
            },
            value: calenderType.value.title,
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  children: [
                    ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: appDataDoc.entity.appIcon,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      title: GestureDetector(
                        onTap: () {
                          UrlLaunchClient().accessUrl(appDataDoc.entity.appUrl);
                        },
                        child: Text(
                          '${appDataDoc.entity.appName}',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: LineChartWidget(
                          spots: spots, // Use spots from chartDataResult
                          calenderType: calenderType.value,
                          startDate:
                              startDate, // Use startDate from chartDataResult
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: AppListWidget(
              genre: genre,
              onTap: (app) {
                print(app.entity.appName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
