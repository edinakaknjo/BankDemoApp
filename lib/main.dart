import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp/router/go_router.dart';
import 'common/cubit/transactions_cubit.dart';
import 'common/source/api_source.dart';
import 'package:dio/dio.dart';
import 'common/cubit/login_cubit.dart';
import 'common/cubit/signup_cubit.dart';
import 'common/firebase/firebase_module.dart';

Future<void> main() async {
  await setupFirebase(); // Call your firebase setup

  final dio = Dio();
  final apiSource = ApiDataSource(dio);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionsCubit(apiSource),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => SignupCubit(),
        ),
      ],
      child: const MoneyApp(),
    ),
  );
}

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MoneyApp',
      routerConfig: AppRouter.router,
    );
  }
}
