import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/models/expense_model.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expensemethod_model.dart';

class HistoryContainer extends StatefulWidget {
  final Expenses? expense;
  const HistoryContainer({super.key, this.expense});

  @override
  State<HistoryContainer> createState() => _HistoryContainerState();
}

class _HistoryContainerState extends State<HistoryContainer> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    ///Formatting the date to display in the history list
    String timestamp = widget.expense!.expensetransaction;
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat('MMM dd').format(dateTime);

    final provider = Provider.of<BackEndProvider>(context);
    List<ExpenseMethod> expenseMethodList = provider.expenseMethods;

    // ExpenseMethod initialValue = expenseMethodList.firstWhere((element) =>
    //     (element.emname == widget.expense!.emname &&
    //         element.emshortname == widget.expense!.emshortname &&
    //         element.emdetail == widget.expense!.emdetail));
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).colorScheme.secondary),
      height: SizeConfig.height! * 13.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.expense!.categoryname,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${dotenv.get("CURRENCY")}${widget.expense!.expensecost}",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Consumer<BackEndProvider>(
                            builder: (context, value, child) {
                          if (value.expenseMethods.isNotEmpty) {
                            ExpenseMethod initialValue = value.expenseMethods
                                .firstWhere((element) => (element.emshortname ==
                                        widget.expense!.emshortname &&
                                    element.emdetail ==
                                        widget.expense!.emdetail));

                            return DropdownButton<ExpenseMethod>(
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                isDense: true,
                                padding: EdgeInsets.zero,
                                iconEnabledColor: Colors.white,
                                value: initialValue,
                                underline: const SizedBox(),
                                elevation: 8,
                                selectedItemBuilder: (context) =>
                                    expenseMethodList
                                        .map((ExpenseMethod value) {
                                      // ignore: avoid_unnecessary_containers
                                      return Container(
                                          child: Text(
                                        value.emshortname,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: Colors.white),
                                      ));
                                    }).toList(),
                                onChanged: (ExpenseMethod? value) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final provider = Provider.of<
                                                          BackEndProvider>(
                                                      context,
                                                      listen: false);
                                                  await changeExpenseMethod(
                                                      provider: provider,
                                                      expenseid: widget
                                                          .expense!.expenseid,
                                                      emdetail: value!.emdetail,
                                                      emshortname:
                                                          value.emshortname,
                                                      emname: value.emname);
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
                                            content: Text(
                                                "Do you want to change this payment method to \"${value!.emshortname}\""),
                                          ));
                                  print(value!.emshortname);
                                  // This is called when the user selects an item.
                                },
                                items: expenseMethodList
                                    .map((ExpenseMethod value) {
                                  return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value.emshortname,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ));
                                }).toList());
                          } else {
                            return Container();
                          }
                        }),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          await deleteExpenses(
                              widget.expense!.expenseid, provider);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ]),
          ),
          Consumer<BackEndProvider>(builder: (context, value, child) {
            Expenses initialValue = value.expenses!.firstWhere(
                (element) => (element.expenseid == widget.expense!.expenseid));
            final expenseNotesEditingController =
                TextEditingController(text: initialValue.expensenotes);
            return Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  initialValue.expensenotes.isNotEmpty
                      ? Flexible(
                          child: Row(
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (isTapped) {
                                    final provider1 =
                                        Provider.of<BackEndProvider>(context,
                                            listen: false);
                                    changeNotes(
                                        provider: provider1,
                                        expenseId: widget.expense!.expenseid,
                                        expenseNotes:
                                            expenseNotesEditingController.text);
                                  }
                                  setState(() {
                                    isTapped = !isTapped;
                                  });
                                },
                                child: isTapped
                                    ? const Icon(
                                        Icons.done,
                                        size: 18,
                                      )
                                    : const Icon(
                                        Icons.edit,
                                        size: 18,
                                      ),
                              ),
                              Flexible(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  // width: SizeConfig.width! * 30,
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: isTapped
                                      ? TextFormField(
                                          // expands: true,
                                          autofocus: true,
                                          controller:
                                              expenseNotesEditingController,
                                          decoration: const InputDecoration(
                                              isDense: true),
                                        )
                                      : Text(
                                          initialValue.expensenotes,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xff808080)),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Flexible(
                          child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              height: 30,
                              // width: SizeConfig.width! * 40,
                              child: TextFormField(
                                onFieldSubmitted: (value) async {
                                  print(value);
                                  final provider1 =
                                      Provider.of<BackEndProvider>(context,
                                          listen: false);
                                  await changeNotes(
                                      provider: provider1,
                                      expenseId: widget.expense!.expenseid,
                                      expenseNotes: value);
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.only(bottom: 10),
                                  hintText: "Click here to add notes",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff808080),
                                      ),
                                ),
                              )),
                        ),
                  Row(children: [
                    Text(
                      widget.expense!.budgetname,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff808080)),
                    ),
                    Text(" | ",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff808080))),
                    Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff808080)),
                    )
                  ]),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}


 /*
   */