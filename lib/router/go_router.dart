import 'package:go_router/go_router.dart';
import 'package:moneyapp/features/autentication/login_page.dart';
import 'package:moneyapp/features/autentication/signup_page.dart';
import 'package:moneyapp/features/loan/pages/loan_page.dart';
import 'package:moneyapp/features/pay/pages/pay_page.dart';
import 'package:moneyapp/features/pay/pages/pay_who_page.dart';
import 'package:moneyapp/features/transactions/pages/transaction_details_page.dart';
import 'package:moneyapp/features/transactions/pages/transactions_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login', 
    routes: [
      GoRoute(
        path: '/', 
        builder: (context, state) => const TransactionsPage(),
      ),
      GoRoute(
        path: '/login', 
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
         path: '/pay',
  builder: (context, state) => PayPage(isTopUp: state.extra as bool? ?? false),  // Pass the isTopUp value here

       // builder: (context, state) {
       //   final isTopUp = state.extra as bool? ?? false; // Retrieve the `extra` data
       //   return PayPage(isTopUp: isTopUp); // Pass `isTopUp` to PayPage
       // },
      ),
      GoRoute(
        path: '/pay_who',
        builder: (context, state) => const PayWhoPage(),
      ),
      GoRoute(
        path: '/transaction_details',
        builder: (context, state) => const TransactionDetailsPage(),
      ),
      GoRoute(
        path: '/loan',
        builder: (context, state) => const LoanPage(),
      ),
    ],
  );
}
