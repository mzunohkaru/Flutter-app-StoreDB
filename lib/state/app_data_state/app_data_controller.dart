import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../exception/app_exception.dart';
import '../../model/enum/firestore.dart';
import '../../repository/app_data_repository/app_data_repository_impl.dart';
import 'app_data_state.dart';

part 'app_data_controller.g.dart';

@Riverpod(keepAlive: true)
class AppDataController extends _$AppDataController {
  @override
  FutureOr<AppDataState> build({
    required Genre genre,
  }) async {
    return await _fetch(genre: genre);
  }

  Future<AppDataState> _fetch({
    required Genre genre,
  }) async {
    try {
      final appDataDocList = await ref
          .read(appDataRepositoryProvider)
          .fetchDocList(country: Country.jp, genre: genre);

      return AppDataState(
        appDataDocList: appDataDocList,
      );
    } on AppException catch (e) {
      return AppDataState.error(e);
    }
  }

  // リフレッシュ処理
  Future<void> refresh({
    required Genre genre,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => _fetch(genre: genre));
  }
}
