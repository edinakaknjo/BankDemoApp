import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp/common/cubit/login_cubit.dart';
import 'package:moneyapp/common/cubit/signup_cubit.dart';
import 'package:moneyapp/router/go_router.dart';
import 'package:dio/dio.dart';
import 'common/cubit/transactions_cubit.dart';
import 'common/source/api_source.dart';
import 'injectable.dart'; // Import for configureDependencies()

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and GetIt dependencies
  await configureDependencies(); // Initializes GetIt and registers dependencies

  final dio = Dio();
  final apiSource = ApiDataSource(dio);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionsCubit(apiSource),
        ),
        BlocProvider(
          create: (context) =>
              getIt<LoginCubit>(), // Use getIt to resolve dependencies
        ),
        BlocProvider(
          create: (context) =>
              getIt<SignupCubit>(), // Use getIt to resolve dependencies
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
