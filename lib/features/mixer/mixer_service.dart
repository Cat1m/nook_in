import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nook_in/features/mixer/sound_track.dart';

@lazySingleton
class MixerService {
  final Map<String, AudioPlayer> _players = {};

  void _log(String message) {
    print('🔴 [MIXER]: $message');
  }

  Future<void> initDefault() async {
    try {
      final defaultSound = SoundTrack.presets.firstWhere((s) => s.id == 'rain');
      await _initializePlayer(defaultSound);
    } catch (e) {
      _log('Error initDefault: $e');
    }
  }

  Future<void> loadSound(String id) async {
    if (_players.containsKey(id)) return;
    try {
      final sound = SoundTrack.presets.firstWhere((s) => s.id == id);
      await _initializePlayer(sound);
    } catch (e) {
      _log('Error loadSound $id: $e');
    }
  }

  Future<void> _initializePlayer(SoundTrack sound) async {
    final player = AudioPlayer();
    try {
      _players[sound.id] = player;

      await player.setAsset(sound.assetPath);
      await player.setLoopMode(LoopMode.one); // Set 1 lần là đủ
      await player.setVolume(0);

      // 👇 CẢNH SÁT VỊ TRÍ (Manual Loop bằng cơm)
      // Đây là giải pháp mạnh nhất cho Web: Tự check thời gian để tua lại
      player.positionStream.listen((position) {
        final duration = player.duration;
        if (duration != null && player.playing) {
          // Nếu vị trí hiện tại >= (Tổng thời gian - 300ms)
          // Tức là sắp hết bài rồi -> Tua về đầu ngay lập tức
          if (position.inMilliseconds >= duration.inMilliseconds - 300) {
            // _log('${sound.id} -> Manual Loop Triggered!');
            player.seek(Duration.zero);
          }
        }
      });

      // Vẫn giữ cảnh sát State để đề phòng
      player.playerStateStream.listen((state) async {
        if (state.processingState == ProcessingState.completed &&
            player.volume > 0) {
          _log('${sound.id} -> Completed detected -> Seek 0');
          await player.seek(Duration.zero);
          await player.play();
        }
      });
    } catch (e) {
      _log('Error loading sound ${sound.id}: $e');
      _players.remove(sound.id);
    }
  }

  Future<void> setVolume(String soundId, double volume) async {
    final player = _players[soundId];
    if (player == null) return;

    try {
      // Lazy load check
      if (player.duration == null) {
        final sound = SoundTrack.presets.firstWhere((s) => s.id == soundId);
        await player.setAsset(sound.assetPath);
        await player.setLoopMode(LoopMode.one);
      }

      if (volume > 0) {
        // 👇 BỎ Force Toggle Loop (Vì nó gây spam lệnh)
        // Chỉ cần đảm bảo nó đang One là được
        if (player.loopMode != LoopMode.one) {
          await player.setLoopMode(LoopMode.one);
        }

        // Chỉ cần gọi play() là trình duyệt sẽ tỉnh ngủ (Wake lock)
        if (!player.playing) {
          if (player.processingState == ProcessingState.completed) {
            await player.seek(Duration.zero);
          }
          await player.play();
        }
      }

      if (volume == 0 && player.playing) {
        await player.pause();
      }

      await player.setVolume(volume);
    } catch (e) {
      _log('Lỗi setVolume $soundId: $e');
    }
  }

  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}
