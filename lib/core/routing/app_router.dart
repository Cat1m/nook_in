import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nook_in/features/home/presentation/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,

  routes: [
    // 🏠 Home - Featured templates
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),

    // 🎴 Play template by ID
    GoRoute(
      path: '/m/:mixId',
      name: 'template',
      builder: (context, state) {
        final mixId = state.pathParameters['mixId']!;

        // TODO: Replace with actual PlayerPage
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Player Page - TODO'),
                const SizedBox(height: 16),
                Text('Template ID: $mixId'),
              ],
            ),
          ),
        );
      },
    ),

    // 🔗 Play custom mix (encoded in URL)
    GoRoute(
      path: '/p/:encoded',
      name: 'custom',
      builder: (context, state) {
        final encoded = state.pathParameters['encoded']!;

        // TODO: Decode PomoMix and show PlayerPage
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Player Page - TODO'),
                const SizedBox(height: 16),
                Text('Encoded: ${encoded.substring(0, 20)}...'),
              ],
            ),
          ),
        );
      },
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.uri.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);

// 🎯 Route Extensions for type-safe navigation
extension AppRouterExtension on BuildContext {
  void goHome() => go('/');

  void goToTemplate(String mixId) => go('/m/$mixId');

  void goToCustomMix(String encoded) => go('/p/$encoded');
}
