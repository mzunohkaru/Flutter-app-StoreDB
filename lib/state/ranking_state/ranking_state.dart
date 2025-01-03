import 'package:freezed_annotation/freezed_annotation.dart';

import '../../exception/app_exception.dart';
import '../../model/entity/ranking/ranking_document.dart';

part 'ranking_state.freezed.dart';

@freezed
class RankingState with _$RankingState {
  const factory RankingState({
    required List<RankingDocument> rankingDocList,
    AppException? exception,
  }) = _RankingState;

  factory RankingState.initial() => RankingState(
        rankingDocList: [],
      );

  factory RankingState.loading() => RankingState.initial().copyWith(
        exception: null,
      );

  factory RankingState.error(AppException exception) =>
      RankingState.initial().copyWith(
        exception: exception,
      );

  const RankingState._();

  bool get isLoading => this is _RankingState && exception == null;
  bool get hasError => exception != null;
  bool get isEmpty => rankingDocList.isEmpty;
}
