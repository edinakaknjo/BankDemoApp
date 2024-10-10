abstract class TransactionsEvent {}

class AddTransaction extends TransactionsEvent {
  final String name;
  final double amount;
  final bool isTopUp;

  AddTransaction(
      {required this.name, required this.amount, required this.isTopUp});
}

class ApplyForLoan extends TransactionsEvent {
  final double loanAmount;
  final int term;
  final double monthlySalary;
  final double monthlyExpenses;

  ApplyForLoan({
    required this.loanAmount,
    required this.term,
    required this.monthlySalary,
    required this.monthlyExpenses,
  });
}
