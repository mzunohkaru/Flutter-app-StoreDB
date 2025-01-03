import 'package:freezed_annotation/freezed_annotation.dart';

import '../../exception/app_exception.dart';
import '../../model/entity/app_data/app_data_document.dart';

part 'app_data_state.freezed.dart';

@freezed
class AppDataState with _$AppDataState {
  const factory AppDataState({
    required List<AppDataDocument> appDataDocList,
    AppException? exception,
  }) = _AppDataState;

  factory AppDataState.initial() => AppDataState(
        appDataDocList: [],
      );

  factory AppDataState.loading() => AppDataState.initial().copyWith(
        exception: null,
      );

  factory AppDataState.error(AppException exception) =>
      AppDataState.initial().copyWith(
        exception: exception,
      );

  const AppDataState._();

  bool get isLoading => this is _AppDataState && exception == null;
  bool get hasError => exception != null;
  bool get isEmpty => appDataDocList.isEmpty;
}
