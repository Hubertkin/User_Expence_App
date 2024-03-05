import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'chart_bar.dart';

// A stateless widget for displaying a chart
class Chart extends StatelessWidget {
  // A list of recent transactions
  final List<Transaction> recentTransactions;

  // Constructor for the Chart widget
  const  Chart(this.recentTransactions);

  // A getter that returns a list of transactions grouped by day
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      // Calculate the date for the current index
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      // Initialize the total sum of transactions for the current day
      double totalSum = 0.0;

      // Loop through all recent transactions
      for (int i = 0; i < recentTransactions.length; i++) {
        // If the transaction occurred on the current day, add its amount to the total sum
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      // Return a map containing the day and the total sum of transactions for that day
      return {
        'day': DateFormat.E().format(weekDay)[0],
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  // A getter that returns the maximum spending amount
  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  // The build method for the Chart widget
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, 
          children: [
            // Map each grouped transaction to a ChartBar widget
            ...groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  data['day'].toString(),
                  data['amount'] as double,
                  maxSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / maxSpending,
                ),
              );
            }).toList()
          ]),
      ),
    );
  }
}
