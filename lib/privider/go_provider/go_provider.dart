import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../model/entity/app_data/app_data_document.dart';
import '../../model/enum/app_router.dart';
import '../../model/enum/genre.dart';
import '../../ui/chart/chart_screen.dart';
import '../../ui/app_list/app_list_screen.dart';
import '../../ui/home/home_screen.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: AppRoute.home.path,
      routes: [
        GoRoute(
          path: AppRoute.home.path,
          name: AppRoute.home.name,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: '${AppRoute.appList.path}/:genre',
              name: AppRoute.appList.name,
              builder: (BuildContext context, GoRouterState state) {
                final genre = state.pathParameters['genre']!;
                return AppListScreen(genre: Genre.values.byName(genre));
              },
              routes: [
                GoRoute(
                  path: AppRoute.chart.path,
                  name: AppRoute.chart.name,
                  builder: (BuildContext context, GoRouterState state) {
                    final genre = state.pathParameters['genre']!;
                    return ChartScreen(
                      appDataDoc: state.extra as AppDataDocument,
                      genre: Genre.values.byName(genre),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  },
);
