# Explicit Animations

A new Flutter project.

## Basic Application

Display a Flutter Logo image with increase and decrease buttons that will change the size of the logo and an animate button that will be implemented later. 

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const LogoApp());
}

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> {

  //  Initialize size of the logo.
  double _logoSize = 100;

  //  Maximum and minimum size limits for the logo.
  final double _maxSize = 300;
  final double _minSize = 50;

  // Incremental value for the logo size.
  final double _step = 50;

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

  // Placeholder for the animate function, to be implemented with explicit animations.
  void _animateLogoSize() {

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
```

To start implement an animation that will increase the size of the logo smoothly, then use an AnimationController that by default will animate from 0.0 to 1.0 and update the size of the logo every time the animation listener gets called. 

```dart
class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  double _logoSize = 100;
  final double _maxSize = 300;
  final double _minSize = 50;
  final double _step = 50;

  //  The controller of an animation
  late AnimationController controller;

  void _increaseLogoSize() { /* ... */}

  void _decreaseLogoSize() { /* ... */}

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

    //  Add a listener to the controller that updates _logoSize based on
    //  the controller's current value, which changes from 0.0 to 1.0.
    //  As the controller's value goes from 0.0 to 1.0, _logoSize will go from 0 to _maxSize.
    controller.addListener(() {
      //  Update the state of the widget to refresh the UI
      setState(() => _logoSize = controller.value * _maxSize);
    });
  }
  
  // ...
}
```

Animate from the range of 0 to 300 directly, instead of having to transform every value from 0.0 to 1.0.

```dart

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  double _logoSize = 100;
  final double _maxSize = 300;
  final double _minSize = 50;
  final double _step = 50;

  //  The controller of an animation
  late AnimationController controller;

  //  Get status of the animation with the translated value.
  late Animation<double> animation;

  void _increaseLogoSize() { /* ... */}

  void _decreaseLogoSize() { /* ... */}

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

  // ...
}
```

Simplify code with the AnimatedWidget helper, that will rebuild everytime the animation calls its listeners. 

```dart
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
    controller.forward();
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
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
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: _increaseLogoSize,
                child: const Text('Increase Size'),
              ),
            ),
            // Flutter logo that will rebuild every time the animation is updated.
            AnimatedLogo(animation: animation),
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

```