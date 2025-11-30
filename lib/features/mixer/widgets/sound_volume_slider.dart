import 'package:flutter/material.dart';

class SoundVolumeSlider extends StatelessWidget {
  final String title;
  final String iconPath;
  final double volume;
  final bool isReady; // 👇 MỚI: Biến nhận biết trạng thái
  final ValueChanged<double> onChanged;

  const SoundVolumeSlider({
    super.key,
    required this.title,
    required this.iconPath,
    required this.volume,
    required this.isReady, // Thêm vào constructor
    required this.onChanged,
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
                // Làm mờ tên nếu chưa sẵn sàng
                opacity: isReady ? 1.0 : 0.5,
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),

            // Slider hoặc Loading
            Expanded(
              flex: 5,
              child: isReady
                  ? Slider(
                      value: volume,
                      min: 0.0,
                      max: 1.0,
                      activeColor: volume > 0
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade400,
                      onChanged: onChanged,
                    )
                  : const Center(
                      // Loading nhỏ xinh thay thế cho Slider
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
            ),

            // Text % hoặc khoảng trống
            SizedBox(
              width: 40,
              child: isReady
                  ? Text(
                      '${(volume * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.end,
                    )
                  : const SizedBox(), // Ẩn số % khi đang load
            ),
          ],
        ),
      ],
    );
  }
}
