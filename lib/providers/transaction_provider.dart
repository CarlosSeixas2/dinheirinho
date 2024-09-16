import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TransactionType { receitas, despesas }

class TransactionProvider extends ChangeNotifier {
  TransactionType _transactionType = TransactionType.despesas;
  String _selectedMonth = 'Setembro';
  List<Map<String, dynamic>> _transactions = [];

  TransactionType get transactionType => _transactionType;
  String get selectedMonth => _selectedMonth;
  List<Map<String, dynamic>> get transactions => _transactions;

  void setTransactionType(TransactionType type) {
    _transactionType = type;
    notifyListeners();
  }

  void setSelectedMonth(String month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void addTransaction(Map<String, dynamic> transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  double get balance {
    double balance = 0.0;
    for (var transaction in _transactions) {
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
