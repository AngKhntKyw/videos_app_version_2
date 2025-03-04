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

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

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

  void setUpVideoDataSource({required Course course}) async {
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

    //
  }

  Future<void> updataDatasource({required Lesson lesson}) async {
    DownloadModel downloadModel = await checkIsDownloaded(lesson: lesson);
    if (downloadModel.status == DownloadStatus.success) {
      int datasourceIndex = findDataSourceIndexByLesson(lesson: lesson);
      _dataSourceList[datasourceIndex] =
          BetterPlayerDataSource.file(lesson.downloadModel!.path);
    }
    notifyListeners();
  }

  Future<void> updateCourseWithDownloadStatus() async {
    final updatedUnits = await Future.wait(
      _currentCourse!.units.map((unit) => _updateUnitWithDownloadStatus(unit)),
    );
    _currentCourse = _currentCourse!.copyWith(units: updatedUnits);
    notifyListeners();
  }

  Future<Unit> _updateUnitWithDownloadStatus(Unit unit) async {
    final updatedLessons = await Future.wait(
      unit.lessons.map((lesson) => _updateLessonWithDownloadStatus(lesson)),
    );

    return unit.copyWith(lessons: updatedLessons);
  }

  Future<Lesson> _updateLessonWithDownloadStatus(Lesson lesson) async {
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
        url: lesson.lessonUrl!,
        path: '',
        progress: 0,
        status: DownloadStatus.none,
      ),
    );
  }

//
  int findDataSourceIndexByLesson({required Lesson lesson}) {
    log("LessonURL :${lesson.lessonUrl}");
    log("Lesson DownloadModel :${lesson.downloadModel!.path}");

    final result = _dataSourceList.indexWhere(
      (element) {
        log("Element : ${element.url}");
        if (lesson.downloadModel!.status == DownloadStatus.success) {
          return element.url == lesson.downloadModel!.path;
        }
        return element.url == lesson.lessonUrl;
      },
    );
    return result;
  }

  Lesson findLessonByDataSourceIndex({required int? index}) {
    return _videoLessons.firstWhere(
        (element) => _dataSourceList[index!].url == element.lessonUrl,
        orElse: () => _videoLessons.first);
  }

  bool isLessonWatching({required int lessonId}) {
    if (_watchingLesson != null) {
      return _watchingLesson!.id == lessonId;
    }
    return false;
  }

  void setWatchingLesson({required Lesson lesson}) async {
    log("Set lesson : $lesson");
    _watchingLesson = lesson;
    notifyListeners();
  }

  Future<int> getLastWatchingLesson() async {
    if (_watchingLesson == null) {
      return 0;
    } else {
      final lastlesson = await checkIsDownloaded(lesson: _watchingLesson!);

      if (lastlesson.status == DownloadStatus.success) {
        return _dataSourceList.indexWhere(
            (element) => element.url == _watchingLesson!.downloadModel!.path);
      } else {
        return _dataSourceList
            .indexWhere((element) => element.url == _watchingLesson!.lessonUrl);
      }
    }
  }

  void createDownload({required Lesson lesson}) async {
    DownloadModel downloadModel = DownloadModel(
      id: lesson.id,
      courseId: _currentCourse!.id,
      url: lesson.lessonUrl!,
      path: 'not download path',
      progress: 0,
      status: DownloadStatus.waiting,
    );
    final result =
        await databaseHelper.createDownload(downloadModel: downloadModel);
    log("result : $result");
    await updateCourseWithDownloadStatus();
    await updataDatasource(lesson: lesson);

    //
    await queueDownload();

    //
  }

  Future<Lesson> getLessonByDownloadModelId(
      {required DownloadModel downloadModel}) async {
    return _currentCourse!.units
        .where((e) => e.lessons.isNotEmpty)
        .expand((unit) => unit.lessons)
        .where((lesson) => lesson.lessonType == 'VIDEO')
        .toList()
        .firstWhere((element) => element.id == downloadModel.id);
  }

  Future<void> queueDownload() async {
    await Future.delayed(const Duration(seconds: 5));
    log("queue downloading...");

    List<DownloadModel> downloadModels = await databaseHelper.getDownloads();
    List<DownloadModel> waitingDownloadModels = downloadModels
        .where((d) => d.status == DownloadStatus.waiting)
        .toList();

    //
    if (waitingDownloadModels.isEmpty) return;

    for (final download in waitingDownloadModels) {
      await startDownloading(downloadModel: download);
    }

    await queueDownload();
  }

  Future<void> startDownloading({required DownloadModel downloadModel}) async {
    await Future.delayed(const Duration(seconds: 5));
    log("start downloading...");

    downloadModel = downloadModel.copyWith(status: DownloadStatus.running);
    await databaseHelper.updateDownload(download: downloadModel);
    final lesson =
        await getLessonByDownloadModelId(downloadModel: downloadModel);
    await updateCourseWithDownloadStatus();
    await updataDatasource(lesson: lesson);

    //
    await Future.delayed(const Duration(seconds: 5));

    //
    downloadModel = DownloadModel(
      id: lesson.id,
      courseId: _currentCourse!.id,
      url: lesson.lessonUrl!,
      path: 'downloaded path',
      progress: 1,
      status: DownloadStatus.success,
    );

    await databaseHelper.updateDownload(download: downloadModel);

    final updatedLesson =
        await getLessonByDownloadModelId(downloadModel: downloadModel);
    await updateCourseWithDownloadStatus();
    log("Updated Lesson ${lesson.downloadModel}");
    await updataDatasource(lesson: updatedLesson);
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
