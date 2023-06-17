import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense_model.dart';

class FilterDialogWidget extends StatefulWidget {
  const FilterDialogWidget({super.key});

  @override
  State<FilterDialogWidget> createState() => _FilterDialogWidgetState();
}

class _FilterDialogWidgetState extends State<FilterDialogWidget> {
  List<String> filterList = ['Budget', 'Category', 'Expense', 'Date Range'];
  late Future<List<List<String>>> filterDataList;
  int selectedIndex = 0;
  bool isLoading = false;
  @override
  void initState() {
   
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    filterDataList = getFilterDataList(provider);
  }

  Future<List<List<String>>> getFilterDataList(BackEndProvider provider) async {
    List<List<String>> finalResultList = [];
    List<String> tempList = [];

    for (var element in provider.budget!.budgets) {
      tempList.add(element.budgetname);
    }
    finalResultList.add(tempList);
    tempList = [];
    for (var element in provider.categories!) {
      tempList.add(element.categoryname);
    }
    finalResultList.add(tempList);
    tempList = [];
    for (var element in provider.expenseMethods) {
      tempList.add(element.emshortname);
    }
    finalResultList.add(tempList);
    // final budgetList = provider.budget!.budgets.;
    return finalResultList;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    return Dialog(
      surfaceTintColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      child: FutureBuilder(
          future: filterDataList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: SizeConfig.height! * 60,
                width: SizeConfig.width! * 90,
                // padding: const EdgeInsets.symmetric(horizontal: 36),
                decoration: const BoxDecoration(),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      child: Text(
                        "Filter",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 5,
                      height: 0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filterList.length,
                                    itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 15, bottom: 15),
                                            child: Text(
                                              filterList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ),
                                        ))
                              ],
                            ),
                          ),
                          const VerticalDivider(),
                          Expanded(
                              flex: 2,
                              child: selectedIndex < 3
                                  ? ListView.builder(
                                      itemCount:
                                          snapshot.data![selectedIndex].length,
                                      itemBuilder: (context, index) {
                                        List<String> tempList =
                                            snapshot.data![selectedIndex];
                                        return SizedBox(
                                          height: 42,
                                          child: RadioListTile(
                                            value: index,
                                            groupValue:
                                                provider.selectedRadioButtons[
                                                    filterList[selectedIndex]],
                                            onChanged: (value) {
                                              provider.setSelectedRadioData(
                                                  filterList[selectedIndex],
                                                  value!,
                                                  tempList[value]);
                                            },
                                            title: Text(
                                              tempList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                          ),
                                        );
                                      },
                                    )

                                  ///Date Filter
                                  : Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Start date :",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          Row(
                                            children: [
                                              provider.startDate != null
                                                  ? Text(
                                                      " ${provider.startDate!.day}/${provider.startDate!.month}/${provider.startDate!.year}")
                                                  : const Text("Pick a date"),
                                              IconButton(
                                                  onPressed: () async {
                                                    DateTime? startDate =
                                                        await showDatePicker(
                                                            initialDate:
                                                                provider.startDate !=
                                                                        null
                                                                    ? provider
                                                                        .startDate!
                                                                    : DateTime
                                                                        .now(),
                                                            context: context,
                                                            firstDate: DateTime(
                                                                1999, 12, 1),
                                                            lastDate: DateTime(
                                                                2100, 12, 1));
                                                    print(startDate);
                                                    if (startDate != null) {
                                                      if (startDate.isBefore(
                                                              provider
                                                                          .endDate !=
                                                                      null
                                                                  ? provider
                                                                      .endDate!
                                                                  : DateTime
                                                                      .now()) ||
                                                          startDate.isAtSameMomentAs(
                                                              provider
                                                                          .endDate !=
                                                                      null
                                                                  ? provider
                                                                      .endDate!
                                                                  : DateTime
                                                                      .now())) {
                                                        provider.setStartDate(
                                                            startDate);
                                                      } else {
                                                        // ignore: use_build_context_synchronously
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                                      actions: [
                                                                        ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text("OK"))
                                                                      ],
                                                                      content:
                                                                          const Text(
                                                                              "Start date should be less than the end date"),
                                                                    ));
                                                      }
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      Icons.calendar_month)),
                                            ],
                                          ),
                                          const Divider(),
                                          Text(
                                            "End date :",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          Row(
                                            children: [
                                              provider.endDate != null
                                                  ? Text(
                                                      " ${provider.endDate!.day}/${provider.endDate!.month}/${provider.endDate!.year}")
                                                  : const Text("Pick a Date"),
                                              IconButton(
                                                  onPressed: () async {
                                                    DateTime? endDate =
                                                        await showDatePicker(
                                                            initialDate:
                                                                provider.endDate !=
                                                                        null
                                                                    ? provider
                                                                        .endDate!
                                                                    : DateTime
                                                                        .now(),
                                                            context: context,
                                                            firstDate: DateTime(
                                                                1999, 12, 1),
                                                            lastDate: DateTime(
                                                                2100, 12, 1));
                                                    if (endDate != null) {
                                                      if (endDate.isAfter(
                                                              provider.startDate !=
                                                                      null
                                                                  ? provider
                                                                      .startDate!
                                                                  : DateTime(
                                                                      1999,
                                                                      1,
                                                                      1)) ||
                                                          endDate.isAtSameMomentAs(
                                                              provider.startDate !=
                                                                      null
                                                                  ? provider
                                                                      .startDate!
                                                                  : DateTime(
                                                                      1999,
                                                                      1,
                                                                      1))) {
                                                        provider.setEndDate(
                                                            endDate);
                                                      } else {
                                                        // ignore: use_build_context_synchronously
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                                      actions: [
                                                                        ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text("OK"))
                                                                      ],
                                                                      content:
                                                                          const Text(
                                                                              "End date should be greater than the start date"),
                                                                    ));
                                                      }
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      Icons.calendar_month)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      width: SizeConfig.width! * 100,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });

                          print(provider.expenses);
                          var tempList = provider.expenses!;
                          String selectedBudget =
                              provider.selectedRadioButtonsData["Budget"]!;
                          String selectedCategory =
                              provider.selectedRadioButtonsData["Category"]!;
                          String selectedExpenseMethod =
                              provider.selectedRadioButtonsData["Expense"]!;
                          DateTime? startDate = provider.startDate != null
                              ? provider.startDate!
                              : null;
                          DateTime? endDate = provider.endDate != null
                              ? provider.endDate!
                              : null;
                          print(selectedBudget);
                          print(selectedCategory);
                          print(selectedExpenseMethod);
                          print(startDate);
                          print(endDate);
                          List<dynamic> result = filterFunction(
                              selectedBudget,
                              tempList,
                              selectedCategory,
                              selectedExpenseMethod,
                              startDate,
                              endDate);

                          provider.setFilteredData(List<Expenses>.from(result));

                          Navigator.of(context).pop();
                        },
                        child: isLoading
                            ? const Center(
                                child: SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : const Text("Apply Filters"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 12),
                      width: SizeConfig.width! * 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        onPressed: () {
                          provider.resetFilteredData();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Clear Filters"),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

List<dynamic> filterFunction(
    String selectedBudget,
    List<Expenses> tempList,
    String selectedCategory,
    String selectedExpenseMethod,
    DateTime? startDate,
    DateTime? endDate) {
  var result = [];
  print("Start Date ==> $startDate");
  print("End Date ==> $endDate");

  ///Filtering Logic Here
  ///Filter based on budget
  if (selectedBudget.isNotEmpty) {
    result = tempList
        .where((element) => element.budgetname == selectedBudget)
        .toList();
    print("Something");
    print(result);
    tempList = [...result];
  }

  ///Filter based on categories
  if (selectedCategory.isNotEmpty) {
    result = tempList
        .where((element) => element.categoryname == selectedCategory)
        .toList();

    tempList = [...result];
  }

  ///Filter based on expense method
  if (selectedExpenseMethod.isNotEmpty) {
    result = tempList
        .where((element) => element.emshortname == selectedExpenseMethod)
        .toList();

    tempList = [...result];
  }

  ///Filters based on only the start date
  if (startDate != null && endDate == null) {
    result = tempList
        .where((element) => ((element.expensedate.isAfter(startDate) ||
            element.expensedate.isAtSameMomentAs(startDate))))
        .toList();
    tempList = [...result];
  }

  ///Filters based on only the end date
  if (endDate != null && startDate == null) {
    result = tempList
        .where((element) => ((element.expensedate.isBefore(endDate) ||
            element.expensedate.isAtSameMomentAs(endDate))))
        .toList();
    tempList = [...result];
  }

  ///Filters based on both start date and end date
  if (startDate != null && endDate != null) {
    result = tempList
        .where((element) => ((element.expensedate.isAfter(startDate) ||
                element.expensedate.isAtSameMomentAs(startDate)) &&
            (element.expensedate.isBefore(endDate) ||
                element.expensedate.isAtSameMomentAs(endDate))))
        .toList();
    tempList = [...result];
  }
  return tempList;
}
