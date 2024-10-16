import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class PayPage extends HookWidget {
  final bool isTopUp;

  const PayPage({super.key, required this.isTopUp});

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger('PayPage');
    final amount = useState('0');

    useEffect(() {
      logger.info('PayPage initialized with isTopUp=$isTopUp');
      return null;
    }, []);

    void onKeyPressed(String key) {
      if (key == 'C') {
        amount.value = '0';
      } else {
        if (amount.value == '0') {
          amount.value = key;
        } else {
          amount.value += key;
        }
      }
      logger.info('Amount updated: ${amount.value}');
    }

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
                  '£${amount.value}.00',
                  style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                buildNumberPad(onKeyPressed),
                ElevatedButton(
                  onPressed: () {
                    logger.info(
                        'Proceeding with payment: amount=${amount.value}, isTopUp=$isTopUp');
                    context.go('/pay_who',
                        extra: {'amount': amount.value, 'isTopUp': isTopUp});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 100),
                  ),
                  child: Text(isTopUp ? 'Top Up Next' : 'Next',
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

  Widget buildNumberPad(void Function(String) onKeyPressed) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: [
        ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 'C', 0].map((key) {
          return TextButton(
            onPressed: () => onKeyPressed(key.toString()),
            child: Text(key.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 24)),
          );
        }),
      ],
    );
  }
}
