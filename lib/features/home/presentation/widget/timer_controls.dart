// lib/features/home/presentation/widgets/timer_controls.dart
import 'dart:ui';
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
        // Play / Pause Button - Liquid Glass Style
        _GlassButton(
          onPressed: isCompleted ? null : onToggle,
          size: 80,
          isLarge: true,
          child: Icon(
            isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),

        const SizedBox(width: 24),

        // Reset Button - Liquid Glass Style
        _GlassButton(
          onPressed: onReset,
          size: 56,
          child: const Icon(
            Icons.refresh_rounded,
            size: 28,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

// Widget tái sử dụng cho Glass Button
class _GlassButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double size;
  final bool isLarge;

  const _GlassButton({
    required this.onPressed,
    required this.child,
    required this.size,
    this.isLarge = false,
  });

  @override
  State<_GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<_GlassButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.size / 2),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.isLarge ? 15 : 12,
                  sigmaY: widget.isLarge ? 15 : 12,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    // Gradient với độ trong suốt
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isLarge
                          ? [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                            ]
                          : [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                            ],
                    ),
                    shape: BoxShape.circle,
                    // Border sáng
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: widget.isLarge ? 2 : 1.5,
                    ),
                    // Shadow
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: widget.isLarge ? 30 : 20,
                        offset: Offset(0, widget.isLarge ? 15 : 10),
                      ),
                    ],
                  ),
                  child: Center(child: widget.child),
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
// VARIANT 2: Với hiệu ứng glow khi active
// ========================================
class TimerControlsWithGlow extends StatelessWidget {
  final bool isRunning;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onReset;

  const TimerControlsWithGlow({
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
        _GlassButtonWithGlow(
          onPressed: isCompleted ? null : onToggle,
          size: 80,
          isLarge: true,
          isActive: isRunning,
          child: Icon(
            isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),

        const SizedBox(width: 24),

        _GlassButtonWithGlow(
          onPressed: onReset,
          size: 56,
          child: const Icon(
            Icons.refresh_rounded,
            size: 28,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _GlassButtonWithGlow extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double size;
  final bool isLarge;
  final bool isActive;

  const _GlassButtonWithGlow({
    required this.onPressed,
    required this.child,
    required this.size,
    this.isLarge = false,
    this.isActive = false,
  });

  @override
  State<_GlassButtonWithGlow> createState() => _GlassButtonWithGlowState();
}

class _GlassButtonWithGlowState extends State<_GlassButtonWithGlow> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect khi active
                if (widget.isActive)
                  Container(
                    width: widget.size + 20,
                    height: widget.size + 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),

                // Glass button
                ClipRRect(
                  borderRadius: BorderRadius.circular(widget.size / 2),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: widget.isLarge ? 15 : 12,
                      sigmaY: widget.isLarge ? 15 : 12,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: widget.isActive
                              ? [
                                  Colors.blue.withOpacity(0.3),
                                  Colors.blue.withOpacity(0.15),
                                ]
                              : widget.isLarge
                              ? [
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ]
                              : [
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.05),
                                ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.isActive
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.white.withOpacity(0.3),
                          width: widget.isLarge ? 2 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: widget.isLarge ? 30 : 20,
                            offset: Offset(0, widget.isLarge ? 15 : 10),
                          ),
                        ],
                      ),
                      child: Center(child: widget.child),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ========================================
// VARIANT 3: Minimalist - Siêu đơn giản
// ========================================
class TimerControlsMinimal extends StatelessWidget {
  final bool isRunning;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onReset;

  const TimerControlsMinimal({
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
        _MinimalGlassButton(
          onPressed: isCompleted ? null : onToggle,
          size: 72,
          child: Icon(
            isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: 36,
            color: Colors.white,
          ),
        ),

        const SizedBox(width: 20),

        _MinimalGlassButton(
          onPressed: onReset,
          size: 52,
          child: const Icon(
            Icons.refresh_rounded,
            size: 24,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _MinimalGlassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double size;

  const _MinimalGlassButton({
    required this.onPressed,
    required this.child,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
