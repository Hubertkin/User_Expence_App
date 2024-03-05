import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_expense/widgets/adaptive_flat_button.dart';

// This widget is the root of your application.
class NewTransaction extends StatefulWidget {
  // Function to add a new transaction
  final Function addTx;

  // Constructor
  const NewTransaction(this.addTx, {super.key});

  @override
  // Create the state for this widget
  State<NewTransaction> createState() => _NewTransactionState();
}

// The state for the NewTransaction widget
class _NewTransactionState extends State<NewTransaction> {
  // Controller for the title text field
  final titleController = TextEditingController();

  // Controller for the amount text field
  final amountController = TextEditingController();

  // The selected date
  DateTime? _selectedDate;

  // Function to submit the data
  void submitData() {
    // If the amount text field is empty, return
    if (amountController.text.isEmpty) {
      return;
    }
    // Get the entered title and amount
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    // If the title is empty, the amount is less than or equal to 0, or no date is selected, return
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    // Add the transaction and close the modal
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  // Function to present the date picker
  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then(
      (value) {
        // If no date is selected, return
        if (value == null) {
          return;
        }
        // Otherwise, set the selected date
        setState(() {
          _selectedDate = value;
        });
      },
    );
  }

  @override
  // Build the widget
  Widget build(BuildContext context) {
    // Get the media query data
    final mediaQuery = MediaQuery.of(context);

    // Return a scrollable view with a card containing the form
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          // Padding for the container
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: mediaQuery.viewInsets.bottom + 10,
          ),
          child: Column(children: [
            // Title text field
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleController,
            ),
            // Amount text field
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            // Date picker row
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  // Display the selected date or a default message
                  Expanded(
                      child: Text(_selectedDate == null
                          ? "No Date Chosen!"
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}')),
                  // Button to present the date picker
                  AdaptiveFlatButton("Choose Date", _presentDatePicker),
                ],
              ),
            ),
            // Button to submit the data
            ElevatedButton(
              onPressed: submitData,
              child: const Text(
                "Add Transaction",
              ),
            )
          ]),
        ),
      ),
    );
  }
}
