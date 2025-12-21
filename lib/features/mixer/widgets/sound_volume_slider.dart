import 'dart:ui';
import 'package:flutter/material.dart';

class SoundVolumeSlider extends StatelessWidget {
  final String title;
  final String iconPath;
  final double volume;
  final bool isReady;
  final ValueChanged<double> onChanged;
  final VoidCallback onPreview;
  final bool isPreviewing;

  const SoundVolumeSlider({
    required this.title,
    required this.iconPath,
    required this.volume,
    required this.isReady,
    required this.onChanged,
    required this.onPreview,
    required this.isPreviewing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            // Gradient background
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            // Border
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            // Shadow
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Title
              Expanded(
                flex: 2,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isReady ? 1.0 : 0.5,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Slider hoặc Loading
              Expanded(
                flex: 5,
                child: isReady
                    ? SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          // Track (thanh nằm ngang)
                          activeTrackColor: volume > 0
                              ? Colors.white.withOpacity(0.8)
                              : Colors.white.withOpacity(0.3),
                          inactiveTrackColor: Colors.white.withOpacity(0.15),
                          trackHeight: 4,

                          // Thumb (nút tròn)
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),

                          // Overlay khi nhấn
                          overlayColor: Colors.white.withOpacity(0.2),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 16,
                          ),
                        ),
                        child: Slider(value: volume, onChanged: onChanged),
                      )
                    : Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
              ),

              const SizedBox(width: 8),

              // Preview Button với Glass Effect
              SizedBox(
                width: 48,
                child: isReady
                    ? _GlassPreviewButton(
                        isPreviewing: isPreviewing,
                        onPressed: onPreview,
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Preview Button với Liquid Glass Effect
class _GlassPreviewButton extends StatefulWidget {
  final bool isPreviewing;
  final VoidCallback onPressed;

  const _GlassPreviewButton({
    required this.isPreviewing,
    required this.onPressed,
  });

  @override
  State<_GlassPreviewButton> createState() => _GlassPreviewButtonState();
}

class _GlassPreviewButtonState extends State<_GlassPreviewButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Background với opacity khác nhau khi active
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isPreviewing
                  ? [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.15),
                    ]
                  : [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                    ],
            ),
            // Border sáng hơn khi đang preview
            border: Border.all(
              color: widget.isPreviewing
                  ? Colors.white.withOpacity(0.4)
                  : Colors.white.withOpacity(0.2),
              width: 1,
            ),
            // Shadow
            boxShadow: widget.isPreviewing
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Icon(
            widget.isPreviewing
                ? Icons.pause_circle_outline_rounded
                : Icons.play_circle_outline_rounded,
            size: 24,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}

// ========================================
// BONUS: Section Header với Glass Effect
// Để thay thế Divider
// ========================================
class GlassSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;

  const GlassSectionHeader({required this.title, this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // ← Fix này!
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: Colors.white.withOpacity(0.8)),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 0.5,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 3,
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
    );
  }
}

// ========================================
// BONUS: Divider với Glass Effect
// Nếu bạn muốn giữ divider nhưng làm đẹp hơn
// ========================================
class GlassDivider extends StatelessWidget {
  final double height;
  final double thickness;

  const GlassDivider({this.height = 24, this.thickness = 1, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height),
      child: Container(
        height: thickness,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.2),
              Colors.transparent,
            ],
            stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
          ),
          boxShadow: [
            BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 2),
          ],
        ),
      ),
    );
  }
}
