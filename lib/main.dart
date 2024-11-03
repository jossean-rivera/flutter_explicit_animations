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
  double _logoSize = 100;
  final double _maxSize = 300;
  final double _minSize = 50;
  final double _step = 50;

  late AnimationController controller;

  void _increaseLogoSize() {
    setState(() => _logoSize = (_logoSize + _step).clamp(_minSize, _maxSize));
  }

  void _decreaseLogoSize() {
    setState(() => _logoSize = (_logoSize - _step).clamp(_minSize, _maxSize));
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

    //  Add a listener to the controller that updates _logoSize based on
    //  the controller's current value, which changes from 0.0 to 1.0.
    //  As the controller's value goes from 0.0 to 1.0, _logoSize will go from 0 to _maxSize.
    controller.addListener(() {
      //  Update the state of the widget to refresh the UI
      setState(() => _logoSize = controller.value * _maxSize);
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
