import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  App({super.key});

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Store DB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Store DB'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () async {
              final doc = firestore
                  .collection('/jp/v1/6005/v1/1017604270/v1/20241230');
              final snapshot = await doc.get();
              print(snapshot.docs.map((e) => e.data()));
            },
            child: const Text('data'),
          ),
        ),
      ),
    );
  }
}
