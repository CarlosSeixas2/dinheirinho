import 'package:controle_financeiro/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

String formatToReal(double value) {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  return currencyFormat.format(value);
}

class TransactionGraphicWidget extends StatelessWidget {
  final TransactionType transactionType;
  final List<Map<String, dynamic>> transactions;
  final dynamic transactionNotifier;

  const TransactionGraphicWidget({
    super.key,
    required this.transactionType,
    required this.transactions,
    required this.transactionNotifier,
  });

  List<PieData> getPieData(List<Map<String, dynamic>> transactions) {
    final Map<String, double> categoryTotals = {};

    // for (final transaction in transactions) {
    // Pegar apenas as transações do tipo selecionado
    for (final transaction in transactions.where((transaction) {
      return transaction['type'] ==
          (transactionType == TransactionType.despesas ? 'despesa' : 'receita');
    })) {
      final category = transaction['category'] ?? 'Sem categoria';
      final value = transaction['value']?.toDouble() ?? 0;

      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + value;
      } else {
        categoryTotals[category] = value;
      }
    }

    final double total =
        categoryTotals.values.fold(0, (sum, value) => sum + value);

    final List<PieData> pieData = categoryTotals.entries.map((entry) {
      final category = entry.key;
      final value = entry.value;
      final percentage = (value / total) * 100;
      final label = '${percentage.toStringAsFixed(2)}%';

      return PieData(category, value, label);
    }).toList();

    return pieData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transactionType == TransactionType.receitas
                          ? 'Receitas'
                          : 'Despesas',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '15 Set 2024 - 21 Set 2024',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7A7A7A),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      formatToReal(transactions.where((transaction) {
                        return transaction['type'] ==
                            (transactionType == TransactionType.despesas
                                ? 'despesa'
                                : 'receita');
                      }).fold(0, (sum, transaction) {
                        return sum + transaction['value'];
                      })),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: transactionType == TransactionType.receitas
                            ? const Color(0xFF24F07D)
                            : const Color(0xFFFE4219),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      transactionType == TransactionType.receitas
                          ? 'assets/icons/arrow_up.svg'
                          : 'assets/icons/arrow_down.svg',
                      height: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SfCircularChart(
            margin: const EdgeInsets.all(0),
            palette: const [
              Color(0xFF24F07D),
              Color(0xFFFE4219),
              Color(0xFFFF8161),
              Color(0xFF1A1A1A),
              Color(0xFF1FD06F),
              Color(0xFFE13B17),
              Color(0xFFFF613C),
              Color(0xFF19B060),
              Color(0xFF121212),
              Color(0xFF38F396),
              Color(0xFFC13313),
              Color(0xFF57F6B5),
            ],
            legend: const Legend(
              isVisible: true,
              alignment: ChartAlignment.center,
              position: LegendPosition.right,
            ),
            series: <DoughnutSeries<PieData, String>>[
              DoughnutSeries<PieData, String>(
                explode: false,
                enableTooltip: true,
                explodeIndex: 0,
                dataSource: getPieData(transactions),
                xValueMapper: (PieData data, _) => data.category,
                yValueMapper: (PieData data, _) => data.value,
                dataLabelMapper: (PieData data, _) => data.label,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Color(0xFF121212),
                  labelPosition: ChartDataLabelPosition.outside,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PieData {
  PieData(this.category, this.value, this.label);

  final String category;
  final double value;
  final String label;
}
