import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp/pages/loan_page.dart';
import 'package:moneyapp/pages/transaction_details_page.dart';
import 'cubit/transactions/transactions_cubit.dart';
import 'pages/pay_page.dart';
import 'pages/pay_who_page.dart';
import 'pages/transactions_page.dart';
import 'package:dio/dio.dart';
import 'source/api_source.dart';

void main() {
  final dio = Dio();
  final apiSource = ApiDataSource(dio);
  runApp(
    BlocProvider(
      create: (context) =>
          TransactionsCubit(apiSource), // Use TransactionsCubit
      child: const MoneyApp(),
    ),
  );
}

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoneyApp',
      initialRoute: '/',
      routes: {
        '/': (context) => const TransactionsPage(),
        '/pay': (context) => const PayPage(),
        '/pay_who': (context) => const PayWhoPage(),
        '/transaction_details': (context) => const TransactionDetailsPage(),
        '/loan': (context) => const LoanPage(),
      },
    );
  }
}
