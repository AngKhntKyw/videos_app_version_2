import 'dart:developer';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videos_app_version_2/core/enum/download_status.dart';
import 'package:videos_app_version_2/core/model/course.dart';
import 'package:videos_app_version_2/core/model/lesson.dart';
import 'package:videos_app_version_2/providers/course_provider.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> with RouteAware {
  // Better Player
  final GlobalKey<BetterPlayerPlaylistState> betterPlayerPlaylistStateKey =
      GlobalKey();
  BetterPlayerPlaylistController? get getKey =>
      betterPlayerPlaylistStateKey.currentState!.betterPlayerPlaylistController;
  late BetterPlayerConfiguration betterPlayerConfiguration;
  late BetterPlayerPlaylistConfiguration betterPlayerPlaylistConfiguration;

  //

  @override
  void initState() {
    context.read<CourseProvider>().setUpVideoDataSource(course: widget.course);
    initBetterPlayer();
    super.initState();
  }

  @override
  void didPop() async {
    context.read<CourseProvider>().clearDataSources();
    await getKey?.betterPlayerController!.clearCache();
    await getKey?.betterPlayerController!.videoPlayerController!.dispose();
    getKey?.betterPlayerController!.dispose(forceDispose: true);
    getKey?.dispose();
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    return Scaffold(
        appBar: AppBar(),
        body: courseProvider.currentCourse == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BetterPlayerPlaylist(
                    betterPlayerConfiguration: betterPlayerConfiguration,
                    key: betterPlayerPlaylistStateKey,
                    betterPlayerDataSourceList: courseProvider.dataSourceList,
                    betterPlayerPlaylistConfiguration:
                        betterPlayerPlaylistConfiguration,
                  ),
                  Expanded(
                    child: ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: courseProvider.currentCourse!.units.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          childrenPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          maintainState: false,
                          shape: const ContinuousRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 0)),
                          controlAffinity: ListTileControlAffinity.trailing,
                          enableFeedback: true,
                          expansionAnimationStyle: AnimationStyle(
                            curve: Curves.easeInOut,
                            reverseCurve: Curves.easeInOut,
                          ),
                          dense: true,
                          title: Text(widget.course.units[index].name),
                          subtitle: Text(
                              "${widget.course.units[index].lessons.length} lessons"),
                          onExpansionChanged: (value) {},
                          children: [
                            //
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: courseProvider
                                  .currentCourse!.units[index].lessons.length,
                              itemBuilder: (context, lessonIndex) {
                                Lesson currentLesson = courseProvider
                                    .currentCourse!
                                    .units[index]
                                    .lessons[lessonIndex];

                                //
                                return ListTile(
                                  dense: true,
                                  leading: courseProvider.isLessonWatching(
                                          lessonId: currentLesson.id)
                                      ? const Icon(
                                          Icons.pause_circle,
                                          color: Colors.green,
                                        )
                                      : const Icon(Icons.play_circle),
                                  title: Text(
                                    currentLesson.title,
                                  ),
                                  subtitle: Text(
                                    currentLesson.downloadModel!.path,
                                    maxLines: 2,
                                  ),
                                  trailing: trailingIcon(
                                      currentLesson: currentLesson,
                                      courseProvider: courseProvider),
                                  onTap: () async {
                                    if (currentLesson.lessonUrl != null) {
                                      final courseProvider =
                                          context.read<CourseProvider>();

                                      await getKey?.betterPlayerController!
                                          .clearCache();

                                      getKey?.setupDataSource(courseProvider
                                          .findDataSourceIndexByLesson(
                                        lesson: currentLesson,
                                      ));

                                      courseProvider.setWatchingLesson(
                                        lesson: currentLesson,
                                      );
                                    } else {
                                      log("Lesson URL : null");
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ));
  }

  Widget trailingIcon({
    required Lesson currentLesson,
    required CourseProvider courseProvider,
  }) {
    switch (currentLesson.downloadModel!.status) {
      case DownloadStatus.success:
        return const Icon(Icons.download_done);

      case DownloadStatus.fail:
        return const Icon(Icons.info);

      case DownloadStatus.running:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            backgroundColor: const Color.fromARGB(255, 206, 205, 205),
            strokeWidth: 2,
            color: Colors.green,
            value: currentLesson.downloadModel!.progress,
          ),
        );

      case DownloadStatus.waiting:
        return const Icon(Icons.watch_later_rounded);

      case DownloadStatus.none:
        return InkWell(
            onTap: () {
              courseProvider.createDownload(lesson: currentLesson);
            },
            child: const Icon(Icons.download));

      default:
        return const SizedBox.shrink();
    }
  }

  void initBetterPlayer() async {
    final courseProvider = context.read<CourseProvider>();

    //
    betterPlayerConfiguration = BetterPlayerConfiguration(
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        progressBarHandleColor: Colors.green,
        progressBarBackgroundColor: Colors.white,
        progressBarBufferedColor: Colors.grey,
        progressBarPlayedColor: Colors.green,
        enableMute: true,
        iconsColor: Colors.white,
      ),
      autoPlay: false,
      fit: BoxFit.contain,
      autoDetectFullscreenDeviceOrientation: true,
      autoDetectFullscreenAspectRatio: true,
      fullScreenByDefault: false,
      autoDispose: true,
      aspectRatio: 16 / 9,
      fullScreenAspectRatio: 16 / 9,
      handleLifecycle: true,
      eventListener: (event) async {
        switch (event.betterPlayerEventType) {
          //
          case BetterPlayerEventType.setupDataSource:
            break;

          case BetterPlayerEventType.initialized:
            getKey?.betterPlayerController!.setControlsVisibility(false);
            // await getKey?.betterPlayerController!.play();
            break;

          case BetterPlayerEventType.changedTrack:
            if (!mounted) return;
            await getKey?.betterPlayerController!.clearCache();

            if (getKey!.currentDataSourceIndex != 0) {
              final lesson = courseProvider.findLessonByDataSourceIndex(
                index: getKey?.currentDataSourceIndex,
              );

              courseProvider.setWatchingLesson(lesson: lesson);

              final aspectRatio = getKey?.betterPlayerController!
                  .videoPlayerController!.value.aspectRatio;
              getKey?.betterPlayerController!
                  .setOverriddenAspectRatio(aspectRatio!);
            }
            break;

          case BetterPlayerEventType.finished:
            await getKey?.betterPlayerController!.clearCache();
            break;

          default:
            break;
        }
      },
    );

    betterPlayerPlaylistConfiguration = const BetterPlayerPlaylistConfiguration(
      loopVideos: false,
      nextVideoDelay: Duration(seconds: 5),
      // initialStartIndex: lastWatchingIndex,
    );
  }
}
