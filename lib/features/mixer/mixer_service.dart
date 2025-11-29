import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

import 'package:nook_in/features/mixer/sound_track.dart';

@lazySingleton
class MixerService {
  final Map<String, AudioPlayer> _players = {};

  Future<void> init() async {
    for (var sound in SoundTrack.presets) {
      final player = AudioPlayer();
      try {
        // 1. Setup cơ bản
        await player.setAsset(sound.assetPath);
        await player.setLoopMode(LoopMode.one); // Hy vọng cái này chạy
        await player.setVolume(0);

        // 2. 👇 THÊM "CẢNH SÁT" Ở ĐÂY:
        // Lắng nghe trạng thái liên tục.
        // Nếu lỡ LoopMode.one bị lỗi mà player chạy đến trạng thái 'completed' (dừng)
        // Thì ta bắt nó tua lại và chạy tiếp ngay lập tức.
        player.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            // Chỉ restart nếu volume đang mở (người dùng đang muốn nghe)
            if (player.volume > 0) {
              player.seek(Duration.zero);
              player.play();
            }
          }
        });

        _players[sound.id] = player;
      } catch (e) {
        log('Error loading sound ${sound.id}: $e');
      }
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
