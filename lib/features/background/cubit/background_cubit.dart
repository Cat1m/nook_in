import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:nook_in/gen/assets.gen.dart';

enum BackgroundMode { static, slideshow, live, custom }

class BackgroundState extends Equatable {
  final BackgroundMode mode;
  final String currentAsset;
  final bool isVideo;

  const BackgroundState({
    required this.mode,
    required this.currentAsset,
    this.isVideo = false,
  });

  @override
  List<Object> get props => [mode, currentAsset, isVideo];
}

@injectable
class BackgroundCubit extends Cubit<BackgroundState> {
  Timer? _slideshowTimer;

  // DATA HARDCODE (Sau này bạn có thể move ra file config riêng)
  final List<String> _staticImages = [
    Assets.backgrounds.static.hanoiGirl.path,
    Assets.backgrounds.static.nature.path,
    Assets.backgrounds.static.sakura.path,
  ];

  final List<String> _liveVideos = [
    Assets.backgrounds.live.campfire,
    Assets.backgrounds.live.catInRain,
  ];

  BackgroundCubit()
    : super(
        const BackgroundState(
          mode: BackgroundMode.slideshow, // Mặc định vẫn là slideshow
          currentAsset: '',
        ),
      ) {
    // Khởi động vào là chạy slideshow luôn
    setMode(BackgroundMode.slideshow);
  }

  void setMode(BackgroundMode mode) {
    _slideshowTimer?.cancel();

    switch (mode) {
      case BackgroundMode.static:
        // Random 1 ảnh tĩnh
        final random = Random();
        final asset = _staticImages[random.nextInt(_staticImages.length)];
        emit(BackgroundState(mode: mode, currentAsset: asset, isVideo: false));
        break;

      case BackgroundMode.slideshow:
        _startSlideshow();
        break;

      case BackgroundMode.live:
        // Mặc định lấy video đầu tiên (hoặc random tùy bạn)
        if (_liveVideos.isNotEmpty) {
          emit(
            BackgroundState(
              mode: mode,
              currentAsset: _liveVideos.first,
              isVideo: true,
            ),
          );
        }
        break;

      case BackgroundMode.custom:
        // TODO: Xử lý logic custom sau
        break;
    }
  }

  void _startSlideshow() {
    int index = 0;
    // Emit cái đầu tiên ngay lập tức
    if (_staticImages.isNotEmpty) {
      emit(
        BackgroundState(
          mode: BackgroundMode.slideshow,
          currentAsset: _staticImages[index],
        ),
      );
    }

    _slideshowTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_staticImages.isEmpty) return;
      index = (index + 1) % _staticImages.length;
      emit(
        BackgroundState(
          mode: BackgroundMode.slideshow,
          currentAsset: _staticImages[index],
        ),
      );
    });
  }

  // Hàm đổi video cụ thể (nếu sau này menu cho chọn chi tiết)
  void changeLiveWallpaper(String assetPath) {
    emit(
      BackgroundState(
        mode: BackgroundMode.live,
        currentAsset: assetPath,
        isVideo: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _slideshowTimer?.cancel();
    return super.close();
  }
}
