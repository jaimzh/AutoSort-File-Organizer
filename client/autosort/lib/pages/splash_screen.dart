import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async';

class SplashContent extends StatefulWidget {
  const SplashContent({super.key});

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    // Delay for 2 seconds before showing the animation
    Timer(const Duration(milliseconds: 500 ), () {
      if (mounted) {
        setState(() {
          _showAnimation = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _showAnimation
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: RiveAnimation.asset(
                    'assets/animation/autosort.riv',
                    stateMachines: ['state machine'],
                  ),
                ),
              ],
            )
          : const Center(), // shows loader before animation
    );
  }
}
