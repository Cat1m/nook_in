import 'package:flutter/material.dart';

import 'package:nook_in/core/routing/app_router.dart';
import 'package:nook_in/core/theme/app_theme.dart';

class NookInApp extends StatelessWidget {
  const NookInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nook In',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.light,

      // Routing
      routerConfig: appRouter,
    );
  }
}
