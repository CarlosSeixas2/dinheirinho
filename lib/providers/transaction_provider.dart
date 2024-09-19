import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum TransactionType { receitas, despesas }

class TransactionState {
  // tipo atual da transação(receita ou despesa)
  final TransactionType transactionType;
  // mês atual
  final String selectedMonth;
  // lista de transações
  final List<Map<String, dynamic>> transactions;

  TransactionState({
    required this.transactionType,
    required this.selectedMonth,
    required this.transactions,
  });

  // Calculo do saldo atual
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

  // Retorna uma cópia do estado com possíveis mudanças em seus valores.
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

  // Converte o estado atual para um mapa (para salvar no SharedPreferences).
  Map<String, dynamic> toMap() {
    return {
      'transactionType':
          transactionType == TransactionType.receitas ? 'receitas' : 'despesas',
      'selectedMonth': selectedMonth,
      'transactions': transactions,
    };
  }

  // Cria uma instância de `TransactionState` a partir de um mapa.
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

class TransactionNotifier extends StateNotifier<TransactionState> {
  // Construtor que inicializa o estado e carrega dados salvos das preferências.
  TransactionNotifier()
      : super(TransactionState(
          transactionType: TransactionType.despesas,
          selectedMonth: 'Setembro',
          transactions: [],
        )) {
    _loadFromPrefs();
  }

  // Função para salvar o estado atual no SharedPreferences.
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transaction_state', jsonEncode(state.toMap()));
  }

  // Função para carregar o estado salvo do SharedPreferences.
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = prefs.getString('transaction_state');
    if (stateJson != null) {
      final stateMap = jsonDecode(stateJson);
      state = TransactionState.fromMap(stateMap);
    }
  }

  // Define o tipo de transação (receitas ou despesas) e salva a mudança.
  void setTransactionType(TransactionType type) {
    state = state.copyWith(transactionType: type);
    _saveToPrefs();
  }

  // Define o mês selecionado e salva a mudança.
  void setSelectedMonth(String month) {
    state = state.copyWith(selectedMonth: month);
    _saveToPrefs();
  }

  // Adiciona uma nova transação e salva o estado.
  void addTransaction(Map<String, dynamic> transaction) {
    final updatedTransactions =
        List<Map<String, dynamic>>.from(state.transactions)..add(transaction);
    state = state.copyWith(transactions: updatedTransactions);

    _saveToPrefs();
  }

  // Formata um valor monetário para o formato brasileiro (R$).
  String formatToReal(double value) {
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return currencyFormat.format(value);
  }

  // Limpa todas as transações (reset) e salva o estado atualizado.
  void clearTransactions() {
    state = state.copyWith(transactions: []);
  }

  // Remove uma transação específica da lista e salva o estado.
  void removeTransaction(Map<String, dynamic> transaction) {
    final updatedTransactions =
        List<Map<String, dynamic>>.from(state.transactions)
          ..remove(transaction);
    state = state.copyWith(transactions: updatedTransactions);
    _saveToPrefs();
  }

  // Atualiza uma transação específica na lista e salva o estado.
  void updateTransaction(Map<String, dynamic> oldTransaction,
      Map<String, dynamic> updatedTransaction) {
    final updatedTransactions =
        List<Map<String, dynamic>>.from(state.transactions);
    final transactionIndex = updatedTransactions.indexOf(oldTransaction);

    if (transactionIndex != -1) {
      updatedTransactions[transactionIndex] =
          updatedTransaction; // Atualizar o item na posição correta
    }

    state = state.copyWith(transactions: updatedTransactions);
    _saveToPrefs();
  }
}

// Define o provider que gerencia o estado das transações usando `TransactionNotifier`.
final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>(
  (ref) => TransactionNotifier(),
);
