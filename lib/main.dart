import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.lime,
                  fontFamily: 'Open Sans')),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(fontSize: 18, fontFamily: 'Open Sans'),
              headline1: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold),
            ),
      ),
      home: MyHomePage(title: 'Personal Expenses'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool _showChart = false;

  final List<Transaction> _usertransaction = [
    // Transaction(id: "t1", title: "Adidas", amount: 59.59, date: DateTime.now()),
    // Transaction(
    //     id: "t2", title: "McDonald's", amount: 15.59, date: DateTime.now()),
  ];
  List<Transaction> get _recentTransactions {
    return _usertransaction.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime choseDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: choseDate,
        id: DateTime.now().toString());

    setState(() {
      _usertransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _usertransaction.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        widget.title,
        style: Theme.of(context).appBarTheme.textTheme.headline1,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart'),
                Switch(
                  value: _showChart,
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                  },
                )
              ],
            ),
            _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child:
                        TransactionList(_usertransaction, _deleteTransaction)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        tooltip: 'Add Transaction',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
