import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/entity/app_data/app_data_document.dart';
import '../../model/enum/calender_type.dart';
import '../../model/enum/firestore.dart';
import '../../state/ranking_state/ranking_controller.dart';
import '../app_list/widget/app_list_widget.dart';
import 'widget/drop_down_button_widget.dart';
import 'widget/liner_chart_widget.dart';

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

    final spots =
        rankingState.value!.rankingDocList.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble() + 1,
        entry.value.entity.rank.toDouble(),
      );
    }).toList();

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
                          spots: spots,
                          calenderType: calenderType.value,
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
