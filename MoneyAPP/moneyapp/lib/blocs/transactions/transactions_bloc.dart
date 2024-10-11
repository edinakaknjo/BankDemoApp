import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../source/api_source.dart';
import '../../models/transaction_model.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';
import 'package:logger/logger.dart';

@injectable
class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final Logger logger = Logger();
  final ApiDataSource apiDataSource;

  TransactionsBloc(this.apiDataSource)
      : super(TransactionsState(transactions: [], balance: 150.25)) {
    on<AddTransaction>(_onAddTransaction);
    on<ApplyForLoan>(_onApplyForLoan);
  }

  void _onAddTransaction(
      AddTransaction event, Emitter<TransactionsState> emit) {
    final newTransaction = Transaction(
      name: event.name,
      amount: event.amount,
      isTopUp: event.isTopUp,
      date: DateTime.now(),
    );

    final updatedTransactions = List<Transaction>.from(state.transactions)
      ..add(newTransaction);

    final updatedBalance =
        state.balance + (event.isTopUp ? event.amount : -event.amount);

    emit(state.copyWith(
        transactions: updatedTransactions, balance: updatedBalance));
  }

  void _onApplyForLoan(
      ApplyForLoan event, Emitter<TransactionsState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final cacheBust = DateTime.now().millisecondsSinceEpoch.toString();
      final response = await apiDataSource.getRandomNumber(cacheBust);
      logger.i('Response Status Code: ${response.response.statusCode}');
      logger.i('Response Body: ${response.data}');

      final jsonData = json.decode(response.data);
      String contents = jsonData['contents'];
      List<dynamic> numbers = json.decode(contents);
      int randomNumber = numbers[0];

      bool loanApproved = _checkLoanEligibility(
        randomNumber,
        state.balance,
        event.loanAmount,
        event.term,
        event.monthlySalary,
        event.monthlyExpenses,
      );

      if (loanApproved) {
        final newLoanTransaction = Transaction(
          name: 'Loan',
          amount: event.loanAmount,
          isTopUp: true,
          date: DateTime.now(),
        );

        final updatedTransactions = List<Transaction>.from(state.transactions)
          ..add(newLoanTransaction);
        final updatedBalance = state.balance + event.loanAmount;

        emit(state.copyWith(
            transactions: updatedTransactions,
            balance: updatedBalance,
            loanApproved: true,
            isLoading: false));
      } else {
        emit(state.copyWith(loanApproved: false, isLoading: false));
      }
    } catch (error) {
      logger.e('Error fetching random number: $error');
      emit(state.copyWith(isLoading: false));
    }
  }

  bool _checkLoanEligibility(
    int randomNumber,
    double accountBalance,
    double loanAmount,
    int term,
    double monthlySalary,
    double monthlyExpenses,
  ) {
    if (randomNumber <= 50) return false;
    if (accountBalance <= 1000) return false;
    if (monthlySalary <= 1000) return false;
    if (monthlyExpenses >= (monthlySalary / 3)) return false;
    if ((loanAmount / term) >= (monthlySalary / 3)) return false;

    return true;
  }
}
