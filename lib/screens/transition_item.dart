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
  final VoidCallback onTap;

  const TransactionItem(
      {super.key,
      required this.description,
      required this.value,
      required this.isPositive,
      required this.onTap,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
            Expanded(
              child: Column(
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
            ),
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
