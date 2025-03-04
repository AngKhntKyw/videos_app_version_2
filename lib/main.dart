import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videos_app_version_2/pages/nav_bar_page.dart';
import 'package:videos_app_version_2/providers/course_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => CourseProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Videos App Version 2',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const NavigationBarPage(),
      ),
    );
  }
}
