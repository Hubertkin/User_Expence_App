// Importing necessary libraries
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Importing custom widgets and models
import './widgets/new_transactions.dart';
import 'models/transaction.dart';
import 'widgets/transaction_list.dart';
import 'widgets/chart.dart';

// Main entry point for the application
void main() => runApp(const MyApp());

// Root of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: const MyHomePage(),

      // App theme configuration
      theme: ThemeData(
        primarySwatch: Colors.purple,
        hintColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Main content of the application
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // List to store user transactions
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'New Shirt',
    //   amount: 39.99,
    //   date: DateTime.now(),
    // ),
  ];

  // Variable to track whether to show the chart or not
  bool _showChart = false;

// Lifecycle method: initState
  void initSate() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

// Lifecycle method: didChangeAppLifecycleState
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint(state.toString());
  }

// Lifecycle method: dispose
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

// Getter for recent transactions within the last 7 days
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

 // Method to add a new transaction
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

// Method to open the modal bottom sheet for adding new transactions
  void _startAddNewTransactions(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  // Function to delete a transaction
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  // Method to build content for landscape orientation
  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).hintColor,
              value: _showChart, // Variable to hold the state of the switch
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(
                  _recentTransactions)) // Variable to hold recent transactions
          : txListWidget
    ];
  }

  // Function to build the portrait view
  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      SizedBox(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(
              _recentTransactions)), // Variable to hold recent transactions
      txListWidget
    ];
  }

  // Widget to build the UI
  @override
  Widget build(BuildContext context) {
    final mediaQuery =
        MediaQuery.of(context); // Variable to hold media query data
    final isLanscape = mediaQuery.orientation ==
        Orientation.landscape; // Variable to hold the orientation state
    final PreferredSizeWidget appBar = Platform.isIOS
        ? PreferredSize(
            preferredSize: Size.fromHeight(
                mediaQuery.size.height * 0.1), // Adjust this as needed
            child: CupertinoNavigationBar(
                middle: const Text('Personal Expenses'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _startAddNewTransactions(context),
                      child: const Icon(CupertinoIcons.add),
                    )
                  ],
                )),
          )
        : AppBar( // Material-specific app bar
            title: const Text('Personal Expenses'),
            actions: [
              IconButton(
                onPressed: () => _startAddNewTransactions(context),
                icon: const Icon(Icons.add),
              ),
            ],
          );
          // Creating the transaction list widget
    final txListWidget = SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions,
            _deleteTransaction)); // Variable to hold the transaction list widget
   
    // Constructing the main body of the page
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
  
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLanscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLanscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransactions(context),
                    child: const Icon(Icons.add),
                  ),
          );
  }
}
