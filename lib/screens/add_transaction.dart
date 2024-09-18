import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart'; // O caminho para o TransactionProvider

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  AddTransactionDialogState createState() => AddTransactionDialogState();
}

class AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
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
    return Consumer(
      builder: (context, ref, child) {
        final transactionNotifier = ref.read(transactionProvider.notifier);

        return AlertDialog(
            backgroundColor: const Color(0xFF121212),
            alignment: Alignment.center,
            title: const Text('Nova Transação',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Título'),
                      onSaved: (value) {
                        _description = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor insira um título';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Valor'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onSaved: (value) {
                        _value = double.tryParse(value ?? '0') ?? 0;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                      dropdownColor: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(10),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
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
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 13, 211, 145),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _formKey.currentState?.save();

                              // Utilizando o Riverpod para adicionar a transação
                              transactionNotifier.addTransaction({
                                'description': _description,
                                'value': _value,
                                'category': _category,
                                'type': _isReceita ? 'receita' : 'despesa',
                                // 'icon': _isReceita ? Icons.attach_money : Icons.money_off,
                              });

                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Salvar'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]);
      },
    );
  }
}
