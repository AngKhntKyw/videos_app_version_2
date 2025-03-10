import 'dart:developer';
import 'package:extractor/extractor.dart';

class VideoDownloaderRepository {
  Future<VideoData?> getAvailableVideos({required String url}) async {
    log(url);
    try {
      final response = await Extractor.getDirectLink(link: "$url");
      if (response != null) {
        return response;
      }
      return null;
      // var directLink = DirectLink();
      // var data = await directLink.check("$url");

      // if (data != null) {
      //   return data;
      // } else {
      //   return null;
      // }
    } on Exception catch (e) {
      log("Extractor error :$e");
      return null;
    }
  }
}
