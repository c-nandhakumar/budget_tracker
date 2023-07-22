import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/widgets/category_dialog.dart';
import 'package:budget_app/widgets/category_grid.dart';
import 'package:budget_app/widgets/create_new_budget_dialog.dart';
import 'package:budget_app/widgets/date_remaining_container.dart';
import 'package:budget_app/widgets/remaining_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/drop_down_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? dateNow;

  @override
  void initState() {
    super.initState();
    final datenow = DateTime.now();
    String currentMonth = DateFormat('MMMM yyyy').format(datenow);
    String formattedDate = DateFormat('dd').format(datenow);
    final provider = Provider.of<BackEndProvider>(context, listen: false);

    ///Logic to create new budget for the next month
    ///if the budget's month is not equal to the current month or
    ///if the next month is near by (i.e) 2 more days for the current month to end
    ///then it will show the dialog to create budget for the next month
    if (!provider.budget!.budgets[0].budgetname.contains(currentMonth) ||
        int.parse(formattedDate) > 28) {
      dateNow = true;
      if (provider.initialCall) {
        provider.setInitialCall(false);
        Future.delayed(
            const Duration(seconds: 3),
            () => showDialog(
                  context: context,
                  builder: (context) {
                    int status = int.parse(formattedDate) > 20 ? 2 : 1;
                    return CreateNewBudgetDialog(
                      status: status,
                    );
                  },
                ));
      }
    } else {
      dateNow = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final provider = Provider.of<BackEndProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
                              final datenow = DateTime.now();
                              String formattedDate =
                                  DateFormat('dd').format(datenow);
                              int status =
                                  int.parse(formattedDate) > 20 ? 2 : 1;
                              return CreateNewBudgetDialog(
                                status: status,
                              );
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
