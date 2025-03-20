import 'dart:developer';
import 'package:direct_link/direct_link.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoDownloaderRepository {
  Future<SiteModel?> getAvailableVideos({required String url}) async {
    log(url);
    try {
      var directLink = DirectLink();
      var data = await directLink.check(url);

      if (data != null) {
        return data;
      } else {
        return null;
      }
    } on Exception catch (e) {
      log("Extractor error :$e");
      return null;
    }
  }

  Future<Video> getDataFromYoutube({required String url}) async {
    var yt = YoutubeExplode();
    try {
      var video = await yt.videos.get(url);
      log("YouTube video metadata: ${video.title}");
      return video;
    } finally {
      yt.close();
    }
  }

  Future<Map<String, String>> getYoutubeStreams({required String url}) async {
    var yt = YoutubeExplode();
    try {
      var manifest = await yt.videos.streamsClient.getManifest(url);

      // Prefer muxed stream if available
      if (manifest.muxed.isNotEmpty) {
        var streamInfo = manifest.muxed.sortByVideoQuality().first;
        log("Using muxed stream URL: ${streamInfo.url}");
        return {'video': streamInfo.url.toString()};
      }
      // Get separate video and audio streams
      else {
        var videoStream = manifest.video.sortByVideoQuality().first;
        var audioStream = manifest.audioOnly.sortByBitrate().first;
        log("Using video stream: ${videoStream.url}");
        log("Using audio stream: ${audioStream.url}");
        return {
          'video': videoStream.url.toString(),
          'audio': audioStream.url.toString()
        };
      }
    } catch (e) {
      log("YouTube stream fetch error: $e");
      throw Exception("Failed to fetch streams: $e");
    } finally {
      yt.close();
    }
  }
}
