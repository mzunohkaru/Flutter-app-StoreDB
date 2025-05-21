import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/enum/genre.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Store DB'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              if (!context.mounted) {
                return;
              }
              context.go('/appList/${Genre.socialNetworking.name}');
            },
            child: Text(Genre.socialNetworking.title),
          ),
          ElevatedButton(
            onPressed: () {
              if (!context.mounted) {
                return;
              }
              context.go('/appList/${Genre.business.name}');
            },
            child: Text(Genre.business.title),
          ),
          ElevatedButton(
            onPressed: () {
              if (!context.mounted) {
                return;
              }
              context.go('/appList/${Genre.healthAndFitness.name}');
            },
            child: Text(Genre.healthAndFitness.title),
          ),
          ElevatedButton(
            onPressed: () {
              if (!context.mounted) {
                return;
              }
              context.go('/appList/${Genre.lifeStyle.name}');
            },
            child: Text(Genre.lifeStyle.title),
          ),
          ElevatedButton(
            onPressed: () {
              if (!context.mounted) {
                return;
              }
              context.go('/appList/${Genre.travel.name}');
            },
            child: Text(Genre.travel.title),
          ),
        ],
      ),
    );
  }
}
