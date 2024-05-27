import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/landing/landing.dart';
import 'package:flutter_chat_app/pages/chat_room/chat_room.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const Landing();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'room',
            builder: (BuildContext context, GoRouterState state) {
              return const Room();
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
