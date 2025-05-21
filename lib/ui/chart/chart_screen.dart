import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/entity/app_data/app_data_document.dart';
import '../../model/enum/calender_type.dart';
import '../../model/enum/genre.dart';
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

  final newSpots = <FlSpot>[];
  final rankingMap = {for (var data in rankingData) data.dateId: data.rank};

  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    final currentDate = startDate.add(Duration(days: i));
    final formattedDate = DateFormat('yyyyMMdd').format(currentDate);
    final rank = rankingMap[formattedDate];

    if (rank != null) {
      newSpots.add(FlSpot(i.toDouble(), rank.toDouble()));
    } else {
      newSpots.add(FlSpot.nullSpot);
    }
  }
  return newSpots;
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
  final rankingMap = {for (var data in rankingData) data.dateId: data.rank};

  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    final currentDate = startDate.add(Duration(days: i));
    final formattedDate = DateFormat('yyyyMMdd').format(currentDate);
    final rank = rankingMap[formattedDate];

    if (rank != null) {
      newSpots.add(FlSpot(i.toDouble(), rank.toDouble()));
    } else {
      newSpots.add(FlSpot.nullSpot);
    }
  }
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
                      title: Text(
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
