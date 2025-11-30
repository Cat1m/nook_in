import 'package:flutter/material.dart';

class SoundVolumeSlider extends StatelessWidget {
  final String title;
  final String iconPath;
  final double volume;
  final bool isReady;
  final ValueChanged<double> onChanged;
  final VoidCallback onPreview; // 👇 Callback mới cho nút Preview
  final bool isPreviewing;

  const SoundVolumeSlider({
    required this.title,
    required this.iconPath,
    required this.volume,
    required this.isReady,
    required this.onChanged,
    required this.onPreview, // Nhớ thêm vào constructor, super.key,
    required this.isPreviewing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Title
            Expanded(
              flex: 2,
              child: Opacity(
                opacity: isReady ? 1.0 : 0.5,
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Slider
            Expanded(
              flex: 5,
              child: isReady
                  ? Slider(
                      value: volume,
                      activeColor: volume > 0
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade400,
                      onChanged:
                          onChanged, // Kéo slider chỉ chỉnh volume, ko phát nhạc
                    )
                  : const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
            ),

            // 👇 Nút Preview Mới
            SizedBox(
              width: 48,
              child: isReady
                  ? IconButton(
                      // Logic đổi icon: Đang preview thì hiện Pause, không thì hiện Play
                      icon: Icon(
                        isPreviewing
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        size: 28,
                        // Đổi màu để nổi bật hơn khi đang chạy
                        color: isPreviewing
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade600,
                      ),
                      tooltip: isPreviewing ? 'Dừng nghe thử' : 'Nghe thử',
                      onPressed: onPreview,
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}
