import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/cubit/transactions_cubit.dart';
import '../../../common/cubit/transactions_state.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

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
        title: Text('loan_application'.tr(),
            style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: SingleChildScrollView(
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
    );
  }

  Widget _buildTermsAndConditionsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'terms_and_conditions'.tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'terms_and_conditions_text'.tr(),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
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
        Expanded(
          child: Text(
            'accept_terms_conditions'.tr(),
            style: const TextStyle(fontSize: 16),
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
            labelText: 'monthly_salary'.tr(),
            validatorMessage: 'enter_monthly_salary'.tr(),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _monthlyExpensesController,
            labelText: 'monthly_expenses'.tr(),
            validatorMessage: 'enter_monthly_expenses'.tr(),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _loanAmountController,
            labelText: 'loan_amount'.tr(),
            validatorMessage: 'enter_loan_amount'.tr(),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _termController,
            labelText: 'term'.tr(),
            validatorMessage: 'enter_term'.tr(),
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
    return BlocConsumer<TransactionsCubit, TransactionsState>(
      listener: (context, state) {
        if (state.loanApproved != null) {
          _showLoanDialog(context, state.loanApproved!);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('loan_error'.tr()),
            ),
          );
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
                      SnackBar(
                        content: Text('accept_terms_conditions_warning'.tr()),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC0028B),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child: Text('apply_for_loan'.tr()),
              ),
          ],
        );
      },
    );
  }

  void _applyForLoan(BuildContext context) {
    context.read<TransactionsCubit>().applyForLoan(
          double.parse(_loanAmountController.text),
          int.parse(_termController.text),
          double.parse(_monthlySalaryController.text),
          double.parse(_monthlyExpensesController.text),
        );
  }

  void _showLoanDialog(BuildContext context, bool approved) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(approved ? 'congrats_title'.tr() : 'oops_title'.tr()),
          content: Text(
            approved
                ? 'loan_approved_message'.tr()
                : 'loan_declined_message'.tr(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('ok'.tr()),
            ),
          ],
        );
      },
    );
  }
}
