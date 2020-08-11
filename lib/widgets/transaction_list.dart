import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function removeTransaction;

  TransactionList(this.transactions, this.removeTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
            children: <Widget>[
              Text(
                'No transactions added yet!',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 100,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          )
        : ListView.builder(
            // for best performance
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text(
                            '\$${transactions[index].amount.toStringAsFixed(0)}'),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(transactions[index].date),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => removeTransaction(transactions[index].id),
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
