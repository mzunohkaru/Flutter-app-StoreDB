import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/enum/firestore.dart';
import '../../repository/ranking_repository/ranking_repository_impl.dart';
import '../../state/app_data_state/app_data_controller.dart';

class AppListScreen extends ConsumerWidget {
  const AppListScreen({super.key, required this.genre});
  final Genre genre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appDataState = ref.watch(appDataControllerProvider(genre: genre));

    return Scaffold(
      appBar: AppBar(
        title: Text(genre.title),
      ),
      body: appDataState.when(
        data: (state) {
          return ListView.builder(
            itemCount: state.appDataDocList.length,
            itemBuilder: (context, index) {
              final app = state.appDataDocList[index];
              return ListTile(
                leading: Image.network(app.entity.appIcon),
                title: Text(app.entity.appName),
                onTap: () async {
                  try {
                    print(app.ref.id);
                    final list =
                        await ref.read(rankingRepositoryProvider).fetchDoc(
                              country: Country.jp,
                              genre: genre,
                              appId: app.ref.id,
                              date: "20250103",
                            );
                    print(list.entity.rank.toString());
                  } catch (e) {
                    print(e);
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
    );
  }
}
