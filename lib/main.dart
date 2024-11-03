import 'package:flutter/material.dart';

void main() {
  runApp(const LogoApp());
}

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

//  Use the AnimatedWidget helper class that will
//  rebuild everytime the animation calls the listener
//  No need to set the state of the widget directly.
class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({super.key, required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: SizedBox(
        height: animation.value,
        width: animation.value,
        child: const FlutterLogo(),
      ),
    );
  }
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  final double _maxSize = 300;
  final double _minSize = 50;
  final double _animationStep = 0.1;

  late AnimationController controller;
  late Animation<double> animation;

  void _increaseLogoSize() {
    //  Move the controller value forwards
    controller.value = (controller.value + _animationStep).clamp(0.0, 1.0);
  }

  void _decreaseLogoSize() {
    //  Move the controller value backwards
    controller.value = (controller.value - _animationStep).clamp(0.0, 1.0);
  }

  //  Method to start the animation, increasing the logo size smoothly to max size.
  void _animateLogoSize() {
    //  Start the animation from its initial value (0.0) to its final value (1.0).
    controller.forward();
  }

  @override
  void initState() {
    super.initState();

    //  Initialize the animation controller with a duration of 2 seconds.
    //  This controller will animate from the default ranage of 0.0 to 1.0 over 2 seconds.
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    // Use a Tween to define the animation range from _minSize to _maxSize.
    // This allows the animation to produce values directly between 50 and 300,
    // mapping the controller's progress (0.0 to 1.0) to a range from _minSize to _maxSize.
    animation =
        Tween<double>(begin: _minSize, end: _maxSize).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Logo Resizer')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Button at the top to increase the logo size.
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: _increaseLogoSize,
                child: const Text('Increase Size'),
              ),
            ),
            // Flutter logo at the center of the page with a dynamic sizing based on _logoSize.
            AnimatedLogo(animation: animation),
            // Bottom buttons to decrease the logo size and trigger animation.
            Column(
              children: [
                // Button to decrease the logo size.
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: _decreaseLogoSize,
                    child: const Text('Decrease Size'),
                  ),
                ),
                // Button for animation, functionality to be added later.
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: _animateLogoSize,
                    child: const Text('Animate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
