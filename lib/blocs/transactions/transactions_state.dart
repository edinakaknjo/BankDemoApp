import '../../models/transaction_model.dart';

class TransactionsState {
  final List<Transaction> transactions;
  final double balance;
  final bool? loanApproved;
  final bool isLoading;
  TransactionsState({
    required this.transactions,
    required this.balance,
    this.loanApproved,
    this.isLoading = false,
  });

  TransactionsState copyWith({
    List<Transaction>? transactions,
    double? balance,
    bool? loanApproved,
    bool? isLoading,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      balance: balance ?? this.balance,
      loanApproved: loanApproved ?? this.loanApproved,
      isLoading: isLoading ?? this.isLoading, //
    );
  }
}
