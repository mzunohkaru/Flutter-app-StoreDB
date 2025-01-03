import 'package:flutter/material.dart';

import '../../model/enum/firestore.dart';
import 'app_list_screen.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AppListScreen(genre: Genre.socialNetworking),
                ),
              );
            },
            child: Text(Genre.socialNetworking.title),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppListScreen(genre: Genre.business),
                ),
              );
            },
            child: Text(Genre.business.title),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AppListScreen(genre: Genre.healthAndFitness),
                ),
              );
            },
            child: Text(Genre.healthAndFitness.title),
          ),
        ],
      ),
    );
  }
}
