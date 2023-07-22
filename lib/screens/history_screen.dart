import 'package:budget_app/models/expense_model.dart';
import 'package:budget_app/utility/showsnackbar.dart';
import 'package:budget_app/widgets/expense_method_dialog.dart';
import 'package:budget_app/widgets/expense_methods_list_widget.dart';
import 'package:budget_app/widgets/filter_widget.dart';
import 'package:budget_app/widgets/swipable_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../common/screen_size.dart';
import '../provider/app_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _key1 = GlobalKey<_HistoryScreenState>();
  final _key2 = GlobalKey<_HistoryScreenState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    showTutorialScreen();
    super.initState();
  }

  showTutorialScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("newUser")) {
      await prefs.setBool('newUser', false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        return ShowCaseWidget.of(context).startShowCase(
          [
            _key1,
            _key2,
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    return Scaffold(
      floatingActionButton: Showcase.withWidget(
          height: 25,
          width: SizeConfig.screenWidth! * 0.775,
          tooltipPosition: TooltipPosition.top,
          targetBorderRadius: BorderRadius.circular(1000),
          targetPadding: const EdgeInsets.all(48),
          container: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Tap the ",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(48),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            ),
                            Text(" icon",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18)),
                          ],
                        ),
                        Text(
                          "to create expense method",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          disposeOnTap: true,
          onTargetClick: () {
            showDialog(
                context: context,
                builder: (context) => const ExpenseMethodDialog());
          },
          key: _key1,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => const ExpenseMethodDialog());
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )),
      appBar: AppBar(
        actions: [
          Showcase.withWidget(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth! * 0.85,
            tooltipPosition: TooltipPosition.bottom,
            targetBorderRadius: BorderRadius.circular(1000),
            targetPadding: const EdgeInsets.all(50),
            container: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Tap the ",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(48),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  )),
                            ),
                            Text(" icon",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18)),
                          ],
                        ),
                        Text(
                          "to edit expense method",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            disposeOnTap: true,
            onTargetClick: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    surfaceTintColor: Colors.white,
                    insetPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const ExpenseMethodsListWidget(),
                  );
                },
              );
            },
            key: _key2,
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        surfaceTintColor: Colors.white,
                        insetPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const ExpenseMethodsListWidget(),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_vert)),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            provider.setBottomNavIndex(0);
          },
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: SizeConfig.height! * 10,
        centerTitle: true,
        title: Text(
          "History",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.only(left: 12, right: 12),
            // alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Search Bar
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      padding: const EdgeInsets.only(left: 12),
                      // Add padding around the search bar
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.secondary,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 2),
                                color: Colors.grey,
                                blurRadius: 2)
                          ]),
                      // Use a Material design search bar
                      child: Align(
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          onEditingComplete: () {
                            // Perform the search here
                            ///Compares the expense notes with the input typed
                            List<Expenses> list = provider.expenses!;
                            var newList = list.where((element) => element
                                .expensenotes
                                .toLowerCase()
                                .contains(_searchController.text));
                            provider
                                .setSearchResults(List<Expenses>.from(newList));
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: _searchController,
                          decoration: InputDecoration(
                              // constraints: const BoxConstraints(),
                              // contentPadding: EdgeInsets.zero,
                              hintText: 'Search...',
                              // Add a clear button to the search bar
                              suffixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  Icons.clear,
                                  size: 18,
                                  color: Colors.grey[700],
                                ),
                                onPressed: () {
                                  ///On clicking the clear icon,
                                  ///resets the state back to its old state
                                  _searchController.clear();
                                  provider.changeToUnsorted();
                                },
                              ),

                              ///Enable prefix search button by uncommenting this lines
                              // Add a search icon or button to the search bar
                              /*prefixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.search),
                      
                                ///On Pressing the search icon..
                                ///this will be implemented
                                onPressed: () {
                                  // Perform the search here
                                  ///Compares the expense notes with the input typed
                                  List<Expenses> list = provider.expenses!;
                                  var newList = list.where((element) => element
                                      .expensenotes
                                      .toLowerCase()
                                      .contains(_searchController.text));
                                  provider.setSearchResults(
                                      List<Expenses>.from(newList));
                                },
                              ), */
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      if (provider.isAscending == true) {
                        provider.setAscending(false);
                        provider.changeToUnsorted();
                      } else {
                        provider.setAscending(true);
                        provider.setDescending(false);
                        var tempList = provider.filteredExpenses;
                        if (tempList != null) {
                          tempList.sort(
                              (a, b) => a.expensecost.compareTo(b.expensecost));
                        }
                      }
                    },
                    child: Container(
                      // height: 42,
                      // width: 42,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                          color: provider.isAscending
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Image(
                                image: const AssetImage(
                                    "assets/icons/ascending.png"),
                                color: provider.isAscending
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      if (provider.isDescending == true) {
                        provider.setDescending(false);
                        provider.changeToUnsorted();
                      } else {
                        provider.setDescending(true);
                        provider.setAscending(false);
                        var tempList = provider.filteredExpenses;
                        if (tempList != null) {
                          tempList.sort(
                              (a, b) => b.expensecost.compareTo(a.expensecost));
                        }
                        for (var element in tempList!) {
                          print(element.expensecost);
                        }
                        provider.setFilteredData(List<Expenses>.from(tempList));
                      }
                    },
                    child: Container(
                      // height: 42,
                      // width: 42,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                          color: provider.isDescending
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Image(
                                filterQuality: FilterQuality.high,
                                image: const AssetImage(
                                    "assets/icons/descending.png"),
                                color: provider.isDescending
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      if (provider.budget != null &&
                          provider.budget!.budgets.isNotEmpty &&
                          provider.categories!.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const FilterDialogWidget();
                          },
                        );
                      } else {
                        showSnackBar(context, "No enough data to filter");
                      }
                    },
                    child: Container(
                      // height: 42,
                      // width: 42,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: const SizedBox(
                        height: 20,
                        width: 20,
                        child: Image(
                          image: AssetImage("assets/icons/filter.png"),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 12),
              child: Text(
                "Total: ${provider.filteredAmount} ",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: SwipableCard(),
              )),
        ],
      ),
    );
  }
}
