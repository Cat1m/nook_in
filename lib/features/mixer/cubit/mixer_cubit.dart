import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:nook_in/features/mixer/mixer_service.dart';
import 'package:nook_in/features/mixer/sound_track.dart';

// --- STATE ---
class MixerState extends Equatable {
  final Map<String, double> volumes;
  final Set<String> readySoundIds; // 👇 MỚI: Danh sách sound đã tải xong

  const MixerState({this.volumes = const {}, this.readySoundIds = const {}});

  @override
  List<Object> get props => [volumes, readySoundIds];

  MixerState copyWith({
    Map<String, double>? volumes,
    Set<String>? readySoundIds,
  }) {
    return MixerState(
      volumes: volumes ?? this.volumes,
      readySoundIds: readySoundIds ?? this.readySoundIds,
    );
  }
}

// --- CUBIT ---
@injectable
class MixerCubit extends Cubit<MixerState> {
  final MixerService _mixerService;

  // Khi khởi tạo Cubit, ta bắt đầu quy trình tải luôn
  MixerCubit(this._mixerService) : super(const MixerState()) {
    _startBackgroundLoading();
  }

  void _startBackgroundLoading() async {
    // 1. Đánh dấu 'rain' là ready ngay lập tức (vì đã init ở main rồi)
    emit(state.copyWith(readySoundIds: {'rain'}));

    // 2. Lọc ra những sound chưa tải (trừ rain ra)
    final otherSounds = SoundTrack.presets.where((s) => s.id != 'rain');

    // 3. Tải lần lượt từng cái (Background Process)
    for (var sound in otherSounds) {
      // Gọi service tải (await ở đây là await cho việc tải xong file đó)
      await _mixerService.loadSound(sound.id);

      // Tải xong cái nào, update UI cái đó ngay (Realtime feedback)
      final newReadySet = Set<String>.from(state.readySoundIds)..add(sound.id);
      emit(state.copyWith(readySoundIds: newReadySet));
    }
  }

  void changeVolume(String soundId, double newVolume) {
    // Chỉ cho chỉnh volume nếu sound đã ready
    if (!state.readySoundIds.contains(soundId)) return;

    _mixerService.setVolume(soundId, newVolume);

    final currentVolumes = Map<String, double>.from(state.volumes);
    currentVolumes[soundId] = newVolume;
    emit(state.copyWith(volumes: currentVolumes));
  }
}
