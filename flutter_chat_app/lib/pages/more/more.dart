import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../state/login_state.dart';

class More extends StatelessWidget {
  final LoginState controller;
  const More({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          controller.logoutUser();
          context.pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple[100],
        ),
        child: const Text('Logout'),
      ),
    );
  }
}
