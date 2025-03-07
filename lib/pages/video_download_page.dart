import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:direct_link/direct_link.dart';
import 'package:extractor/extractor.dart';
import 'package:flutter/material.dart';
import 'package:videos_app_version_2/repository/video_downloader_repository.dart';

class VideoDownloadPage extends StatefulWidget {
  const VideoDownloadPage({super.key});

  @override
  State<VideoDownloadPage> createState() => _VideoDownloadPageState();
}

class _VideoDownloadPageState extends State<VideoDownloadPage> {
  final textController = TextEditingController();
  // double progressValue = 0;
  // bool isDownloading = false;
  // List<VideoQuality> qualities = [];
  // VideoDownload? video;
  // bool isLoading = false;
  // int selectedQualityIndex = 0;
  // String fileName = '';
  // bool isSearching = false;
  // VideoType videoType = VideoType.none;
  SiteModel? videoData;
  int selectedLinkIndex = 0;
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: ListView(
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            textController.clear();
                          });
                        },
                        icon: const Icon(Icons.close))),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height / 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                onPressed: () async {
                  FocusManager.instance.primaryFocus!.unfocus();
                  setState(() {
                    isSearching = true;
                  });
                  final result = await VideoDownloaderRepository()
                      .getAvailableVideos(url: textController.text);
                  log("Result status ${result!}");
                  setState(() {
                    videoData = result;
                    isSearching = false;
                  });
                },
                child: const Text("Check Link"),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height / 40),

              //
              isSearching
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : videoData == null
                      ? const Text("Video data is null")
                      : Text(
                          videoData!.title ?? "No name",
                        ),

              //
            ],
          ),
        ),
      ),
    );
  }
}

// videoData!.status == true
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("${videoData!.message}"),
//                                 Text(videoData!.title!),
//                                 Text(videoData!.duration!),
//                                 CachedNetworkImage(
//                                     imageUrl: videoData!.thumbnail ?? ""),
//                                 ListView.builder(
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemCount: videoData!.links!.length,
//                                   itemBuilder: (context, index) {
//                                     final video = videoData!.links![index];
//                                     return RadioListTile<int>(
//                                       value: index,
//                                       groupValue: selectedLinkIndex,
//                                       onChanged: (int? value) {
//                                         setState(() {
//                                           selectedLinkIndex = value!;
//                                         });
//                                       },
//                                       title: Text(video.text ?? "Video $index"),
//                                     );
//                                   },
//                                 ),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     padding: const EdgeInsets.all(20),
//                                     fixedSize: Size.fromWidth(
//                                         MediaQuery.sizeOf(context).width),
//                                     backgroundColor: Colors.green,
//                                     foregroundColor: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                   ),
//                                   onPressed: () async {},
//                                   child: const Text("Download"),
//                                 ),
//                               ],
//                             )
//                           : const Text("Fail"),



  // IconData? get _getBrandIcon {
  //   switch (videoType) {
  //     case VideoType.facebook:
  //       return Icons.facebook;
  //     case VideoType.instagram:
  //       return Icons.g_mobiledata;
  //     case VideoType.tiktok:
  //       return Icons.tiktok;
  //     case VideoType.youtube:
  //       return Icons.video_collection;
  //     case VideoType.twitter:
  //       return Icons.tab;
  //     case VideoType.none:
  //       return Icons.note_outlined;
  //     default:
  //       return null;
  //   }
  // }

  // String? get _getFilePrefix {
  //   switch (videoType) {
  //     case VideoType.facebook:
  //       return "facebook";
  //     case VideoType.instagram:
  //       return "instagram";
  //     case VideoType.tiktok:
  //       return "tiktok";
  //     case VideoType.youtube:
  //       return "youtube";
  //     case VideoType.twitter:
  //       return "twitter";
  //     case VideoType.none:
  //       return "none";
  //     default:
  //       return null;
  //   }
  // }

  // void setVideoType(String url) {
  //   if (url.isEmpty) {
  //     setState(() => videoType = VideoType.none);
  //   } else if (url.contains("facebook.com") || url.contains("fb.watch")) {
  //     setState(() => videoType = VideoType.facebook);
  //   } else if (url.contains("youtube.com") || url.contains("youtu.be")) {
  //     setState(() => videoType = VideoType.youtube);
  //   } else if (url.contains("twitter.com")) {
  //     setState(() => videoType = VideoType.twitter);
  //   } else if (url.contains("instagram.com")) {
  //     setState(() => videoType = VideoType.instagram);
  //   } else if (url.contains("tiktok.com")) {
  //     setState(() => videoType = VideoType.tiktok);
  //   } else {
  //     setState(() => videoType = VideoType.none);
  //   }
  // }

  // Future<void> performDownloading(String url) async {
  //   Dio dio = Dio();
  //   var permissions = await [Permission.storage].request();

  //   if (permissions[Permission.storage]!.isGranted) {
  //     var dir = await getApplicationDocumentsDirectory();

  //     setState(() {
  //       fileName =
  //           "/$_getFilePrefix-${DateFormat("yyyyMMddHmmss").format(DateTime.now())}.mp4";
  //     });
  //     var path = dir.path + fileName;
  //     try {
  //       setState(() => isDownloading = true);
  //       await dio.download(
  //         url,
  //         path,
  //         onReceiveProgress: (count, total) {
  //           if (total != -1) {
  //             setState(() {
  //               progressValue = (count / total * 100);
  //               log("Downloading ..... $progressValue");
  //             });
  //           }
  //         },
  //         deleteOnError: true,
  //       ).then(
  //         (value) {
  //           setState(() {
  //             isDownloading = false;
  //             progressValue = 0;
  //             videoType = VideoType.none;
  //             isLoading = false;
  //             qualities = [];
  //             video = null;
  //           });
  //         },
  //       );
  //     } catch (e) {
  //       log("Error $e");
  //     }
  //   }
  // }