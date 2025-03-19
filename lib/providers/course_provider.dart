import 'dart:async';
import 'dart:developer';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:videos_app_version_2/core/enum/download_status.dart';
import 'package:videos_app_version_2/core/model/course.dart';
import 'package:videos_app_version_2/core/model/download_model.dart';
import 'package:videos_app_version_2/core/model/lesson.dart';
import 'package:videos_app_version_2/core/model/unit.dart';
import 'package:videos_app_version_2/providers/database_helper.dart';
import 'package:videos_app_version_2/providers/m3u8_downloader.dart';

class CourseProvider with ChangeNotifier {
  //
  Course? _currentCourse;
  Course? get currentCourse => _currentCourse;

  final List<BetterPlayerDataSource> _dataSourceList = [];
  List<BetterPlayerDataSource> get dataSourceList => _dataSourceList;

  List<Lesson> _videoLessons = [];
  List<Lesson> get videoLessons => _videoLessons;

  final Map<String, Lesson> _watchingLesson = {};
  Map<String, Lesson> get watchingLesson => _watchingLesson;

  int _lastWatchingLassonIndex = 0;
  int get lastWatchingLessonIndex => _lastWatchingLassonIndex;

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  final M3U8Downloader m3u8Downloader = M3U8Downloader();

  DownloadModel? _currentDownloading;
  DownloadModel? get currentDownloading => _currentDownloading;

  Future<void> initDownloads() async {
    await getDownloads();
  }

  //
  Future<List<DownloadModel>> getDownloads() async {
    return await databaseHelper.getDownloads();
  }

  Future<void> setUpVideoDataSource({required Course course}) async {
    _currentCourse = course;
    _dataSourceList.clear();
    _videoLessons.clear();

    _dataSourceList.add(BetterPlayerDataSource.network(course.introVideoUrl));

    _videoLessons = _currentCourse!.units
        .where((e) => e.lessons.isNotEmpty)
        .expand((unit) => unit.lessons)
        .where((lesson) => lesson.lessonType == 'VIDEO')
        .toList();

    for (Lesson lesson in _videoLessons) {
      final downloadModel = await checkIsDownloaded(lesson: lesson);
      final datasource = downloadModel.status == DownloadStatus.success
          ? BetterPlayerDataSource.file(downloadModel.path)
          : BetterPlayerDataSource.network(lesson.lessonUrl ?? "");
      _dataSourceList.add(datasource);
    }
    await updateCourseWithDownloadStatus();
    getLastWatchingLessonIndex(courseId: "${_currentCourse!.id}");

    //
  }

  Future<void> updataDatasource({required Lesson lesson}) async {
    if (lesson.downloadModel!.status == DownloadStatus.success) {
      int datasourceIndex =
          findDatasourceIndexToUpdateDatasource(lesson: lesson);
      _dataSourceList[datasourceIndex] =
          BetterPlayerDataSource.file(lesson.downloadModel!.path);
    }
    notifyListeners();
  }

  int findDatasourceIndexToUpdateDatasource({required Lesson lesson}) {
    return _dataSourceList
        .indexWhere((element) => element.url == lesson.lessonUrl);
  }

  Future<void> updateCourseWithDownloadStatus() async {
    final updatedUnits = await Future.wait(
      _currentCourse!.units.map((unit) => updateUnitWithDownloadStatus(unit)),
    );
    _currentCourse = _currentCourse!.copyWith(units: updatedUnits);
    notifyListeners();
  }

  Future<Unit> updateUnitWithDownloadStatus(Unit unit) async {
    final updatedLessons = await Future.wait(
      unit.lessons.map((lesson) => updateLessonWithDownloadStatus(lesson)),
    );

    return unit.copyWith(lessons: updatedLessons);
  }

  Future<Lesson> updateLessonWithDownloadStatus(Lesson lesson) async {
    final downloadModel = await checkIsDownloaded(lesson: lesson);
    return lesson.copyWith(downloadModel: downloadModel);
  }

  Future<DownloadModel> checkIsDownloaded({required Lesson lesson}) async {
    final result = await databaseHelper.getDownloads();
    return result.firstWhere(
      (d) => d.id == lesson.id,
      orElse: () => DownloadModel(
        id: lesson.id,
        courseId: _currentCourse!.id,
        lessonTitle: lesson.title,
        url: lesson.lessonUrl!,
        path: '',
        progress: 0,
        status: DownloadStatus.none,
      ),
    );
  }

//
  int findDataSourceIndexByLesson({required Lesson lesson}) {
    if (lesson.downloadModel!.status == DownloadStatus.success) {
      return _dataSourceList
          .indexWhere((element) => element.url == (lesson.downloadModel!.path));
    } else {
      return _dataSourceList
          .indexWhere((element) => element.url == lesson.lessonUrl);
    }
  }

