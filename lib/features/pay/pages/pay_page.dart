import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class PayPage extends StatefulWidget {
  final bool isTopUp;

  const PayPage({super.key, required this.isTopUp});

  @override
  PayPageState createState() => PayPageState();
}

class PayPageState extends State<PayPage> {
  final Logger _logger = Logger('PayPage');
  String amount = '0';

  @override
  void initState() {
    super.initState();
    _logger.info('PayPage initialized with isTopUp=${widget.isTopUp}');
  }

  void _onKeyPressed(String key) {
    setState(() {
      if (key == 'C') {
        amount = '0';
      } else {
        if (amount == '0') {
          amount = key;
        } else {
          amount += key;
        }
      }
      _logger.info('Amount updated: $amount');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0028B),
        title: const Text(
          'MoneyApp',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFC0028B),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'How much?',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  '£$amount.00',
                  style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                _buildNumberPad(),
                ElevatedButton(
                  onPressed: () {
                    _logger.info(
                        'Proceeding with payment: amount=$amount, isTopUp=${widget.isTopUp}');
                    context.go('/pay_who',
                        extra: {'amount': amount, 'isTopUp': widget.isTopUp});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 100),
                  ),
                  child: Text(widget.isTopUp ? 'Top Up Next' : 'Next',
                      style: const TextStyle(
                          color: Color(0xFFC0028B), fontSize: 18)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: [
        ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 'C', 0].map((key) {
          return TextButton(
            onPressed: () => _onKeyPressed(key.toString()),
            child: Text(key.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 24)),
          );
        }),
      ],
    );
  }
}
