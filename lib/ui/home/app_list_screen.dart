import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../model/enum/firestore.dart';
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
                leading: CachedNetworkImage(
                  imageUrl: app.entity.appIcon,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                title: Text(app.entity.appName),
                onTap: () {
                  context.go(
                    '/appList/${genre.name}/chart',
                    extra: app,
                  );
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
