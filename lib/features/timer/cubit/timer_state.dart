import 'package:equatable/equatable.dart';

sealed class TimerState extends Equatable {
  final int duration; // Tổng thời gian cài đặt (giây)
  final int remaining; // Thời gian còn lại (giây)

  const TimerState(this.duration, this.remaining);

  @override
  List<Object> get props => [duration, remaining];
}

class TimerInitial extends TimerState {
  // SỬA LỖI Ở ĐÂY:
  // Thay 'super.duration' bằng 'int duration' thường
  // Và truyền nó vào cả 2 tham số của cha: duration và remaining
  const TimerInitial(int duration) : super(duration, duration);
}

class TimerRunning extends TimerState {
  const TimerRunning(super.duration, super.remaining);
}

class TimerPaused extends TimerState {
  const TimerPaused(super.duration, super.remaining);
}

class TimerCompleted extends TimerState {
  const TimerCompleted() : super(0, 0);
}
