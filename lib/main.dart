import 'package:flutter/material.dart';
import 'package:nook_in/core/di/injectable.dart';
import 'package:nook_in/nook_in_app.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();

  // Run app
  runApp(const NookInApp());
}
