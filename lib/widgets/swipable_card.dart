import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/widgets/history_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// This Widget is used in the History Screen
/// This Enables the user to Swipe and Delete the History Content
class SwipableCard extends StatefulWidget {
  const SwipableCard({super.key});

  @override
  State<SwipableCard> createState() => _SwipableCardState();
}

class _SwipableCardState extends State<SwipableCard> {
  late Future<String> expenses;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    expenses = getExpenses(provider);
    print("Fired init State");
  }

  List<Map<String, String>> historyList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: expenses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          historyList = [];
          final provider = Provider.of<BackEndProvider>(context);

          /// The below implementation is used to sort the expenses based on the date and time
          /// and it is stored inside the *[historyList]*
          if (provider.expenses != null) {
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

            ///To have a check whether the historyList is empty or not and display
            ///the widget accordingly
            if (historyList.isNotEmpty) {
              print("Deleted and Triggered");
              print(historyList);
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
                          // key: ValueKey(item),
                          key: UniqueKey(),
                          secondaryBackground: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffEA0000),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      "Delete",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      "Delete",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )),
                          onDismissed: (direction) async {
                            // print("Expense ID : ${historyList[index]}");

                            await deleteExpenses(
                                historyList[index]["expenseId"] as String,
                                provider);
                            // setState(() {
                            //   // historyList.removeAt(index);
                            // });

                            // ignore: use_build_context_synchronously
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
            }

            ///when there is no data in the historyList, then this fallback UI will be displayed
            ///for the existing user, who have cleared all the data in the historyList
            else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                    child: Text(
                        "No Transactions Yet. To add transaction, Flip the category card and add the expenses")),
              );
            }
          }

          ///this fallback UI will be displayed for the initial User
          else {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                  child: Text(
                      "No Transactions Yet. To add transaction, Flip the category card and add the expenses")),
            );
          }
        }

        /// UI for Loading State
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
