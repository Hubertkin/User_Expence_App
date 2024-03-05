import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
const  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay)[0],
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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

// Card(
//             child: Row(
//               children: [
//                 Container(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                   decoration: BoxDecoration(
//                       border: Border.all(
//                     color: Theme.of(context).primaryColor,
//                     width: 2,
//                   )),
//                   padding: const EdgeInsets.all(10), 
//                   child: Text('\$${ transactions[index].amount.toStringAsFixed(2)}',
//                       style:  TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         color: Theme.of(context).primaryColor,
//                       )),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                      transactions[index].title,
//                       style: Theme.of(context).textTheme.titleLarge,
                    
//                     ),
//                     Text(
//                       DateFormat.yMMMMEEEEd().format( transactions[index].date),
//                       style: const TextStyle(
//                           fontWeight: FontWeight.w300, color: Colors.grey),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           );
