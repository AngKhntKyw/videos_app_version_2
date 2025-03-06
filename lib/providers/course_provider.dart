import 'dart:async';
import 'dart:developer';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:videos_app_version_2/core/enum/download_status.dart';
import 'package:videos_app_version_2/core/model/course.dart';
import 'package:videos_app_version_2/core/model/download_model.dart';
import 'package:videos_app_version_2/core/model/lesson.dart';
import 'package:videos_app_version_2/core/model/unit.dart';
import 'package:videos_app_version_2/providers/database_helper.dart';
import 'package:videos_app_version_2/providers/m3u8_downloader.dart';

class CourseProvider with ChangeNotifier {
  CourseProvider() {
    initDownloads();
  }

  //
  Course? _currentCourse;
  Course? get currentCourse => _currentCourse;

  final List<BetterPlayerDataSource> _dataSourceList = [];
  List<BetterPlayerDataSource> get dataSourceList => _dataSourceList;

  List<Lesson> _videoLessons = [];
  List<Lesson> get videoLessons => _videoLessons;

  Lesson? _watchingLesson;
  Lesson? get watchingLesson => _watchingLesson;

  int _lastWatchingLassonIndex = 0;
  int get lastWatchingLessonIndex => _lastWatchingLassonIndex;

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  final M3U8Downloader m3u8Downloader = M3U8Downloader();

  DownloadModel? _currentDownloading;
  DownloadModel? get currentDownloading => _currentDownloading;

  // List<DownloadModel> _downloadModels = [];
  // List<DownloadModel> get downloadModels => _downloadModels;

  //

  Future<void> initDownloads() async {
    await getDownloads();
  }

  //
  Future<List<DownloadModel>> getDownloads() async {
    final result = await databaseHelper.getDownloads();

    // _downloadModels = result;
    notifyListeners();
    return result;
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
    getLastWatchingLessonIndex();

    //
  }

  Future<void> updataDatasource({required Lesson lesson}) async {
    // DownloadModel downloadModel = await checkIsDownloaded(lesson: lesson);
    log("Lesson status : ${lesson.downloadModel!.status}");
    if (lesson.downloadModel!.status == DownloadStatus.success) {
      int datasourceIndex =
          findDatasourceIndexToUpdateDatasource(lesson: lesson);
      log("index $datasourceIndex");
      _dataSourceList[datasourceIndex] =
          BetterPlayerDataSource.file(lesson.downloadModel!.path);
    }
    notifyListeners();
  }

  int findDatasourceIndexToUpdateDatasource({required Lesson lesson}) {
    log("Datasource 0 :${_dataSourceList[0].url}");
    log("Datasource 1 :${_dataSourceList[1].url}");
    log("Datasource 2 :${_dataSourceList[2].url}");
    log("Lesson URL : ${lesson.lessonUrl}");

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
    log("Datasource : ${_dataSourceList[1].url}");
    log("Lesson url : ${lesson.lessonUrl}");
    log("Lesson DownloadModel : ${lesson.downloadModel?.status.name}");

    if (lesson.downloadModel!.status == DownloadStatus.success) {
      return _dataSourceList
          .indexWhere((element) => element.url == (lesson.downloadModel!.path));
    } else {
      return _dataSourceList
          .indexWhere((element) => element.url == lesson.lessonUrl);
    }
  }

  Lesson findLessonByDataSourceIndex({required int? index}) {
    return _videoLessons.firstWhere(
        (element) => _dataSourceList[index!].url == element.lessonUrl,
        orElse: () => _videoLessons.first);
  }

  Lesson getLessonByDownloadModelId({required DownloadModel downloadModel}) {
    return _currentCourse!.units
        .where((e) => e.lessons.isNotEmpty)
        .expand((unit) => unit.lessons)
        .where((lesson) => lesson.lessonType == 'VIDEO')
        .toList()
        .firstWhere((element) => element.id == downloadModel.id);
  }

  bool isLessonWatching({required int lessonId}) {
    if (_watchingLesson != null) {
      return _watchingLesson!.id == lessonId;
    }
    return false;
  }

  void getLastWatchingLessonIndex() {
    _lastWatchingLassonIndex = _watchingLesson == null
        ? 0
        : _watchingLesson!.downloadModel == null
            ? _dataSourceList.indexWhere(
                (element) => element.url == _watchingLesson!.lessonUrl)
            : _dataSourceList.indexWhere(
                (element) =>
                    element.url == _watchingLesson!.downloadModel!.path,
              );
    notifyListeners();
  }

  void setWatchingLesson({required Lesson lesson, required int index}) async {
    _watchingLesson = lesson;
    _lastWatchingLassonIndex = index;
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
    // await updataDatasource(lesson: lesson);
    //
    _currentDownloading == null ? await queueDownload() : null;

    //
  }

  Future<void> queueDownload() async {
    log("queue downloading...");

    List<DownloadModel> downloadModels = await databaseHelper.getDownloads();
    List<DownloadModel> waitingDownloadModels = downloadModels
        .where((d) => d.status == DownloadStatus.waiting)
        .toList();

    //
    if (waitingDownloadModels.isEmpty) return;

    // for (final download in waitingDownloadModels) {
    //   await startDownloading(downloadModel: download);
    // }
    await startDownloading(downloadModel: waitingDownloadModels.first);
    await queueDownload();
  }

  Future<void> startDownloading({required DownloadModel downloadModel}) async {
    _currentDownloading = downloadModel;
    // await Future.delayed(const Duration(seconds: 3));
    log("start downloading...");

    downloadModel = downloadModel.copyWith(status: DownloadStatus.running);
    await databaseHelper.updateDownload(download: downloadModel);
    await updateCourseWithDownloadStatus();
    final lesson = getLessonByDownloadModelId(downloadModel: downloadModel);
    // await updataDatasource(lesson: lesson);

    //
    await Future.delayed(const Duration(seconds: 3));

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

    //
    // downloadModel = DownloadModel(
    //   id: lesson.id,
    //   courseId: _currentCourse!.id,
    //   lessonTitle: lesson.title,
    //   url: lesson.lessonUrl!,
    //   path: 'downloaded path',
    //   progress: 1,
    //   status: DownloadStatus.success,
    // );

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
    _watchingLesson = null;
  }
}
