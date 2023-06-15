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
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    filterDataList = getFilterDataList(provider);
  }

  Future<List<List<String>>> getFilterDataList(BackEndProvider provider) async {
    List<List<String>> finalResultList = [];
    List<String> tempList = [];

    provider.budget!.budgets.forEach((element) {
      tempList.add(element.budgetname);
    });
    finalResultList.add(tempList);
    tempList = [];
    provider.categories!.forEach((element) {
      tempList.add(element.categoryname);
    });
    finalResultList.add(tempList);
    tempList = [];
    provider.expenseMethods.forEach((element) {
      tempList.add(element.emshortname);
    });
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
                      padding: EdgeInsets.all(16),
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
                          VerticalDivider(),
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
                                  : IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.calendar_month)))
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
                          print(selectedBudget);
                          print(selectedCategory);
                          print(selectedExpenseMethod);
                          var result = [];

                          print(tempList);
                          if (selectedBudget.isNotEmpty) {
                            result = tempList
                                .where((element) =>
                                    element.budgetname == selectedBudget)
                                .toList();
                            print("Something");
                            print(result);
                            tempList = [...result];
                          }
                          if (selectedCategory.isNotEmpty) {
                            result = tempList
                                .where((element) =>
                                    element.categoryname == selectedCategory)
                                .toList();

                            tempList = [...result];
                          }
                          if (selectedExpenseMethod.isNotEmpty) {
                            result = tempList
                                .where((element) =>
                                    element.emshortname ==
                                    selectedExpenseMethod)
                                .toList();

                            tempList = [...result];
                          }
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
                            : const Text("Apply Filter"),
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
                        child: const Text("Cancel Filter"),
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
