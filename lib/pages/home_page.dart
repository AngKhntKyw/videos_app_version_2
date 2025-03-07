import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_app_version_2/core/model/course.dart';
import 'package:videos_app_version_2/courses/courses.dart';
import 'package:videos_app_version_2/pages/course_detail_page.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGridView = false;

  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isGridView = prefs.getBool('isGridView') ?? false;
    });
  }

  Future<void> _saveViewPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGridView', value);
  }

  @override
  void initState() {
    super.initState();
    _loadViewPreference();
  }

  @override
  Widget build(BuildContext context) {
    List<Course> courses =
        courseListJson.map((json) => Course.fromJson(json)).toList();

    //
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              {
                setState(() {
                  setState(() {
                    isGridView = !isGridView;
                    _saveViewPreference(isGridView);
                  });
                });
              }
            },
            icon: Icon(isGridView ? Icons.list_alt_sharp : Icons.grid_on),
          ),
        ],
      ),
      body: isGridView
          ? GridView.builder(
              itemCount: courses.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GridViewCourseCard(
                  course: courses[index],
                );
              },
            )
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return ListViewCourseCard(
                  course: courses[index],
                );
              },
            ),
    );
  }
}

class ListViewCourseCard extends StatelessWidget {
  final Course course;
  const ListViewCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: const Color.fromARGB(255, 219, 239, 220),
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height / 6,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: course.imgUrl,
              fit: BoxFit.cover,
              width: MediaQuery.sizeOf(context).width / 3,
              height: double.infinity,
            ),
            SizedBox(width: MediaQuery.sizeOf(context).width / 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        course.description,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(
                    "${course.price}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridViewCourseCard extends StatelessWidget {
  final Course course;
  const GridViewCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: const Color.fromARGB(255, 219, 239, 220),
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
      child: badges.Badge(
        position: badges.BadgePosition.topEnd(top: 0, end: 0),
        badgeContent: const Text(
          'Hot',
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
        animationType: badges.BadgeAnimationType.slide,
        alignment: Alignment.topRight,
        animationDuration: const Duration(seconds: 5),
        badgeColor: Colors.green,
        ignorePointer: true,
        toAnimate: true,
        shape: badges.BadgeShape.circle,
        stackFit: StackFit.loose,
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: CachedNetworkImage(
                    imageUrl: course.imgUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      course.title,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "${course.price}",
                      maxLines: 1,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
