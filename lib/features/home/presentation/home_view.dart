// lib/features/home/presentation/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook_in/features/home/presentation/duration_picker.dart';
import 'package:nook_in/features/home/presentation/timer_controls.dart';
import 'package:nook_in/features/home/presentation/timer_display.dart';
import 'package:nook_in/features/timer/cubit/timer_cubit.dart';
import 'package:nook_in/features/timer/cubit/timer_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<TimerCubit, TimerState>(
          builder: (context, state) {
            // Logic map state sang properties cho dumb widgets
            final isRunning = state is TimerRunning;
            final isCompleted = state is TimerCompleted;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Đồng hồ
                TimerDisplay(remainingSeconds: state.remaining),

                const SizedBox(height: 32),

                // 2. Chọn giờ (chỉ hiện khi chưa start để đỡ rối, hoặc disable)
                DurationPicker(
                  currentDuration: state.duration,
                  isRunning: isRunning,
                  onDurationSelected: (minutes) {
                    context.read<TimerCubit>().setDuration(minutes);
                  },
                ),

                const SizedBox(height: 48),

                // 3. Điều khiển
                TimerControls(
                  isRunning: isRunning,
                  isCompleted: isCompleted,
                  onToggle: () {
                    if (isRunning) {
                      context.read<TimerCubit>().pauseTimer();
                    } else {
                      context.read<TimerCubit>().startTimer();
                    }
                  },
                  onReset: () => context.read<TimerCubit>().resetTimer(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
