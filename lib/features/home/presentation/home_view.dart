import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook_in/features/background/cubit/background_cubit.dart';
import 'package:nook_in/features/background/presentation/background_layer.dart';
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
                    const Divider(),
                    const SizedBox(height: 24),

                    // --- PHẦN MIXER (Mới thêm) ---
                    Text(
                      'Sound Mixer',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: Colors.white),
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

          // 3. Menu Button Thay đổi hình nền
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: PopupMenuButton<BackgroundMode>(
                icon: const Icon(Icons.wallpaper, color: Colors.white70),
                tooltip: 'Đổi hình nền',
                onSelected: (mode) {
                  if (mode == BackgroundMode.custom) {
                    // TODO: Mở dialog custom (Làm sau)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tính năng Custom đang phát triển!'),
                      ),
                    );
                  } else {
                    context.read<BackgroundCubit>().setMode(mode);
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<BackgroundMode>>[
                      const PopupMenuItem<BackgroundMode>(
                        value: BackgroundMode.static,
                        child: ListTile(
                          leading: Icon(Icons.image),
                          title: Text('Ảnh tĩnh (Random)'),
                        ),
                      ),
                      const PopupMenuItem<BackgroundMode>(
                        value: BackgroundMode.slideshow,
                        child: ListTile(
                          leading: Icon(Icons.slideshow),
                          title: Text('Slideshow (Tự động)'),
                        ),
                      ),
                      const PopupMenuItem<BackgroundMode>(
                        value: BackgroundMode.live,
                        child: ListTile(
                          leading: Icon(Icons.movie_filter),
                          title: Text('Live Wallpaper'),
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<BackgroundMode>(
                        value: BackgroundMode.custom,
                        child: ListTile(
                          leading: Icon(Icons.add_photo_alternate),
                          title: Text('Custom (Sắp ra mắt)'),
                        ),
                      ),
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
