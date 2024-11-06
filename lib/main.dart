import 'package:flutter/material.dart';

void main() {
  runApp(const LogoApp());
}

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  //  Initialize size of the logo.
  double _logoSize = 100;

  //  Maximum and minimum size limits for the logo.
  final double _maxSize = 300;
  final double _minSize = 50;

  // Incremental value for the logo size.
  final double _step = 50;

  //  The controller of an animation
  late AnimationController controller;

  //  Get status of the animation with the translated value.
  late Animation<double> animation;

  // Update the state of the widget to resize with the updated size.
  void _increaseLogoSize() {
    setState(() {
      _logoSize = (_logoSize + _step).clamp(_minSize, _maxSize);
    });
  }

  // Update the state of the widget to resize with the updated size.
  void _decreaseLogoSize() {
    setState(() {
      //  Reduce size by step, and make sure it's always between the size limits
      _logoSize = (_logoSize - _step).clamp(_minSize, _maxSize);
    });
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

    // Add a listener to the animation that updates _logoSize as the animation progresses.
    // Each time the animation's value changes, it will set _logoSize to that value,
    // smoothly transitioning from _minSize to _maxSize.
    animation.addListener(() {
      setState(() => _logoSize = animation.value);
    });
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
            Center(
              child: SizedBox(
                height: _logoSize,
                width: _logoSize,
                child: const FlutterLogo(),
              ),
            ),
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
