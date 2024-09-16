import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum TransactionType { receitas, despesas }

// Classe que define o estado das transações
class TransactionState {
  final TransactionType transactionType;
  final String selectedMonth;
  final List<Map<String, dynamic>> transactions;

  TransactionState({
    required this.transactionType,
    required this.selectedMonth,
    required this.transactions,
  });

  double get balance {
    double balance = 0.0;
    for (var transaction in transactions) {
      if (transaction['type'] == 'receita') {
        balance += transaction['value'];
      } else {
        balance -= transaction['value'];
      }
    }
    return balance;
  }

  // Método para atualizar o tipo de transação
  TransactionState copyWith({
    TransactionType? transactionType,
    String? selectedMonth,
    List<Map<String, dynamic>>? transactions,
  }) {
    return TransactionState(
      transactionType: transactionType ?? this.transactionType,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      transactions: transactions ?? this.transactions,
    );
  }
}

// StateNotifier gerencia o estado das transações
class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier()
      : super(TransactionState(
    transactionType: TransactionType.despesas,
    selectedMonth: 'Setembro',
    transactions: [],
  ));

  void setTransactionType(TransactionType type) {
    state = state.copyWith(transactionType: type);
  }

  void setSelectedMonth(String month) {
    state = state.copyWith(selectedMonth: month);
  }

  void addTransaction(Map<String, dynamic> transaction) {
    final updatedTransactions = List<Map<String, dynamic>>.from(state.transactions)
      ..add(transaction);
    state = state.copyWith(transactions: updatedTransactions);
  }

  double get balance {
    double balance = 0.0;
    for (var transaction in state.transactions) {
      if (transaction['type'] == 'receita') {
        balance += transaction['value'];
      } else {
        balance -= transaction['value'];
      }
    }
    return balance;
  }

  String formatToReal(double value) {
    final NumberFormat currencyFormat =
    NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return currencyFormat.format(value);
  }
}

// Definindo o provider com StateNotifier
final transactionProvider = StateNotifierProvider<TransactionNotifier, TransactionState>(
      (ref) => TransactionNotifier(),
);
