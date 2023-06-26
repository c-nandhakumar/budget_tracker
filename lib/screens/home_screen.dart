import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/widgets/category_dialog.dart';
import 'package:budget_app/widgets/category_grid.dart';
import 'package:budget_app/widgets/date_remaining_container.dart';
import 'package:budget_app/widgets/dialog_widget.dart';
import 'package:budget_app/widgets/remaining_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/drop_down_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
            Padding(
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
                      builder: (context) => const DialogWidget());
                },
                color: Colors.white,
                icon: const Icon(Icons.add),
              ),
            )
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
