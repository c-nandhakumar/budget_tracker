import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/models/expensemethod_model.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseMethodsListWidget extends StatefulWidget {
  const ExpenseMethodsListWidget({super.key});

  @override
  State<ExpenseMethodsListWidget> createState() =>
      _ExpenseMethodsListWidgetState();
}

class _ExpenseMethodsListWidgetState extends State<ExpenseMethodsListWidget> {
  late String initialValue;
  late ExpenseMethod cash;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    initialValue = provider.defaultExpenseMethod!.emid;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    initialValue = provider.defaultExpenseMethod!.emid;
    List<ExpenseMethod> expenseMethodsList = [];
    for (var element in provider.expenseMethods) {
      if (element.emid == provider.defaultExpenseMethod!.emid) {
        expenseMethodsList.insert(0, element);
      } else {
        expenseMethodsList.add(element);
      }
      if (element.emname == 'CASH') {
        cash = element;
      }
    }

    // ignore: sized_box_for_whitespace
    return Container(
        height: SizeConfig.height! * 65,
        width: SizeConfig.width! * 90,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "Expense Methods",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            ...expenseMethodsList.map((element) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: RadioListTile(
                            contentPadding: const EdgeInsets.only(left: 12),
                            value: element.emid,
                            groupValue: initialValue,
                            title: Row(children: [
                              Text(
                                element.emshortname,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                " | ",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                element.emname,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ]),
                            subtitle: Text(initialValue == element.emid
                                ? "${element.emdetail} (Default)"
                                : element.emdetail),
                            onChanged: (value) {
                              print(value);
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              final provider =
                                                  Provider.of<BackEndProvider>(
                                                      context,
                                                      listen: false);

                                              ///Changing the old default to false
                                              await changeDefault(
                                                  provider.defaultExpenseMethod!
                                                      .emid,
                                                  false,
                                                  provider);

                                              ///Changing the new default
                                              await changeDefault(
                                                  value!, true, provider);
                                              setState(() {
                                                initialValue = value;
                                              });
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Yes"),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("No"),
                                          )
                                        ],
                                        content: const Text(
                                            "Do you want to make this as default payment method ?"),
                                      ));
                            },
                          ),
                        ),

                        ///If the Expense is Cash, then this condition wont display the delete button
                        element.emshortname != "CASH"
                            ? Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final provider1 = Provider
                                                        .of<BackEndProvider>(
                                                            context,
                                                            listen: false);

                                                    if (element.emisdefault ==
                                                        false) {
                                                      await deleteExpenseMethod(
                                                          element.emid,
                                                          provider1);
                                                    }
                                                    if (element.emisdefault ==
                                                        true) {
                                                      await changeDefault(
                                                          cash.emid,
                                                          true,
                                                          provider1);
                                                      await deleteExpenseMethod(
                                                          element.emid,
                                                          provider1);
                                                    }
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("No"),
                                                )
                                              ],
                                              content: const Text(
                                                  "Do you want to delete this expense method for sure? "),
                                            ));
                                  },
                                  child: SizedBox(
                                    height: 56,
                                    child: Ink(
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ],
                ))
          ],
        ));
  }
}
