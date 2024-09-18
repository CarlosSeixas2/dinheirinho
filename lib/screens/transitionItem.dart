import 'package:controle_financeiro/screens/view_transaction.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  // final IconData icon;
  final String description;
  final String value;
  final bool isPositive;

  const TransactionItem({
    super.key,
    // required this.icon,
    required this.description,
    required this.value,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar para a página de visualização da transação
        Navigator.of(context).push(
          MaterialPageRoute(
            // builder: (context) => const ViewTransaction(),
            // Mandar qual transação foi clicada
            builder: (context) => ViewTransaction(
              description: description,
              value: value,
              isPositive: isPositive,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isPositive ? Colors.green : Colors.red,
              child: Icon(
                isPositive ? Icons.attach_money : Icons.money_off,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
