// Criar página para visualizar uma transação

import 'package:flutter/material.dart';

class ViewTransaction extends StatelessWidget {
  final String id;
  final String description;
  final String value;
  final bool isPositive;

  const ViewTransaction({
    super.key,
    required this.id,
    required this.description,
    required this.value,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar Transação'),
      ),
      body: Column(
        children: [
          Text('Descrição: '),
          Text('Valor: '),
          Text('Categoria: '),
          Text('Data: '),
          // Deletar o item da lista
          ElevatedButton(
            onPressed: () {
              // Deletar a transação
            },
            child: Text('Deletar'),
          ),
        ],
      ),
    );
  }
}
