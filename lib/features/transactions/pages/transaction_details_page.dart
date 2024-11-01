import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../common/cubit/transactions_cubit.dart';

class TransactionDetailsPage extends StatelessWidget {
  const TransactionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? transactionData =
        GoRouterState.of(context).extra as Map<String, dynamic>?;

    if (transactionData == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFC0028B),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'transaction_details'.tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Text(
            'error_no_data'.tr(),
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    final String amount = transactionData['amount'] ?? '0';
    final String name = transactionData['name'] ?? 'unknown'.tr();
    final String type = transactionData['type'] ?? 'PAYMENT';

    void splitTheBill() {
      final double originalAmount = double.parse(amount);
      final double halfAmount = originalAmount / 2;

      BlocProvider.of<TransactionsCubit>(context).addTransaction(
        name,
        halfAmount,
        true,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('bill_split_message'.tr(args: [halfAmount.toString()]))),
      );

      context.push('/');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0028B),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'transaction_details'.tr(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.push('/');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_bag,
                    size: 50, color: Color(0xFFC0028B)),
                const SizedBox(width: 10),
                Text(name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            Text('£$amount.00',
                style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC0028B))),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: Text('add_receipt'.tr()),
              onTap: () {},
            ),
            if (type == 'PAYMENT')
              ListTile(
                leading: const Icon(Icons.call_split),
                title: Text('split_bill'.tr()),
                onTap: splitTheBill,
              ),
            if (type == 'PAYMENT')
              ListTile(
                leading: const Icon(Icons.repeat),
                title: Text('repeating_payment'.tr()),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    if (value) {
                      BlocProvider.of<TransactionsCubit>(context)
                          .addTransaction(
                        name,
                        double.parse(amount),
                        false,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('repeating_payment_message'
                                .tr(args: [amount]))),
                      );
                    }
                  },
                ),
              ),
            ListTile(
              leading: const Icon(Icons.error),
              title: Text('something_wrong'.tr()),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('help'.tr()),
                      content: Text('help_message'.tr()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('ok'.tr()),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
