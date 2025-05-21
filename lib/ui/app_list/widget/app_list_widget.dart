import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/entity/app_data/app_data_document.dart';
import '../../../model/enum/firestore.dart';
import '../../../state/app_data_state/app_data_controller.dart';

class AppListWidget extends ConsumerWidget {
  const AppListWidget({
    super.key,
    required this.genre,
    required this.onTap,
  });
  final Genre genre;
  final Function(AppDataDocument) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appDataState = ref.watch(appDataControllerProvider(genre: genre));

    return appDataState.when(
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
                onTap(app);
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
    );
  }
}
