import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    //  Interpolate an animation value from -100 to +100, instead of 0 to 1.
    var controller = AnimationController(vsync: this);
    var animation = Tween<double>(begin: -100, end: 100).animate(controller);

    animation.addListener(() => setState(() { }));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}