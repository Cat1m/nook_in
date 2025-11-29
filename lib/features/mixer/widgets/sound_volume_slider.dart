import 'package:flutter/material.dart';

class SoundVolumeSlider extends StatelessWidget {
  final String title;
  final String
  iconPath; // Nếu bạn chưa dùng svg/img thì có thể dùng IconData tạm
  final double volume;
  final ValueChanged<double> onChanged;

  const SoundVolumeSlider({
    super.key,
    required this.title,
    required this.iconPath, // Tạm thời mình sẽ hiển thị tên trước
    required this.volume,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Icon hoặc Tên Sound
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            // Slider điều chỉnh
            Expanded(
              flex: 5,
              child: Slider(
                value: volume,
                min: 0.0,
                max: 1.0,
                // UI tinh tế: Nếu volume = 0 thì màu xám, > 0 thì màu chính
                activeColor: volume > 0
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade400,
                onChanged: onChanged,
              ),
            ),
            // Hiển thị % volume (Optional)
            SizedBox(
              width: 40,
              child: Text(
                '${(volume * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
