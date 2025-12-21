// lib/features/home/presentation/widgets/duration_picker.dart
import 'dart:ui';
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
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: _options.map((minutes) {
        final isSelected = currentDuration == minutes * 60;
        return _GlassChip(
          label: '${minutes}m',
          isSelected: isSelected,
          isDisabled: isRunning,
          onTap: isRunning ? null : () => onDurationSelected(minutes),
        );
      }).toList(),
    );
  }
}

class _GlassChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _GlassChip({
    required this.label,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  State<_GlassChip> createState() => _GlassChipState();
}

class _GlassChipState extends State<_GlassChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = !widget.isDisabled && widget.onTap != null;

    return GestureDetector(
      onTapDown: isInteractive
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: isInteractive ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isInteractive
          ? () => setState(() => _isPressed = false)
          : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: widget.isDisabled ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    // Background với gradient
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isSelected
                          ? [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.2),
                            ]
                          : [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    // Border sáng hơn khi được chọn
                    border: Border.all(
                      color: widget.isSelected
                          ? Colors.white.withOpacity(0.5)
                          : Colors.white.withOpacity(0.2),
                      width: widget.isSelected ? 2 : 1,
                    ),
                    // Shadow
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: widget.isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: Colors.white,
                      // Text shadow cho độ sâu
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========================================
// BONUS: Với icon indicator (nếu muốn)
// ========================================
class DurationPickerWithIcon extends StatelessWidget {
  final int currentDuration;
  final bool isRunning;
  final Function(int minutes) onDurationSelected;

  const DurationPickerWithIcon({
    required this.currentDuration,
    required this.isRunning,
    required this.onDurationSelected,
    super.key,
  });

  final List<Map<String, dynamic>> _options = const [
    {'minutes': 1, 'icon': Icons.flash_on},
    {'minutes': 15, 'icon': Icons.coffee},
    {'minutes': 25, 'icon': Icons.timer},
    {'minutes': 45, 'icon': Icons.work},
    {'minutes': 60, 'icon': Icons.alarm},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: _options.map((option) {
        final minutes = option['minutes'] as int;
        final icon = option['icon'] as IconData;
        final isSelected = currentDuration == minutes * 60;

        return _GlassChipWithIcon(
          label: '${minutes}m',
          icon: icon,
          isSelected: isSelected,
          isDisabled: isRunning,
          onTap: isRunning ? null : () => onDurationSelected(minutes),
        );
      }).toList(),
    );
  }
}

class _GlassChipWithIcon extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _GlassChipWithIcon({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  State<_GlassChipWithIcon> createState() => _GlassChipWithIconState();
}

class _GlassChipWithIconState extends State<_GlassChipWithIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = !widget.isDisabled && widget.onTap != null;

    return GestureDetector(
      onTapDown: isInteractive
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: isInteractive ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isInteractive
          ? () => setState(() => _isPressed = false)
          : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: widget.isDisabled ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isSelected
                          ? [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.2),
                            ]
                          : [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.isSelected
                          ? Colors.white.withOpacity(0.5)
                          : Colors.white.withOpacity(0.2),
                      width: widget.isSelected ? 2 : 1,
                    ),
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.icon,
                        size: 18,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: widget.isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
