import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook_in/features/background/cubit/background_cubit.dart';
import 'package:nook_in/features/background/presentation/live_wallpaper_player.dart';

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackgroundCubit, BackgroundState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: state.isVideo
              // Nếu là Live Wallpaper
              ? LiveWallpaperPlayer(
                  key: ValueKey(
                    state.currentAsset,
                  ), // Key để force rebuild khi đổi video
                  assetPath: state.currentAsset,
                )
              // Nếu là Ảnh tĩnh / Slideshow
              : Container(
                  key: ValueKey(state.currentAsset),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(state.currentAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Overlay tối để dễ đọc chữ
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
        );
      },
    );
  }
}
