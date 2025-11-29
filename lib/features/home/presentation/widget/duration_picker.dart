// lib/features/home/presentation/widgets/duration_picker.dart
import 'package:flutter/material.dart';

class DurationPicker extends StatelessWidget {
  final int currentDuration; // Tổng giây
  final bool isRunning;
  final Function(int minutes) onDurationSelected;

  const DurationPicker({
    required this.currentDuration,
    required this.isRunning,
    required this.onDurationSelected,
    super.key,
  });

  final List<int> _options = const [1, 15, 25, 45, 60];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: _options.map((minutes) {
        final isSelected = currentDuration == minutes * 60;
        return FilterChip(
          label: Text('${minutes}m'),
          selected: isSelected,
          onSelected: isRunning
              ? null // Disable khi đang chạy
              : (_) => onDurationSelected(minutes),
        );
      }).toList(),
    );
  }
}
