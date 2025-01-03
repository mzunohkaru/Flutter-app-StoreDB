import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../exception/app_exception.dart';
import '../../model/enum/firestore.dart';
import '../../repository/ranking_repository/ranking_repository_impl.dart';
import 'ranking_state.dart';

part 'ranking_controller.g.dart';

@Riverpod(keepAlive: true)
class RankingController extends _$RankingController {
  @override
  FutureOr<RankingState> build({
    required Genre genre,
    required String appId,
  }) async {
    return await _fetch(genre: genre, appId: appId);
  }

  Future<RankingState> _fetch({
    required Genre genre,
    required String appId,
  }) async {
    try {
      final rankingDocList = await ref
          .read(rankingRepositoryProvider)
          .fetchList(country: Country.jp, genre: genre, appId: appId);

      return RankingState(
        rankingDocList: rankingDocList,
      );
    } on AppException catch (e) {
      return RankingState.error(e);
    }
  }

  // リフレッシュ処理
  Future<void> refresh({
    required Genre genre,
    required String appId,
  }) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() async => _fetch(genre: genre, appId: appId));
  }
}
