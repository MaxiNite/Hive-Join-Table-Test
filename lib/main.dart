import 'package:flutter/material.dart';
import 'package:hive_join_table_test/database/database.dart';
import 'package:hive_join_table_test/screens/options.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AppDatabase(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hive Join Tables Tutorial',
        home: Options(),
      ),
    );
  }
}
