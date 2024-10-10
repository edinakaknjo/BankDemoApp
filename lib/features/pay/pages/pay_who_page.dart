import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp/common/blocs/transactions_event.dart';
import '../../../common/blocs/transactions_bloc.dart';

class PayWhoPage extends StatefulWidget {
  const PayWhoPage({super.key});

  @override
  PayWhoPageState createState() => PayWhoPageState();
}

class PayWhoPageState extends State<PayWhoPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String amount = args['amount'] as String; 
    final bool isTopUp = args['isTopUp'] as bool; 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0028B),
        title: const Text('MoneyApp', style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFC0028B),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'To whom?',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<TransactionsBloc>(context).add(AddTransaction(
                    name: _controller.text,
                    amount: double.parse(amount),
                    isTopUp: isTopUp,
                  ));

                  Navigator.pushNamed(context, '/transaction_details',
                      arguments: {'amount': amount, 'name': _controller.text});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                ),
                child: const Text('Pay',
                    style: TextStyle(color: Color(0xFFC0028B), fontSize: 18)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}