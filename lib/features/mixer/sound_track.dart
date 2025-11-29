import 'package:nook_in/gen/assets.gen.dart';

enum SoundType { rain, fire }

class SoundTrack {
  final String id;
  final String name;
  final String assetPath;
  final String iconAsset; // Sau này bạn có thể thay bằng IconData hoặc path SVG

  const SoundTrack({
    required this.id,
    required this.name,
    required this.assetPath,
    this.iconAsset = '',
  });

  // Danh sách các sound có sẵn trong app
  static List<SoundTrack> get presets => [
    SoundTrack(
      id: 'rain',
      name: 'Summer Rain',
      assetPath: Assets.sounds.raining, // Lấy từ flutter_gen
    ),
    SoundTrack(
      id: 'fire',
      name: 'Campfire',
      assetPath: Assets.sounds.campFire, // Lấy từ flutter_gen
    ),
  ];
}
