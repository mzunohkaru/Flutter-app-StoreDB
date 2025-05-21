import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/enum/genre.dart';
import 'widget/app_list_widget.dart';

class AppListScreen extends StatelessWidget {
  const AppListScreen({super.key, required this.genre});
  final Genre genre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genre.title),
      ),
      body: AppListWidget(
        genre: genre,
        onTap: (app) {
          context.go(
            '/appList/${genre.name}/chart',
            extra: app,
          );
        },
      ),
    );
  }
}
