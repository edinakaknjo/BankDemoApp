import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp/common/cubit/login_cubit.dart';
import 'package:moneyapp/common/cubit/signup_cubit.dart';
import 'package:moneyapp/router/go_router.dart';
import 'common/cubit/transactions_cubit.dart';
import 'features/transactions/source/transaction_source.dart';
import 'injectable.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  final apiSource = getIt<ApiDataSource>();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionsCubit(apiSource),
        ),
        BlocProvider(
          create: (context) => getIt<LoginCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<SignupCubit>(),
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
