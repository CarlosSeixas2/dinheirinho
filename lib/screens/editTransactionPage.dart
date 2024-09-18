import 'package:flutter/material.dart';

class EditTransactionPage extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const EditTransactionPage({super.key, required this.transaction});

  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late String _type;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.transaction['description'] ?? '');
    _valueController = TextEditingController(text: widget.transaction['value']?.toString() ?? '');
    _type = widget.transaction['type'] ?? 'despesa';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _save() {
    final updatedTransaction = {
      'description': _descriptionController.text,
      'value': double.tryParse(_valueController.text) ?? 0.0,
      'type': _type,
    };

    Navigator.pop(context, updatedTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Transação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            DropdownButton<String>(
              value: _type,
              onChanged: (String? newValue) {
                setState(() {
                  _type = newValue!;
                });
              },
              items: <String>['receita', 'despesa']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
