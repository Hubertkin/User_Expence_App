// Importing necessary packages
import 'package:flutter/material.dart';
import '../models/transaction.dart'; // Importing the Transaction model

import 'transaction_item.dart'; // Importing the TransactionItem widget

// Defining a stateless widget named TransactionList
class TransactionList extends StatelessWidget {
  // Defining a list of Transaction objects
  final List<Transaction> transactions;
  // Defining a function to delete a transaction
  final Function deleteTx;

  // Defining a constructor for this widget
  const TransactionList(this.transactions, this.deleteTx, {super.key});

  // Overriding the build method to define the UI of this widget
  @override
  Widget build(BuildContext context) {
    // Getting the MediaQuery data
    final mediaQuery = MediaQuery.of(context);
    // Checking if the transactions list is empty
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            // If the list is empty, show a message and an image
            return Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ))
              ],
            );
          })
        : ListView.builder(
            // If the list is not empty, build a list of TransactionItem widgets
            itemBuilder: ((context, index) {
              return TransactionItem(
                key: ValueKey(transactions[index].id),
                transaction: transactions[index], mediaQuery: mediaQuery, deleteTx: deleteTx);
            }),
            itemCount: transactions.length,
          );
  }
}
