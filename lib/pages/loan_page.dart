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
            Navigator.pop(context); 
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTermsAndConditionsHeader(),
              _buildTermsAndConditionsCheckbox(),
              const SizedBox(height: 20),
              _buildLoanFormSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndConditionsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Terms and Conditions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTermsAndConditionsCheckbox() {
    return Row(
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
    );
  }

  Widget _buildLoanFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _monthlySalaryController,
            labelText: 'Monthly Salary',
            validatorMessage: 'Please enter your monthly salary',
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _monthlyExpensesController,
            labelText: 'Monthly Expenses',
            validatorMessage: 'Please enter your monthly expenses',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _loanAmountController,
            labelText: 'Loan Amount',
            validatorMessage: 'Please enter the loan amount',
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _termController,
            labelText: 'Term',
            validatorMessage: 'Please enter the loan term',
          ),
          const SizedBox(height: 20),
          _buildLoanButton(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String validatorMessage,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }

  Widget _buildLoanButton() {
    return BlocConsumer<TransactionsBloc, TransactionsState>(
      listener: (context, state) {
        if (state.loanApproved != null) {
          _showLoanDialog(context, state.loanApproved!);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            if (state.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _acceptedTerms) {
                    _applyForLoan(context);
                  } else if (!_acceptedTerms) {
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
                Navigator.pop(context);  
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
