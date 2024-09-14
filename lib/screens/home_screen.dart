import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transitionItem.dart';
import 'add_transaction.dart';
import 'package:intl/intl.dart'; // Para formatar a data

enum TransactionType { receitas, despesas }

final transactionTypeProvider = StateProvider<TransactionType>((ref) => TransactionType.despesas);

// Armazena as transações localmente
final transactionsProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

// Seleciona o mês
final selectedMonthProvider = StateProvider<String>((ref) => 'Setembro');

// Calcula o saldo com base nas transações
final balanceProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider);
  double balance = 0.0;

  for (var transaction in transactions) {
    if (transaction['type'] == 'receita') {
      balance += transaction['value'];
    } else {
      balance -= transaction['value'];
    }
  }

  return balance;
});

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType = ref.watch(transactionTypeProvider);
    final transactions = ref.watch(transactionsProvider);
    final balance = ref.watch(balanceProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Saldo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
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
                'R\$ ${balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(transactionTypeProvider.notifier).state = TransactionType.despesas;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: transactionType == TransactionType.despesas ? Colors.green : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Despesas'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(transactionTypeProvider.notifier).state = TransactionType.receitas;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: transactionType == TransactionType.receitas ? Colors.green : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Receitas'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedMonth,
                      icon: const Icon(Icons.arrow_drop_down),
                      underline: const SizedBox(),
                      onChanged: (String? newValue) {
                        ref.read(selectedMonthProvider.notifier).state = newValue!;
                      },
                      items: <String>[
                        'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto',
                        'Setembro', 'Outubro', 'Novembro', 'Dezembro'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Transações',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Exibe apenas as transações do tipo selecionado e do mês selecionado
              Column(
                children: transactions
                    .where((transaction) {
                  final transactionDate = transaction['date'] as DateTime;
                  final transactionMonth = DateFormat('MMMM').format(transactionDate);
                  return transaction['type'] == (transactionType == TransactionType.despesas ? 'despesa' : 'receita') &&
                      transactionMonth == selectedMonth;
                })
                    .map((transaction) => TransactionItem(
                  icon: transaction['icon'],
                  title: transaction['title'],
                  subtitle: transaction['subtitle'],
                  value: 'R\$ ${transaction['value'].toStringAsFixed(2)}',
                  isPositive: transaction['type'] == 'receita',
                ))
                    .toList(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTransactionDialog();
            },
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Carteira',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Relatórios',
          ),
        ],
      ),
    );
  }
}
