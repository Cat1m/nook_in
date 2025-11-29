import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nook_in/gen/assets.gen.dart';

@lazySingleton
class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> init() async {
    // Không cần pre-load file cụ thể nào ở đây nữa
    // Chỉ cần đảm bảo player sẵn sàng
  }

  /// Phát âm thanh bắt đầu (1s)
  /// Hàm này đóng vai trò "Warm Up" cho Web luôn
  Future<void> playStart() async {
    try {
      // Vì file start rất ngắn, ta load và phát luôn
      await _player.setAsset(Assets.sounds.startTime);
      await _player.setLoopMode(LoopMode.off);
      await _player.setVolume(1.0); // Đảm bảo volume mở
      await _player.play();
    } catch (e) {
      log('Error playing start sound: $e');
    }
  }

  /// Phát âm thanh kết thúc
  Future<void> playAlarm() async {
    try {
      // Stop âm thanh cũ (nếu có)
      await _player.stop();

      // Chuyển sang file End
      await _player.setAsset(Assets.sounds.endTime);
      await _player.setLoopMode(LoopMode.off);
      await _player.play();
    } catch (e) {
      log('Error playing alarm: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
