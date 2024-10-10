

class Transaction {
  final String name;
  final double amount;
  final bool isTopUp;
  final DateTime date;

  Transaction({
    required this.name,
    required this.amount,
    required this.isTopUp,
    required this.date,
  });
}

