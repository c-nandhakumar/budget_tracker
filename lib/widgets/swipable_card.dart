import 'package:budget_app/models/expense_model.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/widgets/history_container.dart';
import 'package:flutter/material.dart';
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

  List<Expenses> historyList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: expenses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Consumer<BackEndProvider>(builder: (context, value, child) {
            historyList = [];
            // print("<===========Listening in swipable card============>");
            final provider = Provider.of<BackEndProvider>(context);

            /// The below implementation is used to sort the expenses based on the date and time
            /// and it is stored inside the *[historyList]*
            if (value.expenses!.isNotEmpty) {
              ///To sort the list based on the expensetransaction

              if (provider.isAscending) {
                provider.filteredExpenses!
                    .sort((a, b) => a.expensecost.compareTo(b.expensecost));
              } else if (provider.isDescending) {
                provider.filteredExpenses!
                    .sort((a, b) => b.expensecost.compareTo(a.expensecost));
              } else {
                provider.filteredExpenses!.sort((a, b) =>
                    b.expensetransaction.compareTo(a.expensetransaction));
              }

              for (var element in provider.filteredExpenses!) {
                historyList.add(element);
              }

              ///To have a check whether the historyList is empty or not and display
              ///the widget accordingly
              if (value.expenses!.isNotEmpty) {
                return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 12,
                        ),
                    itemCount: value.expenses!.length,
                    itemBuilder: (context, index) {
                      final item = historyList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Dismissible(
                            // key: ValueKey(item),
                            key: ValueKey(item.expenseid),
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
                                  historyList[index].expenseid, provider);
                              // setState(() {
                              //   // historyList.removeAt(index);
                              // });

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    '${item.budgetname} - ${item.categoryname} : ${item.expensecost}  deleted'),
                                duration: const Duration(milliseconds: 1000),
                              ));
                            },
                            child: HistoryContainer(expense: item)),
                      );
                    });
              }

              ///when there is no data in the historyList, then this fallback UI will be displayed
              ///for the existing user, who have cleared all the data in the historyList
              else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 56,
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey, offset: Offset(-4, 4))
                            ],
                            color: Colors.white,
                            border: Border.all(width: 1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: const Text(
                              "No Transactions Yet. To add transaction, Flip the category card and add the expenses"),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }

            ///this fallback UI will be displayed for the initial User
            else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                    child: Container(
                  height: 56,
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, offset: Offset(-4, 4))
                    ],
                    color: Colors.white,
                    border: Border.all(width: 1),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: const Text(
                      "No Transactions Yet. To add transaction, Flip the category card and add the expenses"),
                )),
              );
            }
          });
        }

        /// UI for Loading State
        else if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
