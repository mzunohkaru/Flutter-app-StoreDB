import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/ui/chart/chart_screen.dart';
import '../../../lib/model/enum/calender_type.dart';
// chart_screen.dart 内の _ChartRankingData を利用

// _ChartRankingData は chart_screen.dart で public なので、ここではインポート経由で直接利用できます。
// もし _ChartRankingData が private (_ClassName) の場合は、
// chart_screen.dart 側で @visibleForTesting を付与するか、
// このテストファイル内で同等のダミークラスを定義する必要があります。
// 今回は chart_screen.dart の _ChartRankingData が private ではない前提で進めます。

// テスト用のダミー rankingData を準備するヘルパー関数
List<_ChartRankingData> createDummyRankingData(List<Map<String, dynamic>> data) {
  return data.map((d) => _ChartRankingData(dateId: d['dateId'] as String, rank: d['rank'] as int)).toList();
}

void main() {
  group('generateChartData tests', () {
    // テスト用の共通の now
    final now = DateTime(2024, 3, 15); // 例: 2024年3月15日 (金曜日)

    test('should return correct FlSpots for CalenderType.c2w with 2-day interval data', () {
      final rankingData = createDummyRankingData([
        {'dateId': '20240303', 'rank': 10}, // 期間内 (3/2 - 3/15) startDate: 3/2
        {'dateId': '20240305', 'rank': 12},
        {'dateId': '20240307', 'rank': 9},
        {'dateId': '20240309', 'rank': 15},
        {'dateId': '20240311', 'rank': 8},
        {'dateId': '20240313', 'rank': 11},
        {'dateId': '20240315', 'rank': 10}, // 最終日
      ]);
      final result = generateChartData(calenderType: CalenderType.c2w, now: now, rankingData: rankingData);
      
      // 期待される startDate (now - 13 days)
      final expectedStartDate = DateTime(2024, 3, 2);
      expect(result.startDate, expectedStartDate);

      // 期待される FlSpot リスト
      // x は expectedStartDate からの経過日数
      expect(result.spots.length, 7);
      expect(result.spots[0], FlSpot(1, 10)); // 20240303 is 1 day after 20240302
      expect(result.spots[1], FlSpot(3, 12)); // 20240305 is 3 days after 20240302
      expect(result.spots[2], FlSpot(5, 9));
      expect(result.spots[3], FlSpot(7, 15));
      expect(result.spots[4], FlSpot(9, 8));
      expect(result.spots[5], FlSpot(11, 11));
      expect(result.spots[6], FlSpot(13, 10));
    });

    test('should return correct FlSpots for CalenderType.c1m with 2-day interval data', () {
      final rankingData = createDummyRankingData([
        {'dateId': '20240301', 'rank': 5},
        {'dateId': '20240303', 'rank': 10},
        {'dateId': '20240305', 'rank': 12},
        // March has 31 days. Data points every 2 days from 1st to 31st.
        // 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31
        {'dateId': '20240307', 'rank': 11},
        {'dateId': '20240309', 'rank': 13},
        {'dateId': '20240311', 'rank': 14},
        {'dateId': '20240313', 'rank': 10},
        {'dateId': '20240315', 'rank': 8},
        {'dateId': '20240317', 'rank': 9},
        {'dateId': '20240319', 'rank': 12},
        {'dateId': '20240321', 'rank': 15},
        {'dateId': '20240323', 'rank': 17},
        {'dateId': '20240325', 'rank': 16},
        {'dateId': '20240327', 'rank': 19},
        {'dateId': '20240329', 'rank': 20},
        {'dateId': '20240331', 'rank': 18},
      ]);
      final result = generateChartData(calenderType: CalenderType.c1m, now: now, rankingData: rankingData);
      
      final expectedStartDate = DateTime(2024, 3, 1);
      expect(result.startDate, expectedStartDate);

      expect(result.spots.length, 16); // (31-1)/2 + 1 = 16 spots
      expect(result.spots[0], FlSpot(0, 5)); // 20240301 is 0 days after 20240301
      expect(result.spots[1], FlSpot(2, 10)); // 20240303 is 2 days after 20240301
      expect(result.spots.last, FlSpot(30, 18)); // 20240331 is 30 days after 20240301
    });

    test('should return correct FlSpots for CalenderType.c1y with mixed interval data (ensure only data within year is taken)', () {
      final rankingData = createDummyRankingData([
        {'dateId': '20231230', 'rank': 100}, // 前年 (無視される)
        {'dateId': '20240101', 'rank': 20},
        {'dateId': '20240115', 'rank': 25},
        {'dateId': '20240310', 'rank': 30}, // now (2024/3/15) より前のデータ
        {'dateId': '20240620', 'rank': 15},
        {'dateId': '20241231', 'rank': 22},
        {'dateId': '20250105', 'rank': 50}, // 翌年 (無視される)
      ]);
      // now は 2024/3/15 だが、c1y の場合はその年の1/1から12/31までが対象
      final result = generateChartData(calenderType: CalenderType.c1y, now: now, rankingData: rankingData);
      
      final expectedStartDate = DateTime(2024, 1, 1);
      expect(result.startDate, expectedStartDate);

      expect(result.spots.length, 5);
      expect(result.spots[0], FlSpot(0, 20));   // 20240101 is 0 days after 20240101
      expect(result.spots[1], FlSpot(14, 25)); // 20240115 is 14 days after 20240101
      expect(result.spots[2], FlSpot(DateTime(2024,3,10).difference(expectedStartDate).inDays.toDouble(), 30));
      expect(result.spots[3], FlSpot(DateTime(2024,6,20).difference(expectedStartDate).inDays.toDouble(), 15));
      expect(result.spots[4], FlSpot(DateTime(2024,12,31).difference(expectedStartDate).inDays.toDouble(), 22));
    });

    test('should return empty list if rankingData is empty', () {
      final rankingData = createDummyRankingData([]);
      final result = generateChartData(calenderType: CalenderType.c2w, now: now, rankingData: rankingData);
      expect(result.spots.isEmpty, true);
      // startDate は now と calenderType に基づいて設定される
      expect(result.startDate, DateTime(2024, 3, 2)); 
    });

    test('should return empty list if rankingData is outside the CalenderType range', () {
      final rankingData = createDummyRankingData([
        {'dateId': '20240220', 'rank': 10}, // c2w (3/2-3/15) の範囲外
        {'dateId': '20240225', 'rank': 12}, // c2w (3/2-3/15) の範囲外
      ]);
      final result = generateChartData(calenderType: CalenderType.c2w, now: now, rankingData: rankingData);
      expect(result.spots.isEmpty, true);
      expect(result.startDate, DateTime(2024, 3, 2));
    });

    test('should correctly sort rankingData by dateId', () {
      // 順不同のデータ
      final rankingData = createDummyRankingData([
        {'dateId': '20240307', 'rank': 9},
        {'dateId': '20240303', 'rank': 10}, 
        {'dateId': '20240305', 'rank': 12},
      ]);
      final result = generateChartData(calenderType: CalenderType.c2w, now: now, rankingData: rankingData);
      
      expect(result.startDate, DateTime(2024, 3, 2));
      expect(result.spots.length, 3);
      expect(result.spots[0], FlSpot(1, 10)); // 20240303
      expect(result.spots[1], FlSpot(3, 12)); // 20240305
      expect(result.spots[2], FlSpot(5, 9));  // 20240307
    });
  });
}
