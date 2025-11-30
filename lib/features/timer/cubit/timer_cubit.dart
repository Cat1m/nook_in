import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nook_in/core/services/audio_service.dart';
import 'package:nook_in/features/mixer/mixer_service.dart';
import 'package:nook_in/features/timer/ticker.dart';

import 'package:nook_in/features/timer/cubit/timer_state.dart';

@injectable
class TimerCubit extends Cubit<TimerState> {
  final Ticker _ticker;
  final AudioService _audioService;
  final MixerService _mixerService;
  StreamSubscription<int>? _tickerSubscription;

  // Mặc định 25 phút = 1500 giây
  static const int _defaultDuration = 25 * 60;

  TimerCubit(this._ticker, this._audioService, this._mixerService)
    : super(const TimerInitial(_defaultDuration));

  /// 1. Bắt đầu đếm (từ trạng thái Initial hoặc Resume từ Paused)
  void startTimer() {
    if (state is TimerRunning) return;
    // Vừa kêu "Ting" một cái, vừa unlock Audio trên Web
    _audioService.playStart();
    // 👇 RA LỆNH CHO DÀN NHẠC: "Bắt đầu diễn!"
    _mixerService.setTimerStatus(true);
    // Nếu đang Initial thì start mới, nếu đang Paused thì resume tiếp
    final duration = state.duration;
    final remaining = state is TimerPaused ? state.remaining : state.duration;

    emit(TimerRunning(duration, remaining));
    _startTicker(remaining);
  }

  /// 2. Tạm dừng
  void pauseTimer() {
    if (state is TimerRunning) {
      _tickerSubscription?.pause();
      // 👇 RA LỆNH: "Dừng nhạc!"
      _mixerService.setTimerStatus(false);
      emit(TimerPaused(state.duration, state.remaining));
    }
  }

  /// 3. Tiếp tục (Resume)
  void resumeTimer() {
    if (state is TimerPaused) {
      _tickerSubscription?.resume();
      emit(TimerRunning(state.duration, state.remaining));
    }
  }

  /// 4. Reset về trạng thái ban đầu (giữ nguyên duration đang chọn)
  void resetTimer() {
    _tickerSubscription?.cancel();
    // 👇 RA LỆNH: "Dừng nhạc và về vị trí cũ!"
    _mixerService.setTimerStatus(false);
    emit(TimerInitial(state.duration));
  }

  /// 5. Người dùng chọn thời gian mới (phút) từ Filter Chip
  void setDuration(int minutes) {
    _tickerSubscription?.cancel();
    emit(TimerInitial(minutes * 60));
  }

  /// Logic nội bộ để lắng nghe Ticker
  void _startTicker(int ticks) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: ticks).listen((duration) {
      if (duration > 0) {
        emit(TimerRunning(state.duration, duration));
      } else {
        _tickerSubscription?.cancel();
        _audioService.playAlarm();
        // 👇 RA LỆNH: "Hết giờ diễn, nghỉ!"
        _mixerService.setTimerStatus(false);
        emit(const TimerCompleted());
      }
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
