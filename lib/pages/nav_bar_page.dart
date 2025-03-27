import 'package:flutter/material.dart';
import 'package:videos_app_version_2/pages/home_page.dart';
import 'package:videos_app_version_2/pages/live_streaming_page.dart';
import 'package:videos_app_version_2/pages/social_links_download_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int screenIndex = 0;
  final screens = [
    const HomePage(),
    const SocialLinksDownloadPage(),
    const LiveStreamingPage(),
    // const TestSvgPage(),
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.stream_outlined),
          //   activeIcon: Icon(Icons.stream),
          //   label: "Stream",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_outlined),
            activeIcon: Icon(Icons.image),
            label: "Stream",
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
