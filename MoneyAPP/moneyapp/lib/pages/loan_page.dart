import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/transactions/transactions_bloc.dart';
import '../blocs/transactions/transactions_event.dart';
import '../blocs/transactions/transactions_state.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  LoanPageState createState() => LoanPageState();
}

class LoanPageState extends State<LoanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _monthlySalaryController = TextEditingController();
  final TextEditingController _monthlyExpensesController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _termController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0028B),
        title: const Text('Loan Application', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
      ),
      body: SingleChildScrollView(  //problem
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Terms & Conditions
              const Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Terms & Conditions Checkbox
              Row(
                children: [
                  Switch(
                    value: _acceptedTerms,
                    onChanged: (bool value) {
                      setState(() {
                        _acceptedTerms = value;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Accept Terms & Conditions',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Loan Form Section
              const Text('About You', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Monthly Salary
                    TextFormField(
                      controller: _monthlySalaryController,
                      decoration: const InputDecoration(
                        labelText: 'Monthly Salary',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your monthly salary';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Monthly Expenses
                    TextFormField(
                      controller: _monthlyExpensesController,
                      decoration: const InputDecoration(
                        labelText: 'Monthly Expenses',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your monthly expenses';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Loan Amount
                    TextFormField(
                      controller: _loanAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Loan Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the loan amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Term (in months)
                    TextFormField(
                      controller: _termController,
                      decoration: const InputDecoration(
                        labelText: 'Term',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the loan term';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Apply for Loan Button
                    BlocConsumer<TransactionsBloc, TransactionsState>(
                      listener: (context, state) {
                        if (state.loanApproved != null) {
                          // Show success/failure dialog based on loan status
                          _showLoanDialog(context, state.loanApproved!);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            if (state.isLoading) // Show loading spinner if isLoading is true
                              const CircularProgressIndicator()
                            else
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate() && _acceptedTerms) {
                                    // Apply for loan
                                    _applyForLoan(context);
                                  } else if (!_acceptedTerms) {
                                    // Terms are not accepted
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please accept the Terms & Conditions')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC0028B),
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                ),
                                child: const Text('Apply for Loan'),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to trigger loan application event
  void _applyForLoan(BuildContext context) {
    // Dispatch loan event with entered values
    context.read<TransactionsBloc>().add(
      ApplyForLoan(
        loanAmount: double.parse(_loanAmountController.text),
        term: int.parse(_termController.text),
        monthlySalary: double.parse(_monthlySalaryController.text),
        monthlyExpenses: double.parse(_monthlyExpensesController.text),
      ),
    );
  }

  // Show loan decision dialog
  void _showLoanDialog(BuildContext context, bool approved) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(approved ? 'Yeeeyyy !! Congrats' : 'Ooopsss'),
          content: Text(
            approved
                ? 'Your application has been approved. Don’t tell your friends you have money!'
                : 'Your application has been declined. It’s not your fault, it’s a financial crisis.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
