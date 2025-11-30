import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nook_in/features/background/cubit/background_cubit.dart';
import 'package:nook_in/features/home/presentation/home_view.dart';
import 'package:nook_in/features/mixer/cubit/mixer_cubit.dart';
import 'package:nook_in/features/timer/cubit/timer_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 1. Timer Logic
        BlocProvider(create: (_) => GetIt.I<TimerCubit>()),

        // 2. Mixer Logic (Mới thêm)
        BlocProvider(create: (_) => GetIt.I<MixerCubit>()),

        // 3.background
        BlocProvider(create: (_) => GetIt.I<BackgroundCubit>()),
      ],
      child: const HomeView(),
    );
  }
}
