// lib/features/home/presentation/widgets/timer_display.dart
import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final int remainingSeconds;

  const TimerDisplay({super.key, required this.remainingSeconds});

  String get _formattedTime {
    final minutes = (remainingSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formattedTime,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontSize: 80,
        fontWeight: FontWeight.bold,
        fontFeatures: [
          const FontFeature.tabularFigures(),
        ], // Giữ số không bị nhảy
      ),
    );
  }
}
