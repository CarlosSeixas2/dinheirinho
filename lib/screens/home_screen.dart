import 'package:controle_financeiro/widgets/custom_bottom_bar.dart';
import 'package:controle_financeiro/widgets/transaction_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transitionItem.dart';
import 'add_transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TransactionType { receitas, despesas }

String formatToReal(double value) {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  return currencyFormat.format(value);
}

final transactionTypeProvider =
    StateProvider<TransactionType>((ref) => TransactionType.despesas);

// Armazena as transações localmente
final transactionsProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);

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
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              formatToReal(balance),
              style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Seu Saldo',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7A7A7A)),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              // Ação ao clicar
            },
            child: SvgPicture.asset(
              'lib/assets/icons/bell.svg',
              width: 20,
              height: 20,
              colorFilter:
                  const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TransactionToggle(
                    transactionType: transactionType,
                    onToggle: (type) {
                      ref.read(transactionTypeProvider.notifier).state = type;
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      child: Center(
                        child: DropdownButton<String>(
                          style: const TextStyle(
                              color: Colors.white,
                              backgroundColor: Color(0xFF121212)),
                          value: selectedMonth,
                          icon: const Icon(Icons.arrow_drop_down),
                          underline: const SizedBox(),
                          onChanged: (String? newValue) {
                            ref.read(selectedMonthProvider.notifier).state =
                                newValue!;
                          },
                          items: <String>[
                            'Janeiro',
                            'Fevereiro',
                            'Março',
                            'Abril',
                            'Maio',
                            'Junho',
                            'Julho',
                            'Agosto',
                            'Setembro',
                            'Outubro',
                            'Novembro',
                            'Dezembro'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
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
                      // TODO: Filtrar transações por mês
                      // final transactionDate = transaction['date'] as DateTime;
                      // final transactionMonth =
                      //     DateFormat('MMMM').format(transactionDate);
                      return transaction['type'] ==
                          (transactionType == TransactionType.despesas
                              ? 'despesa'
                              : 'receita');
                    })
                    .map((transaction) => TransactionItem(
                          icon: transaction['icon'],
                          title: transaction['title'],
                          subtitle: transaction['subtitle'],
                          value:
                              'R\$ ${transaction['value'].toStringAsFixed(2)}',
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
        backgroundColor: const Color(0xFF24F07D),
        child: const Icon(Icons.add, color: Colors.black),

        
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
