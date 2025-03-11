import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestSvgPage extends StatefulWidget {
  const TestSvgPage({super.key});

  @override
  State<TestSvgPage> createState() => _TestSvgPageState();
}

class _TestSvgPageState extends State<TestSvgPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset('assets/svgs/monk.svg'),
      ),
    );
  }
}
