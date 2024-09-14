import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';

class AddTransactionDialog extends ConsumerStatefulWidget {
  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _subtitle = '';
  double _value = 0;
  bool _isReceita = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nova Transação'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Título'),
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
              decoration: InputDecoration(labelText: 'Descrição'),
              onSaved: (value) {
                _subtitle = value ?? '';
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
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
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              ref.read(transactionsProvider.notifier).state = [
                ...ref.read(transactionsProvider),
                {
                  'title': _title,
                  'subtitle': _subtitle,
                  'value': _value,
                  'type': _isReceita ? 'receita' : 'despesa',
                  'icon': _isReceita ? Icons.attach_money : Icons.money_off,
                }
              ];

              Navigator.of(context).pop();
            }
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
