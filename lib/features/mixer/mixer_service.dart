import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

import 'package:nook_in/features/mixer/sound_track.dart';

@lazySingleton
class MixerService {
  final Map<String, AudioPlayer> _players = {};

  /// 1. Chỉ tải sound mặc định (Rain) và chờ nó xong
  Future<void> initDefault() async {
    // Tìm sound mặc định (ví dụ Rain)
    final defaultSound = SoundTrack.presets.firstWhere((s) => s.id == 'rain');
    await _initializePlayer(defaultSound);
  }

  /// 2. Hàm tải lẻ từng sound (Dùng để tải nền)
  Future<void> loadSound(String id) async {
    // Nếu đã có player rồi thì thôi
    if (_players.containsKey(id)) return;

    final sound = SoundTrack.presets.firstWhere((s) => s.id == id);
    await _initializePlayer(sound);
  }

  /// Logic khởi tạo player chung
  Future<void> _initializePlayer(SoundTrack sound) async {
    final player = AudioPlayer();
    try {
      _players[sound.id] = player; // Lưu instance trước

      await player.setAsset(sound.assetPath);
      await player.setLoopMode(LoopMode.one);
      await player.setVolume(0);

      // Cài đặt "Cảnh sát Loop"
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed &&
            player.volume > 0) {
          player.seek(Duration.zero);
          player.play();
        }
      });
    } catch (e) {
      log('Error loading sound ${sound.id}: $e');
      _players.remove(sound.id); // Lỗi thì xóa đi để ko bị lỗi logic
    }
  }

  Future<void> setVolume(String soundId, double volume) async {
    final player = _players[soundId];
    if (player != null) {
      try {
        // Nếu kéo volume lên và player đang nghỉ (do chưa chạy hoặc bị dừng) -> Chạy ngay
        if (volume > 0 && !player.playing) {
          // Lưu ý: seek về 0 để chắc chắn không bị đứng ở cuối bài
          if (player.processingState == ProcessingState.completed) {
            await player.seek(Duration.zero);
          }
          await player.play();
        }

        // Logic cũ: Pause nếu về 0 để tiết kiệm tài nguyên
        if (volume == 0 && player.playing) {
          await player.pause();
        }

        await player.setVolume(volume);
      } catch (e) {
        log('Lỗi khi chỉnh volume: $e');
      }
    }
  }

  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}
