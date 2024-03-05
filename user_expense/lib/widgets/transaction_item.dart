import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

// This is a stateless widget for displaying a transaction item.
class TransactionItem extends StatelessWidget {
  // The constructor for this widget. It takes a key, a transaction, a MediaQueryData object, and a delete function as parameters.
  const TransactionItem({
    super.key,
    required this.transaction, // The transaction to be displayed.
    required this.mediaQuery, // The MediaQueryData object for responsive design.
    required this.deleteTx, // The function to delete a transaction.
  });

  // The transaction to be displayed.
  final Transaction transaction;
  // The MediaQueryData object for responsive design.
  final MediaQueryData mediaQuery;
  // The function to delete a transaction.
  final Function deleteTx;

  // The build method for this widget.
  @override
  Widget build(BuildContext context) {
    // Returns a Card widget.
    return Card(
      elevation: 5, // The elevation of the card.
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5), // The margin of the card.
      child: ListTile(
          leading: CircleAvatar( // A circular avatar.
              radius: 30, // The radius of the avatar.
              child: Padding(
                padding: const EdgeInsets.all(6.0), // The padding inside the avatar.
                child: FittedBox(
                  child: Text(
                    '\$${transaction.amount}', // The amount of the transaction.
                  ),
                ),
              )),
          title: Text(
            transaction.title, // The title of the transaction.
            style: Theme.of(context).textTheme.titleLarge, // The style of the title.
          ),
          subtitle: Text(DateFormat.yMMMMEEEEd()
              .format(transaction.date)), // The date of the transaction.
          trailing: mediaQuery.size.width > 460
              ? TextButton.icon(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all(Colors.red), // The color of the button.
                  ),
                  label: const Text('Delete'), // The label of the button.
                  icon: const Icon(Icons.delete), // The icon of the button.
                  onPressed: () => deleteTx(transaction.id),) // The function to be called when the button is pressed.
              : IconButton(
                  icon: const Icon(Icons.delete), // The icon of the button.
                  onPressed: () => deleteTx(transaction.id), // The function to be called when the button is pressed.
                  color: Theme.of(context).colorScheme.error, // The color of the button.
))
    );
  }
}