import 'dart:developer';
import 'package:videos_app_version_2/core/model/video_download.dart';
import 'package:extractor/extractor.dart';
import 'package:videos_app_version_2/core/model/video_quality.dart';

class VideoDownloaderRepository {
  Future<VideoData?> getAvailableVideos({required String url}) async {
    try {
      final response = await Extractor.getDirectLink(link: url);

      if (response != null) {
        return response;
        //     return VideoDownload.fromJson({
        //   "title": response.title,
        //   "source": response.links?.first.href,
        //   "thumbnail": response.thumbnail,
        //   "videos": [
        //     VideoQuality(
        //       url: response.links?.first.href,
        //       quality: "720",
        //     ),
        //   ],
        // });
      } else {
        return null;
      }
    } on Exception catch (e) {
      log("Extractor error :$e");
      return null;
    }
  }
}
