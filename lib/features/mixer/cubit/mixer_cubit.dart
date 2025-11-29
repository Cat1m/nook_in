import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:nook_in/features/mixer/mixer_service.dart';

// --- STATE ---
class MixerState extends Equatable {
  // Map lưu volume hiện tại của từng sound: {'rain': 0.5, 'fire': 0.0}
  final Map<String, double> volumes;

  const MixerState({this.volumes = const {}});

  @override
  List<Object> get props => [volumes];

  MixerState copyWith({Map<String, double>? volumes}) {
    return MixerState(volumes: volumes ?? this.volumes);
  }
}

// --- CUBIT ---
@injectable
class MixerCubit extends Cubit<MixerState> {
  final MixerService _mixerService;

  MixerCubit(this._mixerService) : super(const MixerState());

  void changeVolume(String soundId, double newVolume) {
    // 1. Gọi xuống Service để chỉnh nhạc thật
    _mixerService.setVolume(soundId, newVolume);

    // 2. Cập nhật UI
    final currentVolumes = Map<String, double>.from(state.volumes);
    currentVolumes[soundId] = newVolume;

    emit(state.copyWith(volumes: currentVolumes));
  }
}
