import 'package:flutter/material.dart';
import 'package:videos_app_version_2/pages/facebook_and_instagram_download_page.dart';
import 'package:videos_app_version_2/pages/youtube_links_download_page.dart';

class SocialLinksDownloadPage extends StatefulWidget {
  const SocialLinksDownloadPage({super.key});

  @override
  State<SocialLinksDownloadPage> createState() =>
      _SocialLinksDownloadPageState();
}

class _SocialLinksDownloadPageState extends State<SocialLinksDownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Social Links Download"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const FacebookAndInstagramDownLoadPage(),
                    ));
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: const Text(
                  "Facebook & Instagram",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YoutubeLinksDownloadPage(),
                    ));
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red,
                ),
                child: const Text(
                  "Youtube",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
