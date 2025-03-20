import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:direct_link/direct_link.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videos_app_version_2/repository/video_downloader_repository.dart';

class FacebookAndInstagramDownLoadPage extends StatefulWidget {
  const FacebookAndInstagramDownLoadPage({super.key});

  @override
  State<FacebookAndInstagramDownLoadPage> createState() =>
      _FacebookAndInstagramDownLoadPageState();
}

class _FacebookAndInstagramDownLoadPageState
    extends State<FacebookAndInstagramDownLoadPage> {
  final textController = TextEditingController();
  SiteModel? videoData;
  int selectedLinkIndex = 0;
  bool isSearching = false;
  bool isDownloading = false;
  double progressValue = 0;
  String fileName = '';

  Future<void> performDownloading(String url) async {
    // log("Download URL :$url");
    Dio dio = Dio();
    var permissions =
        await [Permission.storage, Permission.manageExternalStorage].request();
    // log("${permissions[Permission.storage]!.isGranted}");

    if (permissions[Permission.storage]!.isGranted) {
      // Directory? dir = Directory('/storage/emulated/0/Download');
      Directory dir = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : Directory('/storage/emulated/0/Download');
      setState(() {
        fileName =
            "/video-${DateFormat("yyyyMMddHmmss").format(DateTime.now())}.mp4";
      });
      // var path = dir.path + fileName;

      var path =
          "${dir.path}/video-${DateFormat("yyyyMMddHmmss").format(DateTime.now())}.mp4";
      try {
        setState(() => isDownloading = true);
        await dio.download(
          url,
          path,
          onReceiveProgress: (count, total) {
            if (total != -1) {
              setState(() {
                progressValue = (count / total * 100);
                log("Downloading ..... $progressValue");
              });
            }
          },
          deleteOnError: true,
        ).then((value) {
          setState(() {
            isDownloading = false;
            progressValue = 0;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Downloaded to $path")),
            );
          });
        });
      } catch (e) {
        log("Download error: $e");

        setState(() => isDownloading = false);

        ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(content: const Text("Download fails"), actions: [
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text("OK"))
        ]));
      }
    } else {
      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          content: const Text("Storage permission denied"),
          actions: [
            TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                },
                child: const Text("OK"))
          ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Facepbook & Instagram & Tiktok Links Download"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: ListView(
            children: [
              TextField(
                controller: textController,
                autocorrect: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        textController.clear();
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
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: isSearching || isDownloading
                    ? null
                    : () async {
                        FocusManager.instance.primaryFocus!.unfocus();
                        setState(() {
                          isSearching = true;
                          videoData = null;
                        });
                        try {
                          final result = await VideoDownloaderRepository()
                              .getAvailableVideos(url: textController.text);
                          if (result != null) {
                            log("Result: ${result.title}");
                            setState(() {
                              videoData = result;
                              selectedLinkIndex = 0;
                              isSearching = false;
                            });
                          } else {
                            setState(() => isSearching = false);
                          }
                        } catch (e) {
                          log("Error: $e");
                          setState(() => isSearching = false);
                        }
                      },
                child: const Text("Check Link"),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height / 40),
              isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : videoData == null
                      ? const Text("Video data is null")
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(videoData!.title ?? "No name"),
                            // Text(videoData!.message ?? "No message"),
                            Text(videoData!.duration ?? "No duration"),
                            CachedNetworkImage(
                              imageUrl: videoData!.thumbnail ?? "",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: videoData!.links!.length,
                              itemBuilder: (context, index) {
                                final video = videoData!.links![index];
                                return RadioListTile<int>(
                                  value: index,
                                  groupValue: selectedLinkIndex,
                                  onChanged: isDownloading
                                      ? null
                                      : (int? value) {
                                          setState(() {
                                            selectedLinkIndex = value!;
                                          });
                                        },
                                  title: Text(video.type ?? "Video $index"),
                                );
                              },
                            ),
                            if (isDownloading) ...[
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                  value: progressValue / 100),
                              Text("${progressValue.toStringAsFixed(1)}%"),
                            ],
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(20),
                                fixedSize: Size.fromWidth(
                                    MediaQuery.sizeOf(context).width),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: isDownloading
                                  ? null
                                  : () async {
                                      final selectedLink =
                                          videoData!.links![selectedLinkIndex];
                                      final downloadUrl = selectedLink.link;
                                      await performDownloading(downloadUrl);
                                    },
                              child: const Text("Download"),
                            ),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
