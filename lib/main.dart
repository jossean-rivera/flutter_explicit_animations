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

  static const double _maxSize = 300;
  static const double _minSize = 50;

  // Make the Tweens static because they don't change.
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: _minSize, end: _maxSize);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Opacity(
      //  Use the tween to change the animation value, to an opacity value
      opacity: _opacityTween.evaluate(animation),
      child: Center(
        child: SizedBox(
          //  Use the tween to change the animation value, to a size value
          height: _sizeTween.evaluate(animation),
          width: _sizeTween.evaluate(animation),
          child: const FlutterLogo(),
        ),
      ),
    );
  }
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  final double _animationStep = 0.1;

  late AnimationController controller;

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
    controller.forward();
  }

  @override
  void initState() {
    super.initState();

    //  Have one controller to move both animations
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Logo Resizer')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: _increaseLogoSize,
                child: const Text('Increase Size'),
              ),
            ),
            // Flutter logo that will rebuild every time the animation is updated.
            AnimatedLogo(animation: controller),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: _decreaseLogoSize,
                    child: const Text('Decrease Size'),
                  ),
                ),
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
