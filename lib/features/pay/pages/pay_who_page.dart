import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../common/cubit/transactions_cubit.dart';

class PayWhoPage extends HookWidget {
  final String amount;
  final bool isTopUp;

  const PayWhoPage({
    super.key,
    required this.amount,
    required this.isTopUp,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0028B),
        title: Text(
          'app_name'.tr(),
          style: const TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFC0028B),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'to_whom'.tr(),
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'enter_name'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<TransactionsCubit>(context).addTransaction(
                    controller.text,
                    double.parse(amount),
                    isTopUp,
                  );

                  context.push('/transaction_details',
                      extra: {'amount': amount, 'name': controller.text});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                ),
                child: Text(
                  'pay'.tr(),
                  style:
                      const TextStyle(color: Color(0xFFC0028B), fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
