import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:encrypt/encrypt.dart' as aes;

import 'Encryption/encryption_key.dart';
import 'model/room_model.dart';
import 'pages/chat_room/chat_room.dart';
import 'pages/landing/landing.dart';
import 'pages/login/login.dart';
import 'state/login_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static final LoginState loginStateController = LoginState();

  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return Login(controller: loginStateController);
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'landing',
            builder: (BuildContext context, GoRouterState state) {
              return Landing(controller: loginStateController);
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'room',
                builder: (BuildContext context, GoRouterState state) {
                  final name = state.uri.queryParameters['name'];
                  if (name != null) {
                    var key = aes.Key.fromUtf8(EncryptionKey.encryptionKey);
                    // var iv = aes.IV.fromLength(16);
                    var iv = aes.IV(Uint8List(16));
                    var encrypter = aes.Encrypter(aes.AES(key));
                    var decrypted = encrypter.decrypt64(name, iv: iv);
                    var map = jsonDecode(decrypted) as Map<String, dynamic>;
                    var room = RoomModel.fromJson(map);
                    return ChatRoom(room: room);
                  }

                  return const ChatRoom(room: null);
                },
              ),
            ],
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
