// lib/features/home/presentation/widgets/timer_controls.dart
import 'package:flutter/material.dart';

class TimerControls extends StatelessWidget {
  final bool isRunning;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onReset;

  const TimerControls({
    super.key,
    required this.isRunning,
    required this.isCompleted,
    required this.onToggle,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Play / Pause Button
        FloatingActionButton.large(
          onPressed: isCompleted ? null : onToggle,
          child: Icon(isRunning ? Icons.pause : Icons.play_arrow),
        ),
        const SizedBox(width: 24),
        // Reset Button
        FloatingActionButton(
          onPressed: onReset,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 0,
          shape: CircleBorder(
            side: BorderSide(color: Theme.of(context).dividerColor),
          ),
          child: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
