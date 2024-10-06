import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

class Loan {
  final double monthlySalary;
  final double monthlyExpenses;
  final double loanAmount;
  final int term;
  bool appliedBefore = false; //problem, was always triggering and i couldnt pinpoint why
  Loan({
    required this.monthlySalary,
    required this.monthlyExpenses,
    required this.loanAmount,
    required this.term,
  });

  bool isEligible(double accountBalance, int randomNumber) {
    if (randomNumber <= 50){
      printToConsole(randomNumber.toString());
      return false;
    }else {
      printToConsole(randomNumber.toString());
    }
     
    if (accountBalance <= 1000) return false;
    if (monthlySalary <= 1000) return false;
    if (monthlyExpenses >= (monthlySalary / 3)) return false;
    if ((loanAmount / term) >= (monthlySalary / 3)) return false;

    return true;
  }
}
