import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_data.freezed.dart';
part 'app_data.g.dart';

@freezed
class AppData with _$AppData {
  const factory AppData({
    required String appName,
    required String appIcon,
    required String appUrl,
  }) = _AppData;

  factory AppData.fromJson(Map<String, dynamic> json) =>
      _$AppDataFromJson(json);
  const AppData._();
}
