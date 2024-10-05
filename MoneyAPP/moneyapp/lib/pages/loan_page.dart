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
  final TextEditingController _monthlySalaryController =
      TextEditingController();
  final TextEditingController _monthlyExpensesController =
      TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _termController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0028B),
        title: const Text('Loan Application',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
      ),
      body: SingleChildScrollView(
        //problem
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
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam elementum enim non neque luctus, nec blandit ipsum sagittis. Sed fringilla blandit nibh, sit amet suscipit massa sollicitudin lacinia. Donec cursus, odio sit amet tincidunt sodales, odio nisl hendrerit sem, tempor tincidunt ligula nisl nec ante. Nulla aliquet aliquam justo, ac bibendum orci rhoncus non. Nullam quis ex elementum, pharetra ligula eleifend, convallis nulla. Nulla sit amet nisi viverra, semper nunc eu, posuere dui. Donec at metus ut eros rhoncus vestibulum vitae at lacus. Etiam imperdiet, nulla ac condimentum aliquam, enim lacus fringilla leo, vel hendrerit mi ipsum et ante. Vivamus finibus mauris eget diam sodales, eget efficitur orci laoreet. Sed feugiat odio quis mattis tristique. Mauris sit amet sem mauris.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
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

              const Text('About You',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

                    BlocConsumer<TransactionsBloc, TransactionsState>(
                      listener: (context, state) {
                        if (state.loanApproved != null) {
                          _showLoanDialog(context, state.loanApproved!);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            if (state.isLoading) // loading spinner
                              const CircularProgressIndicator()
                            else
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      _acceptedTerms) {
                                    // Apply for loan
                                    _applyForLoan(context);
                                  } else if (!_acceptedTerms) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please accept the Terms & Conditions')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC0028B),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
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

  void _applyForLoan(BuildContext context) {
    context.read<TransactionsBloc>().add(
          ApplyForLoan(
            loanAmount: double.parse(_loanAmountController.text),
            term: int.parse(_termController.text),
            monthlySalary: double.parse(_monthlySalaryController.text),
            monthlyExpenses: double.parse(_monthlyExpensesController.text),
          ),
        );
  }

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
                Navigator.pop(context); //
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
