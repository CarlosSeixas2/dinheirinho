import 'package:controle_financeiro/screens/transitionItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_transaction.dart';

enum TransactionType { receitas, despesas }

final transactionTypeProvider = StateProvider<TransactionType>((ref) => TransactionType.despesas);

// Armazena as transações localmente
final transactionsProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType = ref.watch(transactionTypeProvider);
    final transactions = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Seu Saldo'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'R\$ 500,00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(transactionTypeProvider.notifier).state = TransactionType.despesas;
                      },
                      child: Text('Despesas'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: transactionType == TransactionType.despesas ? Colors.green : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(transactionTypeProvider.notifier).state = TransactionType.receitas;
                      },
                      child: Text('Receitas'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: transactionType == TransactionType.receitas ? Colors.green : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text(
                'Transações',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Exibe apenas as transações do tipo selecionado
              Column(
                children: transactions
                    .where((transaction) =>
                transaction['type'] == (transactionType == TransactionType.despesas ? 'despesa' : 'receita'))
                    .map((transaction) => TransactionItem(
                  icon: transaction['icon'],
                  title: transaction['title'],
                  subtitle: transaction['subtitle'],
                  value: 'R\$ ${transaction['value']}',
                  isPositive: transaction['type'] == 'receita',
                ))
                    .toList(),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abre o formulário para adicionar nova transação
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTransactionDialog();
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Carteira',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Gráfico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert),
            label: 'Mais',
          ),
        ],
      ),
    );
  }
}
