import 'dart:developer';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:ivs_broadcaster/Broadcaster/ivs_broadcaster.dart';
import 'package:ivs_broadcaster/Player/Widget/ivs_player_view.dart';
import 'package:ivs_broadcaster/Player/ivs_player.dart';
import 'package:ivs_broadcaster/helpers/enums.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveStreamingPage extends StatefulWidget {
  const LiveStreamingPage({super.key});

  @override
  State<LiveStreamingPage> createState() => _LiveStreamingPageState();
}

class _LiveStreamingPageState extends State<LiveStreamingPage> {
  IvsBroadcaster? ivsBroadcaster;

  String key = "sk_ap-south-1_AqyoLhTaeXXq_5QfxQk4idLrNbp9jkvyjAuWrmF7i2w";
  String url = "rtmps://e80c4ce6902a.global-contribute.live-video.net:443/app/";

  ///
  IvsPlayer? ivsPlayer;
  late BetterPlayerController controller;
  late BetterPlayerDataSource datasource;

  @override
  void initState() {
    super.initState();
    ivsBroadcaster = IvsBroadcaster.instance;
    datasource = BetterPlayerDataSource.network(
      "https://e80c4ce6902a.ap-south-1.playback.live-video.net/api/video/v1/ap-south-1.183093208690.channel.np3uFXKdQHTE.m3u8",
      liveStream: true,
      // videoFormat: BetterPlayerVideoFormat.hls,
    );
    const config = BetterPlayerConfiguration(autoPlay: true);
    controller = BetterPlayerController(
      config,
      betterPlayerDataSource: datasource,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Start Broadcast
            ElevatedButton(
              onPressed: () async {
                await ivsBroadcaster?.requestPermissions();
                await ivsBroadcaster?.startPreview(
                  imgset: url,
                  streamKey: key,
                  quality: IvsQuality.q360,
                  cameraType: CameraType.FRONT,
                );
                await ivsBroadcaster?.startBroadcast();
                ivsBroadcaster!.broadcastState.stream.listen(
                  (event) {
                    log("Event ${event.name}");
                  },
                );
              },
              child: const Text('Start Broadcast'),
            ),

            // Stop Broadcast
            ElevatedButton(
              onPressed: () async {
                await ivsBroadcaster?.stopBroadcast();
              },
              child: const Text('Stop Broadcast'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (ivsPlayer != null)
            Expanded(
              child: IvsPlayerView(
                controller: ivsPlayer!,
                autoDispose: true,
                aspectRatio: 16 / 9,
              ),
            ),
          ElevatedButton(onPressed: playLiveStream, child: const Text("Play")),
          ElevatedButton(onPressed: checkCamera, child: Text('Check')),
          BetterPlayer(controller: controller),
        ],
      ),
    );
  }

  Future<void> checkCamera() async {
    PermissionStatus cameraStatus = await Permission.camera.request();

    if (cameraStatus == PermissionStatus.denied) {
      log("Camera permission $cameraStatus");
    } else {
      log("Camera permission $cameraStatus");
    }
  }

  Future<void> checkMic() async {
    PermissionStatus micStatus = await Permission.microphone.request();

    if (micStatus == PermissionStatus.denied) {
      log("Mic permission $micStatus");
    } else {
      log("Mic permission $micStatus");
    }
  }

  void playLiveStream() {
    ivsPlayer = IvsPlayer();
    ivsPlayer!.startPlayer(
      "https://e80c4ce6902a.ap-south-1.playback.live-video.net/api/video/v1/ap-south-1.183093208690.channel.VFSWoTGudftX.m3u8",
    );
  }
}
