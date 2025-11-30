import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nook_in/core/di/injectable.dart';
import 'package:nook_in/features/mixer/mixer_service.dart';
import 'package:nook_in/nook_in_app.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();
  await GetIt.I<MixerService>().initDefault();
  // Run app
  runApp(const NookInApp());
}
