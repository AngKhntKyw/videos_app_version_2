import 'package:flutter/material.dart';
import 'package:videos_app_version_2/pages/home_page.dart';
import 'package:videos_app_version_2/pages/local_data_storage_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int screenIndex = 0;
  final screens = [
    const HomePage(),
    const LocalDataStoragePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[screenIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sd_storage_outlined),
            activeIcon: Icon(Icons.sd_storage),
            label: "Local",
          ),
        ],
        currentIndex: screenIndex,
        onTap: (value) {
          setState(() {
            screenIndex = value;
          });
        },
      ),
    );
  }
}
