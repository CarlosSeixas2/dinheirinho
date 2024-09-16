import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _subtitle = '';
  double _value = 0;
  bool _isReceita = true;
  String _category = 'Casa';

  final List<String> _categories = [
    'Casa',
    'Alimentação',
    'Transporte',
    'Lazer',
    'Saúde',
    'Educação',
    'Outros',
  ];

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return AlertDialog(
      title: const Text('Nova Transação'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Título'),
              onSaved: (value) {
                _title = value ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor insira um título';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Descrição'),
              onSaved: (value) {
                _subtitle = value ?? '';
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onSaved: (value) {
                _value = double.tryParse(value ?? '0') ?? 0;
              },
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Por favor insira um valor válido';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _category = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor selecione uma categoria';
                }
                return null;
              },
            ),
            SwitchListTile(
              title: Text(_isReceita ? 'Receita' : 'Despesa'),
              value: _isReceita,
              onChanged: (value) {
                setState(() {
                  _isReceita = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              transactionProvider.addTransaction({
                'title': _title,
                'subtitle': _subtitle,
                'value': _value,
                'category': _category,
                'type': _isReceita ? 'receita' : 'despesa',
                'icon': _isReceita ? Icons.attach_money : Icons.money_off,
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
