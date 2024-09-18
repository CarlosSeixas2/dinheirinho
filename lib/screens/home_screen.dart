import 'package:controle_financeiro/helpers/local_persistence.dart';
import 'package:controle_financeiro/providers/transaction_provider.dart';
import 'package:controle_financeiro/screens/add_transaction.dart';
import 'package:controle_financeiro/screens/transitionItem.dart';
import 'package:controle_financeiro/widgets/custom_bottom_bar.dart';
import 'package:controle_financeiro/widgets/transaction_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'transaction_details_page.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionNotifier = ref.watch(transactionProvider.notifier);
    final transactions = ref.watch(transactionProvider).transactions;
    final balance = ref.watch(transactionProvider).balance;
    final transactionType = ref.watch(transactionProvider).transactionType;
    final selectedMonth = ref.watch(transactionProvider).selectedMonth;

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
              transactionNotifier.formatToReal(balance),
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Seu Saldo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7A7A7A),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              print('abrir as notificações');
            },
            child: SvgPicture.asset(
              'assets/icons/bell.svg',
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
                      ref
                          .read(transactionProvider.notifier)
                          .setTransactionType(type);
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
                            backgroundColor: Color(0xFF121212),
                          ),
                          value: selectedMonth,
                          icon: const Icon(Icons.arrow_drop_down),
                          underline: const SizedBox(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              ref
                                  .read(transactionProvider.notifier)
                                  .setSelectedMonth(newValue);
                            }
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
              Column(
                children: transactions.where((transaction) {
                  return transaction['type'] ==
                      (transactionType == TransactionType.despesas
                          ? 'despesa'
                          : 'receita');
                }).map((transaction) {
                  final description =
                      transaction['description'] ?? 'Sem descrição';
                  final value = transaction['value'] != null
                      ? 'R\$ ${transaction['value'].toStringAsFixed(2)}'
                      : 'Sem valor';
                  final isPositive = transaction['type'] == 'receita';
                  final category = transaction['category'] ?? 'Sem categoria';

                  return TransactionItem(
                    description: description,
                    value: value,
                    isPositive: isPositive,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionDetailsPage(
                            transaction: transaction,
                          ),
                        ),
                      );
                    },
                    category: category
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  LocalPersistence.clearList('transactions').then((_) {
                    ref.read(transactionProvider.notifier).clearTransactions();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF24F07D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Limpar Transações',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddTransactionDialog();
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
