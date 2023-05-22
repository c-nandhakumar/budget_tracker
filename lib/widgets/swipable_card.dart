import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/widgets/history_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SwipableCard extends StatefulWidget {
  const SwipableCard({super.key});

  @override
  State<SwipableCard> createState() => _SwipableCardState();
}

class _SwipableCardState extends State<SwipableCard> {
  late Future<String> expenses;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    expenses = getExpenses(provider);
  }

  // final List<Map<String, String>> historyList = [
  //   {"name": "Food", "cost": "\$160", "date": "May 02"},
  //   {"name": "Rent", "cost": "\$160", "date": "May 02"},
  //   {"name": "Gas", "cost": "\$160", "date": "May 02"},
  //   {"name": "Travel", "cost": "\$160", "date": "May 02"},
  //   {"name": "Food", "cost": "\$160", "date": "May 01"}
  // ];
  List<Map<String, String>> historyList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: expenses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final provider = Provider.of<BackEndProvider>(context);
          provider.expenses!.sort(
              (a, b) => b.expensetransaction.compareTo(a.expensetransaction));
          for (var element in provider.expenses!) {
            String timestamp = element.expensetransaction.toIso8601String();

            DateTime dateTime = DateTime.parse(timestamp);
            String formattedDate = DateFormat('MMM dd').format(dateTime);
            historyList.add({
              "name": element.categoryname,
              "cost": element.expensecost.toString(),
              "date": formattedDate,
              "budgetname": element.budgetname,
              "expenseId": element.expenseid,
            });
          }

          return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Dismissible(
                      key: ValueKey(item),
                      secondaryBackground: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffEA0000),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Delete",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white),
                                ),
                              )
                            ],
                          )),
                      background: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffEA0000),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Delete",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white),
                                ),
                              )
                            ],
                          )),
                      onDismissed: (direction) async {
                        // print("Expense ID : ${historyList[index]}");
                        deleteExpenses(
                            historyList[index]["expenseId"] as String);
                        setState(() {
                          historyList.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${item['budgetname']} - ${item['name']} : ${item['cost']}  deleted'),
                          duration: const Duration(milliseconds: 1000),
                        ));
                      },
                      child: HistoryContainer(
                        name: item['name'],
                        cost: item['cost'],
                        date: item['date'],
                        budgetname: item['budgetname'],
                      )),
                );
              });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