  Lesson findLessonByDataSourceIndex({required int? index}) {
    return _currentCourse!.units
        .where((e) => e.lessons.isNotEmpty)
        .expand((unit) => unit.lessons)
        .firstWhere((lesson) => lesson.lessonUrl == _dataSourceList[index!].url,
            orElse: () => _currentCourse!.units
                .where((e) => e.lessons.isNotEmpty)
                .expand((unit) => unit.lessons)
                .firstWhere((lesson) =>
                    lesson.downloadModel!.path == _dataSourceList[index!].url));
  }

  Lesson getLessonByDownloadModelId({required DownloadModel downloadModel}) {
    return _currentCourse!.units
        .where((e) => e.lessons.isNotEmpty)
        .expand((unit) => unit.lessons)
        .where((lesson) => lesson.lessonType == 'VIDEO')
        .toList()
        .firstWhere((element) => element.id == downloadModel.id);
  }

  bool isLessonWatching({required int lessonId, required String courseId}) {
    if (_watchingLesson.isNotEmpty) {
      return _watchingLesson[courseId]?.id == lessonId;
    }
    return false;
  }

  void getLastWatchingLessonIndex({required String courseId}) {
    log("${_watchingLesson[courseId]}");

    _lastWatchingLassonIndex = _watchingLesson[courseId] == null
        ? 0
        : _watchingLesson[courseId]!.downloadModel!.status ==
                DownloadStatus.none
            ? _dataSourceList.indexWhere((element) =>
                element.url == _watchingLesson[courseId]!.lessonUrl)
            : _dataSourceList.indexWhere(
                (element) =>
                    element.url ==
                    _watchingLesson[courseId]!.downloadModel!.path,
              );
  }

  void setWatchingLesson(
      {required Lesson lesson, required String courseId}) async {
    _watchingLesson[courseId] = lesson;
    notifyListeners();
  }

  void createDownload({required Lesson lesson}) async {
    DownloadModel downloadModel = DownloadModel(
      id: lesson.id,
      courseId: _currentCourse!.id,
      lessonTitle: lesson.title,
      url: lesson.lessonUrl!,
      path: '',
      progress: 0,
      status: DownloadStatus.waiting,
    );

    await databaseHelper.createDownload(downloadModel: downloadModel);
    await updateCourseWithDownloadStatus();

    _currentDownloading == null ? await queueDownload() : null;
  }

  Future<void> queueDownload() async {
    List<DownloadModel> downloadModels = await databaseHelper.getDownloads();
    List<DownloadModel> waitingDownloadModels = downloadModels
        .where((d) => d.status == DownloadStatus.waiting)
        .toList();

    //
    if (waitingDownloadModels.isEmpty) return;

    await startDownloading(downloadModel: waitingDownloadModels.first);
    await queueDownload();
  }

  Future<void> startDownloading({required DownloadModel downloadModel}) async {
    _currentDownloading = downloadModel;

    downloadModel = downloadModel.copyWith(status: DownloadStatus.running);
    await databaseHelper.updateDownload(download: downloadModel);
    await updateCourseWithDownloadStatus();

    //
    final localPath = await m3u8Downloader.download(
      url: downloadModel.url,
      lessonTitle: downloadModel.lessonTitle,
      onProgress: (progress) async {
        downloadModel = downloadModel.copyWith(progress: progress);
        await databaseHelper.updateDownload(download: downloadModel);
        await updateCourseWithDownloadStatus();
      },
    );

    downloadModel = downloadModel.copyWith(
      status: localPath != null ? DownloadStatus.success : DownloadStatus.fail,
      path: localPath ?? "",
      progress: localPath != null ? 1.0 : downloadModel.progress,
    );

    await databaseHelper.updateDownload(download: downloadModel);
    await updateCourseWithDownloadStatus();

    final updatedLesson =
        getLessonByDownloadModelId(downloadModel: downloadModel);
    await updataDatasource(lesson: updatedLesson);
    _currentDownloading = null;
    notifyListeners();
  }

  Future<void> deleteLocalDatabase() async {
    await databaseHelper.deleteDatabase();
  }

  void clearDataSources() {
    _dataSourceList.clear();
    _videoLessons.clear();
    _currentCourse = null;
  }
}
