// lib/features/home/presentation/widgets/background_menu_button.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook_in/features/background/cubit/background_cubit.dart';

class BackgroundMenuButton extends StatelessWidget {
  const BackgroundMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect platform size
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Positioned(
      top: 16,
      right: 16,
      child: SafeArea(
        child: isDesktop ? _DesktopBackgroundMenu() : _MobileBackgroundMenu(),
      ),
    );
  }
}

// ========================================
// MOBILE VERSION - Glass Icon Button
// ========================================
class _MobileBackgroundMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BackgroundMode>(
      tooltip: 'Đổi hình nền',
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // Custom glass button - không dùng GestureDetector nữa
      child: _GlassIconButton(icon: Icons.wallpaper_rounded, size: 48),
      onSelected: (mode) => _handleModeSelection(context, mode),
      itemBuilder: (context) => [
        _buildGlassMenuItem(
          value: BackgroundMode.static,
          icon: Icons.image_rounded,
          title: 'Ảnh tĩnh',
          subtitle: 'Random',
        ),
        _buildGlassMenuItem(
          value: BackgroundMode.slideshow,
          icon: Icons.slideshow_rounded,
          title: 'Slideshow',
          subtitle: 'Tự động',
        ),
        _buildGlassMenuItem(
          value: BackgroundMode.live,
          icon: Icons.movie_filter_rounded,
          title: 'Live Wallpaper',
          subtitle: 'Động',
        ),
        const PopupMenuDivider(height: 16),
        _buildGlassMenuItem(
          value: BackgroundMode.custom,
          icon: Icons.add_photo_alternate_rounded,
          title: 'Custom',
          subtitle: 'Sắp ra mắt',
          isComingSoon: true,
        ),
      ],
    );
  }

  PopupMenuItem<BackgroundMode> _buildGlassMenuItem({
    required BackgroundMode value,
    required IconData icon,
    required String title,
    required String subtitle,
    bool isComingSoon = false,
  }) {
    return PopupMenuItem<BackgroundMode>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: isComingSoon ? Colors.grey : Colors.black87,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isComingSoon ? Colors.grey : Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isComingSoon ? Colors.grey : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleModeSelection(BuildContext context, BackgroundMode mode) {
    if (mode == BackgroundMode.custom) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tính năng Custom đang phát triển!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      context.read<BackgroundCubit>().setMode(mode);
    }
  }
}

class _DesktopBackgroundMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackgroundCubit, BackgroundState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DesktopModeButton(
                    icon: Icons.image_rounded,
                    tooltip: 'Ảnh tĩnh',
                    isSelected: state.mode == BackgroundMode.static,
                    onTap: () => context.read<BackgroundCubit>().setMode(
                      BackgroundMode.static,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _DesktopModeButton(
                    icon: Icons.slideshow_rounded,
                    tooltip: 'Slideshow',
                    isSelected: state.mode == BackgroundMode.slideshow,
                    onTap: () => context.read<BackgroundCubit>().setMode(
                      BackgroundMode.slideshow,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _DesktopModeButton(
                    icon: Icons.movie_filter_rounded,
                    tooltip: 'Live Wallpaper',
                    isSelected: state.mode == BackgroundMode.live,
                    onTap: () => context.read<BackgroundCubit>().setMode(
                      BackgroundMode.live,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Divider
                  Container(
                    width: 1,
                    height: 32,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  const SizedBox(width: 8),
                  _DesktopModeButton(
                    icon: Icons.add_photo_alternate_rounded,
                    tooltip: 'Custom (Coming Soon)',
                    isSelected: false,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tính năng Custom đang phát triển!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DesktopModeButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const _DesktopModeButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DesktopModeButton> createState() => _DesktopModeButtonState();
}

class _DesktopModeButtonState extends State<_DesktopModeButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? Colors.white.withOpacity(0.25)
                  : _isHovered
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isSelected
                    ? Colors.white.withOpacity(0.5)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 22,
              color: Colors.white.withOpacity(widget.isSelected ? 1.0 : 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

// ========================================
// SHARED: Glass Icon Button
// ========================================
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final double size;

  const _GlassIconButton({required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: size * 0.5,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}
