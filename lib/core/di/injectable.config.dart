// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/background/cubit/background_cubit.dart' as _i565;
import '../../features/mixer/cubit/mixer_cubit.dart' as _i7;
import '../../features/mixer/mixer_service.dart' as _i187;
import '../../features/timer/cubit/timer_cubit.dart' as _i553;
import '../../features/timer/ticker.dart' as _i204;
import '../services/audio_service.dart' as _i15;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i565.BackgroundCubit>(() => _i565.BackgroundCubit());
    gh.factory<_i204.Ticker>(() => const _i204.Ticker());
    gh.lazySingleton<_i15.AudioService>(() => _i15.AudioService());
    gh.lazySingleton<_i187.MixerService>(() => _i187.MixerService());
    gh.factory<_i7.MixerCubit>(() => _i7.MixerCubit(gh<_i187.MixerService>()));
    gh.factory<_i553.TimerCubit>(
      () => _i553.TimerCubit(
        gh<_i204.Ticker>(),
        gh<_i15.AudioService>(),
        gh<_i187.MixerService>(),
      ),
    );
    return this;
  }
}
