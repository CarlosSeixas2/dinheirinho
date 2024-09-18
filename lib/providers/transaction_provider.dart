import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  // Converte o estado para um Map, útil para salvar no SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'transactionType':
          transactionType == TransactionType.receitas ? 'receitas' : 'despesas',
      'selectedMonth': selectedMonth,
      'transactions': transactions,
    };
  }

  // Cria um estado a partir de um Map, útil para carregar do SharedPreferences
  factory TransactionState.fromMap(Map<String, dynamic> map) {
    return TransactionState(
      transactionType: map['transactionType'] == 'receitas'
          ? TransactionType.receitas
          : TransactionType.despesas,
      selectedMonth: map['selectedMonth'] ?? 'Setembro',
      transactions: List<Map<String, dynamic>>.from(map['transactions'] ?? []),
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
        )) {
    _loadFromPrefs(); // Carregar estado salvo ao inicializar
  }

  // Salva o estado atual no SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transaction_state', jsonEncode(state.toMap()));
  }

  // Carrega o estado do SharedPreferences
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = prefs.getString('transaction_state');
    if (stateJson != null) {
      final stateMap = jsonDecode(stateJson);
      state = TransactionState.fromMap(stateMap);
    }
  }

  void setTransactionType(TransactionType type) {
    state = state.copyWith(transactionType: type);
    _saveToPrefs(); // Salvar após a alteração
  }

  void setSelectedMonth(String month) {
    state = state.copyWith(selectedMonth: month);
    _saveToPrefs(); // Salvar após a alteração
  }

  void addTransaction(Map<String, dynamic> transaction) {
    final updatedTransactions =
        List<Map<String, dynamic>>.from(state.transactions)..add(transaction);
    state = state.copyWith(transactions: updatedTransactions);
    _saveToPrefs(); // Salvar após a alteração
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

  void clearTransactions() {
    state = state.copyWith(transactions: []);
  }

  void removeTransaction(Map<String, dynamic> transaction) {
    final updatedTransactions = List<Map<String, dynamic>>.from(state.transactions)
      ..remove(transaction);
    state = state.copyWith(transactions: updatedTransactions);
    _saveToPrefs();
  }

  void updateTransaction(Map<String, dynamic> oldTransaction, Map<String, dynamic> updatedTransaction) {
    final updatedTransactions = List<Map<String, dynamic>>.from(state.transactions);
    final transactionIndex = updatedTransactions.indexOf(oldTransaction);

    if (transactionIndex != -1) {
      updatedTransactions[transactionIndex] = updatedTransaction; // Atualizar o item na posição correta
    }

    state = state.copyWith(transactions: updatedTransactions);
    _saveToPrefs();
  }
}

// Definindo o provider com StateNotifier
final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>(
  (ref) => TransactionNotifier(),
);
