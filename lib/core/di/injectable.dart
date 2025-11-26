// 🎯 Dependency Injection Setup
// Run: dart run build_runner build --delete-conflicting-outputs

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:nook_in/core/di/injectable.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
void configureDependencies() => getIt.init();

/// Initialize all dependencies
/// Call this in main() before runApp()
Future<void> initializeDependencies() async {
  configureDependencies();

  // Add any async initialization here if needed

  // Example: await getIt.allReady();
}

// 📝 HOW TO USE:
//
// 1. Mark your classes with @injectable, @lazySingleton, or @singleton
//
// 2. For abstract classes with implementations:
//    @Injectable(as: AudioRepository)
//    class AudioRepositoryImpl implements AudioRepository {}
//
// 3. For modules (third-party or complex setup):
//    @module
//    abstract class AudioModule {
//      @lazySingleton
//      AudioPlayer get audioPlayer => AudioPlayer();
//    }
//
// 4. Inject in constructors:
//    @injectable
//    class PlayerBloc {
//      final AudioRepository _audioRepository;
//      PlayerBloc(this._audioRepository);
//    }
//
// 5. Get instance manually (avoid if possible):
//    final repo = getIt<AudioRepository>();
//
// 6. Generate code:
//    dart run build_runner build --delete-conflicting-outputs
