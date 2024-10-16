import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:sun_moon_theme_switch_button/load_assest_image.dart';

import 'moon_sun_switch_painter.dart';

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: Durations.long3,
  );

  void onTap() {
    controller.value == 0 ? controller.forward() : controller.reverse();
  }

  ui.Image? moon;
  late ui.Image cloud1, cloud2;
  late ui.Image star;
  void _loadImages() async {
    moon = await loadImageFromAssets("assets/moon.png");
    cloud1 = await loadImageFromAssets("assets/cloud1.png");
    cloud2 = await loadImageFromAssets("assets/cloud2.png");
    star = await loadImageFromAssets("assets/star.png");

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: Center(
        child: moon == null
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: 3 / 1,
                child: Material(
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomPaint(
                        painter: MoonPainter(
                          animation: controller,
                          moon: moon!,
                          cloudT: cloud1,
                          cloudB: cloud2,
                          star: star,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        shape: const StadiumBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          customBorder: const StadiumBorder(),
                          splashColor: Colors.white.withOpacity(0.3),
                          highlightColor: Colors.transparent,
                          onTap: onTap,
                          child: const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
