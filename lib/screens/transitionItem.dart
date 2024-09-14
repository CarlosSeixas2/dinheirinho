import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final bool isPositive;

  const TransactionItem({super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isPositive ? Colors.green : Colors.red,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}