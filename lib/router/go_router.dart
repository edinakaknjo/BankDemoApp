import 'package:go_router/go_router.dart';
import 'package:moneyapp/features/autentication/login_page.dart';
import 'package:moneyapp/features/autentication/signup_page.dart';
import 'package:moneyapp/features/loan/pages/loan_page.dart';
import 'package:moneyapp/features/pay/pages/pay_page.dart';
import 'package:moneyapp/features/pay/pages/pay_who_page.dart';
import 'package:moneyapp/features/transactions/pages/transaction_details_page.dart';
import 'package:moneyapp/features/transactions/pages/transactions_page.dart';

class AppRouter {
  static const String signup = '/signup';
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
        builder: (context, state) =>
            PayPage(isTopUp: state.extra as bool? ?? false),
      ),
      GoRoute(
        path: '/pay_who',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final String amount = args['amount'] as String;
          final bool isTopUp = args['isTopUp'] as bool;

          return PayWhoPage(amount: amount, isTopUp: isTopUp);
        },
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
