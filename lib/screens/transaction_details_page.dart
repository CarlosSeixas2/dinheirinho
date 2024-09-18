import 'package:controle_financeiro/screens/editTransactionPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:controle_financeiro/providers/transaction_provider.dart';

class TransactionDetailsPage extends ConsumerWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = transaction['description'] ?? 'Sem descrição';
    final value = transaction['value'] != null
        ? 'R\$ ${transaction['value'].toStringAsFixed(2)}'
        : 'Sem valor';
    final isPositive = transaction['type'] == 'receita';
    final category = transaction['categoria'] ?? 'Sem categoria';

    void deleteTransaction() {
      ref.read(transactionProvider.notifier).removeTransaction(transaction);
      Navigator.popUntil(context, (route) => route.isFirst);
    }

    void editTransaction() async {
      final updatedTransaction = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (context) => EditTransactionPage(transaction: transaction),
        ),
      );

      if (updatedTransaction != null) {
        ref.read(transactionProvider.notifier).updateTransaction(transaction, updatedTransaction);

        // Atualize a própria transação na tela de detalhes
        Navigator.pop(context); // Fecha a tela atual
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailsPage(
              transaction: updatedTransaction, // Reabre a tela com os dados atualizados
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Transação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: editTransaction,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Excluir Transação'),
                    content: const Text('Você tem certeza de que deseja excluir esta transação?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Excluir'),
                        onPressed: () {
                          deleteTransaction();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tipo: ${isPositive ? 'Receita' : 'Despesa'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Categoria: $category',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
