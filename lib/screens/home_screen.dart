import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/widgets/category_dialog.dart';
import 'package:budget_app/widgets/category_grid.dart';
import 'package:budget_app/widgets/create_next_new_budget_dialog.dart';
import 'package:budget_app/widgets/date_remaining_container.dart';
import 'package:budget_app/widgets/remaining_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../widgets/drop_down_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? dateNow;
  final _key1 = GlobalKey<_HomeScreenState>();

  @override
  void initState() {
    showTutorialScreen();
    super.initState();

    final datenow = DateTime.now();
    DateTime firstDayOfNextMonth = DateTime(datenow.year, datenow.month + 1, 1);
    Duration remainingDuration = firstDayOfNextMonth.difference(datenow);
    int remainingDays = remainingDuration.inDays;
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    String currentMonth = DateFormat('MMMM yyyy').format(datenow);

    String nextMonth = DateFormat('MMMM yyyy')
        .format(DateTime(datenow.year, datenow.month + 1, datenow.day));

    ///If its the end of the month or if the current month is not equal to the budget's first month
    ///then it will enable the createnextnewbudget

    if ((remainingDays <= 2 ||
            !provider.budget!.budgets[0].budgetname.contains(currentMonth)) &&
        !provider.budget!.budgets[0].budgetname.contains(nextMonth)) {
      dateNow = true;
      if (provider.initialCall) {
        Future.delayed(const Duration(seconds: 3), () {
          showDialog(
            context: context,
            builder: (context) {
              return CreateNextNewBudgetDialog(
                  callback: checkCurrentMonthAndNextMonth);
            },
          );
          provider.setInitialCall(false);
        });
      }
    } else {
      ///for testing dateNow is set to true
      dateNow = false;
      // dateNow = true;
    }
  }

  checkCurrentMonthAndNextMonth() {
    final datenow = DateTime.now();
    String nextMonth = DateFormat('MMMM yyyy')
        .format(DateTime(datenow.year, datenow.month + 1, datenow.day));
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    if (provider.budget!.budgets[0].budgetname.contains(nextMonth)) {
      setState(() {
        dateNow = false;
      });
    }
  }

  showTutorialScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("newUserHome") &&
        prefs.getBool("newUserHome") == true) {
      prefs.setBool("newUserHome", false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        return ShowCaseWidget.of(context).startShowCase(
          [
            _key1,
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final provider = Provider.of<BackEndProvider>(context);

    return Scaffold(
      floatingActionButton: Showcase.withWidget(
        height: 25,
        width: SizeConfig.screenWidth! * 0.85,
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
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(48),
                                  color: Theme.of(context).colorScheme.primary),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                        ),
                        Text(" icon",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)),
                      ],
                    ),
                    Text(
                      "to create new category",
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
              context: context, builder: (context) => const CategoryDialog());
        },
        key: _key1,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context, builder: (context) => const CategoryDialog());
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: SizeConfig.height! * 12,
          title: provider.budget != null && provider.budget!.budgets.isNotEmpty
              ? const DropDownWidget()
              : Text(
                  "",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
          actions: [
            dateNow!
                ? Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      padding: const EdgeInsets.all(5),
                      constraints: const BoxConstraints(),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CreateNextNewBudgetDialog(
                                  callback: checkCurrentMonthAndNextMonth);
                            });
                      },
                      color: Colors.white,
                      icon: const Icon(Icons.add),
                    ),
                  )
                : Container(),
          ]),
      body: provider.selectedBudget != null
          ? ListView(
              children: [
                //Two Main Containers
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.width! * 5,
                    right: SizeConfig.width! * 5,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RemainingContainer(),
                      DateRemainingContainer(),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, left: 24.0, bottom: 16),
                  child: Text(
                    "Expenses",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const CategoryGrid(),
                const SizedBox(
                  height: 100,
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 120,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationZ(5.9),
                          child: Image.asset('assets/images/arrow.png'),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          height: 36,
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
                              "Tap the \"+\" Icon to create a budget")),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
