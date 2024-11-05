import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:moneyapp/common/cubit/signup_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class SignupPage extends HookWidget {
  const SignupPage({super.key});

  Future<void> _signup(
      BuildContext context,
      SignupCubit cubit,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    try {
      await cubit.signup(emailController.text, passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('signup_success'.tr())),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('signup_failed'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return BlocProvider(
      create: (_) => GetIt.instance<SignupCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFC0028B),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'email_hint'.tr(),
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'password_hint'.tr(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final cubit = context.read<SignupCubit>();
                  _signup(context, cubit, emailController, passwordController);
                },
                child: Text('signup_button'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
