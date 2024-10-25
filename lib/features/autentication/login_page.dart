import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyapp/common/cubit/login_cubit.dart';
import 'package:moneyapp/common/cubit/login_state.dart';
import 'package:moneyapp/injectable.dart';
import 'package:moneyapp/router/go_router.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFC0028B),
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Login failed. Please try again.')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('LOG IN',
                    style: TextStyle(fontSize: 32, color: Colors.white)),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final cubit = context.read<LoginCubit>();
                    try {
                      await cubit.login(
                          emailController.text, passwordController.text);
                      AppRouter.router.push('/');
                    } catch (e) {}
                  },
                  child: const Text('Log in'),
                ),
                TextButton(
                  onPressed: () {
                    context.push(AppRouter.signup);
                  },
                  child: const Text('Sign up',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
