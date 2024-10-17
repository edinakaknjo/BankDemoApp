import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
          title: const Text(
            'Transaction Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: Text(
            'Error: No transaction data available.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    final String amount = transactionData['amount'] ?? '0';
    final String name = transactionData['name'] ?? 'Unknown';
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
            content: Text(
                'Bill split. £$halfAmount returned and £$halfAmount paid.')),
      );

      context.push('/');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0028B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Transaction Details',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
              title: const Text('Add receipt'),
              onTap: () {},
            ),
            if (type == 'PAYMENT')
              ListTile(
                leading: const Icon(Icons.call_split),
                title: const Text('Split this bill'),
                onTap: splitTheBill,
              ),
            if (type == 'PAYMENT')
              ListTile(
                leading: const Icon(Icons.repeat),
                title: const Text('Repeating payment'),
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
                            content:
                                Text('Repeating payment created for £$amount')),
                      );
                    }
                  },
                ),
              ),
            ListTile(
              leading: const Icon(Icons.error),
              title: const Text('Something wrong?'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Help'),
                      content: const Text('Help is on the way, stay put!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
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
