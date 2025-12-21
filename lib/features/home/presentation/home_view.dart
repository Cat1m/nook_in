import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook_in/features/background/cubit/background_cubit.dart';
import 'package:nook_in/features/background/presentation/background_layer.dart';
import 'package:nook_in/features/home/presentation/widget/background_menu_button.dart';
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
      body: Stack(
        children: [
          // 1. LỚP NỀN
          const BackgroundLayer(),
          // 2. LỚP NỘI DUNG (Content cũ của bạn)
          SafeArea(
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
                    const GlassDivider(),
                    const SizedBox(height: 24),

                    // --- PHẦN MIXER (Mới thêm) ---
                    const GlassSectionHeader(
                      title: 'Sound Mixer',
                      icon: Icons.music_note_rounded, // Optional
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
                                iconPath: sound.assetPath,
                                volume: currentVol,

                                // Kiểm tra xem soundId có trong danh sách ready chưa
                                isReady: state.readySoundIds.contains(sound.id),

                                onChanged: (newVol) {
                                  context.read<MixerCubit>().changeVolume(
                                    sound.id,
                                    newVol,
                                  );
                                },
                                onPreview: () {
                                  context.read<MixerCubit>().togglePreview(
                                    sound.id,
                                  );
                                },
                                isPreviewing: state.previewingSoundIds.contains(
                                  sound.id,
                                ),
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

          const BackgroundMenuButton(),
        ],
      ),
    );
  }
}
