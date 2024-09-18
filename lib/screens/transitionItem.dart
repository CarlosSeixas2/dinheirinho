import 'package:controle_financeiro/screens/view_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

String formatToReal(double value) {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  return currencyFormat.format(value);
}

class TransactionItem extends StatelessWidget {
  final String description;
  final String category;
  final String value;
  final bool isPositive;

  const TransactionItem({
    super.key,
    required this.description,
    required this.category,
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
              backgroundColor: isPositive
                  ? const Color(0xFF24F07D)
                  : const Color(0xFFFE4219),
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
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              // value,
              formatToReal(double.parse(value)),
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              isPositive
                  ? 'assets/icons/arrow_up.svg'
                  : 'assets/icons/arrow_down.svg',
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}
