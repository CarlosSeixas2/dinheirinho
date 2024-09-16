import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/custom_bottom_bar.dart';
import '../widgets/transaction_toggle.dart';
import 'transitionItem.dart';
import 'add_transaction.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;
    final balance = transactionProvider.balance;
    final transactionType = transactionProvider.transactionType;
    final selectedMonth = transactionProvider.selectedMonth;

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
              transactionProvider.formatToReal(balance),
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
                      transactionProvider.setTransactionType(type);
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
                            if (newValue != null && newValue is TransactionType) {
                              transactionProvider.setSelectedMonth(newValue);
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
                children: transactions
                    .where((transaction) {
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
