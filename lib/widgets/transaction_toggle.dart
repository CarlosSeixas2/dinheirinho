import 'package:controle_financeiro/screens/home_screen.dart';
import 'package:flutter/material.dart';

class TransactionToggle extends StatelessWidget {
  final TransactionType transactionType;
  final Function(TransactionType) onToggle;

  const TransactionToggle({
    super.key,
    required this.transactionType,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(100),
      ),
      width: 240,
      height: 60,
      padding: const EdgeInsets.all(4),
      // Substituído por TransactionToggle
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                onToggle(TransactionType.despesas);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: transactionType == TransactionType.despesas
                    ? const Color(0xFF24F07D)
                    : const Color(0xFF121212),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                // Tirar a sombra do botão
                elevation: 0,
              ),
              child: Text(
                'Despesas',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: transactionType == TransactionType.despesas
                        ? Colors.black
                        : const Color(0xFF7A7A7A)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                onToggle(TransactionType.receitas);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: transactionType == TransactionType.receitas
                    ? const Color(0xFF24F07D)
                    : const Color(0xFF121212),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Text(
                'Receitas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: transactionType == TransactionType.receitas
                      ? Colors.black
                      : const Color(0xFF7A7A7A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
