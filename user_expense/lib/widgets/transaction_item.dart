import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';



class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.mediaQuery,
    required this.deleteTx,
  });

  final Transaction transaction;
  final MediaQueryData mediaQuery;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
          leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FittedBox(
                  child: Text(
                    '\$${transaction.amount}',
                  ),
                ),
              )),
          title: Text(
            transaction.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(DateFormat.yMMMMEEEEd()
              .format(transaction.date)),
          trailing: mediaQuery.size.width > 460
              ? TextButton.icon(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all(Colors.red),
                  ),
                  label: const Text('Delete'),
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteTx(transaction.id),)
              : IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteTx(transaction.id),
                  color: Theme.of(context).colorScheme.error,
))
    );
  }
}