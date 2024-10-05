import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http; //had a problem, used wrong embeding
import '../../models/transaction_model.dart';
import 'transactions_event.dart';
import 'package:logger/logger.dart';
import 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final Logger logger = Logger(); // Initialize logger

  TransactionsBloc()
      : super(TransactionsState(transactions: [], balance: 15025)) {
    on<AddTransaction>(_onAddTransaction);
    on<ApplyForLoan>(_onApplyForLoan); // priv new
  }

  void _onAddTransaction(
      AddTransaction event, Emitter<TransactionsState> emit) {
    final newTransaction = Transaction(
      name: event.name,
      amount: event.amount,
      isTopUp: event.isTopUp,
      date: DateTime.now(),
    );

    //push back
    final updatedTransactions = List<Transaction>.from(state.transactions)
      ..add(newTransaction);

    final updatedBalance = state.balance +
        (event.isTopUp
            ? event.amount
            : -event
                .amount); //this will be implemented further on, basicly a if statment

    emit(state.copyWith(
        transactions: updatedTransactions, balance: updatedBalance));
  }

  void _onApplyForLoan(
      ApplyForLoan event, Emitter<TransactionsState> emit) async {
    emit(state.copyWith(isLoading: true));

    int randomNumber = await getRandomNumber();
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
      emit(state.copyWith(
          loanApproved: false, isLoading: false)); // Reset loading state
    }
  }


Future<int> getRandomNumber() async {
  final url = Uri.parse('http://www.randomnumberapi.com/api/v1.0/random');
  final response = await http.get(url);

  // Log the response for debugging
  logger.i('Response Status Code: ${response.statusCode}');
  logger.i('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    List<int> randomNumber = json.decode(response.body);
    return randomNumber[0];
  } else {
    throw Exception('Failed to load random number');
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
    if (accountBalance <= 1000) return false; //problem in this page you will see your current balance.... says in .docs
    if (monthlySalary <= 1000) return false;
    if (monthlyExpenses >= (monthlySalary / 3)) return false;
    if ((loanAmount / term) >= (monthlySalary / 3)) return false;

    return true;
  }
}
