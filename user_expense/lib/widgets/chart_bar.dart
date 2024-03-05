import 'package:flutter/material.dart';

// This is a stateless widget that represents a bar in a chart.
class ChartBar extends StatelessWidget {
  // This is the label for the bar.
  final String label;
  // This is the amount of spending that the bar represents.
  final double spendingAmount;
  // This is the percentage of the total spending that the bar represents.
  final double spendingPctOfTotal;

  // This is the constructor for the ChartBar widget.
  const ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  // This is the build method that describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) { 
      return Column(
        children: [
          // This is a box with a specified height that contains the spending amount.
          SizedBox(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text('\$${spendingAmount.toStringAsFixed(0)}')
            )
          ),
          // This is a box with a specified height used as a spacer.
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          // This is a box with a specified height and width that contains a stack of widgets.
          SizedBox(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(children: [
              // This is a container with a border and a background color.
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // This is a box that sizes its child to a fraction of the total available space.
              FractionallySizedBox(
                heightFactor: spendingPctOfTotal,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ),
            ]),
          ),
          // This is a box with a specified height used as a spacer.
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          // This is a box with a specified height that contains the label.
          SizedBox(
            height:constraints.maxHeight * 0.15, 
            child: FittedBox(child: Text(label))
          ),
        ],
      );
    });
  }
}
