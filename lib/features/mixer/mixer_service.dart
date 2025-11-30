import 'dart:async';
import 'dart:developer';
import 'package:rxdart/rxdart.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

import 'package:nook_in/features/mixer/sound_track.dart';

@lazySingleton
class MixerService {
  final Map<String, AudioPlayer> _players = {};
  bool _isTimerRunning = false;

  // Timer cho preview
  final Map<String, Timer> _previewTimers = {};

  // 👇 2. Dùng BehaviorSubject thay vì StreamController
  // .seeded({}) nghĩa là giá trị khởi tạo ban đầu là rỗng
  final _previewIdsSubject = BehaviorSubject<Set<String>>.seeded({});

  Stream<Set<String>> get previewIdsStream => _previewIdsSubject.stream;

  // Biến nội bộ để thao tác cho dễ (giữ nguyên logic cũ)
  final Set<String> _activePreviewIds = {};

  Future<void> initDefault() async {
    try {
      final defaultSound = SoundTrack.presets.firstWhere((s) => s.id == 'rain');
      await _initializePlayer(defaultSound);
      if (_players.containsKey('rain')) {
        await _players['rain']!.setVolume(0.3);
      }
    } catch (e) {
      log('Error initDefault: $e');
    }
  }

  Future<void> loadSound(String id) async {
    if (_players.containsKey(id)) return;
    try {
      final sound = SoundTrack.presets.firstWhere((s) => s.id == id);
      await _initializePlayer(sound);
    } catch (e) {
      log('Error loadSound $id: $e');
    }
  }

  Future<void> _initializePlayer(SoundTrack sound) async {
    final player = AudioPlayer();
    try {
      _players[sound.id] = player;
      await player.setAsset(sound.assetPath);
      await player.setLoopMode(LoopMode.one);
      await player.setVolume(0); // Mặc định im lặng

      // Cảnh sát vị trí (Giữ nguyên logic bất tử này)
      player.positionStream.listen((position) {
        final duration = player.duration;
        if (duration != null && player.playing) {
          if (position.inMilliseconds >= duration.inMilliseconds - 300) {
            player.seek(Duration.zero);
          }
        }
      });

      player.playerStateStream.listen((state) async {
        if (state.processingState == ProcessingState.completed &&
            player.volume > 0) {
          await player.seek(Duration.zero);
          await player.play();
        }
      });
    } catch (e) {
      log('Error loading sound ${sound.id}: $e');
      _players.remove(sound.id);
    }
  }

  // 👇 HÀM 1: CHỈ CHỈNH VOLUME (Cực gọn)
  Future<void> setVolume(String soundId, double volume) async {
    final player = _players[soundId];
    if (player == null) return;

    // Lazy load nếu chưa có
    if (player.duration == null) {
      final sound = SoundTrack.presets.firstWhere((s) => s.id == soundId);
      await player.setAsset(sound.assetPath);
      await player.setLoopMode(LoopMode.one);
    }

    await player.setVolume(volume);

    // Nếu Timer Chính đang chạy -> Thì chỉnh volume phải có tác dụng ngay (Pause/Play)
    if (_isTimerRunning) {
      if (volume > 0 && !player.playing) {
        if (player.processingState == ProcessingState.completed) {
          await player.seek(Duration.zero);
        }
        await player.play();
      } else if (volume == 0 && player.playing) {
        await player.pause();
      }
    }
    // Nếu Timer đang tắt -> setVolume KHÔNG LÀM GÌ CẢ (Chỉ lưu giá trị volume đó thôi)
  }

  Future<void> togglePreview(String soundId) async {
    final player = _players[soundId];
    if (player == null) return;
    if (_isTimerRunning) return;

    if (_activePreviewIds.contains(soundId)) {
      // --- TRƯỜNG HỢP TẮT ---

      // 1. Cập nhật danh sách ngay lập tức
      _activePreviewIds.remove(soundId);
      // 👇 QUAN TRỌNG: Tạo Set mới để Bloc nhận diện sự thay đổi
      _previewIdsSubject.add(Set.from(_activePreviewIds));

      // 2. Xử lý Logic (Hủy timer, dừng nhạc)
      _previewTimers[soundId]?.cancel();
      _previewTimers.remove(soundId);

      await player.pause();
      await player.seek(Duration.zero);
    } else {
      // --- TRƯỜNG HỢP BẬT ---

      // 1. Cập nhật danh sách NGAY LẬP TỨC (Optimistic UI)
      // Để icon đổi thành Pause ngay khi chạm tay, không cần chờ nhạc load
      _activePreviewIds.add(soundId);
      // 👇 QUAN TRỌNG: Tạo Set mới
      _previewIdsSubject.add(Set.from(_activePreviewIds));

      // 2. Setup Timer ngay (Không chờ play)
      _previewTimers[soundId]?.cancel();
      _previewTimers[soundId] = Timer(const Duration(seconds: 7), () async {
        if (!_isTimerRunning && player.playing) {
          await player.pause();
          await player.seek(Duration.zero);

          // Hết giờ -> Xóa khỏi list và báo cáo
          _activePreviewIds.remove(soundId);
          // 👇 QUAN TRỌNG: Tạo Set mới
          _previewIdsSubject.add(Set.from(_activePreviewIds));
        }
        _previewTimers.remove(soundId);
      });

      // 3. Bây giờ mới xử lý Audio (Nặng nề để sau cùng)
      try {
        if (player.volume == 0) await player.setVolume(0.3);
        if (player.processingState == ProcessingState.completed) {
          await player.seek(Duration.zero);
        }
        await player.play();
      } catch (e) {
        // Nếu lỡ play lỗi thì phải revert lại UI
        log('Lỗi play preview: $e');
        _activePreviewIds.remove(soundId);
        _previewIdsSubject.add(Set.from(_activePreviewIds));
      }
    }
  }

  Future<void> setTimerStatus(bool isRunning) async {
    _isTimerRunning = isRunning;
    // Hủy hết preview nếu Timer chính bắt đầu chạy
    for (var timer in _previewTimers.values) {
      timer.cancel();
    }
    _previewTimers.clear();

    _activePreviewIds.clear();
    _previewIdsSubject.add({});

    if (isRunning) {
      for (var player in _players.values) {
        if (player.volume > 0) {
          // Chỉ phát những sound có volume
          if (player.processingState == ProcessingState.completed) {
            await player.seek(Duration.zero);
          }
          unawaited(player.play());
        }
      }
    } else {
      // 1. Gom tất cả các lệnh pause cần thiết vào 1 danh sách
      final pauseTasks = _players.values
          .where((player) => player.playing)
          .map((player) => player.pause());

      // 2. Thực thi tất cả cùng 1 lúc và đợi tất cả xong
      await Future.wait(pauseTasks);
    }
  }

  // ... Dispose giữ nguyên
  void dispose() {
    _previewIdsSubject.close(); // Quan trọng
    for (var t in _previewTimers.values) {
      t.cancel();
    }
    _previewTimers.clear();
    for (var p in _players.values) {
      p.dispose();
    }
    _players.clear();
  }
}
