import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videos_app_version_2/core/enum/download_status.dart';
import 'package:videos_app_version_2/core/model/download_model.dart';
import 'package:videos_app_version_2/providers/course_provider.dart';

class LocalDataStoragePage extends StatefulWidget {
  const LocalDataStoragePage({super.key});

  @override
  State<LocalDataStoragePage> createState() => _LocalDataStoragePageState();
}

class _LocalDataStoragePageState extends State<LocalDataStoragePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Data Storage Page"),
        actions: [
          IconButton(
              onPressed: () async {
                context.read<CourseProvider>().deleteLocalDatabase();
                setState(() {});
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: FutureBuilder(
        future: context.read<CourseProvider>().getDownloads(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final downloadModels = snapshot.data!;
          return ListView.builder(
            itemCount: downloadModels.length,
            itemBuilder: (context, index) {
              final downloadModel = downloadModels[index];
              return ListTile(
                isThreeLine: true,
                title: Text("DownloadModel ID : ${downloadModel.id}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Lesson ID : ${downloadModel.id}"),
                    Text("Course ID : ${downloadModel.courseId}"),
                    Text("DownloadModel Url : ${downloadModel.url}",
                        maxLines: 1),
                    Text("Download Status : ${downloadModel.status}"),
                    Text("DownloadModel Progress : ${downloadModel.progress}"),
                    Text("DownloadModel Path : ${downloadModel.path}"),
                    const Divider(),
                  ],
                ),
                trailing: trailingWidget(downloadModel: downloadModel),
              );
            },
          );
        },
      ),
    );
  }

  Widget trailingWidget({required DownloadModel downloadModel}) {
    switch (downloadModel.status) {
      case DownloadStatus.success:
        return const Icon(Icons.download_done);

      case DownloadStatus.fail:
        return const Icon(Icons.info);

      case DownloadStatus.running:
        return const Icon(Icons.downloading);

      case DownloadStatus.waiting:
        return const Icon(Icons.watch_later_rounded);

      case DownloadStatus.none:
        return const Icon(Icons.download);

      default:
        return const SizedBox.shrink();
    }
  }
}
