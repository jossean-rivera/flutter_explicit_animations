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