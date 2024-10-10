import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp/pages/loan_page.dart';
import 'package:moneyapp/pages/transaction_details_page.dart';
import 'blocs/transactions/transactions_bloc.dart';
import 'pages/pay_page.dart';
import 'pages/pay_who_page.dart';
import 'pages/transactions_page.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => TransactionsBloc(),
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
