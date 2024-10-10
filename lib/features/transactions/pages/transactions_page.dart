import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../common/blocs/transactions_bloc.dart';
import '../../../common/blocs/transactions_state.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0028B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'MoneyApp',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: const Color(0xFFC0028B),
            child: Column(
              children: [
                BlocBuilder<TransactionsBloc, TransactionsState>(
                  builder: (context, state) {
                    return Text(
                      '£${state.balance.toStringAsFixed(2)}', 
                      style: const TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton('Pay', 'assets/icons/phone_icon.svg',
                          context, '/pay'), 
                      _buildActionButton('Top up',
                          'assets/icons/wallet_icon.svg', context, '/pay',
                          isTopUp: true),  
                      _buildActionButton('Loan', 'assets/icons/loan_icon.svg',
                          context, '/loan'),  
                    ],
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE4E6EB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: BlocBuilder<TransactionsBloc, TransactionsState>(
                builder: (context, state) {
                      return ListView.builder(
                        itemCount: state.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = state.transactions[index];
                          final isTopUp = transaction.isTopUp;
                          
                          final svgAssetPath = isTopUp ? 'assets/icons/topup_icon.svg' : 'assets/icons/payment_icon.svg';

                          final amountColor = isTopUp ? const Color(0xFFC0028B) : Colors.black;
                          final amountPrefix = isTopUp ? "+" : " ";

                          return ListTile(
                            leading: SvgPicture.asset(
                              svgAssetPath,
                              height: 40,  
                              width: 40,   
                              color: amountColor, 
                            ),
                            title: Text(transaction.name),
                            trailing: Text(
                              "$amountPrefix${transaction.amount.toStringAsFixed(2)}",
                              style: TextStyle(color: amountColor),
                            ),
                          );
                        },
                      );

                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, String svgAssetPath, BuildContext context, String route, {bool isTopUp = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black, 
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
         context.go(route, extra: isTopUp);
      },
      child: Column(
        children: [
           Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8), 
            child: SvgPicture.asset(
              svgAssetPath,
              height: 40,
              width: 40,
              color: Colors.black, 
            ),
          ),
          const SizedBox(height: 5), 
          Text(
            title,
            style: const TextStyle(color: Color(0xFFC0028B)), 
          ),
        ],
      ),
    );
  }
}
