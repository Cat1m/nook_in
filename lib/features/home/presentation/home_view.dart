import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook_in/features/home/presentation/widget/duration_picker.dart';
import 'package:nook_in/features/home/presentation/widget/timer_controls.dart';
import 'package:nook_in/features/home/presentation/widget/timer_display.dart';
import 'package:nook_in/features/mixer/cubit/mixer_cubit.dart';
import 'package:nook_in/features/mixer/sound_track.dart';
import 'package:nook_in/features/mixer/widgets/sound_volume_slider.dart';

import 'package:nook_in/features/timer/cubit/timer_cubit.dart';
import 'package:nook_in/features/timer/cubit/timer_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- PHẦN TIMER (Giữ nguyên) ---
                BlocBuilder<TimerCubit, TimerState>(
                  builder: (context, state) {
                    final isRunning = state is TimerRunning;
                    final isCompleted = state is TimerCompleted;

                    return Column(
                      children: [
                        TimerDisplay(remainingSeconds: state.remaining),
                        const SizedBox(height: 32),
                        DurationPicker(
                          currentDuration: state.duration,
                          isRunning: isRunning,
                          onDurationSelected: (minutes) {
                            context.read<TimerCubit>().setDuration(minutes);
                          },
                        ),
                        const SizedBox(height: 48),
                        TimerControls(
                          isRunning: isRunning,
                          isCompleted: isCompleted,
                          onToggle: () {
                            isRunning
                                ? context.read<TimerCubit>().pauseTimer()
                                : context.read<TimerCubit>().startTimer();
                          },
                          onReset: () =>
                              context.read<TimerCubit>().resetTimer(),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 60),
                const Divider(),
                const SizedBox(height: 24),

                // --- PHẦN MIXER (Mới thêm) ---
                Text(
                  'Sound Mixer',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),

                // Lắng nghe state của MixerCubit
                BlocBuilder<MixerCubit, MixerState>(
                  builder: (context, state) {
                    // Duyệt qua danh sách SoundPreset (Rain, Fire)
                    return Column(
                      children: SoundTrack.presets.map((sound) {
                        // Lấy volume hiện tại từ State, mặc định 0.0 nếu chưa có
                        final currentVol = state.volumes[sound.id] ?? 0.0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SoundVolumeSlider(
                            title: sound.name,
                            iconPath: sound.assetPath, // Tạm dùng path làm key
                            volume: currentVol,
                            onChanged: (newVol) {
                              // Gọi Cubit để cập nhật volume
                              context.read<MixerCubit>().changeVolume(
                                sound.id,
                                newVol,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
