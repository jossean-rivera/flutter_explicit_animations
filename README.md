# Explicit Animations

In Flutter, an **explicit animation** is a UI animation in which you have control over the execution of the animation, as opposed to implicit animations, where you typically assign changing values that automatically animate over time.

Key items of explicit animations are:

### AnimationController

Manager of the animation, it progresses an internal value from 0.0 to 1.0 (or vise versa) over a given period of time. The controller allows you to start, stop, reverse, and repeat the animation as needed. Once the animation is triggered, you can use the controller value to dynamically change the property values of widgets, such as width, height, and opacity. 

You can register functions as "listeners" that will be invoked when the internal value of the controller changes. You'll likely register a function that updates the state of the widget, causing it to refresh on the UI. 

Common fields and methods from the AnimationController are:

- `value`: Internal value of the animation.
- `forward()`: Start the animation and progresses the invernal value from 0.0 to 1.0.
- `reverse()`: Reverses the animation and moves the internal value from 1.0 to 0.0.
- `stop()`: Stops the animations at the current internal value.
- `addListener()`: Registers a function that will be invoked when the controller value changes.

See more: [AnimationController class referece | Flutter.dev](https://api.flutter.dev/flutter/animation/AnimationController-class.html)

### Tween

Typically, a AnimationController goes from 0.0 to 1.0. However, you can use a `Tween` object to interpolate between other value ranges. Like, having an animation going from -100 to +100, or a color changing from one RGB value to another RGB value. 

Example:

```dart 
//  Interpolate an animation value from -100 to +100, instead of 0 to 1.
var controller = AnimationController(vsync: this);
var animation = Tween<double>(begin: -100, end: 100).animate(controller);

// Define a ColorTween that transitions from blue to red.
var colorAnimation = ColorTween(
  begin: Colors.blue,
  end: Colors.red,
).animate(controller);
```

See more: [Tween class reference | Flutter.dev](https://api.flutter.dev/flutter/animation/Tween-class.html)

### TickerProvider

The controller requires a TickerProvider, which is usually the widget itself, in order to generate ticks at regular interval values, allowing the controller to update its internal value. If you're using the widget itself as a TikerProvider, then inheriht from either `SingleTickerProviderStateMixin` or `TickerProviderStateMixin`.

Example:

```dart
class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    //  Pass a reference to this widget instance that implements SingleTickerProviderStateMixin
    controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

See more: [TickerProvider class reference | Flutter.dev](https://api.flutter.dev/flutter/scheduler/TickerProvider-class.html)

### Listeners

You can register listeners on the animation objects so that they get notified the animation value has changed on every frame or the status of the animation. This is likely where you will add a listener that updates the state of a stateful widget, to update the UI with a new value for a dynamic property.

Example:

```dart
@override
void initState() {
  super.initState();

  // Initialize the animation controller with a 2-second duration.
  controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  // Define a tween to animate the value from 0.0 to 1.0.
  animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
    // Add a listener that prints the current animation value.
    ..addListener(() {
      print("Current animation value: ${_animation.value}");
    });

  // Start the animation.
  _controller.forward();
}
```

## Tutorial

### 1. Setup basic application

For demostration purposes, we'll use a basic application that displays the Flutter logo and the logo will be resized with an animation. 

First, Create a new Flutter application.

```
flutter create animations_testing
cd animiations_testing
```

Update the `main.dart` file to include the basic application. The app will display a Flutter Logo image with increase and decrease buttons that will change the size of the logo and an animate button that will be implemented later. 

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

### 2. Use AnimationController

To start implementing an animation that will increase the size of the logo smoothly, then use an `AnimationController` that by default will animate from 0.0 to 1.0 and update the size of the logo every time the animation listener gets called. 

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

### 3. Use Tweens
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

### 4. Use AnimatedWidget

Simplify code with the `AnimatedWidget` helper, that will rebuild everytime the animation calls its listeners. So there's no need to keep resetting the state of the widget every time the listener gets called. 

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

### 5. Get animation status notifications 

You can use `addStatusListener` to call a listener every time the status of an animation changes. For example, you can use a status listener that will play the animation backwards once it reaches the end, and play the animation again forwards once it reaches the start. This will result in having a loop animation that keeps changing the size of the logo from the `_minSize` value to `_maxSize`. 

```dart
class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  final double _maxSize = 300;
  final double _minSize = 50;

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    //  Set a loop animation that increases and decreases the logo from 
    //  _minSize to _maxSize
    animation =
        Tween<double>(begin: _minSize, end: _maxSize).animate(controller)
          ..addStatusListener((status) {

            // The addStatusListener checks the current status of the animation.
            switch (status) {

              // If the animation has completed, reverse it back to the start.
              case AnimationStatus.completed:
                controller.reverse();
                break;

              // If the animation has been dismissed (reached the start), start it again forward.
              case AnimationStatus.dismissed:
                controller.forward();
                break;

              // Do nothing for other statuses (forwarding or reversing).
              default:
            }
          });
  }

  // ...
}

```

### 6. Set an animation curve
The progression from start to end of an animation is linear by default, but it can be changed by using a curved animation.  

```dart
class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {

  // ...

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    //  Set a curve of the animation
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInCirc);
    animation =
        Tween<double>(begin: _minSize, end: _maxSize).animate(controller)
          ..addStatusListener((status) {
            // Use addStatusListener to loop the animation.
            switch (status) {
              case AnimationStatus.completed:
                controller.reverse();
                break;
              case AnimationStatus.dismissed:
                controller.forward();
                break;
              // Do nothing for other statuses (forwarding or reversing).
              default:
            }
          });
  }

  // ...
}
```

Built-in curve paremeters options:

![curve image](/images/curves.png)

However, you can define your own curve. 

```dart
import 'dart:math';

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2);
}
```

### 7. Simultaneous animations

Update the logo widget to animate two properties at the same time: size and opacity. You can use multiple Tween objects with the same AnimationController to interpolate the animation value into other values that you can assign to different properties in the widget.

```dart
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

  late AnimationController controller;

  // ...

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

  // ...
}
```

# References / Futher Readings

- [Explicit Animations | Flutter.dev](https://docs.flutter.dev/ui/animations/tutorial)
- [Flutter Animations: Exploring Explicit Animations in Flutter by Ashutosh Rawat | Blup.in](https://www.blup.in/blog/flutter-animations-exploring-explicit-animations-in-flutter)
- [AnimatedBuilder class (useful for more complex widgets) | Flutter.dev](https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html#:~:text=To%20use%20AnimatedBuilder%2C%20construct%20the,additional%20state%2C%20consider%20using%20AnimatedWidget.&text=If%20playback%20doesn't%20begin%20shortly%2C%20try%20restarting%20your%20device.)