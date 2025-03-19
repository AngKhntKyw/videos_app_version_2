import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:videos_app_version_2/repository/video_downloader_repository.dart';

class YoutubeLinksDownloadPage extends StatefulWidget {
  const YoutubeLinksDownloadPage({super.key});

  @override
  State<YoutubeLinksDownloadPage> createState() =>
      _YoutubeLinksDownloadPageState();
}

class _YoutubeLinksDownloadPageState extends State<YoutubeLinksDownloadPage> {
  final VideoDownloaderRepository _repository = VideoDownloaderRepository();
  final TextEditingController youtubeLinkController = TextEditingController();
  bool isDownloading = false;
  double progressValue = 0;
  String? downloadPath;

  Future<void> _downloadVideo(String url) async {
    Dio dio = Dio();
    try {
      var video = await _repository.getDataFromYoutube(url: url);
      Map<String, String> streams =
          await _repository.getYoutubeStreams(url: url);

      Directory dir = await getApplicationDocumentsDirectory();
      String finalPath =
          "${dir.path}/video-${video.id}-${DateTime.now().toIso8601String()}.mp4";
      String tempVideoPath = "${dir.path}/temp-video-${video.id}.mp4";
      String? tempAudioPath;

      setState(() => isDownloading = true);

      // Download video stream
      await dio.download(
        streams['video']!,
        tempVideoPath,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            setState(() {
              progressValue = streams.containsKey('audio')
                  ? (count / total * 50)
                  : (count / total * 100);
            });
          }
        },
      );

      // If we have an audio stream, download and merge
      if (streams.containsKey('audio')) {
        tempAudioPath = "${dir.path}/temp-audio-${video.id}.mp3";

        // Download audio stream
        await dio.download(
          streams['audio']!,
          tempAudioPath,
          onReceiveProgress: (count, total) {
            if (total != -1) {
              setState(() {
                progressValue = 50 + (count / total * 50); // 50% for audio
              });
            }
          },
        );

        // Merge video and audio using FFmpeg
        String command =
            '-i "$tempVideoPath" -i "$tempAudioPath" -c:v copy -c:a aac "$finalPath"';
        await FFmpegKit.execute(command).then((session) async {
          final returnCode = await session.getReturnCode();
          if (returnCode?.isValueSuccess() != true) {
            throw Exception("FFmpeg merge failed");
          }
        });

        // Clean up temporary files
        await File(tempVideoPath).delete();
        await File(tempAudioPath).delete();
      } else {
        // If no separate audio, just rename the video file
        await File(tempVideoPath).rename(finalPath);
      }

      setState(() {
        isDownloading = false;
        progressValue = 0;
        downloadPath = finalPath;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Downloaded to $finalPath")),
        );
      });
    } catch (e) {
      log("Download error: $e");
      setState(() => isDownloading = false);
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text("Download failed: $e"),
          actions: [
            TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("YouTube Video Downloader")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: youtubeLinkController,
              decoration: const InputDecoration(
                labelText: "Enter YouTube URL",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isDownloading
                  ? null
                  : () {
                      if (youtubeLinkController.text.isNotEmpty) {
                        _downloadVideo(youtubeLinkController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter a URL")),
                        );
                      }
                    },
              child: const Text("Download Video"),
            ),
            if (isDownloading) ...[
              const SizedBox(height: 20),
              LinearProgressIndicator(value: progressValue / 100),
              Text("${progressValue.toStringAsFixed(1)}%"),
            ],
            if (downloadPath != null && !isDownloading) ...[
              const SizedBox(height: 20),
              Text("Saved to: $downloadPath"),
            ],
          ],
        ),
      ),
    );
  }
}
