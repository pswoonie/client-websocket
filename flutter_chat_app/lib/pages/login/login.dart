import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../state/login_state.dart';

class Login extends StatefulWidget {
  final LoginState controller;
  const Login({super.key, required this.controller});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String name = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Simple Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                onSaved: (str) {
                  if (str != null) {
                    name = str;
                  }
                },
                validator: (str) {
                  if (str == null || str.isEmpty) {
                    return 'Name is REQUIRED!';
                  }

                  return null;
                },
                onFieldSubmitted: (str) {
                  if (str.isEmpty) return;

                  widget.controller.loginUser(str, str);
                  context.go('/landing');
                  _formKey.currentState?.reset();
                },
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.save();
                      widget.controller.loginUser(name, name);
                      context.go('/landing');
                      _formKey.currentState?.reset();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[200],
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.deepPurple[50],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
