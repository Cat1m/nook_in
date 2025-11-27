// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nook_in/features/home/presentation/home_view.dart';
import 'package:nook_in/features/timer/cubit/timer_cubit.dart'; // Đảm bảo import này

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Inject TimerCubit từ GetIt
      create: (_) => GetIt.I<TimerCubit>(),
      child: const HomeView(),
    );
  }
}
