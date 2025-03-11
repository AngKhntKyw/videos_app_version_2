import 'package:flutter/material.dart';
import 'package:videos_app_version_2/repository/video_downloader_repository.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeLinksDownloadPage extends StatefulWidget {
  const YoutubeLinksDownloadPage({super.key});

  @override
  State<YoutubeLinksDownloadPage> createState() =>
      _YoutubeLinksDownloadPageState();
}

class _YoutubeLinksDownloadPageState extends State<YoutubeLinksDownloadPage> {
  final youtubeLinkController = TextEditingController();
  Video? videoData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youtube Links Download"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            TextField(
              controller: youtubeLinkController,
              autocorrect: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      youtubeLinkController.clear();
                      videoData = null;
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height / 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () {
                VideoDownloaderRepository()
                    .getDataFromYoutube(url: youtubeLinkController.text);
              },
              child: const Text("check link"),
            ),
          ],
        ),
      ),
    );
  }
}
