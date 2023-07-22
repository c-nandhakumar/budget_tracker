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
    // provider.setAscending(false);
    // provider.setDescending(false);
    expenses = getExpenses(provider);
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
            final provider = Provider.of<BackEndProvider>(context);

            /// The below implementation is used to sort the expenses based on the date and time
            /// and it is stored inside the *[historyList]*
            if (value.expenses!.isNotEmpty) {
              if (provider.isAscending) {
                ///To sort the list based on cost in ascending order
                provider.filteredExpenses!
                    .sort((a, b) => a.expensecost.compareTo(b.expensecost));
              } else if (provider.isDescending) {
                ///To sort the list based on cost in descending order
                provider.filteredExpenses!
                    .sort((a, b) => b.expensecost.compareTo(a.expensecost));
              } else {
                ///To sort the list based on the expensetransaction
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
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      final item = historyList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Dismissible(
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
                return fallbackUI(context);
              }
            }

            ///this fallback UI will be displayed for the initial User
            else {
              return fallbackUI(context);
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

  Center fallbackUI(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            // height: 64,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 4),
                    blurRadius: 3,
                    spreadRadius: 1)
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Text(
              "No Transactions Yet. Flip the category card and add the expense",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
        ),
      ],
    ));
  }
}
